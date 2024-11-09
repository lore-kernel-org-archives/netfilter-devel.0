Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C468E146590;
	Sat,  9 Nov 2024 10:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731146977; cv=none; b=tPPSOjb3785OaZ4CBsKqUmvH65Rpk3mxtBGuC31mN639r4Bv2Jchp4v5hKJTPN1cHebT/GSuQJ9x8I6rm961d4r6TpgvXeAmqzWTTqzjHT8INGYHa4AtDA1bvmS1uw7CkzscVXMl7wBFcFsbI3EgCSk0Q52+2FfX4E+5FqQr9iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731146977; c=relaxed/simple;
	bh=Lq5A5kcSbQSM9mkKcxPIpv8cjiiz1I5NOw6kgjNp7XE=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=U/8q+U/ktPP4xwdYrUBgnz6EhGSPLaLpUbe+GaocUqld5zd7jNmwcXj4nwY8e3Nye8gzywpHBm5KKmRJIlPnlAFJSTivCwVqrarxiHxIT7hXM+ezELrRgroXbe1g4VIcfDDxOFuqhJyGmHUOaenTf2ITud+HnENafr8qR1YIpYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W0eYpnFo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W0eYpnFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD94C4CECE;
	Sat,  9 Nov 2024 10:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731146977;
	bh=Lq5A5kcSbQSM9mkKcxPIpv8cjiiz1I5NOw6kgjNp7XE=;
	h=From:Date:To:cc:Subject:In-Reply-To:References:From;
	b=W0eYpnFoHk47ScMecx7J8VkYaqi7D6Blcxp1VDPJrnztZrFujUYplhBCIW8iEzVbV
	 HsD6hymEXrMJVT9Q1lZ5JlKmcOVyiCr3cqjfZc2BrPl8ADzycXgFbv+QFNMPn5EH1z
	 84Etx3EkUksuzXAP9hrNieIC/h1E9JmP4FkPGZpLXqq5M1Z5F7+Vpf1OArMTb3h6TB
	 VjIWgB3LHjGmpOSfUzA61MWqKqbIbNMfrMGzX2q7cIqssgIZdQMcFPnR+TGSbN5lZY
	 7gMY4cYAyTdbjtrjlfRz/KX4XVFapWSzJCrdKgBs+EqEHl3aaAE6LRSS4Hw5UPg8wf
	 +IiE8TrgEqYhA==
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ij@kernel.org>
Date: Sat, 9 Nov 2024 12:09:32 +0200 (EET)
To: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
cc: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net, 
    edumazet@google.com, dsahern@kernel.org, pabeni@redhat.com, 
    joel.granados@kernel.org, kuba@kernel.org, andrew+netdev@lunn.ch, 
    horms@kernel.org, pablo@netfilter.org, kadlec@netfilter.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    ncardwell@google.com, koen.de_schepper@nokia-bell-labs.com, 
    g.white@CableLabs.com, ingemar.s.johansson@ericsson.com, 
    mirja.kuehlewind@ericsson.com, cheshire@apple.com, rs.ietf@gmx.at, 
    Jason_Livingood@comcast.com, vidhi_goel@apple.com
Subject: Re: [PATCH v5 net-next 08/13] gso: AccECN support
In-Reply-To: <20241105100647.117346-9-chia-yu.chang@nokia-bell-labs.com>
Message-ID: <661b9e25-0237-ef1f-e2fa-86ca52f676a2@kernel.org>
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-9-chia-yu.chang@nokia-bell-labs.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-396905128-1731146459=:1016"
Content-ID: <3207a8a6-76b8-bedd-d35c-02d594f2f476@kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-396905128-1731146459=:1016
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <ec7a403e-71b7-e063-ed88-40c0d643d808@kernel.org>

On Tue, 5 Nov 2024, chia-yu.chang@nokia-bell-labs.com wrote:

> From: Ilpo J=E4rvinen <ij@kernel.org>
>=20
> Handling the CWR flag differs between RFC 3168 ECN and AccECN.
> With RFC 3168 ECN aware TSO (NETIF_F_TSO_ECN) CWR flag is cleared
> starting from 2nd segment which is incompatible how AccECN handles
> the CWR flag. Such super-segments are indicated by SKB_GSO_TCP_ECN.
> With AccECN, CWR flag (or more accurately, the ACE field that also
> includes ECE & AE flags) changes only when new packet(s) with CE
> mark arrives so the flag should not be changed within a super-skb.
> The new skb/feature flags are necessary to prevent such TSO engines
> corrupting AccECN ACE counters by clearing the CWR flag (if the
> CWR handling feature cannot be turned off).
>=20
> If NIC is completely unaware of RFC3168 ECN (doesn't support
> NETIF_F_TSO_ECN) or its TSO engine can be set to not touch CWR flag
> despite supporting also NETIF_F_TSO_ECN, TSO could be safely used
> with AccECN on such NIC. This should be evaluated per NIC basis
> (not done in this patch series for any NICs).
>=20
> For the cases, where TSO cannot keep its hands off the CWR flag,
> a GSO fallback is provided by this patch.
>=20
> Signed-off-by: Ilpo J=E4rvinen <ij@kernel.org>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> ---
>  include/linux/netdev_features.h | 8 +++++---
>  include/linux/netdevice.h       | 2 ++
>  include/linux/skbuff.h          | 2 ++
>  net/ethtool/common.c            | 1 +
>  net/ipv4/tcp_offload.c          | 6 +++++-
>  5 files changed, 15 insertions(+), 4 deletions(-)
>=20
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_featu=
res.h
> index 66e7d26b70a4..c59db449bcf0 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -53,12 +53,12 @@ enum {
>  =09NETIF_F_GSO_UDP_BIT,=09=09/* ... UFO, deprecated except tuntap */
>  =09NETIF_F_GSO_UDP_L4_BIT,=09=09/* ... UDP payload GSO (not UFO) */
>  =09NETIF_F_GSO_FRAGLIST_BIT,=09=09/* ... Fraglist GSO */
> +=09NETIF_F_GSO_ACCECN_BIT,         /* TCP AccECN w/ TSO (no clear CWR) *=
/
>  =09/**/NETIF_F_GSO_LAST =3D=09=09/* last bit, see GSO_MASK */
> -=09=09NETIF_F_GSO_FRAGLIST_BIT,
> +=09=09NETIF_F_GSO_ACCECN_BIT,
> =20
>  =09NETIF_F_FCOE_CRC_BIT,=09=09/* FCoE CRC32 */
>  =09NETIF_F_SCTP_CRC_BIT,=09=09/* SCTP checksum offload */
> -=09__UNUSED_NETIF_F_37,
>  =09NETIF_F_NTUPLE_BIT,=09=09/* N-tuple filters supported */
>  =09NETIF_F_RXHASH_BIT,=09=09/* Receive hashing offload */
>  =09NETIF_F_RXCSUM_BIT,=09=09/* Receive checksumming offload */
> @@ -128,6 +128,7 @@ enum {
>  #define NETIF_F_SG=09=09__NETIF_F(SG)
>  #define NETIF_F_TSO6=09=09__NETIF_F(TSO6)
>  #define NETIF_F_TSO_ECN=09=09__NETIF_F(TSO_ECN)
> +#define NETIF_F_GSO_ACCECN=09__NETIF_F(GSO_ACCECN)
>  #define NETIF_F_TSO=09=09__NETIF_F(TSO)
>  #define NETIF_F_VLAN_CHALLENGED=09__NETIF_F(VLAN_CHALLENGED)
>  #define NETIF_F_RXFCS=09=09__NETIF_F(RXFCS)
> @@ -210,7 +211,8 @@ static inline int find_next_netdev_feature(u64 featur=
e, unsigned long start)
>  =09=09=09=09 NETIF_F_TSO_ECN | NETIF_F_TSO_MANGLEID)
> =20
>  /* List of features with software fallbacks. */
> -#define NETIF_F_GSO_SOFTWARE=09(NETIF_F_ALL_TSO | NETIF_F_GSO_SCTP |=09 =
    \
> +#define NETIF_F_GSO_SOFTWARE=09(NETIF_F_ALL_TSO | \
> +=09=09=09=09 NETIF_F_GSO_ACCECN | NETIF_F_GSO_SCTP | \
>  =09=09=09=09 NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_FRAGLIST)
> =20
>  /*
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 6e0f8e4aeb14..480d915b3bdb 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -5076,6 +5076,8 @@ static inline bool net_gso_ok(netdev_features_t fea=
tures, int gso_type)
>  =09BUILD_BUG_ON(SKB_GSO_UDP !=3D (NETIF_F_GSO_UDP >> NETIF_F_GSO_SHIFT))=
;
>  =09BUILD_BUG_ON(SKB_GSO_UDP_L4 !=3D (NETIF_F_GSO_UDP_L4 >> NETIF_F_GSO_S=
HIFT));
>  =09BUILD_BUG_ON(SKB_GSO_FRAGLIST !=3D (NETIF_F_GSO_FRAGLIST >> NETIF_F_G=
SO_SHIFT));
> +=09BUILD_BUG_ON(SKB_GSO_TCP_ACCECN !=3D
> +=09=09     (NETIF_F_GSO_ACCECN >> NETIF_F_GSO_SHIFT));
> =20
>  =09return (features & feature) =3D=3D feature;
>  }
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 48f1e0fa2a13..530cb325fb86 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -694,6 +694,8 @@ enum {
>  =09SKB_GSO_UDP_L4 =3D 1 << 17,
> =20
>  =09SKB_GSO_FRAGLIST =3D 1 << 18,
> +
> +=09SKB_GSO_TCP_ACCECN =3D 1 << 19,
>  };
> =20
>  #if BITS_PER_LONG > 32
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index 0d62363dbd9d..5c3ba2dfaa74 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -32,6 +32,7 @@ const char netdev_features_strings[NETDEV_FEATURE_COUNT=
][ETH_GSTRING_LEN] =3D {
>  =09[NETIF_F_TSO_BIT] =3D              "tx-tcp-segmentation",
>  =09[NETIF_F_GSO_ROBUST_BIT] =3D       "tx-gso-robust",
>  =09[NETIF_F_TSO_ECN_BIT] =3D          "tx-tcp-ecn-segmentation",
> +=09[NETIF_F_GSO_ACCECN_BIT] =3D=09 "tx-tcp-accecn-segmentation",
>  =09[NETIF_F_TSO_MANGLEID_BIT] =3D=09 "tx-tcp-mangleid-segmentation",
>  =09[NETIF_F_TSO6_BIT] =3D             "tx-tcp6-segmentation",
>  =09[NETIF_F_FSO_BIT] =3D              "tx-fcoe-segmentation",
> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> index 2308665b51c5..0b05f30e9e5f 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c
> @@ -139,6 +139,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
>  =09struct sk_buff *gso_skb =3D skb;
>  =09__sum16 newcheck;
>  =09bool ooo_okay, copy_destructor;
> +=09bool ecn_cwr_mask;
>  =09__wsum delta;
> =20
>  =09th =3D tcp_hdr(skb);
> @@ -198,6 +199,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
> =20
>  =09newcheck =3D ~csum_fold(csum_add(csum_unfold(th->check), delta));
> =20
> +=09ecn_cwr_mask =3D !!(skb_shinfo(gso_skb)->gso_type & SKB_GSO_TCP_ACCEC=
N);
> +
>  =09while (skb->next) {
>  =09=09th->fin =3D th->psh =3D 0;
>  =09=09th->check =3D newcheck;
> @@ -217,7 +220,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
>  =09=09th =3D tcp_hdr(skb);
> =20
>  =09=09th->seq =3D htonl(seq);
> -=09=09th->cwr =3D 0;
> +
> +=09=09th->cwr &=3D ecn_cwr_mask;

Hi all,

I started to wonder if this approach would avoid CWR corruption without
need to introduce the SKB_GSO_TCP_ACCECN flag at all:

- Never set SKB_GSO_TCP_ECN for any skb
- Split CWR segment on TCP level before sending. While this causes need to=
=20
split the super skb, it's once per RTT thing so does not sound very=20
significant (compare e.g. with SACK that cause split on every ACK)
- Remove th->cwr cleaning from GSO (the above line)
- Likely needed: don't negotiate HOST/GUEST_ECN in virtio

I think that would prevent offloading treating CWR flag as RFC3168 and CWR
would be just copied as is like a normal flag which is required to not=20
corrupt it. In practice, RFC3168 style traffic would just not combine=20
anything with the CWR'ed packet as CWRs are singletons with RFC3168.

Would that work? It sure sounds too simple to work but I cannot=20
immediately see why it would not.

--=20
 i.
--8323328-396905128-1731146459=:1016--
