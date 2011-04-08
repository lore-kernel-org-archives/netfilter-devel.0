From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Performance issue due to constant "modprobes"
Date: Sat, 9 Apr 2011 01:42:05 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53071 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab1DHXmH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2011 19:42:07 -0400
In-Reply-To: <4D9F98D3.5070802@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-04-09 01:22, Ed W wrote:

>On 08/04/2011 20:54, Jan Engelhardt wrote:
>> 
>> On Friday 2011-04-08 19:11, Ed W wrote:
>>> Starting "shorewall"
>>> - using busybox modprobe + released iptables = several minutes...
>>> - module-init-tools + released iptables = 12s
>>> - module-init-tools + your commit = 7.7s
>>> - module-init-tools + patching out modprobe completely = 4.9s
>>>
>>> So, whilst your patch has a huge positive benefit, I'm still seeing a
>>> substantial amount of cpu going to useless modprobing.
>> 
>> Which is only natural, because the kernel loads stuff. If you have
>> a problem with time (why so?) you should <*> the xtables modules,
>> and just leave iptables in its origin state.
>
>I'm sorry that I haven't managed to explain my situation clearly.
>However, I'm trying very hard to explain that I *have* got <*> in my
>kernel. There are no modules.
>
>Stated another way.  I don't have any kernel modules - everything is
>compiled into the kernel

In that case, iptables should never call modprobe.

You said `iptables -h` itself would take a long time due to modprobe, 
however, I can spot no invocation of it using `strace -fe execve 
iptables -h` when the desired codes are already loaded into the kernel 
one way or another.
