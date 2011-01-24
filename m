From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: ctnetlink: fix (really) race condition
 between dump_table and destroy
Date: Mon, 24 Jan 2011 07:41:45 +0100
Message-ID: <1295851305.28358.16.camel@edumazet-laptop>
References: <20110123231602.3383.31480.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	Stephen Hemminger <shemminger@vyatta.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36743 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1AXGly (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 01:41:54 -0500
Received: by wyb28 with SMTP id 28so3757580wyb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Jan 2011 22:41:53 -0800 (PST)
In-Reply-To: <20110123231602.3383.31480.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 24 janvier 2011 =C3=A0 00:16 +0100, Pablo Neira Ayuso a =C3=A9=
crit :
> In 13ee6ac579574a2a95e982b19920fd2495dce8cd, we recovered spinlocks
> to protect the dump of the conntrack table according to reports from
> Stephen and acknowledgments on the issue from Eric.
>=20

When a commit is referred, always give its title, and you can use a
short id (12 digits are OK)

In 13ee6ac57957 (netfilter: fix race in conntrack between dump_table an=
d
destroy)

> However, Stephen removed the refcount bump in that patch that allows
> to keep a reference to the current ct object we are interating over.
> That code avoids race conditions between ct object destruction and
> the iteration itself. This patch reintroduces these lines since the
> ct object may vanish between two recvmgs() invocations.
>=20
> This patch fixes ocasional crashes while dumping the conntrack table
> intensively.
>=20
> Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>

Thats not true, Stephen was not in CC on your mail

I add him right now.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_conntrack_netlink.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_=
conntrack_netlink.c
> index 93297aa..519e245 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -654,14 +654,16 @@ restart:
>  			if (NF_CT_DIRECTION(h) !=3D IP_CT_DIR_ORIGINAL)
>  				continue;
>  			ct =3D nf_ct_tuplehash_to_ctrack(h);
> +			if (!atomic_inc_not_zero(&ct->ct_general.use))
> +				continue;
>  			/* Dump entries of a given L3 protocol number.
>  			 * If it is not specified, ie. l3proto =3D=3D 0,
>  			 * then dump everything. */
>  			if (l3proto && nf_ct_l3num(ct) !=3D l3proto)
> -				continue;
> +				goto releasect;
>  			if (cb->args[1]) {
>  				if (ct !=3D last)
> -					continue;
> +					goto releasect;
>  				cb->args[1] =3D 0;
>  			}
>  			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
> @@ -679,6 +681,8 @@ restart:
>  				if (acct)
>  					memset(acct, 0, sizeof(struct nf_conn_counter[IP_CT_DIR_MAX]));
>  			}
> +releasect:
> +		nf_ct_put(ct);
>  		}
>  		if (cb->args[1]) {
>  			cb->args[1] =3D 0;
>=20


Hmm...

Only the RCU lookup should need this extra check (atomic_inc_not_zero),
not a writer. (And a dumper is a "writer" since it holds nf_conntrack
spinlock)

In Stephen commit, we switched from RCU lookup to traditional one
(spinlock protected), so, we should not need to touch individual object=
s
refcount ?

I feel the right fix is not to increment refcount then decrement it.

Only to _test_ it being zero, and not dumping the ct, eventually ?


diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_co=
nntrack_netlink.c
index 93297aa..a977cc7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -654,6 +654,8 @@ restart:
 			if (NF_CT_DIRECTION(h) !=3D IP_CT_DIR_ORIGINAL)
 				continue;
 			ct =3D nf_ct_tuplehash_to_ctrack(h);
+			if (!atomic_read(&ct->ct_general.use))
+				continue;
 			/* Dump entries of a given L3 protocol number.
 			 * If it is not specified, ie. l3proto =3D=3D 0,
 			 * then dump everything. */


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
