void write_string( int colour, const char *string )
{
    volatile char *video = (volatile char*)0xB8000;
    while( *string != 0 )
    {
        *video++ = *string++;
        *video++ = colour;
    }
}


extern "C" void main(){
    write_string(2, "IcarOS kernel reached!");
    return;
}
