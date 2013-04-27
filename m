From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 13/13] netfilter: ipset: set match: add support to match
 the counters
Date: Sat, 27 Apr 2013 20:36:27 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304272034050.1511@blackhole.kfki.hu>
References: <1367067045-960-1-git-send-email-kadlec@blackhole.kfki.hu> <1367067045-960-14-git-send-email-kadlec@blackhole.kfki.hu> <20130427173348.GA3298@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:33852 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab3D0Sg3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 14:36:29 -0400
In-Reply-To: <20130427173348.GA3298@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 27 Apr 2013, Pablo Neira Ayuso wrote:

> On Sat, Apr 27, 2013 at 02:50:45PM +0200, Jozsef Kadlecsik wrote:
> > The new revision of the set match supports to match the counters
> > and to suppress updating the counters at matching too.
> > 
> > At the set:list types, the updating of the subcounters can be
> > suppressed as well.
> > 
> > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
[...]
> > +static bool
> > +set_match_v3(const struct sk_buff *skb, CONST struct xt_action_param *par)
> 
> net/netfilter/xt_set.c:344:41: error: unknown type name ?CONST?
> net/netfilter/xt_set.c:426:13: error: ?set_match_v3? undeclared here (not in a function)
> net/netfilter/xt_set.c:326:1: warning: ?match_counter? defined but not used [-Wunused-function]
> 
> Fixed here, no need to resend.

Ohh, that slipped in from the compatibility part for older kernel 
branches in the ipset package, sorry.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
