/**
 * Priority Success Associates LLC
 * Interactive JavaScript Engine & Responsive Drawer Controller
 */

document.addEventListener('DOMContentLoaded', () => {

    /* ==========================================================================
       1. STICKY HEADER & SCROLL BEHAVIOR
       ========================================================================== */
    const siteHeader = document.querySelector('.site-header');
    
    const handleScroll = () => {
        if (!siteHeader) return;
        if (window.scrollY > 30) {
            siteHeader.classList.add('scrolled');
        } else {
            siteHeader.classList.remove('scrolled');
        }
    };

    window.addEventListener('scroll', handleScroll, { passive: true });
    handleScroll();

    /* ==========================================================================
       2. MOBILE DRAWER NAVIGATION CONTROLLER
       ========================================================================== */
    const menuToggles = document.querySelectorAll('#menuToggle, #mobileNavToggle, .menu-toggle, .mobile-toggle');
    const mobileDrawer = document.getElementById('mobileDrawer');
    const drawerBackdrop = document.getElementById('drawerBackdrop');
    const drawerClose = document.getElementById('drawerClose');
    const drawerDirectLinks = document.querySelectorAll('.drawer-link:not(.drawer-dropdown-toggle), .drawer-sublink, .drawer-footer a');
    const drawerDropdownToggles = document.querySelectorAll('.drawer-dropdown-toggle');

    const openDrawer = (e) => {
        if (e && e.preventDefault) e.preventDefault();
        if (mobileDrawer) mobileDrawer.classList.add('active');
        if (drawerBackdrop) drawerBackdrop.classList.add('active');
        document.body.classList.add('drawer-open');
        document.body.style.overflow = 'hidden';
        menuToggles.forEach(btn => btn.setAttribute('aria-expanded', 'true'));
    };

    const closeDrawer = () => {
        if (mobileDrawer) mobileDrawer.classList.remove('active');
        if (drawerBackdrop) drawerBackdrop.classList.remove('active');
        document.body.classList.remove('drawer-open');
        document.body.style.overflow = '';
        menuToggles.forEach(btn => btn.setAttribute('aria-expanded', 'false'));
    };

    menuToggles.forEach(btn => {
        btn.addEventListener('click', (e) => {
            if (mobileDrawer && mobileDrawer.classList.contains('active')) {
                closeDrawer();
            } else {
                openDrawer(e);
            }
        });
    });

    if (drawerClose) {
        drawerClose.addEventListener('click', (e) => {
            e.preventDefault();
            closeDrawer();
        });
    }

    if (drawerBackdrop) {
        drawerBackdrop.addEventListener('click', closeDrawer);
    }

    // Close when navigating to links
    drawerDirectLinks.forEach(link => {
        link.addEventListener('click', () => {
            closeDrawer();
        });
    });

    // Keyboard navigation (Escape key closes drawer)
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && mobileDrawer && mobileDrawer.classList.contains('active')) {
            closeDrawer();
        }
    });

    // Accordion submenu in mobile drawer
    drawerDropdownToggles.forEach(toggle => {
        toggle.addEventListener('click', (e) => {
            e.preventDefault();
            const parent = toggle.closest('.drawer-dropdown');
            if (parent) {
                parent.classList.toggle('active');
                const isExpanded = parent.classList.contains('active');
                toggle.setAttribute('aria-expanded', isExpanded ? 'true' : 'false');
            }
        });
    });

    /* ==========================================================================
       3. INTERSECTION OBSERVER FOR FADE-UP ANIMATIONS
       ========================================================================== */
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.12
    };

    if ('IntersectionObserver' in window) {
        const fadeObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    observer.unobserve(entry.target);
                }
            });
        }, observerOptions);

        const fadeElements = document.querySelectorAll('.fade-up, .reveal');
        fadeElements.forEach(el => fadeObserver.observe(el));
    } else {
        document.querySelectorAll('.fade-up, .reveal').forEach(el => el.classList.add('visible'));
    }

});
