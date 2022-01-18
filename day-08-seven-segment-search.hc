#define MAX_ENTRIES 200
#define NUM_ENTRY_SIGNALS 10
#define NUM_ENTRY_OUTPUT_DIGITS 4
#define NUM_ENTRY_ITEMS (NUM_ENTRY_SIGNALS+NUM_ENTRY_OUTPUT_DIGITS)
#define ENTRY_ITEM_SIZE 8

U8 *StrSep(U8 **src,U8 sep)
{//Like strsep from The GNU C Library except sep is a byte.
  U8 *st=*src,*end=st;
  if (!st)
    return NULL;
  while (*end && *end!=sep)
    end++;
  if (*end)
    *end++=0;
  else
    end=NULL;
  *src=end;
  return st;
}

I64 ParseInput(U8 *st,U8 *entries)
{//Return the number of parsed entries or -1 on error.
  U8 *line,*word;
  I64 entry_idx=0,item_idx,size;

  StrUtil(st,SUF_REM_TRAILING);
  while ((line=StrSep(&st,'\n'))) {
    if (entry_idx==MAX_ENTRIES) {
      PrintErr("There are too many entries.\n");
      return -1;
    }

    item_idx=0;
    while ((word=StrSep(&line,' '))) {
      if (item_idx==NUM_ENTRY_ITEMS) {
        PrintErr("Entry #%d has too many items.\n",entry_idx+1);
        return -1;
      }

      if (*word=='|') //Separator of signals and output values.
        goto continue;

      size=StrLen(word)+1;
      if (size>ENTRY_ITEM_SIZE) {
        PrintErr("Entry #%d has an item of invalid size.\n",entry_idx+1);
        return -1;
      }

      StrCpy(&entries[(entry_idx*NUM_ENTRY_ITEMS*ENTRY_ITEM_SIZE)+
      (item_idx*ENTRY_ITEM_SIZE)],word);

      item_idx++;
  continue:
    }

    if (item_idx!=NUM_ENTRY_ITEMS) {
      PrintErr("Entry #%d has an invalid number of items.\n",entry_idx+1);
      return -1;
    }

    entry_idx++;
  }
  return entry_idx;
}

I64 GetInput(U8 *filename,U8 *entries)
{//Return the number of entries or -1 on error.
  U8 *input=FileRead(filename);
  I64 num_entries;
  if (!input)
    return -1;
  num_entries=ParseInput(input,entries);
  Free(input);
  return num_entries;
}

U0 Solution(U8 *input_filename="~/AoC/Input.TXT")
{
  U8 entries[MAX_ENTRIES][NUM_ENTRY_ITEMS][ENTRY_ITEM_SIZE];
  I64 num_entries,count=0,i,j,len,sum=0,wire_to_segment,digit,k,segments; 

  if ((num_entries=GetInput(input_filename,entries))<=0)
    return;

  //Part 1 answer.
  for (i=0;i<num_entries;i++) {
    for (j=NUM_ENTRY_SIGNALS;j<NUM_ENTRY_ITEMS;j++) {
      len=StrLen(entries[i][j]);
      if (len==2 || len==3 || len==4 || len==7)
        count++;
    }
  }

  "The digits 1, 4, 7 or 8 appear %d times in the output values.\n",count;

  //TODO: Part 2 answer.
  "The output values add up to %d.\n",sum;
}

Solution;
