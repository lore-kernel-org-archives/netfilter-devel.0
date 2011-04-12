From: Ed W <lists@wildgooses.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Tue, 12 Apr 2011 22:03:02 +0100
Message-ID: <4DA4BE06.3020107@wildgooses.com>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr> <4DA0C402.1090809@wildgooses.com> <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, zenczykowski@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:54389 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab1DLVDF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 17:03:05 -0400
In-Reply-To: <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/04/2011 23:30, Jan Engelhardt wrote:
> On Saturday 2011-04-09 22:39, Ed W wrote:
>
>> On 09/04/2011 00:42, Jan Engelhardt wrote:
>>> You said `iptables -h` itself would take a long time due to modprobe, 
>>> however, I can spot no invocation of it using `strace -fe execve 
>>> iptables -h` when the desired codes are already loaded into the kernel 
>>> one way or another.
>> Maciej pointed out this is the case for git as of around 4 days ago, and
>> in my last email I confirmed I saw the same.  I don't expect you to
>> observe what you say if you use last released 1.4.10?
> Maciej's patches do not change the kernel behavior, which is the only 
> place from where kernel modules are loaded.

I'm reasonably sure that we are talking cross purposes and the fault is
no doubt mine. 

However, to be clear - my problem is with xtables.c / xtables_insmod(). 
This function is called multiple times (in 1.4.10) even doing a simple
"iptables -h" on a kernel where there are no modules.  I don't quite
understand what *causes* that code to be called, my point is simply that
it's called repeatedly (and needlessly) on each invocation of "iptables -h"


>> (For example running up a fairly vanilla "shorewall"
>> script manages to cause some 20 odd modules to load).
> Some scripts irresponsibly call iptables often, and thus modprobe gets 
> invoked that many times. I have said earlier, look at `strace -fe execve 
> iptables...`.

Actually, having looked closer at shorewall it's "feature" is that it
builds an iptables restore script and runs it once.  Therefore I'm
seeing around 2+ seconds of modprobe attempts during a single iptables
restore command.  This penalty occurs each time "iptables restore" is
called (ie doesn't go away after first call)


>> I appear to be able to eliminate this delay by modifying
>> /proc/sys/kernel/modprobe, but I not (apparently) by using "iptables -M
>> blah"? No one else is commenting on this, so either it's resolved in
>> current git, or ...?
> Because, as I have said earlier:
> - iptables loads ip_tables.ko, and
> - the kernel loads any remaining requested modules

It may well be the case that it's the kernel which is running the code
in xtables.c.  However, my problem is therefore solveable because the
kernel should know that the relevant module is compiled in and doesn't
need loading. 

Can you please clarify the chain of calling that leads to xtables.c /
xtables_insmod() to be called and perhaps some ideas how the kernel
modules could be modified to pass back some information that they are
compiled in?



>> No one has suggested anything, but basically, is there some way to avoid
>> running modprobe when the kernel has all the xtables modules compiled
>> in? ie can we detect that the code is already loaded and avoid trying to
>> probe for it?
> This detection is precisely what the kernel has been doing _for years_.
> Changing /proc/sys/kernel/modprobe to a script that logs the call will 
> show it.

OK, just to highlight the issue, I run iptables -h in my build chroot
(32bit chroot on a 64bit host):

chroot:quad iptables-1.4.10 # iptables -h
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
FATAL: Could not load
/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
file or directory
iptables v1.4.10
...snip normal iptables help text...


> echo '#!/bin/sh' >/tmp/modp
> echo 'echo "$@" >>/tmp/modp.log' >>/tmp/modp
> echo /tmp/modp >/proc/sys/kernel/modprobe
> iptables-restore foo.txt

OK, with the addition of an "chmod +x" I run the above and get
(deliberately used non existent foo.txt):

$ iptables-restore foo.txt
Can't open foo.txt: No such file or directory

$ cat /tmp/modp.log
ip_tables -q
-q -- ipt_SET
-q -- ipt_SET
-q -- ipt_set
-q -- ipt_set



OK, I'm slightly unsure why there are fewer calls in that last time I
did exactly this, but nonetheless we see a bunch of modprobe calls. 
strace also this code being called.

I then apply Maciej's patch to delay loading and also patch out
xtables.c / xtables_insmod(). Marciej's patch would mean that your test
above wouldn't cause any module loading because it's now delayed until
something uses it, so instead I run up shorewall which loads a fairly
complete real set of rules using "iptables restore".  Result is no log
file is created

Therefore I believe that the delays are due only to the modprobe calls
in xtables.c, and as they are slow and completely redundant (for me) I'm
hoping to find a way to eliminate the call (for the case of compiled in
kernel modules).

Hopefully this is now clearer?

Can anyone please help?

Ed W

