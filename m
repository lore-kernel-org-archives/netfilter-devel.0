From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 13 Apr 2011 00:05:59 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104122337590.12267@obet.zrqbmnf.qr>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
 <4DA0C402.1090809@wildgooses.com> <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <4DA4BE06.3020107@wildgooses.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, zenczykowski@gmail.com
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35544 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600Ab1DLWGA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:06:00 -0400
In-Reply-To: <4DA4BE06.3020107@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2011-04-12 23:03, Ed W wrote:
>
>However, to be clear - my problem is with xtables.c / xtables_insmod(). 
>This function is called multiple times (in 1.4.10) even doing a simple
>"iptables -h" on a kernel where there are no modules.  I don't quite
>understand what *causes* that code to be called, my point is simply that
>it's called repeatedly (and needlessly) on each invocation of "iptables -h"

Then I suggest to grab backtraces with gdb.

>It may well be the case that it's the kernel which is running the code
>in xtables.c.

No no no. Not unless you run a hack like Kernel Mode Linux, which I
doubt you do. Or do you? I have no idea what grsec put into their
stuff, or whether you have an authentic unpatched iptables program.
It does not look standard at all.

>chroot:quad iptables-1.4.10 # iptables -h
>FATAL: Could not load
>/lib/modules/2.6.36.2-grsec2.2.1-vs2.3.0.36.38.4/modules.dep: No such
>file or directory
>[repeated 21 times]
>...snip normal iptables help text...
>
>> echo '#!/bin/sh' >/tmp/modp
>> echo 'echo "$@" >>/tmp/modp.log' >>/tmp/modp
>> echo /tmp/modp >/proc/sys/kernel/modprobe
>> iptables-restore foo.txt
>
>OK, with the addition of an "chmod +x" I run the above and get
>(deliberately used non existent foo.txt):
>
>$ iptables-restore foo.txt
>Can't open foo.txt: No such file or directory

>$ cat /tmp/modp.log
>ip_tables -q
>-q -- ipt_SET
>-q -- ipt_SET
>-q -- ipt_set
>-q -- ipt_set

The trailing -q is a hint towards the call from iptables, whereas the
leading -q is kernel-invoked calls. Specifically, it seems that
xt_set is indeed not built-in, but a module.

>OK, I'm slightly unsure why there are fewer calls in that last time I
>did exactly this, but nonetheless we see a bunch of modprobe calls. 
>strace also this code being called.

Please try with your real ruleset rather than foo.txt after clearing
modp.log.

