From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Performance issue due to constant "modprobes"
Date: Sun, 10 Apr 2011 00:30:55 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
 <4DA0C402.1090809@wildgooses.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58335 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab1DIWa5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Apr 2011 18:30:57 -0400
In-Reply-To: <4DA0C402.1090809@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-04-09 22:39, Ed W wrote:

>On 09/04/2011 00:42, Jan Engelhardt wrote:
>> 
>> You said `iptables -h` itself would take a long time due to modprobe, 
>> however, I can spot no invocation of it using `strace -fe execve 
>> iptables -h` when the desired codes are already loaded into the kernel 
>> one way or another.
>
>Maciej pointed out this is the case for git as of around 4 days ago, and
>in my last email I confirmed I saw the same.  I don't expect you to
>observe what you say if you use last released 1.4.10?

Maciej's patches do not change the kernel behavior, which is the only 
place from where kernel modules are loaded.


>(For example running up a fairly vanilla "shorewall"
>script manages to cause some 20 odd modules to load).

Some scripts irresponsibly call iptables often, and thus modprobe gets 
invoked that many times. I have said earlier, look at `strace -fe execve 
iptables...`.


>I appear to be able to eliminate this delay by modifying
>/proc/sys/kernel/modprobe, but I not (apparently) by using "iptables -M
>blah"? No one else is commenting on this, so either it's resolved in
>current git, or ...?

Because, as I have said earlier:
- iptables loads ip_tables.ko, and
- the kernel loads any remaining requested modules

The -M option only affects the first.


>No one has suggested anything, but basically, is there some way to avoid
>running modprobe when the kernel has all the xtables modules compiled
>in? ie can we detect that the code is already loaded and avoid trying to
>probe for it?

This detection is precisely what the kernel has been doing _for years_.
Changing /proc/sys/kernel/modprobe to a script that logs the call will 
show it.


echo '#!/bin/sh' >/tmp/modp
echo 'echo "$@" >>/tmp/modp.log' >>/tmp/modp
echo /tmp/modp >/proc/sys/kernel/modprobe
iptables-restore foo.txt

