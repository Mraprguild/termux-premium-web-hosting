const root = document.documentElement;
const header = document.querySelector(".site-header");
const menuButton = document.getElementById("menuButton");
const navLinks = document.getElementById("navLinks");
const themeButton = document.getElementById("themeButton");
const themeIcon = document.getElementById("themeIcon");
const copyButton = document.getElementById("copyButton");
const copyAddress = document.getElementById("copyAddress");
const setupCode = document.getElementById("setupCode");
const toast = document.getElementById("toast");

function showToast(message) {
    toast.textContent = message;
    toast.classList.add("show");

    clearTimeout(showToast.timer);
    showToast.timer = setTimeout(() => {
        toast.classList.remove("show");
    }, 2200);
}

function applyTheme(theme) {
    root.dataset.theme = theme;
    themeIcon.textContent = theme === "dark" ? "☀" : "☾";
    localStorage.setItem("mraprguild-theme", theme);
}

const savedTheme = localStorage.getItem("mraprguild-theme");
const preferredTheme = window.matchMedia("(prefers-color-scheme: light)").matches
    ? "light"
    : "dark";

applyTheme(savedTheme || preferredTheme);

themeButton.addEventListener("click", () => {
    const nextTheme = root.dataset.theme === "dark" ? "light" : "dark";
    applyTheme(nextTheme);
});

menuButton.addEventListener("click", () => {
    const isOpen = navLinks.classList.toggle("open");
    menuButton.setAttribute("aria-expanded", String(isOpen));
});

navLinks.querySelectorAll("a").forEach((link) => {
    link.addEventListener("click", () => {
        navLinks.classList.remove("open");
        menuButton.setAttribute("aria-expanded", "false");
    });
});

window.addEventListener("scroll", () => {
    header.classList.toggle("scrolled", window.scrollY > 20);
});

async function copyText(text, successMessage) {
    try {
        await navigator.clipboard.writeText(text);
        showToast(successMessage);
    } catch {
        const helper = document.createElement("textarea");
        helper.value = text;
        helper.style.position = "fixed";
        helper.style.opacity = "0";
        document.body.appendChild(helper);
        helper.select();
        document.execCommand("copy");
        helper.remove();
        showToast(successMessage);
    }
}

copyButton.addEventListener("click", () => {
    copyText(setupCode.textContent.trim(), "Commands copied");
});

copyAddress.addEventListener("click", () => {
    copyText("http://127.0.0.1:8080", "Server address copied");
});

document.getElementById("year").textContent = new Date().getFullYear();

const observer = new IntersectionObserver(
    (entries) => {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                entry.target.classList.add("visible");
                observer.unobserve(entry.target);
            }
        });
    },
    { threshold: 0.14 }
);

document.querySelectorAll(".reveal").forEach((element) => {
    observer.observe(element);
});
