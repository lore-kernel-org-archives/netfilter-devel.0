From: Ed W <lists@wildgooses.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 13 Apr 2011 13:35:13 +0100
Message-ID: <4DA59881.1050501@wildgooses.com>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr> <4DA0C402.1090809@wildgooses.com> <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com> <4DA58A73.9030308@wildgooses.com> <alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:42234 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1DMMfO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:35:14 -0400
In-Reply-To: <alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

> In iptables, the options --enable-static and --enable-shared are 
> semantically different from other projects.

Thanks for confirming - iptables also helpfully spells exactly this out
in the INSTALL doc (+1 for open source documentation!!)


>> Additionally, as helpfully pointed out by Jan, a chunk of my problem is
>> my static iptables apparently trying to probe a kernel module which
>> isn't incorporated into my kernel version.  I can't immediately see a
>> solution to not uselessly probing for that (without patching iptables)?
>> Any ideas?
> 
> I would have said it could be the missing SET module being the cause for 
> your modprobe time accumulation, but since you also use iptables-restore 
> that possibility, too, is eliminated.

Yes, although these modules are being probed for even on a zero
(missing) input to iptables-restore.  However, that seems consistent
with a v1.4.10 iptables --enable-static based binary?  Presumably this
just probes everything?

(To be clear my test in my previous email was NOT using your git commit
to delay mod probing)

I will have to retest with your commit and without my hack to see
exactly what is still being probed for

Thanks

Ed W
