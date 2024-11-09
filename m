Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D9B19D88F;
	Sat,  9 Nov 2024 21:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731188344; cv=none; b=KhPEb8nf0myq+HQS1beVtE/gtnUMDL/adwUBwWgx9Ljypb7B0ObcX2uM2absugFfEvNeJYQn68zV1+za9/dUN9CtTH7E6mqR3ayedjWBOCC7DfzJ+GGXrIPnwD54JLYtulbcwXBzEbSX9v3M/N6Hvz/TL6ZNA+s9o+klhUiwuEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731188344; c=relaxed/simple;
	bh=3ivJDVR/IiK9Pz6kCOt7aV6TK4uN/fU2uSzeItVkkW0=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=PsH4MybY/O+BQvijf2doMwjZGEylWj67ToXLPMiZl+Qs8osKXWe8ltz4rnj+nUkSumWgf7WE9dG78B3uzzxSFp9LU88jEhy57D6HENJrsUJ4vPkM6qVVciTZHGAEbWyCQHebkcdlmeqV6CM56/c7pZbMk9TH1Yu82jzXlPlnyTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZPBwXEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZPBwXEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45176C4CECE;
	Sat,  9 Nov 2024 21:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731188343;
	bh=3ivJDVR/IiK9Pz6kCOt7aV6TK4uN/fU2uSzeItVkkW0=;
	h=From:Date:To:cc:Subject:In-Reply-To:References:From;
	b=tZPBwXEYp2JwRqZVnxYJ1HF9CUoi4SOjmcqIpoaPLnQkU9cDQImQZ9DACRgiM9QTL
	 svpJos8+Zb+NiopvlChTVRI9p9oy+opnPtchPbn7yokdnjyyfibQRsYle5UmtOVjVK
	 G9A8OAN8phWZQ2XOHZea95+8lQ1NDSzzbXQ7d4WlNTMbVDji3GXXJBPxtXQd3DqGB8
	 f6NxmVMldNJPl56G49w/NAYZHcbyTUENapVN94ENEs+oY4Oz8LZ5D5+lxnmXvx/An+
	 ciRTGhhrpoEvD3eTFWorfR20hl/RsIkMVvQplUIIGwoaj1plwaki5n2OeUCVmgZH3e
	 o6odSq7zyFlhQ==
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ij@kernel.org>
Date: Sat, 9 Nov 2024 23:38:58 +0200 (EET)
To: Neal Cardwell <ncardwell@google.com>
cc: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>, netdev@vger.kernel.org, 
    dsahern@gmail.com, davem@davemloft.net, edumazet@google.com, 
    dsahern@kernel.org, pabeni@redhat.com, joel.granados@kernel.org, 
    kuba@kernel.org, andrew+netdev@lunn.ch, horms@kernel.org, 
    pablo@netfilter.org, kadlec@netfilter.org, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, koen.de_schepper@nokia-bell-labs.com, 
    g.white@cablelabs.com, ingemar.s.johansson@ericsson.com, 
    mirja.kuehlewind@ericsson.com, cheshire@apple.com, rs.ietf@gmx.at, 
    Jason_Livingood@comcast.com, vidhi_goel@apple.com, 
    Bob Briscoe <ietf@bobbriscoe.net>
Subject: Re: [PATCH v5 net-next 08/13] gso: AccECN support
In-Reply-To: <CADVnQym4VF9dmV9Q4GGXXoBr-0nNrM181rSZFR2cNJv+MDGO8w@mail.gmail.com>
Message-ID: <246379fa-a651-03f0-d1b2-b1091f4e14e8@kernel.org>
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-9-chia-yu.chang@nokia-bell-labs.com> <661b9e25-0237-ef1f-e2fa-86ca52f676a2@kernel.org> <CADVnQym4VF9dmV9Q4GGXXoBr-0nNrM181rSZFR2cNJv+MDGO8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-468571206-1731187719=:1016"
Content-ID: <2ebad6fa-56f9-b27b-5c2b-75037c78f34d@kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-468571206-1731187719=:1016
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <2aa45649-f36a-32e1-5e78-622692603dc0@kernel.org>

On Sat, 9 Nov 2024, Neal Cardwell wrote:

> On Sat, Nov 9, 2024 at 5:09=E2=80=AFAM Ilpo J=C3=A4rvinen <ij@kernel.org>=
 wrote:
> >
> > On Tue, 5 Nov 2024, chia-yu.chang@nokia-bell-labs.com wrote:
> >
> > > From: Ilpo J=C3=A4rvinen <ij@kernel.org>
> > >
> > > Handling the CWR flag differs between RFC 3168 ECN and AccECN.
> > > With RFC 3168 ECN aware TSO (NETIF_F_TSO_ECN) CWR flag is cleared
> > > starting from 2nd segment which is incompatible how AccECN handles
> > > the CWR flag. Such super-segments are indicated by SKB_GSO_TCP_ECN.
> > > With AccECN, CWR flag (or more accurately, the ACE field that also
> > > includes ECE & AE flags) changes only when new packet(s) with CE
> > > mark arrives so the flag should not be changed within a super-skb.
> > > The new skb/feature flags are necessary to prevent such TSO engines
> > > corrupting AccECN ACE counters by clearing the CWR flag (if the
> > > CWR handling feature cannot be turned off).
> > >
> > > If NIC is completely unaware of RFC3168 ECN (doesn't support
> > > NETIF_F_TSO_ECN) or its TSO engine can be set to not touch CWR flag
> > > despite supporting also NETIF_F_TSO_ECN, TSO could be safely used
> > > with AccECN on such NIC. This should be evaluated per NIC basis
> > > (not done in this patch series for any NICs).
> > >
> > > For the cases, where TSO cannot keep its hands off the CWR flag,
> > > a GSO fallback is provided by this patch.
> > >
> > > Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> > > Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> > > ---
> > >  include/linux/netdev_features.h | 8 +++++---
> > >  include/linux/netdevice.h       | 2 ++
> > >  include/linux/skbuff.h          | 2 ++
> > >  net/ethtool/common.c            | 1 +
> > >  net/ipv4/tcp_offload.c          | 6 +++++-
> > >  5 files changed, 15 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/include/linux/netdev_features.h b/include/linux/netdev_f=
eatures.h
> > > index 66e7d26b70a4..c59db449bcf0 100644
> > > --- a/include/linux/netdev_features.h
> > > +++ b/include/linux/netdev_features.h
> > > @@ -53,12 +53,12 @@ enum {
> > >       NETIF_F_GSO_UDP_BIT,            /* ... UFO, deprecated except t=
untap */
> > >       NETIF_F_GSO_UDP_L4_BIT,         /* ... UDP payload GSO (not UFO=
) */
> > >       NETIF_F_GSO_FRAGLIST_BIT,               /* ... Fraglist GSO */
> > > +     NETIF_F_GSO_ACCECN_BIT,         /* TCP AccECN w/ TSO (no clear =
CWR) */
> > >       /**/NETIF_F_GSO_LAST =3D          /* last bit, see GSO_MASK */
> > > -             NETIF_F_GSO_FRAGLIST_BIT,
> > > +             NETIF_F_GSO_ACCECN_BIT,
> > >
> > >       NETIF_F_FCOE_CRC_BIT,           /* FCoE CRC32 */
> > >       NETIF_F_SCTP_CRC_BIT,           /* SCTP checksum offload */
> > > -     __UNUSED_NETIF_F_37,
> > >       NETIF_F_NTUPLE_BIT,             /* N-tuple filters supported */
> > >       NETIF_F_RXHASH_BIT,             /* Receive hashing offload */
> > >       NETIF_F_RXCSUM_BIT,             /* Receive checksumming offload=
 */
> > > @@ -128,6 +128,7 @@ enum {
> > >  #define NETIF_F_SG           __NETIF_F(SG)
> > >  #define NETIF_F_TSO6         __NETIF_F(TSO6)
> > >  #define NETIF_F_TSO_ECN              __NETIF_F(TSO_ECN)
> > > +#define NETIF_F_GSO_ACCECN   __NETIF_F(GSO_ACCECN)
> > >  #define NETIF_F_TSO          __NETIF_F(TSO)
> > >  #define NETIF_F_VLAN_CHALLENGED      __NETIF_F(VLAN_CHALLENGED)
> > >  #define NETIF_F_RXFCS                __NETIF_F(RXFCS)
> > > @@ -210,7 +211,8 @@ static inline int find_next_netdev_feature(u64 fe=
ature, unsigned long start)
> > >                                NETIF_F_TSO_ECN | NETIF_F_TSO_MANGLEID=
)
> > >
> > >  /* List of features with software fallbacks. */
> > > -#define NETIF_F_GSO_SOFTWARE (NETIF_F_ALL_TSO | NETIF_F_GSO_SCTP |  =
      \
> > > +#define NETIF_F_GSO_SOFTWARE (NETIF_F_ALL_TSO | \
> > > +                              NETIF_F_GSO_ACCECN | NETIF_F_GSO_SCTP =
| \
> > >                                NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_FRAGL=
IST)
> > >
> > >  /*
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index 6e0f8e4aeb14..480d915b3bdb 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -5076,6 +5076,8 @@ static inline bool net_gso_ok(netdev_features_t=
 features, int gso_type)
> > >       BUILD_BUG_ON(SKB_GSO_UDP !=3D (NETIF_F_GSO_UDP >> NETIF_F_GSO_S=
HIFT));
> > >       BUILD_BUG_ON(SKB_GSO_UDP_L4 !=3D (NETIF_F_GSO_UDP_L4 >> NETIF_F=
_GSO_SHIFT));
> > >       BUILD_BUG_ON(SKB_GSO_FRAGLIST !=3D (NETIF_F_GSO_FRAGLIST >> NET=
IF_F_GSO_SHIFT));
> > > +     BUILD_BUG_ON(SKB_GSO_TCP_ACCECN !=3D
> > > +                  (NETIF_F_GSO_ACCECN >> NETIF_F_GSO_SHIFT));
> > >
> > >       return (features & feature) =3D=3D feature;
> > >  }
> > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > index 48f1e0fa2a13..530cb325fb86 100644
> > > --- a/include/linux/skbuff.h
> > > +++ b/include/linux/skbuff.h
> > > @@ -694,6 +694,8 @@ enum {
> > >       SKB_GSO_UDP_L4 =3D 1 << 17,
> > >
> > >       SKB_GSO_FRAGLIST =3D 1 << 18,
> > > +
> > > +     SKB_GSO_TCP_ACCECN =3D 1 << 19,
> > >  };
> > >
> > >  #if BITS_PER_LONG > 32
> > > diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> > > index 0d62363dbd9d..5c3ba2dfaa74 100644
> > > --- a/net/ethtool/common.c
> > > +++ b/net/ethtool/common.c
> > > @@ -32,6 +32,7 @@ const char netdev_features_strings[NETDEV_FEATURE_C=
OUNT][ETH_GSTRING_LEN] =3D {
> > >       [NETIF_F_TSO_BIT] =3D              "tx-tcp-segmentation",
> > >       [NETIF_F_GSO_ROBUST_BIT] =3D       "tx-gso-robust",
> > >       [NETIF_F_TSO_ECN_BIT] =3D          "tx-tcp-ecn-segmentation",
> > > +     [NETIF_F_GSO_ACCECN_BIT] =3D       "tx-tcp-accecn-segmentation"=
,
> > >       [NETIF_F_TSO_MANGLEID_BIT] =3D     "tx-tcp-mangleid-segmentatio=
n",
> > >       [NETIF_F_TSO6_BIT] =3D             "tx-tcp6-segmentation",
> > >       [NETIF_F_FSO_BIT] =3D              "tx-fcoe-segmentation",
> > > diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> > > index 2308665b51c5..0b05f30e9e5f 100644
> > > --- a/net/ipv4/tcp_offload.c
> > > +++ b/net/ipv4/tcp_offload.c
> > > @@ -139,6 +139,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *s=
kb,
> > >       struct sk_buff *gso_skb =3D skb;
> > >       __sum16 newcheck;
> > >       bool ooo_okay, copy_destructor;
> > > +     bool ecn_cwr_mask;
> > >       __wsum delta;
> > >
> > >       th =3D tcp_hdr(skb);
> > > @@ -198,6 +199,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *s=
kb,
> > >
> > >       newcheck =3D ~csum_fold(csum_add(csum_unfold(th->check), delta)=
);
> > >
> > > +     ecn_cwr_mask =3D !!(skb_shinfo(gso_skb)->gso_type & SKB_GSO_TCP=
_ACCECN);
> > > +
> > >       while (skb->next) {
> > >               th->fin =3D th->psh =3D 0;
> > >               th->check =3D newcheck;
> > > @@ -217,7 +220,8 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *s=
kb,
> > >               th =3D tcp_hdr(skb);
> > >
> > >               th->seq =3D htonl(seq);
> > > -             th->cwr =3D 0;
> > > +
> > > +             th->cwr &=3D ecn_cwr_mask;
> >
> > Hi all,
> >
> > I started to wonder if this approach would avoid CWR corruption without
> > need to introduce the SKB_GSO_TCP_ACCECN flag at all:
> >
> > - Never set SKB_GSO_TCP_ECN for any skb
> > - Split CWR segment on TCP level before sending. While this causes need=
 to
> > split the super skb, it's once per RTT thing so does not sound very
> > significant (compare e.g. with SACK that cause split on every ACK)
> > - Remove th->cwr cleaning from GSO (the above line)
> > - Likely needed: don't negotiate HOST/GUEST_ECN in virtio
> >
> > I think that would prevent offloading treating CWR flag as RFC3168 and =
CWR
> > would be just copied as is like a normal flag which is required to not
> > corrupt it. In practice, RFC3168 style traffic would just not combine
> > anything with the CWR'ed packet as CWRs are singletons with RFC3168.
> >
> > Would that work? It sure sounds too simple to work but I cannot
> > immediately see why it would not.
>=20
> The above description just seems to describe the dynamics for the
> RFC3168 case (since it mentions the CWR bit being set as just a "once
> per RTT thing").

For RFC3168 ECN case, that will still hold.

I think the misunderstanding was from this, I meant to only briefly say
how this would impact TCP using RFC3168 ECN. It needs to split CWR segment=
=20
to own skb to not share skb with non-CWR segments and that even is=20
infrequent enough (one per RTT) that it doesn't sound a bad compromise.

> Ilpo, can you please describe how AccECN traffic would be handled in
> your design proposal? (Since with established AccECN connections the
> CWR bit is part of the ACE counter and may be set on roughly half of
> outgoing data skbs...)

TSO (and GSO) RFC3168 ECN offloading takes an skb, puts CWR only into=20
the first segment and the rest of the skb are sent without it.

What we want for AccECN is to never combine CWR and non-CWR skbs. The=20
question is just how to achieve this.

My idea is to instead of this SKB_GSO_TCP_ACCECN flag split those skbs=20
always apart on TCP level (RFC3168 case) and to adapt GRO to not set=20
SKB_GSO_TCP_ECN either (the latter should already be done by this series).=
=20

When SKB_GSO_TCP_ECN is not set by TCP nor GRO anymore, is that enough to=
=20
prevent HW offloading CWR in the RFC3168 way? That is, will the HW offload=
=20
still mess with CWR flag or does HW offloading honor the lack of=20
SKB_GSO_TCP_ECN (I'm not sure about the answer as I've not dealt with NICs=
=20
on that level)? If the HW offloading keeps its hands off from CWR, then=20
there would be no need for this new flag.

GSO case is handled by simply removing CWR mangling from the code.


Well, I now went to read some random NIC drivers and I suspect the answer=
=20
is that HW offloading will still mess with CWR, given the lack of code=20
that would be depending on that gso_type flag... So I guess my idea is a=20
dead-end and SKB_GSO_TCP_ACCECN flag is needed to prevent HW offloads from=
=20
seeing the CWR'ed skb.

> Sorry if I'm misunderstanding something...

--=20
 i.
--8323328-468571206-1731187719=:1016--
