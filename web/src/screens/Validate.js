import React, {useEffect} from "react";
import Avatar from '@mui/material/Avatar';
import Button from '@mui/material/Button';
import CssBaseline from '@mui/material/CssBaseline';
import TextField from '@mui/material/TextField';
import Grid from '@mui/material/Grid';
import Box from '@mui/material/Box';
import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import Auth from '@aws-amplify/auth';
import Amplify from '@aws-amplify/core';
import { useNavigate, useLocation } from "react-router-dom";
import aws_config from '../aws_configuration';

Amplify.configure(aws_config);

export default function Validate() {
    const { state } = useLocation();
    let navigate = useNavigate();

    useEffect(() => {
        if(state==null){
            navigate('/');
        }
    });

    const handleSubmit = async (event) => {
        let code = document.getElementById('code').value;
        let email = state.email;
        if (code.length > 0) {
            await Auth.confirmSignUp(email, code)
              .then(() => {
                navigate('/');
              })
              .catch((err) => {
                if (!err.message) {
                  console.error('Something went wrong, please contact support!');
                } else {
                  console.error(err.message);
                }
              });
          } else {
            console.error('You must enter confirmation code');
          }
    };

    return (
        <Container component="main" maxWidth="xs">
            <CssBaseline />
            <Box
                sx={{
                    marginTop: 8,
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                }}
            >
                <Avatar sx={{ m: 1, bgcolor: 'secondary.main' }}>
                    <LockOutlinedIcon />
                </Avatar>
                <Typography component="h1" variant="h5">
                    Validate
                </Typography>
                <Box noValidate sx={{ mt: 3 }} >
                    <Grid container spacing={2}>
                        <Grid item xs={12}>
                            <TextField
                                fullWidth
                                size="small"
                                id="code"
                                label="Code"
                                name="code"
                            />
                        </Grid>
                    </Grid>
                    <Button
                        fullWidth
                        variant="contained"
                        sx={{ mt: 3, mb: 2 }}
                        onClick={handleSubmit}
                    >
                        Validate
                    </Button>
                </Box>
            </Box>
        </Container>
    );
}
