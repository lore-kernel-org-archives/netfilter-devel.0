From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 13 Apr 2011 14:45:44 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104131441520.25539@obet.zrqbmnf.qr>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr>
 <4DA0C402.1090809@wildgooses.com> <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com> <4DA58A73.9030308@wildgooses.com> <alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr>
 <4DA59881.1050501@wildgooses.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39809 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab1DMMpq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:45:46 -0400
In-Reply-To: <4DA59881.1050501@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-04-13 14:35, Ed W wrote:

>Hi
>
>> In iptables, the options --enable-static and --enable-shared are 
>> semantically different from other projects.
>
>Thanks for confirming - iptables also helpfully spells exactly this out
>in the INSTALL doc (+1 for open source documentation!!)

-1 to the user for not reading it ;-)

>>> Additionally, as helpfully pointed out by Jan, a chunk of my problem is
>>> my static iptables apparently trying to probe a kernel module which
>>> isn't incorporated into my kernel version.  I can't immediately see a
>>> solution to not uselessly probing for that (without patching iptables)?
>>> Any ideas?
>> 
>> I would have said it could be the missing SET module being the cause for 
>> your modprobe time accumulation, but since you also use iptables-restore 
>> that possibility, too, is eliminated.
>
>Yes, although these modules are being probed for even on a zero
>(missing) input to iptables-restore.  However, that seems consistent
>with a v1.4.10 iptables --enable-static based binary?  Presumably this
>just probes everything?

Yes, and that which does not exist in the kernel you pay with a modprobe 
call then. That would not only include SET, but also extensions long 
obsoleted, such as libipt_unclean's counterpart.
