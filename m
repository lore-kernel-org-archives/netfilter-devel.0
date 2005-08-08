From: Roberto Nibali <ratz@tac.ch>
Subject: Re: Fixed Re: iptables 1.3.1 crashes on iptables-restore
Date: Mon, 08 Aug 2005 18:46:51 +0200
Message-ID: <42F78C7B.6060808@tac.ch>
References: <20050330034616.GA8639@samad.com.au>	<424BB242.6070809@drugphish.ch>	<42F24151.1090702@ufomechanic.net>	<42F33AAD.8060201@ufomechanic.net>	<dcvnn9$vpl$1@sea.gmane.org>	<42F367FF.7060605@drugphish.ch>	<42F77E2E.2090307@ufomechanic.net>	<42F780B3.3030102@tac.ch>
	<42F78246.3030302@ufomechanic.net>	<42F78609.5070504@tac.ch>
	<42F78829.2050700@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	ratz@drugphish.ch
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42F78829.2050700@ufomechanic.net>
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

>>>GNU C Library stable release version 2.3.2, by Roland McGrath et al.
>>>Copyright (C) 2003 Free Software Foundation, Inc.
>>>This is free software; see the source for copying conditions.
>>>There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
>>>PARTICULAR PURPOSE.
>>>Compiled by GNU CC version 3.2.2 20030222 (Red Hat Linux 3.2.2-5).
>>>Compiled on a Linux 2.4.20 system on 2003-03-13.
>>>Available extensions:
>>>       GNU libio by Per Bothner
>>>       crypt add-on version 2.1 by Michael Glad and others
>>>       linuxthreads-0.10 by Xavier Leroy
>>>       BIND-8.2.3-T5B
>>>       libthread_db work sponsored by Alpha Processor Inc
>>>       NIS(YP)/NIS+ NSS modules 0.19 by Thorsten Kukuk
>>>Thread-local storage support included.
   ^^^^^^^^^^^^^^^^^^^^
To me this indicates that TLS is included which is strange. The libc I
use for our 2.4.x kernel stuff looks as follows:

GNU C Library stable release version 2.3.5, by Roland McGrath et al.
Copyright (C) 2005 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.
Compiled by GNU CC version 3.4.4.
Compiled on a Linux 2.6.11 system on 2005-07-26.
Available extensions:
        GNU libio by Per Bothner
        crypt add-on version 2.1 by Michael Glad and others
        linuxthreads-0.10 by Xavier Leroy
        BIND-8.2.3-T5B
        libthread_db work sponsored by Alpha Processor Inc
        NIS(YP)/NIS+ NSS modules 0.19 by Thorsten Kukuk
For bug reporting instructions, please see:
<http://www.gnu.org/software/libc/bugs.html>.

The one I use on 2.6.x kernels is as follows:

GNU C Library stable release version 2.3.2 (20030827), by Roland McGrath
et al.
Copyright (C) 2003 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.
Configured for i686-suse-linux.
Compiled by GNU CC version 3.3.1 (SuSE Linux).
Compiled on a Linux 2.6.0-test3 system on 2003-09-23.
Available extensions:
        GNU libio by Per Bothner
        crypt add-on version 2.1 by Michael Glad and others
        linuxthreads-0.10 by Xavier Leroy
        NoVersion patch for broken glibc 2.0 binaries
        BIND-8.2.3-T5B
        libthread_db work sponsored by Alpha Processor Inc
        NIS(YP)/NIS+ NSS modules 0.19 by Thorsten Kukuk
Thread-local storage support included.
Report bugs using the `glibcbug' script to <bugs@gnu.org>.

So I wonder how TLS has slipped into your libc.

>>
>>I'm by no means a libc expert but how did you get infected with this
>>libc version? :). 
>> 
> er.. I inherited it on my development box.

Ok. I see that's a RH box so I presume they certainly know what they
did. I vaguely rememeber that someone of RH once backported the NPTL
stuff to 2.4.x kernels, so this would explain your crippled libc :).

>>I was under the impression that TLS support wasn't
>>functional until NPTL was introduced in the 2.6.x era. 
>> 
> I'm not sure that this glibc is providing TLS, can you see that it is?

The output of /lib/libc.so.6 tells me.

> Certainly I can't see that iptables needs any, although maybe some of
> the libc stuff does(all the getnameby stuff maybe wants per-thread
> static buffers instead of per-process?)

iptables has no influence on this, it's how the linker will put it
together. Obviously it has added the TLS enabled c-library to your
iptables binary which could have provoked this issue. Also when you
LD_ASSUME*'d iptables it wouldn't show the defect anymore. So the
problem must be related to your libc or the toolchain you use to compile
binaries.

>>To my knowledge
>>this could explain the TLS related crashes you were seeing. Any chance
>>of upgrading this libc of yours?
>> 
>>
> I hope so. Are you sure they are TLS related?

No, I'm afraid. In my normal life I thankfully almost never have to deal
with libc issues.

>>I could of course be totally wrong.
>>
> It's more than I've had to go on so far, so keep talking.

I'm off now and I think we should continue this discussion privately,
since the added value for netfilter developers is getting slimmer with
each reply :). We can always post the result of our findings back to
this list, IMHO.

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
