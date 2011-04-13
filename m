From: Ed W <lists@wildgooses.com>
Subject: Re: Performance issue due to constant "modprobes"
Date: Wed, 13 Apr 2011 17:45:58 +0100
Message-ID: <4DA5D346.5030303@wildgooses.com>
References: <4D9E45C2.7030805@wildgooses.com> <BANLkTinfSAk0ruyqNcfAgReATbX_OV64EA@mail.gmail.com> <4D9F41BA.1060509@wildgooses.com> <alpine.LNX.2.01.1104082152500.24599@obet.zrqbmnf.qr> <4D9F98D3.5070802@wildgooses.com> <alpine.LNX.2.01.1104090140010.3023@obet.zrqbmnf.qr> <4DA0C402.1090809@wildgooses.com> <alpine.LNX.2.01.1104100022500.27387@obet.zrqbmnf.qr> <BANLkTik3=XWQHH9au7434RTJuf_Rg2sYSw@mail.gmail.com> <4DA58A73.9030308@wildgooses.com> <alpine.LNX.2.01.1104131406130.25539@obet.zrqbmnf.qr> <4DA59881.1050501@wildgooses.com> <alpine.LNX.2.01.1104131441520.25539@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:39920 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab1DMQqA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:46:00 -0400
In-Reply-To: <alpine.LNX.2.01.1104131441520.25539@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> -1 to the user for not reading it ;-)

I guess my point wasn't clear - I HAD already read it.  Just saying
thanks for being very patient with me and assuming otherwise


>> Yes, although these modules are being probed for even on a zero
>> (missing) input to iptables-restore.  However, that seems consistent
>> with a v1.4.10 iptables --enable-static based binary?  Presumably this
>> just probes everything?
> 
> Yes, and that which does not exist in the kernel you pay with a modprobe 
> call then. That would not only include SET, but also extensions long 
> obsoleted, such as libipt_unclean's counterpart.

Hmm, for the moment I'm happy to simply patch out all modprobe calls in
xtables.c, but there may come a time when I need more flexibility.  Does
anyone care enough about this to consider a more clever solution?

The issue would be that someone might genuinely want to forward/backward
port modules between kernel releases, however, perhaps it would be
reasonable to offer a compile time option for use with --enable-static
which limits compiled in modules to those which match a kernel version?

I can see lots of negatives here - does anyone have a better idea?

Thanks

Ed W
