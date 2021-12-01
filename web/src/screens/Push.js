import React from 'react';
import Button from '@mui/material/Button';
import CssBaseline from '@mui/material/CssBaseline';
import TextField from '@mui/material/TextField';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import { useNavigate, useLocation } from "react-router-dom";
import aws_config from '../aws_configuration';

export default function Push() {
  const { state } = useLocation();
  let navigate = useNavigate();

  const handleSubmit = async (event) => {
    if (state === undefined || state === null || state.accessToken.jwtToken === null || state.email === null) {
      navigate('/signin');
      return;
  }

    let name = document.getElementById('name').value;
    let surname = document.getElementById('surname').value;
    fetch(`${aws_config.aws_api_gateway}/contact?userid=${state.email}`, {
      method: 'POST',
      headers: {
        'Authorization': state.accessToken.jwtToken
      },
      body: JSON.stringify({
        name,
        surname
      })
    })
    .then(res => {
      navigate('/list', { state });
    });
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
        <Typography component="h1" variant="h5">
          Add Contact
        </Typography>
        <Box component="form" noValidate sx={{ mt: 1 }}>
          <TextField
            margin="normal"
            required
            fullWidth
            id="name"
            label="Name"
            name="name"
            autoFocus
          />
          <TextField
            margin="normal"
            required
            fullWidth
            id="surname"
            name="surname"
            label="Surname"
          />
          <Button
            fullWidth
            variant="contained"
            onClick={handleSubmit}
            sx={{ mt: 3, mb: 2 }}>
            Save
          </Button>
        </Box>
      </Box>
    </Container>
  );
}