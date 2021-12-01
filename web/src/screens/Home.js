import Button from '@mui/material/Button';
import Grid from '@mui/material/Grid';

export default function Home() {
    return (
        <Grid container spacing={1}>
            <Grid item xs={12}>
                <Button variant="contained" color="primary" href="/signup">signup</Button>
            </Grid>
            <Grid item xs={12}>
                <Button variant="contained" color="primary" href="/signin">signin</Button>
            </Grid>
        </Grid>
    );
}
