# Contributing to Home Assistant Management Repository

Thank you for your interest in contributing! This document provides guidelines for contributing automations, scripts, and other resources to this repository.

## How to Contribute

### 1. Fork and Clone
```bash
# Fork the repository on GitHub, then:
git clone https://github.com/your-username/home-assistant.git
cd home-assistant
```

### 2. Create a Branch
```bash
git checkout -b feature/your-feature-name
```

### 3. Make Your Changes
Follow the guidelines below for different types of contributions.

### 4. Test Your Changes
- Test automations in your Home Assistant instance
- Verify scripts work as expected
- Check YAML syntax
- Ensure documentation is clear

### 5. Commit Your Changes
```bash
git add .
git commit -m "Add: descriptive commit message"
git push origin feature/your-feature-name
```

### 6. Create a Pull Request
- Go to GitHub and create a pull request
- Describe what your contribution does
- Explain why it's useful
- Include any testing notes

## Contribution Guidelines

### Automations

When contributing automations:

1. **Use Clear Names**
   ```yaml
   alias: 'Turn on porch light at sunset'  # Good
   alias: 'automation_1'  # Bad
   ```

2. **Include Comments**
   ```yaml
   # This automation turns on outdoor lights 30 minutes before sunset
   # It only runs when vacation mode is disabled
   ```

3. **Use Generic Entity IDs**
   ```yaml
   entity_id: light.living_room  # Good, descriptive
   entity_id: light.my_custom_light_ab123  # Bad, too specific
   ```

4. **Add Description**
   ```yaml
   description: |
     Turns on porch light at sunset for security.
     Requires: light.porch_light entity
     Created: 2024-01-15
   ```

5. **Include Usage Instructions**
   - Add a comment block at the top
   - List required entities
   - Note any dependencies

### Scripts

When contributing scripts:

1. **Include Header Comments**
   ```bash
   #!/bin/bash
   #############################################
   # Script Name and Purpose
   # 
   # Description of what this script does
   # Requirements: List any prerequisites
   #############################################
   ```

2. **Use Configuration Variables**
   ```bash
   # Configuration
   HA_CONFIG_DIR="${HA_CONFIG_DIR:-/config}"
   BACKUP_DIR="${BACKUP_DIR:-$HOME/ha-backups}"
   ```

3. **Add Error Handling**
   ```bash
   if [ ! -d "$HA_CONFIG_DIR" ]; then
       echo "Error: Config directory not found"
       exit 1
   fi
   ```

4. **Include Usage Examples**
   ```bash
   # Usage:
   #   ./script_name.sh [options]
   # 
   # Example:
   #   HA_CONFIG_DIR=/config ./script_name.sh
   ```

5. **Make Scripts Portable**
   - Don't hardcode paths
   - Use environment variables
   - Check for dependencies
   - Provide helpful error messages

### Python Scripts

For Python contributions:

1. **Include Docstrings**
   ```python
   """
   Script description here.
   
   Usage:
       python script.py [args]
   
   Requirements:
       - Python 3.7+
       - requests library
   """
   ```

2. **Use Type Hints**
   ```python
   def get_entities(domain: Optional[str] = None) -> List[Dict]:
       """Fetch entities from Home Assistant"""
   ```

3. **Handle Errors Gracefully**
   ```python
   try:
       response = requests.get(url)
       response.raise_for_status()
   except requests.exceptions.RequestException as e:
       print(f"Error: {e}")
       sys.exit(1)
   ```

4. **Follow PEP 8**
   - Use 4 spaces for indentation
   - Keep lines under 100 characters
   - Use meaningful variable names

### Configuration Examples

1. **Use .example Extension**
   - Name files: `configuration.yaml.example`
   - Users copy and remove `.example`

2. **Include Placeholder Comments**
   ```yaml
   # TODO: Update with your latitude
   latitude: 40.7128
   
   # TODO: Update with your API key
   api_key: !secret api_key_name
   ```

3. **Provide Context**
   ```yaml
   # This configuration enables the weather integration
   # Requires: API key from https://example.com
   weather:
     - platform: example
       api_key: !secret weather_api_key
   ```

### Documentation

1. **Use Markdown**
   - Follow existing formatting
   - Use headers appropriately
   - Include code blocks with syntax highlighting

2. **Be Clear and Concise**
   - Write for beginners
   - Explain technical terms
   - Provide examples

3. **Include Prerequisites**
   - List requirements upfront
   - Link to relevant documentation
   - Explain installation steps

4. **Add Troubleshooting**
   - Anticipate common issues
   - Provide solutions
   - Link to additional resources

## File Organization

### Directory Structure
```
automations/       # Automation YAML files
├── README.md      # Automation documentation
├── lighting/      # Optional: organize by category
└── security/

scripts/          # Utility scripts
├── README.md     # Script documentation
├── *.sh          # Shell scripts
└── *.py          # Python scripts

configurations/   # Config templates
├── README.md
└── *.yaml.example

docs/            # Documentation
├── GETTING_STARTED.md
└── BEST_PRACTICES.md

templates/       # Reusable templates
└── README.md

examples/        # Usage examples
└── README.md
```

### Naming Conventions

- **Files**: Use lowercase with underscores
  - `motion_detection.yaml`
  - `backup_config.sh`
  - `find_entities.py`

- **Automations**: Descriptive names
  - `lighting_sunset.yaml`
  - `climate_control.yaml`
  - `security_alert.yaml`

- **Scripts**: Action-oriented names
  - `backup_config.sh`
  - `check_config.sh`
  - `find_entities.py`

## Code Style

### YAML
- Use 2 spaces for indentation
- Use single quotes for strings (when needed)
- Add comments for clarity
- Organize logically

### Shell Scripts
- Use `#!/bin/bash` shebang
- Quote variables: `"$VARIABLE"`
- Check for errors: `if [ $? -eq 0 ]`
- Use meaningful variable names

### Python
- Follow PEP 8
- Use type hints
- Include docstrings
- Handle exceptions

## What to Contribute

We welcome:

### High Priority
- Common automation patterns
- Useful utility scripts
- Clear documentation
- Beginner-friendly examples
- Troubleshooting guides

### Medium Priority
- Advanced automations
- Integration guides
- Performance optimizations
- Best practices

### Low Priority (but still welcome!)
- Edge case solutions
- Experimental features
- Tool integrations

## What NOT to Contribute

Please don't submit:
- Personal/sensitive information
- Hardcoded passwords or tokens
- Vendor-specific code without generalization
- Overly complex solutions without documentation
- Duplicate functionality without improvement
- Copyrighted content

## Review Process

1. **Automated Checks**
   - YAML validation
   - Script syntax checking
   - Documentation formatting

2. **Manual Review**
   - Code quality
   - Documentation clarity
   - Usefulness to community
   - Security considerations

3. **Testing**
   - Verify scripts work as described
   - Check automations are valid
   - Ensure documentation is accurate

## Getting Help

Questions? Issues?

- **General Questions**: Open a discussion
- **Bug Reports**: Open an issue
- **Feature Requests**: Open an issue
- **Security Issues**: Email maintainer directly

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn
- Give credit where due
- Follow community guidelines

## Recognition

Contributors will be:
- Listed in pull request history
- Acknowledged in release notes (for significant contributions)
- Appreciated by the community! 🎉

## License

By contributing, you agree that your contributions will be licensed under the same license as this project.

## Questions?

Feel free to:
- Open an issue for questions
- Join discussions
- Reach out to maintainers

---

Thank you for contributing to making Home Assistant management easier for everyone! 🏠✨
