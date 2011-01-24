From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: ctnetlink: fix (really) race condition between
 dump_table and destroy
Date: Mon, 24 Jan 2011 14:37:35 +0100
Message-ID: <4D3D809F.30808@trash.net>
References: <20110123231602.3383.31480.stgit@decadence>	 <1295851305.28358.16.camel@edumazet-laptop>	 <4D3D691F.3050403@netfilter.org> <4D3D74AD.5080300@trash.net>	 <1295873689.2755.22.camel@edumazet-laptop> <4D3D794D.9010401@netfilter.org> <1295874722.2755.25.camel@edumazet-laptop> <4D3D7DD5.9020902@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63169 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1AXNhm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 08:37:42 -0500
In-Reply-To: <4D3D7DD5.9020902@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.01.2011 14:25, Pablo Neira Ayuso wrote:
> On 24/01/11 14:12, Eric Dumazet wrote:
>> Le lundi 24 janvier 2011 =E0 14:06 +0100, Pablo Neira Ayuso a =E9cri=
t :
>>
>>> Yes, we can use nf_conntrack_get (which does atomic_inc) instead. N=
ew
>>> patch attached.
>>
>> I feel now a bit uncomfortable, sorry ;)
>>
>> Are we sure the refcount cannot reach 0 while we hold
>> nf_conntrack_lock ?
>=20
> the ct deletion from the hash list is protected by spin lock, so
> whatever deletion would wait until we have left the dump section.
>=20
> with this patch, the code looks like it was in 2.6.24 before the rcu =
stuff.

Yeah, we definitely have a reference while the conntrack is contained
in the hash table, and removal requires taking nf_conntrack_lock,
therefor using the conntrack entry while holding the lock is valid.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
