import React from 'react';
import {
    BrowserRouter,
    Routes,
    Route
} from "react-router-dom";
import Home from '../screens/Home';
import Signup from '../screens/Signup';
import Signin from '../screens/Signin';
import List from '../screens/List';
import Validate from '../screens/Validate';
import Push from '../screens/Push';

export default function App() {
    return (
        <BrowserRouter>
            <Routes>
                <Route  path="/" element={<Home />} />
                <Route path="/signup" element={<Signup />} />
                <Route path="/signin" element={<Signin />} />
                <Route path="/list" element={<List />} />
                <Route path="/validate" element={<Validate />} />
                <Route path="/push" element={<Push />} />
            </Routes>
        </BrowserRouter>
    );
}