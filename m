From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Add seperated timeout for the connections that only receive
 packets in one direction
Date: Fri, 27 Nov 2009 10:42:30 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911271036100.18988@blackhole.kfki.hu>
References: <4B0F9737.8050606@gmail.com>  <alpine.DEB.2.00.0911271020160.18988@blackhole.kfki.hu> <412e6f7f0911270132o3329843gab40f0c9a50620ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:59521 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZK0JmZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2009 04:42:25 -0500
In-Reply-To: <412e6f7f0911270132o3329843gab40f0c9a50620ae@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 27 Nov 2009, Changli Gao wrote:

> On Fri, Nov 27, 2009 at 5:25 PM, Jozsef Kadlecsik
> <kadlec@blackhole.kfki.hu> wrote:
> >
> > On Fri, 27 Nov 2009, Changli Gao wrote:
> >
> >
> > I don't see how can the condition be true. The first reply
> > packet checked here and if that's a pure ACK, then the new_state cannot be
> > TCP_CONNTRACK_ESTABLISHED (except for picked up connections).
> 
> Yes, as nf_conntrack_tcp_timeout_loose_unreply implied, it is for
> picked up connections.

Connection pickup can be disabled by proper rules or by setting 
nf_ct_tcp_loose to zero. So in which environment this third method is 
required? I'm curious what triggered you to write your patch.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
