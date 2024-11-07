Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716C9186E58;
	Thu,  7 Nov 2024 19:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731007694; cv=none; b=JusanHsaXtbA0RGafg5CS5ys38O4wzAUbxRar8IzC8YAvaeeQpBEhtzpUpkZxLigW7nCxw3rD8jnEpU8DKRagrkXHscT96t+VsZ41govpDmsZI5R8li9okCEM2ra4oQf3RSG0pL2h0pkbP2sjA1I8xckDaVtMTYlSQ6uul9nUI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731007694; c=relaxed/simple;
	bh=gjKC0WrGDW+KN0KMiorOLOy1s/sDoGsYYTGztXkVg2o=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=eCEevCIZmFBFJDJDdHwEYTJalCZsUsABQk556CuBWz6LgTevJS30+6bfmOltzFDIWHDCUN0xYdm/aC02+len9rONirCO0bUQdOZzl9JT3z2FjEETJWIizm73k5yAqSq2u5EQFiFoqS+n7RtFTZSN7agx18oRlo/nTYZ+TPuMOac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fx8Ea+O6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fx8Ea+O6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42AEC4CECC;
	Thu,  7 Nov 2024 19:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731007694;
	bh=gjKC0WrGDW+KN0KMiorOLOy1s/sDoGsYYTGztXkVg2o=;
	h=From:Date:To:cc:Subject:In-Reply-To:References:From;
	b=fx8Ea+O6OFcWwtSAz01uM72GKTBELMLFXNI3zDkOFC5HgIgradH13YdERHUfk9zOn
	 aOXOaMo0mrtEDp9UmEUyaDH9QsviT/LzhVSKHvF0o5ZPlYaty1VriZPOP2IORmxMCd
	 yCDi1aRSGkSKqH72QBPhH7v6eh6UgzX0MXfeNRzKz20pGWvzTd1lrTOF/V/PNGNsLG
	 FOkfCj0dDT/lUmJXdQsRFrsd3Fbp0jAdcPZ3jT4X1bav5K/NraFBNCp5eMTeBezWgd
	 FacaePiFHr/hDK9hfAVFridTxeV35XfuKMm/JNRlgAkAb6m82/8Y6RA67NocSQTLhQ
	 E/pFUGsm3Fs1g==
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ij@kernel.org>
Date: Thu, 7 Nov 2024 21:28:08 +0200 (EET)
To: Eric Dumazet <edumazet@google.com>
cc: chia-yu.chang@nokia-bell-labs.com, netdev@vger.kernel.org, 
    dsahern@gmail.com, davem@davemloft.net, dsahern@kernel.org, 
    pabeni@redhat.com, joel.granados@kernel.org, kuba@kernel.org, 
    andrew+netdev@lunn.ch, horms@kernel.org, pablo@netfilter.org, 
    kadlec@netfilter.org, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, ncardwell@google.com, 
    koen.de_schepper@nokia-bell-labs.com, g.white@cablelabs.com, 
    ingemar.s.johansson@ericsson.com, mirja.kuehlewind@ericsson.com, 
    cheshire@apple.com, rs.ietf@gmx.at, Jason_Livingood@comcast.com, 
    vidhi_goel@apple.com
Subject: Re: [PATCH v5 net-next 09/13] gro: prevent ACE field corruption &
 better AccECN handling
In-Reply-To: <CANn89i+9USaOthY3yaJPT-cbfAcP0re2bbGbWU7SqOSYEW2CMw@mail.gmail.com>
Message-ID: <37429ace-59c0-21d2-bcc8-54033794e789@kernel.org>
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-10-chia-yu.chang@nokia-bell-labs.com> <CANn89i+9USaOthY3yaJPT-cbfAcP0re2bbGbWU7SqOSYEW2CMw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1269263136-1731006228=:1016"
Content-ID: <5066e8e1-c21f-235d-ed7d-1d0e4fd9d6a4@kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1269263136-1731006228=:1016
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <dc0d38c4-970a-d4b7-79ba-cbd99ef3e7ef@kernel.org>

On Thu, 7 Nov 2024, Eric Dumazet wrote:

> On Tue, Nov 5, 2024 at 11:07=E2=80=AFAM <chia-yu.chang@nokia-bell-labs.co=
m> wrote:
> >
> > From: Ilpo J=C3=A4rvinen <ij@kernel.org>
> >
> > There are important differences in how the CWR field behaves
> > in RFC3168 and AccECN. With AccECN, CWR flag is part of the
> > ACE counter and its changes are important so adjust the flags
> > changed mask accordingly.
> >
> > Also, if CWR is there, set the Accurate ECN GSO flag to avoid
> > corrupting CWR flag somewhere.
> >
> > Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> > Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> > ---
> >  net/ipv4/tcp_offload.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> > index 0b05f30e9e5f..f59762d88c38 100644
> > --- a/net/ipv4/tcp_offload.c
> > +++ b/net/ipv4/tcp_offload.c
> > @@ -329,7 +329,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *h=
ead, struct sk_buff *skb,
> >         th2 =3D tcp_hdr(p);
> >         flush =3D (__force int)(flags & TCP_FLAG_CWR);
> >         flush |=3D (__force int)((flags ^ tcp_flag_word(th2)) &
> > -                 ~(TCP_FLAG_CWR | TCP_FLAG_FIN | TCP_FLAG_PSH));
> > +                 ~(TCP_FLAG_FIN | TCP_FLAG_PSH));
> >         flush |=3D (__force int)(th->ack_seq ^ th2->ack_seq);
> >         for (i =3D sizeof(*th); i < thlen; i +=3D 4)
> >                 flush |=3D *(u32 *)((u8 *)th + i) ^
> > @@ -405,7 +405,7 @@ void tcp_gro_complete(struct sk_buff *skb)
> >         shinfo->gso_segs =3D NAPI_GRO_CB(skb)->count;
> >
> >         if (th->cwr)
> > -               shinfo->gso_type |=3D SKB_GSO_TCP_ECN;
> > +               shinfo->gso_type |=3D SKB_GSO_TCP_ACCECN;
> >  }
> >  EXPORT_SYMBOL(tcp_gro_complete);
> >
>=20
> I do not really understand this patch. How a GRO engine can know which
> ECN variant the peers are using ?

Hi Eric,

Thanks for taking a look.

GRO doesn't know. Setting SKB_GSO_TCP_ECN in case of not knowing can=20
result in header change that corrupts ACE field. Thus, GRO has to assume=20
the RFC3168 CWR offloading trick cannot be used anymore (unless it tracks=
=20
the connection and knows the bits are used for RFC3168 which is something=
=20
nobody is going to do).

The main point of SKB_GSO_TCP_ACCECN is to prevent SKB_GSO_TCP_ECN or=20
NETIF_F_TSO_ECN offloading to be used for the skb as it would corrupt ACE=
=20
field value.

SKB_GSO_TCP_ACCECN doesn't allow CWR bits change within a super-skb but=20
the same CWR flag should be repeated for all segments. In a sense, it's=20
simpler than RFC3168 offloading.

> SKB_GSO_TCP_ECN is also used from other points, what is your plan ?
>=20
> git grep -n SKB_GSO_TCP_ECN
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:3888:
> skb_shinfo(skb)->gso_type |=3D SKB_GSO_TCP_ECN;
> drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:1291:
> skb_shinfo(skb)->gso_type |=3D SKB_GSO_TCP_ECN;
> drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:1312:
> skb_shinfo(skb)->gso_type |=3D SKB_GSO_TCP_ECN;

These looked like they should be just changed to set SKB_GSO_TCP_ACCECN=20
instead.

I don't anymore recall why I didn't change those when I made this patch=20
long time ago, perhaps it was just an oversight or things have changed=20
somehow since then.

> include/linux/netdevice.h:5061: BUILD_BUG_ON(SKB_GSO_TCP_ECN !=3D
> (NETIF_F_TSO_ECN >> NETIF_F_GSO_SHIFT));
> include/linux/skbuff.h:664:     SKB_GSO_TCP_ECN =3D 1 << 2,

Not relevant.

> include/linux/virtio_net.h:88:                  gso_type |=3D SKB_GSO_TCP=
_ECN;
> include/linux/virtio_net.h:161:         switch (gso_type & ~SKB_GSO_TCP_E=
CN) {
> include/linux/virtio_net.h:226:         if (sinfo->gso_type & SKB_GSO_TCP=
_ECN)

These need to be looked further what's going on as UAPI is also involved=20
here.

> net/ipv4/tcp_offload.c:404:             shinfo->gso_type |=3D SKB_GSO_TCP=
_ECN;

This was changed above. :-)

> net/ipv4/tcp_output.c:389: skb_shinfo(skb)->gso_type |=3D SKB_GSO_TCP_ECN=
;

I'm pretty sure this relates to sending side which will be taken care by=20
a later patch in the full series (not among these preparatory patches).


FYI, these TSO/GSO/GRO changes are what I was most unsure myself if I=20
got everything right when I was working with this series a few years back=
=20
so please keep that in mind while reviewing so my lack of knowledge=20
doesn't end up breaking something. :-)

--=20
 i.
--8323328-1269263136-1731006228=:1016--
