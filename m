From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] xt_recent: Fix buffer overflow
Date: Fri, 19 Feb 2010 21:57:37 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002192136160.4415@obet.zrqbmnf.qr>
References: <20100219174804.43CD8F8C3F@sepang.rtg.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Tim Gardner <timg@tpi.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50848 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab0BSU5i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Feb 2010 15:57:38 -0500
In-Reply-To: <20100219174804.43CD8F8C3F@sepang.rtg.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-02-19 18:48, Tim Gardner wrote:
>
>Consider the case when ip_pkt_list_tot==1; the first packet received is stored
>in e->stamps[0] and e->index is initialized to 1. The next received packet
>timestamp is then stored at e->stamps[1] in recent_entry_update(),
>a buffer overflow because the maximum e->stamps[] index is 0.

>@@ -173,10 +173,10 @@ recent_entry_init(struct recent_table *t, const union nf_inet_addr *addr,
> 
> static void recent_entry_update(struct recent_table *t, struct recent_entry *e)
> {
>+	e->index %= ip_pkt_list_tot;
> 	e->stamps[e->index++] = jiffies;
> 	if (e->index > e->nstamps)
> 		e->nstamps = e->index;
>-	e->index %= ip_pkt_list_tot;
> 	list_move_tail(&e->lru_list, &t->lru_list);
> }

Let's analyze in 3-step manner:

Claim: writes always happen to e->stamps[0]
Prereqs: ip_pkt_list_tot==1
Proof:
 Start with assumption that e->index's possible values at the
 start of the function are {0}.
 The timestamp is thus always stored in e->stamps[0].
 e->index is bumped from 0 to 1.
 The %= op clamps it back to 0.
 The possible values at the end of the function are thus {0}.
 Assumption holds and matches the result set exactly.
 Outside of the function you will thus never see e->index != 0.

This does not seem much different from your proposed patch,
which reads like:

Claim: same
Prereq: same
Proof:
 e->index's possible start values are {0,1}.
 The %= op clamps this to {0}.
 The timestamp is always stored in e->stamps[0].
 e->index is increased by one.
 The possible values at the end of the function are {1}.
 Assumption holds, but is a superset of the result set.
 Outside of the function, you may see e->index != 0.


So both variations of the code do the same, except yours seems to
have the additional potential pitfall that e->index is not within the
ring of modulus after the function has been executed.


Where would the thinko be?
