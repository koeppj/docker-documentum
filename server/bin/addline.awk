BEGIN {}
{
    print $0
    if ($0 == section) {
        print line
    }
}
