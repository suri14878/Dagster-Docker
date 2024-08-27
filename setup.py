from setuptools import find_packages, setup

setup(
    name="dag_test",
    packages=find_packages(exclude=["dag_test_tests"]),
    install_requires=[
        "dagster",
        "dagster-cloud"
    ],
    extras_require={"dev": ["dagster-webserver", "pytest"]},
)
