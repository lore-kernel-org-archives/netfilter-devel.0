From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: libmnl: misc code updates
Date: Sun, 24 Oct 2010 22:33:31 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1010242222450.22824@blackhole.kfki.hu>
References: <1287812691-14470-1-git-send-email-jengelh@medozas.de> <4CC2F6AD.7070603@netfilter.org> <alpine.LNX.2.01.1010232052330.8540@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:32956 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438Ab0JXUdc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 16:33:32 -0400
In-Reply-To: <alpine.LNX.2.01.1010232052330.8540@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Sat, 23 Oct 2010, Jan Engelhardt wrote:

> On Saturday 2010-10-23 16:52, Pablo Neira Ayuso wrote:
> 
> >On 23/10/10 07:44, Jan Engelhardt wrote:
> >> The following changes since commit a8956ff09c06869b6c5bc5f525944d8c228e64e9:
> >> 
> >>   doc: git tree update (now at netfilter.org) and fix listing in doxygen (2010-10-21 13:32:42 +0200)
> >> 
> >> are available in the git repository at:
> >>   git://dev.medozas.de/libmnl master
> >
> >Thanks Jan, I have pulled patches from 1 to 11. Patches 12 and 13 change
> >the API/ABI and I'd like to hear from Jozsef first.
> >
> >@Jozsef, since I haven't released first version libmnl yet, we're still
> >in time to make those change, or would they be annoying for ipset5? If
> >so, I won't apply them.
> 
> I compile-tested it with ipset5, and there are no new errors or warnings 
> popping up.

Yes, the changes are OK for ipset5, no problem for me.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
