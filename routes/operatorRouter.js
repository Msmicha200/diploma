const express = require('express');
const OperatorController = require('../controllers/operatorController');
const router = express.Router();
const operatorController = new OperatorController();

router.get('/', operatorController.index);

router.post('/getGroups', operatorController.groups);

router.post('/getDisciplines', operatorController.disciplines);

router.post('/getDisciplToGroup', operatorController.disciplines);

router.post('/getThemes', operatorController.program);

router.post('/passed', operatorController.passed);

router.post('/changeStatus', operatorController.status);

router.post('/addStudent', operatorController.user);

router.post('/addGroup', operatorController.newGroup);

router.post('/getDisciplToTeacher', operatorController.getTeachers);

router.post('/addDisciplToGroup', operatorController.dsiciplToGroup);

router.post('/addTeacher', operatorController.user);

router.post('/addOperator', operatorController.user);

router.post('/addDiscipline', operatorController.newDiscipline);

router.post('/addDisciplToTeacher', operatorController.disciplToTeacher);

router.post('/addTheme', operatorController.newTheme);

router.post('/editStudent', operatorController.editStudent);

router.post('/editGroup', operatorController.editGroup);

router.post('/editTeacher', operatorController.editTeacher);

router.post('/editOperator', operatorController.editOperator);

router.post('/editDiscipline', operatorController.editDiscipline)

module.exports = router;
