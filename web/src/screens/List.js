import React, { useState, useEffect } from 'react';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import Grid from '@mui/material/Grid';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Button from '@mui/material/Button';
import { useLocation, useNavigate } from "react-router-dom";
import aws_config from '../aws_configuration';

export default function List() {
    const [rows, setRows] = useState([]);
    const { state } = useLocation();
    let navigate = useNavigate();

    const openForm = () => {
        navigate('/push', { state });
    };

    useEffect(() => {
        if (state === undefined || state === null || state.accessToken.jwtToken === null || state.email === null) {
            navigate('/signin');
            return;
        }
        fetch(`${aws_config.aws_api_gateway}/contact?userid=${state.email}`, {
            headers: {
                'Authorization': state.accessToken.jwtToken
            },
        })
            .then(res => res.json())
            .then(json => {
                if (json.length === 0) {
                    setRows([]);
                    return;
                }
                setRows(json);
            });
    }, []);


    return (
        <Grid container spacing={1}>
            <Grid item xs={12}>
                <Button variant="contained" color="primary" onClick={openForm}>Add contact</Button>
            </Grid>
            <Grid item xs={12}>
                <Table sx={{ maxWidth: 500 }}>
                    <TableHead>
                        <TableRow>
                            <TableCell align="left">Name</TableCell>
                            <TableCell align="left">Surname</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map((row) => (
                            <TableRow
                                key={rows.indexOf(row)}
                            >
                                <TableCell align="left">{row.name}</TableCell>
                                <TableCell align="left">{row.surname}</TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            </Grid>
        </Grid>

    );
}
