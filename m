From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ctnetlink: fix (really) race condition between
 dump_table and destroy
Date: Mon, 24 Jan 2011 14:25:41 +0100
Message-ID: <4D3D7DD5.9020902@netfilter.org>
References: <20110123231602.3383.31480.stgit@decadence>	 <1295851305.28358.16.camel@edumazet-laptop>	 <4D3D691F.3050403@netfilter.org> <4D3D74AD.5080300@trash.net>	 <1295873689.2755.22.camel@edumazet-laptop> <4D3D794D.9010401@netfilter.org> <1295874722.2755.25.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57011 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab1AXNZp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:25:45 -0500
In-Reply-To: <1295874722.2755.25.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24/01/11 14:12, Eric Dumazet wrote:
> Le lundi 24 janvier 2011 =C3=A0 14:06 +0100, Pablo Neira Ayuso a =C3=A9=
crit :
>=20
>> Yes, we can use nf_conntrack_get (which does atomic_inc) instead. Ne=
w
>> patch attached.
>=20
> I feel now a bit uncomfortable, sorry ;)
>=20
> Are we sure the refcount cannot reach 0 while we hold
> nf_conntrack_lock ?

the ct deletion from the hash list is protected by spin lock, so
whatever deletion would wait until we have left the dump section.

with this patch, the code looks like it was in 2.6.24 before the rcu st=
uff.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
