From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 01/12] IP set core support
Date: Thu, 20 Jan 2011 23:38:42 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101202331260.2195@blackhole.kfki.hu>
References: yes <1295047436-20702-1-git-send-email-kadlec@blackhole.kfki.hu> <1295047436-20702-2-git-send-email-kadlec@blackhole.kfki.hu> <4D370BE5.4050901@trash.net> <alpine.DEB.2.00.1101192201310.31954@blackhole.kfki.hu> <4D376899.20609@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:42827 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1ATWio (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 17:38:44 -0500
In-Reply-To: <4D376899.20609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 19 Jan 2011, Patrick McHardy wrote:

> Am 19.01.2011 22:54, schrieb Jozsef Kadlecsik:
> > Hi Patrick,
> > 
> > On Wed, 19 Jan 2011, Patrick McHardy wrote:
> > 
> >>> +/* Interface to iptables/ip6tables */
> >>> +
> >>> +#define SO_IP_SET		83
> >>
> >> Just wondering if we should define this in relation to IP_BASE_CTL
> >> or something like that to avoid possible clashes in the future.
> > 
> > Or make it a module parameter?
> 
> I don't think that makes sense, the option needs to be known to
> userspace and is part of the ABI. My main concern was clashes with
> other options added in the future since the definition doesn't
> use any of the reserved ranges, like IP_CTL_BASE. I wasn't able
> to figure how you arrived at the value 83 and how we can avoid
> people reusing this value.

The value was inherited from ippool, many many years ago.

If/when iptables is linked against libmnl or alike, this remnant of the 
sockopt based protocol can completely be removed.

I'll send the updated patches to netfilter-devel tomorrow.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
