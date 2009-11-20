From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: conntrack: improve out-of-sync situation in
 TCP tracking
Date: Fri, 20 Nov 2009 20:39:41 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911202038280.10259@blackhole.kfki.hu>
References: <20091114110651.7461.84924.stgit@decadence> <20091114111004.7461.37215.stgit@decadence> <4B0560CF.9000400@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:37111 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbZKTTjg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:39:36 -0500
In-Reply-To: <4B0560CF.9000400@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 19 Nov 2009, Patrick McHardy wrote:

> Pablo Neira Ayuso wrote:
> > Without this patch, if we receive a SYN packet from the client while
> > the firewall is out-of-sync, we let it go through. Then, if we see
> > the SYN/ACK reply coming from the server, we destroy the conntrack
> > entry and drop the packet to trigger a new retransmission. Then,
> > the retransmision from the client is used to start a new clean
> > session.
> > 
> > This patch improves the current handling. Basically, if we see an
> > unexpected SYN packet, we annotate the TCP options. Then, if we
> > see the reply SYN/ACK, this means that the firewall was indeed
> > out-of-sync. Therefore, we set a clean new session from the existing
> > entry based on the annotated values.
> > 
> > This patch adds two new 8-bits fields that fit in a 16-bits gap of
> > the ip_ct_tcp structure.
> > 
> > This patch is particularly useful for conntrackd since the
> > asynchronous nature of the state-synchronization allows to have
> > backup nodes that are not perfect copies of the master. This helps
> > to improve the recovery under some worst-case scenarios.
> 
> This seems like a good idea to me. I'd like to get an ACK from
> Jozsef before I apply this though since he knows this code way
> better than I do :)

Yes, it's a good idea and looks fine to me:

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
