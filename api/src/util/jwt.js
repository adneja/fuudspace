const jwt = require('jsonwebtoken');

module.exports = {
    jwtSignUser: (user) => {
        const ONE_WEEK = 60 * 60 * 24 * 7;

        return jwt.sign(user, process.env.JWT_SECRET, {
            expiresIn: ONE_WEEK
        });
    },

    verifyToken: (req, res, next) => {
        const token = req.header('authorization');

        if(!token) {
            res.json({
                error: 'This action requires login'
            });
        } else {
            try {
                const verified = jwt.verify(token, process.env.JWT_SECRET);
                req.user = verified;
                next();
            } catch (err) {
                res.json({
                    error: 'This action requires login'
                });
            }
        }
    },

    optionalToken: (req, res, next) => {
        const token = req.header('authorization');

        if(token) {
            try {
                const verified = jwt.verify(token, process.env.JWT_SECRET);
                req.user = verified;
                next();
            } catch (err) {
                req.user = {id:null};
                next();
            }
        } else {
            next();
        }
    }
};