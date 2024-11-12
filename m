Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903372038A3;
	Tue, 12 Nov 2024 21:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731446356; cv=none; b=ruICzK6q/VdxpB8fFoxSFwSrj04kzs/ljIcNE9qLp0F7uPLEFVsMWM1y48PI5E4Fv/iKuMBO+mrNut63p/HfEnCvFPelxdRd3OM0aXDu1EshIXH038PGNkM6DTz3aZJqGd75Ry9OlEsMKCigF+3bQDkzZFyw1ACtc0NeFWDGmvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731446356; c=relaxed/simple;
	bh=BG2JxPbCUCWaiiKELo3CFr6HHWr+Xlxip5RIevEPmkE=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=NLC5OUtyFfXAftI/TK8jrriakZl6gQpqpv0vC8yof95HLDp5etJUbbQvD+wuIJtbfHYT+6eAyleo6aK177sTGJpmbMujWRIWHSYv+Hv57IIRPpij+I9Fk4D8CKlRlUvp5RrvUggtzFJzRVPSfc0yMFTf0LmAjAemxxkK+GynQyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEdfckXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEdfckXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E79C4CECD;
	Tue, 12 Nov 2024 21:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731446356;
	bh=BG2JxPbCUCWaiiKELo3CFr6HHWr+Xlxip5RIevEPmkE=;
	h=From:Date:To:cc:Subject:In-Reply-To:References:From;
	b=LEdfckXxMeEAhOKUMmr/+q+siJdebJM9AJ9vFUuUx6PTNpPRf0eA0RwTvu+GJKHkk
	 eBIgU3iTwWeRm9k9y2szKiGSnvgZ1MyOzXarGpHnAx7nOsvqwo4XrhKCtIMRZgbjbm
	 jBClTSULk9VehpCwoalejExbrplGUsNUAz7jXgnkp5KQ1VR3QHZ1Jp3+Dpd1iDM2H1
	 wRTdI+kIpnGYeTQVM7ULvgezcsf66Ta2/gLCUJynA7EsdffrJa0vGmuUeTj2/YWXN8
	 KyvMTk5n6Gd+zMTk0OgXP3cDZqbCE0sJbzcFyHDinFw0eNANsnd0tk4x5xibXdGfyM
	 dHdt/9ozQyirg==
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ij@kernel.org>
Date: Tue, 12 Nov 2024 23:19:09 +0200 (EET)
To: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>, 
    "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
    virtualization@lists.linux.dev
cc: Eric Dumazet <edumazet@google.com>, 
    "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
    "dsahern@gmail.com" <dsahern@gmail.com>, 
    "davem@davemloft.net" <davem@davemloft.net>, 
    "dsahern@kernel.org" <dsahern@kernel.org>, 
    "pabeni@redhat.com" <pabeni@redhat.com>, 
    "joel.granados@kernel.org" <joel.granados@kernel.org>, 
    "kuba@kernel.org" <kuba@kernel.org>, 
    "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, 
    "horms@kernel.org" <horms@kernel.org>, 
    "pablo@netfilter.org" <pablo@netfilter.org>, 
    "kadlec@netfilter.org" <kadlec@netfilter.org>, 
    "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, 
    "coreteam@netfilter.org" <coreteam@netfilter.org>, 
    "ncardwell@google.com" <ncardwell@google.com>, 
    "Koen De Schepper (Nokia)" <koen.de_schepper@nokia-bell-labs.com>, 
    "g.white@cablelabs.com" <g.white@cablelabs.com>, 
    "ingemar.s.johansson@ericsson.com" <ingemar.s.johansson@ericsson.com>, 
    "mirja.kuehlewind@ericsson.com" <mirja.kuehlewind@ericsson.com>, 
    "cheshire@apple.com" <cheshire@apple.com>, 
    "rs.ietf@gmx.at" <rs.ietf@gmx.at>, 
    "Jason_Livingood@comcast.com" <Jason_Livingood@comcast.com>, 
    "vidhi_goel@apple.com" <vidhi_goel@apple.com>
Subject: RE: [PATCH v5 net-next 09/13] gro: prevent ACE field corruption &
 better AccECN handling
In-Reply-To:  <PAXPR07MB7984717B290B1BC250429D2BA3592@PAXPR07MB7984.eurprd07.prod.outlook.com>
Message-ID: <6c6aced9-7543-b195-93e9-17e824538c55@kernel.org>
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-10-chia-yu.chang@nokia-bell-labs.com> <CANn89i+9USaOthY3yaJPT-cbfAcP0re2bbGbWU7SqOSYEW2CMw@mail.gmail.com> <37429ace-59c0-21d2-bcc8-54033794e789@kernel.org> 
 <PAXPR07MB7984717B290B1BC250429D2BA3592@PAXPR07MB7984.eurprd07.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-2005147231-1731446349=:1016"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2005147231-1731446349=:1016
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Adding a few virtio people. Please see the virtio spec/flag question=20
below.

On Tue, 12 Nov 2024, Chia-Yu Chang (Nokia) wrote:

> >From: Ilpo J=C3=A4rvinen <ij@kernel.org>=20
> >Sent: Thursday, November 7, 2024 8:28 PM
> >To: Eric Dumazet <edumazet@google.com>
> >Cc: Chia-Yu Chang (Nokia) <chia-yu.chang@nokia-bell-labs.com>; netdev@vg=
er.kernel.org; dsahern@gmail.com; davem@davemloft.net; dsahern@kernel.org; =
pabeni@redhat.com; joel.granados@kernel.org; kuba@kernel.org; andrew+netdev=
@lunn.ch; horms@kernel.org; pablo@netfilter.org; kadlec@netfilter.org; netf=
ilter-devel@vger.kernel.org; coreteam@netfilter.org; ncardwell@google.com; =
Koen De Schepper (Nokia) <koen.de_schepper@nokia-bell-labs.com>; g.white@ca=
blelabs.com; ingemar.s.johansson@ericsson.com; mirja.kuehlewind@ericsson.co=
m; cheshire@apple.com; rs.ietf@gmx.at; Jason_Livingood@comcast.com; vidhi_g=
oel@apple.com
> >Subject: Re: [PATCH v5 net-next 09/13] gro: prevent ACE field corruption=
 & better AccECN handling
> >
> >
> >CAUTION: This is an external email. Please be very careful when clicking=
 links or opening attachments. See the URL nok.it/ext for additional inform=
ation.
> >
> >
> >
> >On Thu, 7 Nov 2024, Eric Dumazet wrote:
> >
> >>On Tue, Nov 5, 2024 at 11:07=E2=80=AFAM <chia-yu.chang@nokia-bell-labs.=
com> wrote:
> >>>
> >>> From: Ilpo J=C3=A4rvinen <ij@kernel.org>
> >>>
> >>> There are important differences in how the CWR field behaves in=20
> >>> RFC3168 and AccECN. With AccECN, CWR flag is part of the ACE counter=
=20
> >>> and its changes are important so adjust the flags changed mask=20
> >>> accordingly.
> >>>
> >>> Also, if CWR is there, set the Accurate ECN GSO flag to avoid=20
> >>> corrupting CWR flag somewhere.
> >>>
> >>> Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> >>> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> >>> ---
> >>>  net/ipv4/tcp_offload.c | 4 ++--
> >>>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c index=20
> >>> 0b05f30e9e5f..f59762d88c38 100644
> >>> --- a/net/ipv4/tcp_offload.c
> >>> +++ b/net/ipv4/tcp_offload.c
> >>> @@ -329,7 +329,7 @@ struct sk_buff *tcp_gro_receive(struct list_head =
*head, struct sk_buff *skb,
> >>>         th2 =3D tcp_hdr(p);
> >>>         flush =3D (__force int)(flags & TCP_FLAG_CWR);
> >>>         flush |=3D (__force int)((flags ^ tcp_flag_word(th2)) &
> >>> -                 ~(TCP_FLAG_CWR | TCP_FLAG_FIN | TCP_FLAG_PSH));
> >>> +                 ~(TCP_FLAG_FIN | TCP_FLAG_PSH));
> >>>         flush |=3D (__force int)(th->ack_seq ^ th2->ack_seq);
> >>>         for (i =3D sizeof(*th); i < thlen; i +=3D 4)
> >>>                 flush |=3D *(u32 *)((u8 *)th + i) ^ @@ -405,7 +405,7=
=20
> >>> @@ void tcp_gro_complete(struct sk_buff *skb)
> >>>         shinfo->gso_segs =3D NAPI_GRO_CB(skb)->count;
> >>>
> >>>         if (th->cwr)
> >>> -               shinfo->gso_type |=3D SKB_GSO_TCP_ECN;
> >>> +               shinfo->gso_type |=3D SKB_GSO_TCP_ACCECN;
> >>>  }
> >>>  EXPORT_SYMBOL(tcp_gro_complete);
> >>>
> >>
> >> I do not really understand this patch. How a GRO engine can know which=
=20
> >> ECN variant the peers are using ?
> >
> >Hi Eric,
> >
> >Thanks for taking a look.
> >
> >GRO doesn't know. Setting SKB_GSO_TCP_ECN in case of not knowing can res=
ult in header change that corrupts ACE field. Thus, GRO has to assume the R=
FC3168 CWR offloading trick cannot be used anymore (unless it tracks the co=
nnection and knows the bits are used for RFC3168 which is something nobody =
is going to do).
> >
> >The main point of SKB_GSO_TCP_ACCECN is to prevent SKB_GSO_TCP_ECN or NE=
TIF_F_TSO_ECN offloading to be used for the skb as it would corrupt ACE fie=
ld value.
>=20
> Hi Eric and Ilpo,
>=20
> From my understanding of another email thread (patch 08/13), it seems the=
 conclusions that SKB_GSO_TCP_ACCECN will still be needed.
>=20
> >
> >SKB_GSO_TCP_ACCECN doesn't allow CWR bits change within a super-skb but =
the same CWR flag should be repeated for all segments. In a sense, it's sim=
pler than RFC3168 offloading.
> >
> >> SKB_GSO_TCP_ECN is also used from other points, what is your plan ?
> >>
> >> git grep -n SKB_GSO_TCP_ECN
> >> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:3888:
> >> skb_shinfo(skb)->gso_type |=3D SKB_GSO_TCP_ECN;
> >> drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:1291:
> >> skb_shinfo(skb)->gso_type |=3D SKB_GSO_TCP_ECN;
> >> drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:1312:
> >> skb_shinfo(skb)->gso_type |=3D SKB_GSO_TCP_ECN;
> >
> >These looked like they should be just changed to set SKB_GSO_TCP_ACCECN =
instead.
>=20
> I agree with these changes and will apply them in the next version.
>=20
> >
> >I don't anymore recall why I didn't change those when I made this patch =
long time ago, perhaps it was just an oversight or things have changed some=
how since then.
> >
> >> include/linux/netdevice.h:5061: BUILD_BUG_ON(SKB_GSO_TCP_ECN !=3D=20
> >> (NETIF_F_TSO_ECN >> NETIF_F_GSO_SHIFT));
> >> include/linux/skbuff.h:664:     SKB_GSO_TCP_ECN =3D 1 << 2,
> >
> >Not relevant.
> >
> >> include/linux/virtio_net.h:88:                  gso_type |=3D SKB_GSO_=
TCP_ECN;
> >> include/linux/virtio_net.h:161:         switch (gso_type & ~SKB_GSO_TC=
P_ECN) {
> >> include/linux/virtio_net.h:226:         if (sinfo->gso_type & SKB_GSO_=
TCP_ECN)
> >
> >These need to be looked further what's going on as UAPI is also=20
> > involved here.=20
>=20
> I had a look at these parts, and only the 1st and 3rd ones are relevant.
> Related to the 1st one, I propose to change
> from
>=20
>                 if (hdr->gso_type & VIRTIO_NET_HDR_GSO_ECN)
>                         gso_type |=3D SKB_GSO_TCP_ECN;
>=20
> to
>=20
>                 if (hdr->gso_type & VIRTIO_NET_HDR_GSO_ECN)
>                         gso_type |=3D SKB_GSO_TCP_ACCECN;
>=20
> The reason behind this proposed change is similar as the above changes=20
> in en_rx.c.

But en_rx.c is based one CWR flag, there's no similar check here.

> For the 3rd one, I suggest to change from
>=20
>                 if (sinfo->gso_type & SKB_GSO_TCP_ECN)
>                         hdr->gso_type |=3D VIRTIO_NET_HDR_GSO_ECN;
>
> to
>=20
>                 if (sinfo->gso_type & (SKB_GSO_TCP_ECN | SKB_GSO_TCP_ACCE=
CN))
>                         hdr->gso_type |=3D VIRTIO_NET_HDR_GSO_ECN;
>=20
> This proposed change is because VIRTIO_NET_HDR_GSO_ECN must be set to=20
> allow TCP packets requiring segmentation offload which have ECN bit set.
> So, no matter whether skb gso_type have GSO_TCP_ECN flag or=20
> GSO_TCP_ACCECN flag, the corresponding hdr gso_type shall be set.
>=20
> But, I wonder what would the driver do when with VIRTIO_NET_HDR_GSO_ECN=
=20
> flag. Will it corrupts CWR or not?

I'm starting to heavily question what is the meaning of that=20
VIRTIO_NET_HDR_GSO_ECN flag and if it's even consistent...

https://github.com/qemu/qemu/blob/master/net/eth.c

That sets VIRTIO_NET_HDR_GSO_ECN based on CE?? (Whereas kernel associates=
=20
the related SKB_GSO_TCP_ECN to CWR offloading.)

The virtio spec is way too vague to be useful so it would not be=20
surprising if there are diverging interpretations from implementers:

"If the driver negotiated the VIRTIO_NET_F_HOST_ECN feature, the=20
VIRTIO_NET_HDR_GSO_ECN bit in gso_type indicates that the TCP packet has=20
the ECN bit set."

What is "the ECN bit" in terms used by TCP (or IP)? Could some virtio=20
folks please explain?


--=20
 i.

--8323328-2005147231-1731446349=:1016--
