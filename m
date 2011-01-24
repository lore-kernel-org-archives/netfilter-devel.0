From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: ctnetlink: fix (really) race condition
 between dump_table and destroy
Date: Mon, 24 Jan 2011 15:06:11 +0100
Message-ID: <1295877971.2755.30.camel@edumazet-laptop>
References: <20110123231602.3383.31480.stgit@decadence>
	 <1295851305.28358.16.camel@edumazet-laptop>
	 <4D3D691F.3050403@netfilter.org> <4D3D74AD.5080300@trash.net>
	 <1295873689.2755.22.camel@edumazet-laptop> <4D3D794D.9010401@netfilter.org>
	 <1295874722.2755.25.camel@edumazet-laptop> <4D3D7DD5.9020902@netfilter.org>
	  <4D3D809F.30808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36339 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1AXOGQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 09:06:16 -0500
Received: by bwz15 with SMTP id 15so3576226bwz.19
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jan 2011 06:06:15 -0800 (PST)
In-Reply-To: <4D3D809F.30808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 24 janvier 2011 =C3=A0 14:37 +0100, Patrick McHardy a =C3=A9cr=
it :
> On 24.01.2011 14:25, Pablo Neira Ayuso wrote:
> > On 24/01/11 14:12, Eric Dumazet wrote:
> >> Le lundi 24 janvier 2011 =C3=A0 14:06 +0100, Pablo Neira Ayuso a =C3=
=A9crit :
> >>
> >>> Yes, we can use nf_conntrack_get (which does atomic_inc) instead.=
 New
> >>> patch attached.
> >>
> >> I feel now a bit uncomfortable, sorry ;)
> >>
> >> Are we sure the refcount cannot reach 0 while we hold
> >> nf_conntrack_lock ?
> >=20
> > the ct deletion from the hash list is protected by spin lock, so
> > whatever deletion would wait until we have left the dump section.
> >=20
> > with this patch, the code looks like it was in 2.6.24 before the rc=
u stuff.
>=20
> Yeah, we definitely have a reference while the conntrack is contained
> in the hash table, and removal requires taking nf_conntrack_lock,
> therefor using the conntrack entry while holding the lock is valid.

Yes, but to clarify my question, is the following possible ?

CPU 0                                           CPU1
dump()
spin_lock()
=2E...
    if (not enough room in skb)
						decrement last refcount
      increment_ref_count()
spin_unlock();
						since refcount hit 0,
						spin_lock(nf_conntrack)
						remove ct from hashes


If yes we should use the atomic_inc_not_zero() form.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
