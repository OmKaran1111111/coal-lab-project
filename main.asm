INCLUDE Irvine32.inc

.data
WelcomeMessage  BYTE "=================================================", 0Dh, 0Ah
                BYTE "||                                             ||", 0Dh, 0Ah
                BYTE "||        LIBRARY MANAGEMENT SYSTEM            ||", 0Dh, 0Ah
                BYTE "||                                             ||", 0Dh, 0Ah
                BYTE "||            ~ DEVELOPED BY ~                 ||", 0Dh, 0Ah
                BYTE "||           OM      (24k-0711)                ||", 0Dh, 0Ah
                BYTE "||           BAHADUR (23k-0926)                ||", 0Dh, 0Ah
                BYTE "||                                             ||", 0Dh, 0Ah
                BYTE "=================================================", 0Dh, 0Ah, 0
    
emptystring     BYTE " ",0
ExitMessage     BYTE "Thank you for using the program. Goodbye!", 0
    

UserTypePrompt       BYTE "1) Librarian 2) Customer 3) Exit Program: ", 0
    
PasswordPrompt       BYTE "Enter Librarian Password: ", 0
PasswordFailMsg      BYTE "Incorrect Password! Access Denied.", 0
LibrarianPassword    BYTE "password", 0
InputPassword        BYTE 20 DUP(0)

LibrarianOptions     BYTE "1) Add Book 2) Update Book Info 3) Display Library 4) Search Book 5) Register Student 6) Update Rent Limit 7) Log Out : ", 0
CustomerOptions      BYTE "1) Return Book 2) Rent Book 3) Log Out: ", 0
InvalidChoiceMessage BYTE "Invalid choice. Please enter a valid option.: ", 0
    
RentLimitMsg         BYTE "Enter new Rent Limit (Max 5): ", 0
RentLimitUpdateMsg   BYTE "Rent Limit Updated Successfully!", 0
RentLimit            DWORD 1
RentalsLeftMsg       BYTE "Rentals Remaining: ", 0
    
BookTitlePrompt      BYTE "Enter Book Title: ", 0
BookAuthorPrompt     BYTE "Enter Book Author: ", 0
BookISBNPrompt       BYTE "Enter Book ISBN: ", 0
QuantityPrompt       BYTE "Enter Book Quantity: ", 0
BookAddedMessage     BYTE "Book successfully added!", 0
BookTitleMsg         BYTE "Book Title: ", 0
BookAuthorMsg        BYTE "Book Author: ", 0
BookReturnMsg        BYTE "Book Returned Successfully", 0
    
UpdateMsg            BYTE "Press 1 for Updating Book Title" ,0
UpdateMsg2           BYTE "Press 2 for Updating Author Name ",0
UpdateMsg3           BYTE "Press 3 for Updating Book Quantity" ,0
UpdateTitlePrompt    BYTE "Enter new Book Title: ", 0
UpdateAuthorPrompt   BYTE "Enter new Book Author: ", 0
BookUpdatedMessage   BYTE "Book information updated.", 0
InvalidUpdate        BYTE "Invalid choice. Try again",0
    
RentEnterISBN        BYTE "Step 1: Enter ISBN to rent: ", 0
RentEnterTitle       BYTE "Step 2: Enter Book Title to confirm: ", 0
TitleMismatchMsg     BYTE "Error: Title does not match the ISBN record!", 0
BookNotFound         BYTE "Book not found.", 0
RentSuccessMsg       BYTE "Book rented successfully!", 0
MaxBooksReachedMsg   BYTE "You have reached the rental limit!", 0
InsufficientCopiesMsg BYTE "Sorry, no copies of this book are available.", 0
NoBookRentedMsg      BYTE "You have not rented this book.", 0
ReturnEnterISBN      BYTE "Enter ISBN to return: ", 0
    
CustomerIDPrompt     BYTE "Enter Customer ID: ", 0
CustomerNotFoundMsg  BYTE "Customer ID not found. Please register first.", 0
LoginSuccessMsg      BYTE "Login successful! Welcome back.", 0
    
RegisterStudentMsg   BYTE "=== Student Registration ===", 0
StudentNamePrompt    BYTE "Enter Student Name: ", 0
StudentIDPrompt      BYTE "Enter Student ID: ", 0
RegistrationSuccessMsg BYTE "Student registered successfully!", 0
DuplicateIDMsg       BYTE "Error: Student ID already exists!", 0

MAX_BOOKS = 50
BookTitleSize = 50
    
BookTitles   BYTE MAX_BOOKS * BookTitleSize DUP(0)
BookAuthors  BYTE MAX_BOOKS * BookTitleSize DUP(0)
BookISBNs    DWORD MAX_BOOKS DUP(?)
Quantity     DWORD MAX_BOOKS DUP(?)
    
CurrentBookIndex DWORD 0 

BookToRentTitle BYTE 50 DUP(0)
    
MAX_STUDENTS = 50
MAX_RENT_PER_STUDENT = 5
    
StudentCount DWORD 0 
StudentIDs   DWORD MAX_STUDENTS DUP(?)
StudentNames BYTE MAX_STUDENTS * 50 DUP(0)
    
CurrentCustomerIndex DWORD 0 
    
StudentRentals     DWORD MAX_STUDENTS * MAX_RENT_PER_STUDENT DUP(0)
StudentRentCounts  DWORD MAX_STUDENTS DUP(0)

.code
main PROC
  
mov edx, OFFSET WelcomeMessage
call DisplayWelcomeMessage
call Crlf
   
mov eax, 2000
call Delay
    
call Clrscr

MainLoop:
    mov edx, OFFSET UserTypePrompt
    call WriteString
    call ReadInt
        
    cmp eax, 1
    je CheckLibrarianAuth
    cmp eax, 2
    je CustomerLoginLabel
    cmp eax, 3
    je EndProgramLabel
        
    call InvalidChoice
    jmp MainLoop


CheckLibrarianAuth:
    call Crlf
    mov edx, OFFSET PasswordPrompt
    call WriteString
    mov edx, OFFSET InputPassword
    mov ecx, 19
    call ReadString
        

    mov esi, OFFSET InputPassword
    mov edi, OFFSET LibrarianPassword
    mov ecx, 8
        
VerifyPassLoop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne AuthFailed
    cmp al, 0
    je AuthSuccess
    inc esi
    inc edi
    jmp VerifyPassLoop

AuthFailed:
    mov edx, OFFSET PasswordFailMsg
    call WriteString
    call Crlf
    jmp MainLoop
            
AuthSuccess:
    jmp LibrarianMenuLabel


LibrarianMenuLabel:
    call Crlf
    mov edx, OFFSET LibrarianOptions
    call WriteString
    call Crlf
    call ReadInt
        
    cmp eax, 1
    je AddBookJump
    cmp eax, 2
    je UpdateBookInfoJump
    cmp eax, 3
    je DisplayLibraryJump
    cmp eax, 4
    je DisplayBookInfoJump
    cmp eax, 5
    je RegisterStudentJump
    cmp eax, 6
    je UpdateRentLimitJump
    cmp eax, 7
    je MainLoop

    
        
    call InvalidChoice
    jmp LibrarianMenuLabel

AddBookJump:
    call AddBook
    jmp LibrarianMenuLabel
UpdateBookInfoJump:
    call UpdateBookInfo
    jmp LibrarianMenuLabel
DisplayLibraryJump:
    call displayLibraryInfo
    jmp LibrarianMenuLabel
DisplayBookInfoJump:
    call DisplayBookInfo
    jmp LibrarianMenuLabel
RegisterStudentJump:
    call RegisterStudent
    jmp LibrarianMenuLabel
UpdateRentLimitJump:
    call UpdateRentLimit
    jmp LibrarianMenuLabel

CustomerLoginLabel:
    call CustomerLogin
    cmp eax, 1             
    jne MainLoop           
        
CustomerMenuLabel:
    call Crlf
    mov edx, OFFSET CustomerOptions
    call WriteString
    call Crlf
    call ReadInt
            
    cmp eax, 1
    je ReturnBookJump
    cmp eax, 2
    je RentBookJump
    cmp eax, 3
    je MainLoop        
            
    call InvalidChoice
    jmp CustomerMenuLabel
            
ReturnBookJump:
    call ReturnBook
    jmp CustomerMenuLabel
            
RentBookJump:
    call RentBook
    jmp CustomerMenuLabel

EndProgramLabel:
    call Crlf
    mov edx, OFFSET ExitMessage
    call WriteString
    call Crlf
    exit

main ENDP

;displayWelcomeMessage
DisplayWelcomeMessage PROC
mov eax, 0Ch
call SetTextColor
    
mov esi, edx
    
PrintCharacterLoop:
    mov al, [esi]
    cmp al, 0
    je DonePrinting
    call WriteChar
    push eax
    mov eax, 5
    call Delay
    pop eax
    inc esi
    jmp PrintCharacterLoop
        
DonePrinting:
    mov eax, 07h
    call SetTextColor
    ret
    DisplayWelcomeMessage ENDP

;UpdateRentLimit
UpdateRentLimit PROC
    mov edx, OFFSET RentLimitMsg
    call WriteString
    call ReadInt
    
    cmp eax, 5
    jg LimitTooHigh
    mov RentLimit, eax
    mov edx, OFFSET RentLimitUpdateMsg
    call WriteString
    call Crlf
    ret
    
LimitTooHigh:
    mov eax, 5
    mov RentLimit, eax
    mov edx, OFFSET RentLimitUpdateMsg
    call WriteString
    call Crlf
    ret
UpdateRentLimit ENDP

;RentBook
RentBook PROC
    LOCAL targetISBN:DWORD, bookIdx:DWORD
    
    call displayLibraryInfo
    call Crlf
    
    mov esi, CurrentCustomerIndex
    mov eax, StudentRentCounts[esi * 4]
    
    cmp eax, RentLimit
    jae RentMaxReached
    
    mov edx, OFFSET RentalsLeftMsg
    call WriteString
    mov ebx, RentLimit
    sub ebx, eax
    mov eax, ebx
    call WriteDec
    call Crlf
    call Crlf
    
    mov edx, OFFSET RentEnterISBN
    call WriteString
    call ReadInt
    mov targetISBN, eax
    
    mov eax, targetISBN
    call FindISBNIndex
    cmp eax, -1
    je RentNotFound
    mov bookIdx, eax
    
    mov edx, OFFSET RentEnterTitle
    call WriteString
    mov edx, OFFSET BookToRentTitle
    mov ecx, 49
    call ReadString
    
    mov eax, bookIdx
    mov ebx, 50
    mul ebx
    mov edi, OFFSET BookTitles
    add edi, eax
    mov esi, OFFSET BookToRentTitle
    
    push ecx
    mov ecx, 50
CheckTitleLoop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, 0
    je TitleMatchOK
    cmp al, bl
    jne TitleFail
    inc esi
    inc edi
    loop CheckTitleLoop
pop ecx
    
TitleMatchOK:
    mov esi, bookIdx
    cmp Quantity[esi * 4], 0
    jle RentInsufficient
        
    mov eax, CurrentCustomerIndex
    mov ebx, MAX_RENT_PER_STUDENT
    mul ebx
    mov ecx, MAX_RENT_PER_STUDENT
    mov edi, 0 
        
FindSlotLoop:
    mov ebx, eax
    add ebx, edi
    mov esi, StudentRentals[ebx * 4]
    cmp esi, 0
    je FoundEmptySlot
    inc edi
    loop FindSlotLoop
    jmp RentMaxReached
            
FoundEmptySlot:
    mov esi, targetISBN
    mov StudentRentals[ebx * 4], esi
            
    mov esi, CurrentCustomerIndex
    inc StudentRentCounts[esi * 4]
            
    mov esi, bookIdx
    dec Quantity[esi * 4]
            
    mov edx, OFFSET RentSuccessMsg
    call WriteString
    ret

TitleFail:
    pop ecx
    mov edx, OFFSET TitleMismatchMsg
    call WriteString
    ret
        
RentNotFound:
    mov edx, OFFSET BookNotFound
    call WriteString
    ret
        
RentMaxReached:
    mov edx, OFFSET MaxBooksReachedMsg
    call WriteString
    ret
        
RentInsufficient:
    mov edx, OFFSET InsufficientCopiesMsg
    call WriteString
    ret
RentBook ENDP
;returnbook
ReturnBook PROC
LOCAL returnISBN:DWORD, libIdx:DWORD

mov edx, OFFSET ReturnEnterISBN
call WriteString
call ReadInt
mov returnISBN, eax
    
mov eax, CurrentCustomerIndex
mov ebx, MAX_RENT_PER_STUDENT
mul ebx
mov ecx, MAX_RENT_PER_STUDENT
mov edi, 0
    
SearchUserRentals:
    mov ebx, eax
    add ebx, edi
    mov esi, StudentRentals[ebx * 4]
    cmp esi, returnISBN
    je FoundInUserList
    inc edi
    loop SearchUserRentals
        
mov edx, OFFSET NoBookRentedMsg
call WriteString
ret
    
FoundInUserList:
    mov StudentRentals[ebx * 4], 0
        
    mov esi, CurrentCustomerIndex
    dec StudentRentCounts[esi * 4]
        
    mov eax, returnISBN
    call FindISBNIndex
    mov libIdx, eax
    inc Quantity[eax * 4]
        
    mov edx, OFFSET BookReturnMsg
    call WriteString
    ret
ReturnBook ENDP

;addbook
AddBook PROC
    cmp CurrentBookIndex, MAX_BOOKS
    jae AddBookExit

    mov edx, offset BookTitlePrompt
    call WriteString
    mov eax, CurrentBookIndex
    mov ebx, 50
    mul ebx
    mov edi, OFFSET BookTitles
    add edi, eax
    mov edx, edi
    mov ecx, 49
    call ReadString

    mov edx, offset BookAuthorPrompt
    call WriteString
    mov eax, CurrentBookIndex
    mov ebx, 50
    mul ebx
    mov edi, OFFSET BookAuthors
    add edi, eax
    mov edx, edi
    mov ecx, 49
    call ReadString

    mov edx, offset BookISBNPrompt
    call WriteString
    call ReadInt
    mov ebx, CurrentBookIndex
    mov [BookISBNs + ebx * 4], eax

    mov edx, offset QuantityPrompt
    call WriteString
    call ReadInt
    mov ebx, CurrentBookIndex
    mov [Quantity + ebx * 4], eax

    inc CurrentBookIndex
    mov edx, offset BookAddedMessage
    call WriteString
    call Crlf
AddBookExit:
    ret
    AddBook ENDP
;findisbnindex
FindISBNIndex PROC
    LOCAL OriginalISBN : DWORD
    mov OriginalISBN, eax
    mov ecx, CurrentBookIndex
    cmp ecx, 0
    je ISBNNotFound
    mov esi, 0
SearchLoop:
    mov eax, OriginalISBN
    cmp eax, BookISBNs[esi * 4]
    je ISBNFound
    inc esi
    loop SearchLoop
ISBNNotFound:
    mov eax, -1
    ret
ISBNFound:
    mov eax, esi
    ret
FindISBNIndex ENDP
;displaylibraryinfo
displayLibraryInfo PROC
    mov ecx, CurrentBookIndex
    cmp ecx, 0
    je DisplayEmpty
    mov esi, 0
DisplayLoop:
    call Crlf
    mov edx, offset BookTitleMsg
    call WriteString
    mov eax, esi
    mov ebx, 50
    mul ebx
    mov edx, offset BookTitles
    add edx, eax
    call WriteString
    call Crlf
        
    mov edx, offset BookISBNPrompt
    call WriteString
    mov eax, BookISBNs[esi * 4]
    call WriteInt
    call Crlf
        
    mov edx, offset QuantityPrompt
    call WriteString
    mov eax, Quantity[esi * 4]
    call WriteInt
    call Crlf
    inc esi
    loop DisplayLoop
    ret
DisplayEmpty:
    mov edx, offset BookNotFound
    call WriteString
    ret
displayLibraryInfo ENDP

CustomerLogin PROC
    mov edx, OFFSET CustomerIDPrompt
    call WriteString
    call ReadInt
    mov ebx, eax
    mov ecx, StudentCount
    cmp ecx, 0
    je LoginFailed
    mov esi, 0
LoginLoop:
    cmp ebx, StudentIDs[esi * 4]
    je LoginFound
    inc esi
    loop LoginLoop
LoginFailed:
    mov edx, OFFSET CustomerNotFoundMsg
    call WriteString
    mov eax, 0
    ret
LoginFound:
    mov CurrentCustomerIndex, esi
    mov edx, OFFSET LoginSuccessMsg
    call WriteString
    mov eax, 1
    ret
CustomerLogin ENDP
;register student
RegisterStudent PROC
    cmp StudentCount, MAX_STUDENTS
    jae RegFull
    mov edx, OFFSET RegisterStudentMsg
    call WriteString
    call Crlf
RegGetID:
    mov edx, OFFSET StudentIDPrompt
    call WriteString
    call ReadInt
    mov ebx, eax
    mov ecx, StudentCount
    cmp ecx, 0
    je RegStore
    mov esi, 0
RegCheckDup:
    cmp ebx, StudentIDs[esi * 4]
    je RegDupFound
    inc esi
    loop RegCheckDup
RegStore:
    mov esi, StudentCount
    mov StudentIDs[esi * 4], ebx
    mov edx, OFFSET StudentNamePrompt
    call WriteString
    mov eax, StudentCount
    mov ebx, 50
    mul ebx
    mov edi, OFFSET StudentNames
    add edi, eax
    mov edx, edi
    mov ecx, 49
    call ReadString
    inc StudentCount
    mov edx, OFFSET RegistrationSuccessMsg
    call WriteString
    ret
RegDupFound:
    mov edx, OFFSET DuplicateIDMsg
    call WriteString
    call Crlf
    jmp RegGetID
RegFull:
    mov edx, OFFSET BookNotFound
    call WriteString
    ret
RegisterStudent ENDP
;updatebookinfo
UpdateBookInfo PROC
UpdateMenu:
    call Crlf
    mov edx, offset UpdateMsg
    call WriteString
    call Crlf
    mov edx, offset UpdateMsg2
    call WriteString
    call Crlf
    mov edx, offset UpdateMsg3
    call WriteString
    call Crlf
    call ReadInt
    cmp eax, 1
    JE UpdateTitleHandler
    cmp eax, 2
    JE UpdateAuthorHandler
    cmp eax, 3
    JE UpdateQuantityHandler
    mov edx, offset InvalidUpdate
    call WriteString
    jmp UpdateMenu
UpdateTitleHandler:
    call UpdateBookTitle
    ret
UpdateAuthorHandler:
    call UpdateAuthorName
    ret
UpdateQuantityHandler:
    call UpdateBookQuantity
    ret
UpdateBookInfo ENDP
;upgradebooktitle
UpdateBookTitle PROC
    mov edx, offset BookISBNPrompt
    call WriteString
    call ReadInt
    call FindISBNIndex
    cmp eax, -1
    je UpdateExit
    push eax
    mov edx, offset UpdateTitlePrompt
    call WriteString
    pop eax
    mov ebx, 50
    mul ebx
    mov edx, offset BookTitles
    add edx, eax
    mov ecx, 49
    call ReadString
    mov edx, offset BookUpdatedMessage
    call WriteString
UpdateExit: 
    ret
UpdateBookTitle ENDP
;updateauthorname
UpdateAuthorName PROC
    mov edx, offset BookISBNPrompt
    call WriteString
    call ReadInt
    call FindISBNIndex
    cmp eax, -1
    je UpdateExit2
    push eax
    mov edx, offset UpdateAuthorPrompt
    call WriteString
    pop eax
    mov ebx, 50
    mul ebx
    mov edx, offset BookAuthors
    add edx, eax
    mov ecx, 49
    call ReadString
    mov edx, offset BookUpdatedMessage
    call WriteString
UpdateExit2: 
    ret
UpdateAuthorName ENDP
;updatebookquantity
UpdateBookQuantity PROC
    mov edx, offset BookISBNPrompt
    call WriteString
    call ReadInt
    call FindISBNIndex
    cmp eax, -1
    je UpdateExit3
    mov ebx, eax
    mov edx, offset QuantityPrompt
    call WriteString
    call ReadInt
    mov [Quantity + ebx * 4], eax
    mov edx, offset BookUpdatedMessage
    call WriteString
UpdateExit3: 
    ret
UpdateBookQuantity ENDP
;displayboofinfo
DisplayBookInfo PROC
    mov edx, offset BookISBNPrompt
    call WriteString
    call ReadInt
    call FindISBNIndex
    cmp eax, -1
    je DisplayInfoNotFound
    mov esi, eax
    call Crlf
    mov edx, offset BookTitleMsg
    call WriteString
    mov eax, esi
    mov ebx, 50
    mul ebx
    mov edx, offset BookTitles
    add edx, eax
    call WriteString
    call Crlf
    mov edx, offset QuantityPrompt
    call WriteString
    mov eax, Quantity[esi * 4]
    call WriteInt
    call Crlf
    ret
DisplayInfoNotFound:
    mov edx, offset BookNotFound
    call WriteString
    ret
DisplayBookInfo ENDP

InvalidChoice PROC
    mov edx, OFFSET InvalidChoiceMessage
    call WriteString
    call Crlf
    ret
InvalidChoice ENDP

END main