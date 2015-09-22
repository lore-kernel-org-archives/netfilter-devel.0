From: littlesmilingcloud@gmail.com
Subject: [nft] strange behaviour
Date: Tue, 22 Sep 2015 21:41:12 +0300
Message-ID: <5601a0c8.vTjiOdyXOkEgHeZy%littlesmilingcloud@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: dau@sunlink.ru
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:35442 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151AbbIVSlP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2015 14:41:15 -0400
Received: by lagj9 with SMTP id j9so24094923lag.2
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2015 11:41:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

I have try to add the subnet element to the named set, and nft has closed unexpectly.
I use the 4.2 stable kernel and latest stable release of libnftnl and nftables from git.

Reproduce of the strange behaviour.
--------------------------------------------------------------------------------------
nft> list ruleset;
nft> add table ip filter;
nft> add set ip filter addr_list { type ipv4_addr; }
nft> add element ip filter addr_list { 192.168.1.1 }
nft> add element ip filter addr_list { 192.168.10.0/24 }
BUG: invalid data expression type prefix
nft: netlink.c:326: netlink_gen_data: Assertion `0' failed.
danilov@danilov:~$ sudo nft -a -i
nft> list ruleset;
table ip filter {
	set addr_list { 
		type ipv4_addr
		elements = { 192.168.1.1}
	}
}
nft> 

% sudo nft -a -i --debug all
nft> add element ip filter addr_list { 192.168.10.0/24 }
Entering state 0
Reducing stack by rule 1 (line 557):
-> $$ = nterm input (: )
Stack now 0
Entering state 1
Reading a token: --accepting rule at line 261 ("add")
Next token is token "add" (: )
Shifting token "add" (: )
Entering state 16
Reading a token: --accepting rule at line 527 (" ")
--accepting rule at line 245 ("element")
Next token is token "element" (: )
Shifting token "element" (: )
Entering state 12
Reading a token: --accepting rule at line 527 (" ")
--accepting rule at line 358 ("ip")
Next token is token "ip" (: )
Shifting token "ip" (: )
Entering state 28
Reducing stack by rule 132 (line 1172):
   $1 = token "ip" (: )
-> $$ = nterm family_spec_explicit (: )
Stack now 0 1 16 12
Entering state 36
Reducing stack by rule 131 (line 1169):
   $1 = nterm family_spec_explicit (: )
-> $$ = nterm family_spec (: )
Stack now 0 1 16 12
Entering state 35
Reading a token: --accepting rule at line 527 (" ")
--accepting rule at line 498 ("filter")
Next token is token "string" (: )
Shifting token "string" (: )
Entering state 42
Reducing stack by rule 126 (line 1147):
   $1 = token "string" (: )
-> $$ = nterm identifier (: )
Stack now 0 1 16 12 35
Entering state 168
Reducing stack by rule 138 (line 1180):
   $1 = nterm family_spec (: )
   $2 = nterm identifier (: )
-> $$ = nterm table_spec (: )
Stack now 0 1 16 12
Entering state 47
Reading a token: --accepting rule at line 527 (" ")
--accepting rule at line 498 ("addr_list")
Next token is token "string" (: )
Shifting token "string" (: )
Entering state 42
Reducing stack by rule 126 (line 1147):
   $1 = token "string" (: )
-> $$ = nterm identifier (: )
Stack now 0 1 16 12 47
Entering state 238
Reducing stack by rule 142 (line 1210):
   $1 = nterm table_spec (: )
   $2 = nterm identifier (: )
-> $$ = nterm set_spec (: )
Stack now 0 1 16 12
Entering state 49
Reading a token: --accepting rule at line 527 (" ")
--accepting rule at line 204 ("{")
Next token is token '{' (: )
Shifting token '{' (: )
Entering state 191
Reading a token: --accepting rule at line 527 (" ")
--accepting rule at line 462 ("192.168.10.0")
Next token is token "string" (: )
Reducing stack by rule 6 (line 580):
-> $$ = nterm opt_newline (: )
Stack now 0 1 16 12 49 191
Entering state 435
Next token is token "string" (: )
Shifting token "string" (: )
Entering state 80
Reducing stack by rule 127 (line 1150):
   $1 = token "string" (: )
-> $$ = nterm string (: )
Stack now 0 1 16 12 49 191 435
Entering state 127
Reducing stack by rule 252 (line 1644):
   $1 = nterm string (: )
-> $$ = nterm symbol_expr (: )
Stack now 0 1 16 12 49 191 435
Entering state 128
Reducing stack by rule 256 (line 1685):
   $1 = nterm symbol_expr (: )
-> $$ = nterm primary_expr (: )
Stack now 0 1 16 12 49 191 435
Entering state 214
Reducing stack by rule 263 (line 1694):
   $1 = nterm primary_expr (: )
-> $$ = nterm shift_expr (: )
Stack now 0 1 16 12 49 191 435
Entering state 215
Reading a token: --accepting rule at line 222 ("/")
Next token is token "/" (: )
Reducing stack by rule 266 (line 1705):
   $1 = nterm shift_expr (: )
-> $$ = nterm and_expr (: )
Stack now 0 1 16 12 49 191 435
Entering state 216
Next token is token "/" (: )
Reducing stack by rule 268 (line 1712):
   $1 = nterm and_expr (: )
-> $$ = nterm exclusive_or_expr (: )
Stack now 0 1 16 12 49 191 435
Entering state 217
Next token is token "/" (: )
Reducing stack by rule 270 (line 1719):
   $1 = nterm exclusive_or_expr (: )
-> $$ = nterm inclusive_or_expr (: )
Stack now 0 1 16 12 49 191 435
Entering state 218
Next token is token "/" (: )
Reducing stack by rule 272 (line 1726):
   $1 = nterm inclusive_or_expr (: )
-> $$ = nterm basic_expr (: )
Stack now 0 1 16 12 49 191 435
Entering state 219
Next token is token "/" (: )
Shifting token "/" (: )
Entering state 478
Reading a token: --accepting rule at line 472 ("24")
Next token is token "number" (: )
Shifting token "number" (: )
Entering state 559
Reducing stack by rule 277 (line 1763):
   $1 = nterm basic_expr (: )
   $2 = token "/" (: )
   $3 = token "number" (: )
-> $$ = nterm prefix_expr (: )
Stack now 0 1 16 12 49 191 435
Entering state 221
Reducing stack by rule 280 (line 1786):
   $1 = nterm prefix_expr (: )
-> $$ = nterm multiton_expr (: )
Stack now 0 1 16 12 49 191 435
Entering state 513
Reducing stack by rule 303 (line 1865):
   $1 = nterm multiton_expr (: )
-> $$ = nterm set_lhs_expr (: )
Stack now 0 1 16 12 49 191 435
Entering state 516
Reducing stack by rule 297 (line 1841):
   $1 = nterm set_lhs_expr (: )
-> $$ = nterm set_elem_expr_alloc (: )
Stack now 0 1 16 12 49 191 435
Entering state 515
Reading a token: --accepting rule at line 527 (" ")
--accepting rule at line 205 ("}")
Next token is token '}' (: )
Reducing stack by rule 295 (line 1837):
   $1 = nterm set_elem_expr_alloc (: )
-> $$ = nterm set_elem_expr (: )
Stack now 0 1 16 12 49 191 435
Entering state 521
Next token is token '}' (: )
Reducing stack by rule 6 (line 580):
-> $$ = nterm opt_newline (: )
Stack now 0 1 16 12 49 191 435 521
Entering state 590
Reducing stack by rule 293 (line 1827):
   $1 = nterm opt_newline (: )
   $2 = nterm set_elem_expr (: )
   $3 = nterm opt_newline (: )
-> $$ = nterm set_list_member_expr (: )
Stack now 0 1 16 12 49 191
Entering state 437
Reducing stack by rule 289 (line 1810):
   $1 = nterm set_list_member_expr (: )
-> $$ = nterm set_list_expr (: )
Stack now 0 1 16 12 49 191
Entering state 436
Next token is token '}' (: )
Shifting token '}' (: )
Entering state 523
Reducing stack by rule 288 (line 1803):
   $1 = token '{' (: )
   $2 = nterm set_list_expr (: )
   $3 = token '}' (: )
-> $$ = nterm set_expr (: )
Stack now 0 1 16 12 49
Entering state 240
Reducing stack by rule 33 (line 702):
   $1 = token "element" (: )
   $2 = nterm set_spec (: )
   $3 = nterm set_expr (: )
-> $$ = nterm add_cmd (: )
Stack now 0 1 16
Entering state 51
Reducing stack by rule 15 (line 645):
   $1 = token "add" (: )
   $2 = nterm add_cmd (: )
-> $$ = nterm base_cmd (: )
Stack now 0 1
Entering state 33
Reading a token: --(end of buffer or a NUL)
--EOF (start condition 0)
Now at end of input.
Shifting token "end of file" (: )
Entering state 166
Reducing stack by rule 13 (line 615):
   $1 = nterm base_cmd (: )
   $2 = token "end of file" (: )
----------------	------------------
|  0000000020  |	| message length |
| 02576 | R--- |	|  type | flags  |
|  0000000000  |	| sequence number|
|  0000000000  |	|     port ID    |
----------------	------------------
| 00 00 00 00  |	|  extra header  |
----------------	------------------
----------------	------------------
|  0000000020  |	| message length |
| 02561 | R--- |	|  type | flags  |
|  0000000000  |	| sequence number|
|  0000000000  |	|     port ID    |
----------------	------------------
| 00 00 00 00  |	|  extra header  |
----------------	------------------
----------------	------------------
|  0000000032  |	| message length |
| 02570 | R-A- |	|  type | flags  |
|  0000000000  |	| sequence number|
|  0000000000  |	|     port ID    |
----------------	------------------
| 02 00 00 00  |	|  extra header  |
|00011|--|00001|	|len |flags| type|
| 66 69 6c 74  |	|      data      |	 f i l t
| 65 72 00 00  |	|      data      |	 e r  
----------------	------------------
----------------	------------------
|  0000000056  |	| message length |
| 02573 | R-A- |	|  type | flags  |
|  0000000000  |	| sequence number|
|  0000000000  |	|     port ID    |
----------------	------------------
| 02 00 00 00  |	|  extra header  |
|00011|--|00001|	|len |flags| type|
| 66 69 6c 74  |	|      data      |	 f i l t
| 65 72 00 00  |	|      data      |	 e r  
|00014|--|00002|	|len |flags| type|
| 61 64 64 72  |	|      data      |	 a d d r
| 5f 6c 69 73  |	|      data      |	  l i s
| 74 00 00 00  |	|      data      |	 t   
|00008|--|00010|	|len |flags| type|
| 00 00 00 01  |	|      data      |	    
----------------	------------------
----------------	------------------
|  0000000020  |	| message length |
| 02564 | R--- |	|  type | flags  |
|  0000000000  |	| sequence number|
|  0000000000  |	|     port ID    |
----------------	------------------
| 02 00 00 00  |	|  extra header  |
----------------	------------------
<cli>:1:1-51: Evaluate
add element ip filter addr_list { 192.168.10.0/24 }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


<cli>:1:33-51: Evaluate
add element ip filter addr_list { 192.168.10.0/24 }
                                ^^^^^^^^^^^^^^^^^^^
{ $192.168.10.0/24}

<cli>:1:35-49: Evaluate
add element ip filter addr_list { 192.168.10.0/24 }
                                  ^^^^^^^^^^^^^^^
$192.168.10.0/24

<cli>:1:35-49: Evaluate
add element ip filter addr_list { 192.168.10.0/24 }
                                  ^^^^^^^^^^^^^^^
$192.168.10.0/24

<cli>:1:35-46: Evaluate
add element ip filter addr_list { 192.168.10.0/24 }
                                  ^^^^^^^^^^^^
$192.168.10.0

<cli>:1:35-46: Evaluate
add element ip filter addr_list { 192.168.10.0/24 }
                                  ^^^^^^^^^^^^
192.168.10.0

<cli>:1:35-49: Evaluate
add element ip filter addr_list { 192.168.10.0/24 }
                                  ^^^^^^^^^^^^^^^
192.168.10.0 & 4294967040

<cli>:1:35-46: Evaluate
add element ip filter addr_list { 192.168.10.0/24 }
                                  ^^^^^^^^^^^^
192.168.10.0

<cli>:1:35-49: Evaluate
add element ip filter addr_list { 192.168.10.0/24 }
                                  ^^^^^^^^^^^^^^^
4294967040

<cli>:1:35-49: Evaluate
add element ip filter addr_list { 192.168.10.0/24 }
                                  ^^^^^^^^^^^^^^^
192.168.10.0

Stack now 0 1
Cleanup: popping nterm input (: )
BUG: invalid data expression type prefix
nft: netlink.c:326: netlink_gen_data: Assertion `0' failed.

May be there is type mismatch of set and prefix element. I'm stuck.

With best regards, Anton Danilov
