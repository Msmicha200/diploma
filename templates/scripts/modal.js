const doc = document.documentElement;
const modals = ['student-modal', 'group-modal'];
const clearModal = event => {

    modals.forEach(elem => {
        const inputs = uvm.qae(uvm.q(`.${elem}`), 'input');
        const selects = uvm.qa('.uvm--current-item');
        const selected = uvm.qa('.uvm--selected');

        doc.classList.remove(elem);
    
        inputs.forEach(elem => {
            elem.value = '';
        });

        selected.forEach (elem => {
            elem.classList.remove('uvm--selected');
        });
    });
};

document.addEventListener('DOMContentLoaded', () => {
    const closeModal = uvm.qa('.close-modal');

    closeModal.forEach(elem => {
        elem.addEventListener('click', target => {
            target.preventDefault();
        });

        elem.addEventListener('click', clearModal);
    });

});