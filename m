From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Fixed Re: iptables 1.3.1 crashes on iptables-restore
Date: Mon, 08 Aug 2005 17:28:25 +0100
Message-ID: <42F78829.2050700@ufomechanic.net>
References: <20050330034616.GA8639@samad.com.au>	<424BB242.6070809@drugphish.ch>	<42F24151.1090702@ufomechanic.net>	<42F33AAD.8060201@ufomechanic.net>	<dcvnn9$vpl$1@sea.gmane.org>	<42F367FF.7060605@drugphish.ch>	<42F77E2E.2090307@ufomechanic.net>
	<42F780B3.3030102@tac.ch> <42F78246.3030302@ufomechanic.net>
	<42F78609.5070504@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42F78609.5070504@tac.ch>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Roberto Nibali wrote:

>>I'm waiting for all the fancy goods to get merged before I take that one.
>>    
>>
>They get merged into the next mm round I reckon, Linus won't pull until
>2.6.13 is out the doors.
>  
>
>>>Invoke /lib/libc.so.6 like a command. It won't destroy your system but
>>>it will display how your libc was crafted.
>>>
>>>      
>>>
>>GNU C Library stable release version 2.3.2, by Roland McGrath et al.
>>Copyright (C) 2003 Free Software Foundation, Inc.
>>This is free software; see the source for copying conditions.
>>There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
>>PARTICULAR PURPOSE.
>>Compiled by GNU CC version 3.2.2 20030222 (Red Hat Linux 3.2.2-5).
>>Compiled on a Linux 2.4.20 system on 2003-03-13.
>>Available extensions:
>>        GNU libio by Per Bothner
>>        crypt add-on version 2.1 by Michael Glad and others
>>        linuxthreads-0.10 by Xavier Leroy
>>        BIND-8.2.3-T5B
>>        libthread_db work sponsored by Alpha Processor Inc
>>        NIS(YP)/NIS+ NSS modules 0.19 by Thorsten Kukuk
>>Thread-local storage support included.
>>    
>>
>
>I'm by no means a libc expert but how did you get infected with this
>libc version? :). 
>
er.. I inherited it on my development box.

>I was under the impression that TLS support wasn't
>functional until NPTL was introduced in the 2.6.x era. 
>
I'm not sure that this glibc is providing TLS, can you see that it is?
Certainly I can't see that iptables needs any, although maybe some of
the libc stuff does(all the getnameby stuff maybe wants per-thread
static buffers instead of per-process?)

>To my knowledge
>this could explain the TLS related crashes you were seeing. Any chance
>of upgrading this libc of yours?
>  
>
I hope so. Are you sure they are TLS related?

>I could of course be totally wrong.
>
>  
>
It's more than I've had to go on so far, so keep talking.

Sam

>Best regards,
>Roberto Nibali, ratz
>  
>
