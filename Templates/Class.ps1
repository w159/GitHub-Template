class ExampleClass {
    # Properties
    [string]$Name
    [datetime]$CreatedDate
    [ValidateRange(0, 100)]
    [int]$Priority

    # Hidden properties (internal use)
    hidden [string]$InternalId

    # Constructors
    ExampleClass() {
        $this.CreatedDate = Get-Date
        $this.InternalId = [guid]::NewGuid().ToString()
        $this.Priority = 50
    }

    ExampleClass([string]$name) {
        $this.Name = $name
        $this.CreatedDate = Get-Date
        $this.InternalId = [guid]::NewGuid().ToString()
        $this.Priority = 50
    }

    ExampleClass([string]$name, [int]$priority) {
        $this.Name = $name
        $this.Priority = $priority
        $this.CreatedDate = Get-Date
        $this.InternalId = [guid]::NewGuid().ToString()
    }

    # Methods
    [string] GetDisplayName() {
        return "{0} (Priority: {1})" -f $this.Name, $this.Priority
    }

    [void] UpdatePriority([int]$newPriority) {
        if ($newPriority -lt 0 -or $newPriority -gt 100) {
            throw "Priority must be between 0 and 100"
        }
        $this.Priority = $newPriority
        Write-Verbose -Message "Updated priority for '$($this.Name)' to $newPriority"
    }

    # Static method
    static [ExampleClass] CreateWithDefaults([string]$name) {
        return [ExampleClass]::new($name, 50)
    }

    # ToString override for better display
    [string] ToString() {
        return $this.GetDisplayName()
    }
}
