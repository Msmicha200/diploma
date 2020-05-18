document.addEventListener('DOMContentLoaded', () => {
    const addTeacher = uvm.q('.add-teacher');

    addTeacher.addEventListener('click', () => {
        doc.classList.add('operator-modal');
    });

    const acceptTeacher = uvm.q('.accept-teacher');

    acceptTeacher.addEventListener('click', event => {
        event.preventDefault();

        const teacherForm = document.forms.addTeacher;
        const inputs = uvm.qae(teacherForm, '.uvm--input-wrapper > input');
        const data = new FormData(teacherForm);

        if (uvm.valid(inputs)) {

            uvm.ajax({
                url: '/operator/addTeacher',
                type: 'POST',
                data: uvm.dataToObj(data)
            })
            .then(res => {
                const teacherTable = uvm.q('.teacher-table');
                const tbody = uvm.qe(teacherTable, 'tbody')
                const tableWrapper = teacherTable.parentNode;

                if (res === 'Duplicate') {
                    console.log(res);
                    return;
                }

                if (res === 'Error') {
                    console.log(res);
                    return;
                }

                tbody.innerHTML += res;
                clearModal();
                tableWrapper.scrollTop = tableWrapper.scrollHeight;

            })
            .catch(error => {
                console.log('Internal server error' + error);
            });
        }
    });
});
