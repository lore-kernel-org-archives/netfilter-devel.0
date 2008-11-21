From: "David Wu" <davidwu@arcturusnetworks.com>
Subject: Re: iptables (1.4.2 release) failed to run on embedded system with
 "can't initialize iptables table `filter'"
Date: Fri, 21 Nov 2008 13:35:07 -0500
Message-ID: <op.ukze8tjtqigx4y@cyprus.local>
References: <op.uky4wc2dqigx4y@cyprus.local>
 <alpine.LNX.1.10.0811211659001.12307@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.arcturusnetworks.com ([204.50.165.220]:40685 "EHLO
	mail.arcturusnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYKUSfK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:35:10 -0500
In-Reply-To: <alpine.LNX.1.10.0811211659001.12307@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 21 Nov 2008 11:07:41 -0500, Jan Engelhardt <jengelh@medozas.de>  
wrote:

> On Friday 2008-11-21 15:51, David Wu wrote:
>
>> My question:
>>   1 why tries to allocate 0 size memory, it is useful?
>
>         array_elems = (h->num_chains / list_length) +
>                       (h->num_chains % list_length ? 1 : 0);
>         array_mem   = sizeof(h->chain_index) * array_elems;
>
>
> Logically,
> array_mem == 0  =>  (sizeof(h->chain_index) == 0) ^ (array_elems == 0).
> And given that sizeof() is unlikely to return 0 here, array_elems must
> be 0. And the only way array_elems can be 0 is that h->num_chains <
> list_length && h->num_chains == 0.  Buf if you have 0 chains to start
> with, it sounds like it really could not get the filter to table to
> work. gdb will help.

It seems that I really have a 0 chains to start. Does this include default  
chains or is it only user defined chains?

I have compiled on x86(openSUSE 11.0 (X86-64)VERSION = 11.0)
(Linux cyprus 2.6.25.11-0.1-default #1 SMP 2008-07-13 20:48:28 +0200  
x86_64 x86_64 x86_64 GNU/Linux)
and enable debug() in libiptc/libiptc.c

This is output:
cyprus:/home/wmq/iptables/iptables-1.4.2 # ./iptables -L
Alloc Chain index, elems:0 mem:0 bytes
Building chain index
Number of user defined chains:0 bucket_sz:40 array_sz:0
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

>
>>   2 is there any problem to the iptables program in my change?
>>     I may have to rebuild the toolchain so malloc will return a live
>> pointer for 0 size allocation.
>>   3 I have got the error
>>     ip_tables: ERROR target: invalid size 30 != 32
>>     from 1.3.7 and 1.4.2 (didn't try other versions) and sent to this  
>> list
>> a question before but haven't received any answer
>
> It needs the same ABI, as was answered before:
>
> http://marc.info/?l=netfilter-devel&m=122309437709848&w=2

I have built it with: (I added --disable-largefile)
$ ../configure --host=m68k-uclinux  
--with-kernel=/home/wmq/HG-REV/5329/uCmib.devel/kernel --disable-largefile  
--disable-shared CFLAGS=-DNO_SHARED_LIBS
on a machine (uname -a Linux ivymike 2.6.18.2-34-bigsmp #1 SMP Mon Nov 27  
11:46:27 UTC 2006 i686 i686 i386 GNU/Linux, openSUSE 10.2 (i586) VERSION =  
10.2)
kernel version is 2.6.26-rc7

embedded system is 32bit, building system is also 32 bit.
I don't have a clue where goes wrong. Could you give more info about which  
ABI involved.(libc ?)
>

thanks,

-- 
David Wu
