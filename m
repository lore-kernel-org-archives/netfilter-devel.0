From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 7/8] Remove support for compilation of conditional
 extensions
Date: Mon, 14 Apr 2008 15:20:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0804141516120.9562@blackhole.kfki.hu>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de>
 <2b2e38a1bfc0069830bd5cfe535fa52b7ee8a0da.1208075035.git.jengelh@computergmbh.de>
 <4802FDD8.301@trash.net> <alpine.LNX.1.10.0804140850240.9651@fbirervta.pbzchgretzou.qr>
 <4803002E.9070701@trash.net> <alpine.LNX.1.10.0804141414420.9651@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:50288 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbYDNNUF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:20:05 -0400
In-Reply-To: <alpine.LNX.1.10.0804141414420.9651@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 14 Apr 2008, Jan Engelhardt wrote:

> 
> On Monday 2008-04-14 08:56, Patrick McHardy wrote:
> > Jan Engelhardt wrote:
> >> On Monday 2008-04-14 08:46, Patrick McHardy wrote:
> >> > Was there some resolution on the discussion that this
> >> > is the way to go? I mainly would like to see an ACK
> >> > from Jozsef for this change before applying it.
> >> >
> >> There was some sort of positive agreement:
> >> 
> >> http://www.spinics.net/lists/netfilter-devel/msg02729.html (ipset)
> >> http://www.spinics.net/lists/netfilter-devel/msg02727.html (condition)
> >
> > Yes, "sort of". So far it seems most convenient to keep ipset in
> > iptables. What was the exact problem with these extensions again?
> >
> The problem is not the extensions themselves; but they do not compile
> due to a lack of their header files. Should it just be added?
> 
> Should ipset instead be added to the kernel?

No, I think the missing kernel header files (ip_set.h and ipt_set.h) 
should be added to the iptables source.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
