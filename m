From: Ed W <lists@wildgooses.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 13 Apr 2011 12:08:02 +0100
Message-ID: <4DA58412.3070306@wildgooses.com>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr> <4DA0C402.1090809@wildgooses.com> <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <4DA4BE06.3020107@wildgooses.com> <alpine.LNX.2.01.1104122337590.12267@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, zenczykowski@gmail.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:58783 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756965Ab1DMLIF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 07:08:05 -0400
In-Reply-To: <alpine.LNX.2.01.1104122337590.12267@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> It may well be the case that it's the kernel which is running the code
>> in xtables.c.
> 
> No no no. Not unless you run a hack like Kernel Mode Linux, which I
> doubt you do. Or do you? I have no idea what grsec put into their
> stuff, or whether you have an authentic unpatched iptables program.
> It does not look standard at all.

Nope, normal 2.6.37 kernel with grsec patches.  iptables 1.4.10 is
compiled under gentoo and largely vanilla other than I have added the
commit from Maciej and my own hack to delete modprobing

I think grsec is relatively unexciting in this case - largely it's just
a big "constifying" patch, plus some RBAC features.  If you strip out
the "constify" stuff (and chroot limitations), the remaining patch is
reasonably small and sane.


>> $ cat /tmp/modp.log
>> ip_tables -q
>> -q -- ipt_SET
>> -q -- ipt_SET
>> -q -- ipt_set
>> -q -- ipt_set
> 
> The trailing -q is a hint towards the call from iptables, whereas the
> leading -q is kernel-invoked calls. Specifically, it seems that
> xt_set is indeed not built-in, but a module.

Hmm, that's an interesting point.

So ipt_SET of course not build in to the kernel (2.6.37/38).  Further I
can't find any reference to it in a 2.6.38 kernel tree? I do however see
something in the 2.6.39-rc3 tree (sanity check please - is this correct?)

This would seem to explain why the kernel autoloader was having a try to
find some missing module? It's actually completely missing on this kernel?


However, I really don't understand the sequence of calls here that has
caused apparently a "modprobe iptables" from xtables.c to trigger the
kernel (?) to try and insert some module that it knows nothing about
(only iptables seems to know about it)?

Hmm, not sure how to progress this now?

Ed W
