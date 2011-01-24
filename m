From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: ctnetlink: fix (really) race condition
 between dump_table and destroy
Date: Mon, 24 Jan 2011 13:54:49 +0100
Message-ID: <1295873689.2755.22.camel@edumazet-laptop>
References: <20110123231602.3383.31480.stgit@decadence>
	 <1295851305.28358.16.camel@edumazet-laptop>
	 <4D3D691F.3050403@netfilter.org>  <4D3D74AD.5080300@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Stephen Hemminger <shemminger@vyatta.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53458 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1AXMyy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:54:54 -0500
Received: by wyb28 with SMTP id 28so4026861wyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jan 2011 04:54:52 -0800 (PST)
In-Reply-To: <4D3D74AD.5080300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 24 janvier 2011 =C3=A0 13:46 +0100, Patrick McHardy a =C3=A9cr=
it :
> On 24.01.2011 12:57, Pablo Neira Ayuso wrote:
> > On 24/01/11 07:41, Eric Dumazet wrote:
> >> Le lundi 24 janvier 2011 =C3=A0 00:16 +0100, Pablo Neira Ayuso a =C3=
=A9crit :
> >>> In 13ee6ac579574a2a95e982b19920fd2495dce8cd, we recovered spinloc=
ks
> >>> to protect the dump of the conntrack table according to reports f=
rom
> >>> Stephen and acknowledgments on the issue from Eric.
> >>
> >> When a commit is referred, always give its title, and you can use =
a
> >> short id (12 digits are OK)
> >=20
> > I'm using the id that git log --oneline shows, is it OK?
> >=20
> >> In 13ee6ac57957 (netfilter: fix race in conntrack between dump_tab=
le and
> >> destroy)
> >>
> >>> However, Stephen removed the refcount bump in that patch that all=
ows
> >>> to keep a reference to the current ct object we are interating ov=
er.
> >>> That code avoids race conditions between ct object destruction an=
d
> >>> the iteration itself. This patch reintroduces these lines since t=
he
> >>> ct object may vanish between two recvmgs() invocations.
> >>>
> >>> This patch fixes ocasional crashes while dumping the conntrack ta=
ble
> >>> intensively.
> >>>
> >>> Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>
> >>
> >> Thats not true, Stephen was not in CC on your mail
> >=20
> > I'm sorry, I forgot to add --cc to stgit.
> >=20
> >> I add him right now.
> >>
> >>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> >>> ---
> >>>  net/netfilter/nf_conntrack_netlink.c |    8 ++++++--
> >>>  1 files changed, 6 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter=
/nf_conntrack_netlink.c
> >>> index 93297aa..519e245 100644
> >>> --- a/net/netfilter/nf_conntrack_netlink.c
> >>> +++ b/net/netfilter/nf_conntrack_netlink.c
> >>> @@ -654,14 +654,16 @@ restart:
> >>>  			if (NF_CT_DIRECTION(h) !=3D IP_CT_DIR_ORIGINAL)
> >>>  				continue;
> >>>  			ct =3D nf_ct_tuplehash_to_ctrack(h);
> >>> +			if (!atomic_inc_not_zero(&ct->ct_general.use))
> >>> +				continue;
> >>>  			/* Dump entries of a given L3 protocol number.
> >>>  			 * If it is not specified, ie. l3proto =3D=3D 0,
> >>>  			 * then dump everything. */
> >>>  			if (l3proto && nf_ct_l3num(ct) !=3D l3proto)
> >>> -				continue;
> >>> +				goto releasect;
> >>>  			if (cb->args[1]) {
> >>>  				if (ct !=3D last)
> >>> -					continue;
> >>> +					goto releasect;
> >>>  				cb->args[1] =3D 0;
> >>>  			}
> >>>  			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
> >>> @@ -679,6 +681,8 @@ restart:
> >>>  				if (acct)
> >>>  					memset(acct, 0, sizeof(struct nf_conn_counter[IP_CT_DIR_MAX=
]));
> >>>  			}
> >>> +releasect:
> >>> +		nf_ct_put(ct);
> >>>  		}
> >>>  		if (cb->args[1]) {
> >>>  			cb->args[1] =3D 0;
> >>>
> >>
> >>
> >> Hmm...
> >>
> >> Only the RCU lookup should need this extra check (atomic_inc_not_z=
ero),
> >> not a writer. (And a dumper is a "writer" since it holds nf_conntr=
ack
> >> spinlock)
> >>
> >> In Stephen commit, we switched from RCU lookup to traditional one
> >> (spinlock protected), so, we should not need to touch individual o=
bjects
> >> refcount ?
> >>
> >> I feel the right fix is not to increment refcount then decrement i=
t.
> >>
> >> Only to _test_ it being zero, and not dumping the ct, eventually ?
> >>
> >>
> >> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/=
nf_conntrack_netlink.c
> >> index 93297aa..a977cc7 100644
> >> --- a/net/netfilter/nf_conntrack_netlink.c
> >> +++ b/net/netfilter/nf_conntrack_netlink.c
> >> @@ -654,6 +654,8 @@ restart:
> >>  			if (NF_CT_DIRECTION(h) !=3D IP_CT_DIR_ORIGINAL)
> >>  				continue;
> >>  			ct =3D nf_ct_tuplehash_to_ctrack(h);
> >> +			if (!atomic_read(&ct->ct_general.use))
> >> +				continue;
> >>  			/* Dump entries of a given L3 protocol number.
> >>  			 * If it is not specified, ie. l3proto =3D=3D 0,
> >>  			 * then dump everything. */
> >=20
> > No, that won't work.
> >=20
> > Sorry, I didn't explain the problem appropriately. We still do a
> > nf_ct_put() for last ct. In that patch, you forgot to add the refco=
unt
> > bump that we need to keep the reference to the object.
> >=20
> > The following patch attached is smaller, it also fixes the problem =
and
> > we don't have to increase the refcount for each object. Now it look=
s
> > similar to how it was before the RCU patches.
>=20
> This looks correct to me, we need to keep a reference for continuatio=
ns.
> Eric, do you agree with this patch?

Taking a reference I agree for sure, this is the full
atomic_inc_not_zero(&ct->ct_general.use) I disagree.

Pablo, the refcount cannot be 0 at this point, or something is really
wrong ?

Why not using

atomic_inc(&ct->ct_general.use);

?


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
