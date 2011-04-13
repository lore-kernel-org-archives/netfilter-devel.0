From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 13 Apr 2011 14:06:10 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104131402340.25539@obet.zrqbmnf.qr>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
 <4DA0C402.1090809@wildgooses.com> <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <4DA4BE06.3020107@wildgooses.com> <alpine.LNX.2.01.1104122337590.12267@obet.zrqbmnf.qr> <4DA58412.3070306@wildgooses.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, zenczykowski@gmail.com
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53972 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1DMMGM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:06:12 -0400
In-Reply-To: <4DA58412.3070306@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2011-04-13 13:08, Ed W wrote:

>>> $ cat /tmp/modp.log
>>> ip_tables -q
>>> -q -- ipt_SET
>>> -q -- ipt_SET
>>> -q -- ipt_set
>>> -q -- ipt_set
>> 
>> The trailing -q is a hint towards the call from iptables, whereas the
>> leading -q is kernel-invoked calls. Specifically, it seems that
>> xt_set is indeed not built-in, but a module.
>
>Hmm, that's an interesting point.
>
>So ipt_SET of course not build in to the kernel (2.6.37/38).  Further I
>can't find any reference to it in a 2.6.38 kernel tree? I do however see
>something in the 2.6.39-rc3 tree (sanity check please - is this correct?)

Yes, ipset was first merged into the kernel for 2.6.39.

>This would seem to explain why the kernel autoloader was having a try to
>find some missing module? It's actually completely missing on this kernel?

On your 37/38, yes.

>However, I really don't understand the sequence of calls here that has
>caused apparently a "modprobe iptables" from xtables.c to trigger the
>kernel (?) to try and insert some module that it knows nothing about
>(only iptables seems to know about it)?

You mentioned your program _is_ actually compiled with --enable-static,
as such this applies:

Since libxt_SET and libxt_set are built into iptables-multi, their
revision will be checked unconditionally (previous to Maciej's patches).
Since the 37s and 38s kernel has no xt_SET/set, it will try probing.
All looks normal. Including that your modprobe count still is just 5
and not 20+.
