From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH nf] netfilter: conntrack: disable generic protocol
 tracking
Date: Thu, 25 Sep 2014 16:48:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1409251626160.14369@blackhole.kfki.hu>
References: <20140925113237.GC25548@breakpoint.cc> <alpine.DEB.2.10.1409251404060.14369@blackhole.kfki.hu> <20140925125748.GA26716@breakpoint.cc> <alpine.DEB.2.10.1409251535470.14369@blackhole.kfki.hu> <20140925141314.GB26716@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, dborkman@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:44437 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbaIYOrm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:47:42 -0400
In-Reply-To: <20140925141314.GB26716@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 25 Sep 2014, Florian Westphal wrote:

> > Originally all protocol trackers were included in the conntrack module. 
> > The whole issue comes from the fact that at present four ones can be in 
> > modules and might not be loaded in. If the trackers work, then the whole 
> > issue disappears.
> 
> I don't think so.  You'd actually have to implement trackers for all l4
> protocols, and you'd need kernel where these are then also built.

You mean "deep" or "real" connection trackers instead of the generic one.

> > With disabling generic tracking you force everyone to switch to stateless 
> > filtering, without any other option.
> 
> How is generic tracking different from stateless filtering?
> Its identical to
> 
> -p $proto -j ACCEPT
> 
> since the generic tracking entry doesn't contain any l4 lookup keys?
> So I don't see any benefit from the generic tracker (except the
> backwards compat issue, I agree, it is a problem)

Without conntrack, you don't have NAT.

Without conntrack, you don't have a direction. So how do you controll who 
may initiate the connection for the protocols which are covered by the 
generic tracker? We don't have any match for that.
 
> No sctp conntracker available (CONFIG_NF_CT_PROTO_SCTP=n) or some
> temporary issue when we tried to modprobe?
> Too bad, your -p scpt --dport x + ESTABLISHED rule matches all flows.

The generic tracker can know which protocols have an own tracker and when 
it's not available can refuse to track that flow (like the proposed patch 
but selectively, just in this very case).

> Exploitable hole in the sctp conntracker?  Great, remote user can cause
> it to be loaded automatically now.

Exploitable modules can be blacklisted temporarily, while the fix is not 
available. With a generic tracker which refuses to track protocols with 
own trackers, the current security issue is not opened up.

> Some other protocol where we don't have conntrack support?
> Same, you get magic ESTABLISHED state everywhere...

NEW and ESTABLISHED states, which means directions and thus policies.
Those are all lost without the generic tracker.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
