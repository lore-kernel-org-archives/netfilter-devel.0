Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058BA2EBBA1
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 00:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790038528; cv=pass; b=MG1A96BFlSwcdFE0eYK/IE2dFdbbDhPUaNbCGKa1WR+QGM95u7BUje1XEgYyq6n+X1GrxJhqeAfKTryeIHLrRRfyu0KSxzJhZBSo8U5U0ONCuw/sCqjelnLAUZc/PGqOHhaFse4AtBatRGzRNlbOrOiW9VH4mBqCeRsSUF19GtE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790038528; c=relaxed/simple;
	bh=idYsLcFUthlYqGNApYRqdnViCeD+pYTZwRoDQxgF5EY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GFWffEyVapAKQEekE//2Ch21rsp4gVkeD8OUDRAT9kOB93Pq4Zrjd1HnbFXxaFr6ho3X9ln2p6WOgDPXRZ773AsRBESNTssxc96qYlyeQ91NHbTUj/JYx8Mv4xjZqciZeuu8+0vMDzdMWl3TlXN1nmyektIfU27+9bvRZC5BG9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pcImiiDb; arc=pass smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pcImiiDb"
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530c602630bso43826881cf.3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 17:55:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790038524; cv=none;
        d=google.com; s=arc-20260327;
        b=WJ1y0fRlgnveOZgVBOAt6IX8a50kDUK3qRxuPWMKcJaRsmBkWt0Zjbv1xwtGa3vDfT
         +XpcoxxbvPtT6KtSteqjpWDddHNxzOwk1/fH022KmbbtTQDF+c95htShni7snxeJywQB
         O9H/pd6vODhVRC/wHKpQVA8ze8jhOMtAqQ6DgTSj+lGca7CDGjgFgpSHks/soZ/ywPP0
         FjUO1vzzHsjJr/IMGaoY3S9DAOC6zv7mSegRpjSX819WGPsCZJ5vOLxPaja8zZ1LQd0q
         JNUGiPJOoeNHiU10QY+Jxz1ZBCyluVGvOj+Fb4qPF0EgJ72ag8n9xntQvNN7/yQk7xLh
         VHkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=AkJvxqQXbf8veFQEUs+ra5hnxJVATLnhpM7WMMPxNyE=;
        fh=kxNZQt4Ar6ngYIWRmk1QJVfLiALjlPIkzlV/TJEbqIg=;
        b=mpmrk5B4Fl6wSiT6HqFLYRR3lFAY7RFNKkd5H+9WIunB5nqZ+DSGRRZwfYSocPziWE
         /81M6ltIJQNUG/ooTNlfJPHot54x0CC0doU4NOvHpBKvMAmY99wM6NDABKT+/+wiJ46I
         OwMWlEZRuOpu+7+w7r3wP7krJySmfEu+NRPr/+bEmur+pmQA92KIW2K5ciPC423fz/7g
         G14GVnf9QL8tIs3FpXNPeVUjvWMJ/UuvtsdnFW59QMqrBwBO73i0vuiQxqr1JehjszWG
         kWnVG/zQ+eG8Yo7gvShyZcIeevymimKkL5Q5Q6qoOkBQt7alSMHb4Fc9WojQ4SfLeegB
         JbBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790038524; x=1790643324; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AkJvxqQXbf8veFQEUs+ra5hnxJVATLnhpM7WMMPxNyE=;
        b=pcImiiDbToDF8JbqqtHePuOP1sKhu2NkPGztfIs0bGdOsQSQK8qI/xqMyk+JgmWRvq
         0jFDhjMuRL4JsTurDVo44xAfnoebNTOAav50bea/5YWuQcZqGV21s0qNyVHOAO0jxd0Q
         nRmg0FHETY+cNkAYzhinvOAN+9/Fk2tO9Dir3akQNeZWqz7IWXXpxX1Gf4E17w5aMTUu
         7phGj9j0D4hwnj6cjI7FKQDPuyspHWG1FhJAAMStpm4NclhgUu+uIISHhQJbmaHz47N7
         uK/y4eo72lQfpKyihWAtjF5QaYnrzmNdGwAssOo6MhButuXydydNbUCBqGt8rY+0jE0D
         TdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790038524; x=1790643324;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=AkJvxqQXbf8veFQEUs+ra5hnxJVATLnhpM7WMMPxNyE=;
        b=VqeN4Y+QqmC9mlYHh2OCByzTXi8sLztR3wOiQ8ABUiTtSVtwgDK+OPDdv2vhNsXqIK
         m1PF1RNfmXMwr505ZpDBmZBNebLwzf3N9zjqI7gQDNqoFS13MGVSpleCTFOHUQQzcPPf
         C+v6OeUZC5JWfSyH5qy+KUz7XevBJlaq8LqUn51ES0rJ2heb2FAv4pV2Qw1IpKs0it9B
         qHAVar+Adtq+zUCSe/WbLVqfR/LaxQdDnEZUvdGZNS83PDY2WY4HwKJpd7Dv+dE1hDyU
         K0iDpoZy8ckLcmpoH+eoC9EOoag4masRMKbeyCPYmbnrahbJc/I+aZJDDj98ckf4BqYH
         NBfg==
X-Forwarded-Encrypted: i=1; AKwUvBxw3zSHBLQUcx0YWLoDWgNlahz1R3QF1Ig8xXTwaiIQfrA9KTykU7UuhcxKAsmrex0BmMObjW820joEa+XqFRs=@vger.kernel.org
X-Gm-Message-State: AFuF++lx++MX9EGYTt2oo7lr0ciayy7Xx38f3G+bz1WLu9PtzfZK4c+5
	DV0R0JEACxDkgmT4cfZ6qiSpK/9CZco5qHccMQFxdzbywQf6SBDd019yHIHl7TVnmG8wET9B882
	pylvVIllqWRpbyIqEOV0qAeolFccmS7M=
X-Gm-Gg: AYBFou3FsxnPcPEJ0uOkWJrmjHvfTaMQKZlByqp1Q0+voozWNzhdYbC9/Pd+O/V+cop
	mgh3N3flMFD4S9/cUF+Kpp3hIGLjuzAQivFgLX5k6LxcVMpfWuzu4Jr75VI/W0w/Va/kw8nyNKO
	J1QdH7k/orbD5RNaBxPnxh8txBHI6Ho5d22NRIqPrR+evwTsjBMH6tQ0h9t0MVYD4yN9EiM1ESB
	FDCBm/p26CwST7iaFHqAZTM1Sji1jdtfmnFZWwm3nSupWEoWhoNfOMTF45zhLAWscTvBhsYQFi3
	KKHG9hKolLvotTr0tFlvKTboJVg9Omb4cjgraioLzKVE74lKc5uRMMYq5uhve5iXYXeXOmTghQU
	6PpbeNuqWuqrFXVeJaXDF/uc5R9JKN+SfPTIfWyhXYf93
X-Received: by 2002:a05:6214:448d:b0:910:3c08:fc6c with SMTP id
 6a1803df08f44-914007ed79bmr13885126d6.22.1790038523748; Mon, 21 Sep 2026
 17:55:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920004733.6473-1-habte.yibelo@gmail.com> <20260921025341.44846-1-habte.yibelo@gmail.com>
 <20260921025341.44846-2-habte.yibelo@gmail.com> <20260921183657-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260921183657-mutt-send-email-mst@kernel.org>
From: Paulos Yibelo <habte.yibelo@gmail.com>
Date: Mon, 21 Sep 2026 20:55:11 -0400
X-Gm-Features: AcwNN1XiOdcYdPu19EuZH091jiYqdUJt6Tocs_EhNUqFf161YUkgPgSRuQyMJS8
Message-ID: <CAHv8Y_5ZHuSpEKo6bFhwyEA0e+ZVADe=Pzju4Vfzrrwy8nsUuw@mail.gmail.com>
Subject: Re: [PATCH net v5 1/2] net: validate virtio checksum start after
 network header
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, richard@nod.at, anton.ivanov@cambridgegreys.com, 
	johannes@sipsolutions.net, willemdebruijn.kernel@gmail.com, 
	jasowangio@gmail.com, eperezma@redhat.com, xuanzhuo@linux.alibaba.com, 
	andrew+netdev@lunn.ch, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, 
	razor@blackwall.org, idosch@nvidia.com, dsahern@kernel.org, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	horms@kernel.org, linux-um@lists.infradead.org, 
	virtualization@lists.linux.dev, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, bridge@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000005824ff065c07d212"

--0000000000005824ff065c07d212
Content-Type: multipart/alternative; boundary="0000000000005824fc065c07d210"

--0000000000005824fc065c07d210
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, I=E2=80=99ve addressed these points in v6 and will post the full re=
vised
series shortly when the timing gate opens.

On Mon, Sep 21, 2026 at 6:44=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:

> On Sun, Sep 20, 2026 at 10:53:40PM -0400, Paulos Yibelo wrote:
> > __virtio_net_hdr_to_skb() rejects a CHECKSUM_PARTIAL start smaller than
> > an estimated minimum network-header length. Its input offsets are
> relative
> > to skb->data.
> >
> > Using skb_network_offset() here is unsafe. TUN/TAP, virtio-net, and UML
> > parse a received virtio header before skb->network_header is establishe=
d.
> > On an skb with headroom, the resulting negative offset enlarges the
> > apparent distance to the transport header and can admit a checksum star=
t
> > inside the network header.
> >
> > Pass the data-relative L3 offset to the converter explicitly. IFF_TUN
> uses
> > zero, AF_PACKET supplies its established network offset, and Ethernet
> > receive paths parse Ethernet and nested VLAN headers with
> > skb_header_pointer(), without changing skb state. Use the same origin f=
or
> > tunnel-offset validation, and make UML propagate conversion failures.
> >
> > This does not require a virtual-machine guest. A TUN or TAP device with
> > virtio-net header support is sufficient to reach these paths.
> >
> > Fixes: 49d14b54a527 ("net: test for not too small csum_start in
> virtio_net_hdr_to_skb()")
> > Fixes: a2fb4bc4e2a6 ("net: implement virtio helpers to handle UDP GSO
> tunneling.")
> > Reported-by: Paulos Yibelo <habte.yibelo@gmail.com>
> > Link:
> https://lore.kernel.org/netdev/20260920004733.6473-2-habte.yibelo@gmail.c=
om/
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Paulos Yibelo <habte.yibelo@gmail.com>
> > ---
> > Changes in v5:
> > - Replace the not-yet-established skb network-header offset with an
> >   explicit data-relative L3 origin.
> > - Cover all in-tree callers, including Ethernet/VLAN receive paths,
> >   tunnel metadata, and UML error propagation.
> > - Drop the prior Acked-by and Reviewed-by tags because the code changed=
.
> >
> > Changes in v4:
> > - State that a TUN device is sufficient and no guest is required, as
> >   noted by Michael S. Tsirkin.
> >
> > Changes in v3:
> > - Keep the network-relative comparison on one line for readability, as
> >   requested by David Ahern.
> >
> > Changes in v2:
> > - Make nh_min_len an int and remove the casts, as suggested by Michael =
S.
> >   Tsirkin.
> >
> >  arch/um/drivers/vector_transports.c | 10 +++-
> >  drivers/net/tun_vnet.h              | 28 ++++++++++-
> >  drivers/net/virtio_net.c            |  8 ++-
> >  include/linux/virtio_net.h          | 76 +++++++++++++++++++++++------
> >  net/packet/af_packet.c              |  6 ++-
> >  5 files changed, 106 insertions(+), 22 deletions(-)
> >
> > diff --git a/arch/um/drivers/vector_transports.c
> b/arch/um/drivers/vector_transports.c
> > index ddd127ee9..79bc05fc6 100644
> > --- a/arch/um/drivers/vector_transports.c
> > +++ b/arch/um/drivers/vector_transports.c
> > @@ -197,6 +197,7 @@ static int raw_verify_header(
> >       uint8_t *header, struct sk_buff *skb, struct vector_private *vp)
> >  {
> >       struct virtio_net_hdr *vheader =3D (struct virtio_net_hdr *) head=
er;
> > +     int network_offset;
> >
> >       if ((vheader->gso_type !=3D VIRTIO_NET_HDR_GSO_NONE) &&
> >               (vp->req_size !=3D 65536)) {
> > @@ -209,8 +210,13 @@ static int raw_verify_header(
> >       if ((vheader->flags & VIRTIO_NET_HDR_F_DATA_VALID) > 0)
> >               return 1;
> >
> > -     virtio_net_hdr_to_skb(skb, vheader,
> virtio_legacy_is_little_endian());
> > -     return 0;
> > +     network_offset =3D virtio_net_hdr_get_l3_offset(skb, vheader);
> > +     if (network_offset < 0)
> > +             return network_offset;
> > +
> > +     return virtio_net_hdr_to_skb(skb, vheader,
> > +                                  virtio_legacy_is_little_endian(),
> > +                                  network_offset);
> >  }
> >
> >  static bool get_uint_param(
> > diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
> > index f4c652b1f..1c83c359d 100644
> > --- a/drivers/net/tun_vnet.h
> > +++ b/drivers/net/tun_vnet.h
> > @@ -177,10 +177,27 @@ static inline int tun_vnet_hdr_put(int sz, struct
> iov_iter *iter,
> >       return __tun_vnet_hdr_put(sz, 0, iter, hdr);
> >  }
> >
> > +static inline int
> > +tun_vnet_hdr_get_l3_offset(unsigned int flags, const struct sk_buff
> *skb,
> > +                        const struct virtio_net_hdr *hdr)
> > +{
> > +     if ((flags & TUN_TYPE_MASK) !=3D IFF_TAP)
> > +             return 0;
> > +
> > +     return virtio_net_hdr_get_l3_offset(skb, hdr);
> > +}
> > +
> >  static inline int tun_vnet_hdr_to_skb(unsigned int flags, struct
> sk_buff *skb,
> >                                     const struct virtio_net_hdr *hdr)
> >  {
> > -     return virtio_net_hdr_to_skb(skb, hdr,
> tun_vnet_is_little_endian(flags));
> > +     int network_offset =3D tun_vnet_hdr_get_l3_offset(flags, skb, hdr=
);
> > +
> > +     if (network_offset < 0)
> > +             return network_offset;
> > +
> > +     return virtio_net_hdr_to_skb(skb, hdr,
> > +                                  tun_vnet_is_little_endian(flags),
> > +                                  network_offset);
> >  }
> >
> >  /*
> > @@ -199,10 +216,17 @@ tun_vnet_hdr_tnl_to_skb(unsigned int flags,
> netdev_features_t features,
> >                       struct sk_buff *skb,
> >                       const struct virtio_net_hdr_v1_hash_tunnel *hdr)
> >  {
> > +     const struct virtio_net_hdr *vnet_hdr =3D (const struct
> virtio_net_hdr *)hdr;
> > +     int network_offset =3D tun_vnet_hdr_get_l3_offset(flags, skb,
> vnet_hdr);
> > +
> > +     if (network_offset < 0)
> > +             return network_offset;
> > +
> >       return virtio_net_hdr_tnl_to_skb(skb, hdr,
> >                               features & NETIF_F_GSO_UDP_TUNNEL,
> >                               features & NETIF_F_GSO_UDP_TUNNEL_CSUM,
> > -                             tun_vnet_is_little_endian(flags));
> > +                             tun_vnet_is_little_endian(flags),
> > +                             network_offset);
> >  }
> >
> >  static inline int tun_vnet_hdr_from_skb(unsigned int flags,
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index e34c52d05..059eeb18e 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -2502,6 +2502,7 @@ static void virtnet_receive_done(struct
> virtnet_info *vi, struct receive_queue *
> >  {
> >       struct virtio_net_common_hdr *hdr;
> >       struct net_device *dev =3D vi->dev;
> > +     int network_offset;
> >
> >       hdr =3D skb_vnet_common_hdr(skb);
> >       if (dev->features & NETIF_F_RXHASH && vi->has_rss_hash_report)
> > @@ -2515,9 +2516,12 @@ static void virtnet_receive_done(struct
> virtnet_info *vi, struct receive_queue *
> >               goto frame_err;
> >       }
> >
> > -     if (virtio_net_hdr_tnl_to_skb(skb, &hdr->tnl_hdr, vi->rx_tnl,
> > +     network_offset =3D virtio_net_hdr_get_l3_offset(skb, &hdr->hdr);
> > +     if (network_offset < 0 ||
> > +         virtio_net_hdr_tnl_to_skb(skb, &hdr->tnl_hdr, vi->rx_tnl,
> >                                     vi->rx_tnl_csum,
> > -                                   virtio_is_little_endian(vi->vdev)))=
 {
> > +                                   virtio_is_little_endian(vi->vdev),
> > +                                   network_offset)) {
> >               net_warn_ratelimited("%s: bad gso: type: %x, size: %u,
> flags %x tunnel %d tnl csum %d\n",
> >                                    dev->name, hdr->hdr.gso_type,
> >                                    hdr->hdr.gso_size, hdr->hdr.flags,
> > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > index c381b916c..a4c005796 100644
> > --- a/include/linux/virtio_net.h
> > +++ b/include/linux/virtio_net.h
> > @@ -48,11 +48,49 @@ static inline int virtio_net_hdr_set_proto(struct
> sk_buff *skb,
> >       return 0;
> >  }
> >
> > +/*
> > + * Return the L3 offset of an Ethernet frame starting at skb->data.
> > + * The offset is unused without NEEDS_CSUM, so avoid parsing and retur=
n
> zero.
> > + */
> > +static inline int
> > +virtio_net_hdr_get_l3_offset(const struct sk_buff *skb,
> > +                          const struct virtio_net_hdr *hdr)
> > +{
> > +     unsigned int parse_depth =3D VLAN_MAX_DEPTH;
> > +     const struct ethhdr *eth;
> > +     struct ethhdr ethbuf;
> > +     __be16 protocol;
> > +     int depth =3D ETH_HLEN;
> > +
> > +     if (!(hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM))
> > +             return 0;
> > +
> > +     eth =3D skb_header_pointer(skb, 0, sizeof(ethbuf), &ethbuf);
> > +     if (!eth)
> > +             return -EINVAL;
> > +
> > +     protocol =3D eth->h_proto;
> > +     while (eth_type_vlan(protocol)) {
> > +             const struct vlan_hdr *vh;
> > +             struct vlan_hdr vhdr;
> > +
> > +             vh =3D skb_header_pointer(skb, depth, sizeof(vhdr), &vhdr=
);
> > +             if (!vh || !--parse_depth)
> > +                     return -EINVAL;
> > +
> > +             protocol =3D vh->h_vlan_encapsulated_proto;
> > +             depth +=3D VLAN_HLEN;
> > +     }
> > +
> > +     return depth;
> > +}
> > +
> >  static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
> >                                         const struct virtio_net_hdr *hd=
r,
> > -                                       bool little_endian, u8
> hdr_gso_type)
> > +                                       bool little_endian, u8
> hdr_gso_type,
> > +                                       int network_offset)
> >  {
> > -     unsigned int nh_min_len =3D sizeof(struct iphdr);
> > +     int nh_min_len =3D sizeof(struct iphdr);
>
>
> So why is this IPv4 specific assumption still here? Confused.
>
>
> >       unsigned int gso_type =3D 0;
> >       unsigned int thlen =3D 0;
> >       unsigned int p_off =3D 0;
> > @@ -98,16 +136,20 @@ static inline int __virtio_net_hdr_to_skb(struct
> sk_buff *skb,
> >               u32 start =3D __virtio16_to_cpu(little_endian,
> hdr->csum_start);
> >               u32 off =3D __virtio16_to_cpu(little_endian,
> hdr->csum_offset);
> >               u32 needed =3D start + max_t(u32, thlen, off +
> sizeof(__sum16));
> > +             int transport_offset;
> >
> >               if (!pskb_may_pull(skb, needed))
> >                       return -EINVAL;
> >
> >               if (!skb_partial_csum_set(skb, start, off))
> >                       return -EINVAL;
> > -             if (skb_transport_offset(skb) < nh_min_len)
> > +
> > +             transport_offset =3D skb_transport_offset(skb);
> > +             if (transport_offset < nh_min_len || network_offset < 0 |=
|
> > +                 network_offset > transport_offset - nh_min_len)
> >                       return -EINVAL;
> >
> > -             nh_min_len =3D skb_transport_offset(skb);
> > +             nh_min_len =3D transport_offset;
> >               p_off =3D nh_min_len + thlen;
> >               if (!pskb_may_pull(skb, p_off))
> >                       return -EINVAL;
> > @@ -206,9 +248,11 @@ static inline int __virtio_net_hdr_to_skb(struct
> sk_buff *skb,
> >
> >  static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
> >                                       const struct virtio_net_hdr *hdr,
> > -                                     bool little_endian)
> > +                                     bool little_endian,
> > +                                     int network_offset)
> >  {
> > -     return __virtio_net_hdr_to_skb(skb, hdr, little_endian,
> hdr->gso_type);
> > +     return __virtio_net_hdr_to_skb(skb, hdr, little_endian,
> hdr->gso_type,
> > +                                    network_offset);
> >  }
> >
> >  /* This function must be called after virtio_net_hdr_from_skb(). */
> > @@ -287,7 +331,7 @@ static inline int virtio_net_hdr_from_skb(const
> struct sk_buff *skb,
> >       return 0;
> >  }
> >
> > -static inline unsigned int virtio_l3min(bool is_ipv6)
> > +static inline int virtio_l3min(bool is_ipv6)
> >  {
> >       return is_ipv6 ? sizeof(struct ipv6hdr) : sizeof(struct iphdr);
> >  }
> > @@ -297,18 +341,19 @@ virtio_net_hdr_tnl_to_skb(struct sk_buff *skb,
> >                         const struct virtio_net_hdr_v1_hash_tunnel *vhd=
r,
> >                         bool tnl_hdr_negotiated,
> >                         bool tnl_csum_negotiated,
> > -                       bool little_endian)
> > +                       bool little_endian, int network_offset)
> >  {
> >       const struct virtio_net_hdr *hdr =3D (const struct virtio_net_hdr
> *)vhdr;
> > -     unsigned int inner_nh, outer_th, inner_th;
> > -     unsigned int inner_l3min, outer_l3min;
> >       u8 gso_inner_type, gso_tunnel_type;
> >       bool outer_isv6, inner_isv6;
> > +     int inner_nh, outer_th, inner_th;
> > +     int inner_l3min, outer_l3min;
> >       int ret;
> >
> >       gso_tunnel_type =3D hdr->gso_type & VIRTIO_NET_HDR_GSO_UDP_TUNNEL=
;
> >       if (!gso_tunnel_type)
> > -             return virtio_net_hdr_to_skb(skb, hdr, little_endian);
> > +             return virtio_net_hdr_to_skb(skb, hdr, little_endian,
> > +                                          network_offset);
> >
> >       /* Tunnel not supported/negotiated, but the hdr asks for it. */
> >       if (!tnl_hdr_negotiated)
> > @@ -332,19 +377,22 @@ virtio_net_hdr_tnl_to_skb(struct sk_buff *skb,
> >       outer_isv6 =3D gso_tunnel_type & VIRTIO_NET_HDR_GSO_UDP_TUNNEL_IP=
V6;
> >       inner_isv6 =3D gso_inner_type =3D=3D VIRTIO_NET_HDR_GSO_TCPV6;
> >       inner_l3min =3D virtio_l3min(inner_isv6);
> > -     outer_l3min =3D ETH_HLEN + virtio_l3min(outer_isv6);
> > +     outer_l3min =3D virtio_l3min(outer_isv6);
> >
> >       inner_th =3D __virtio16_to_cpu(little_endian, hdr->csum_start);
> >       inner_nh =3D le16_to_cpu(vhdr->inner_nh_offset);
> >       outer_th =3D le16_to_cpu(vhdr->outer_th_offset);
> > -     if (outer_th < outer_l3min ||
> > +     if (network_offset < 0 ||
> > +         outer_th < outer_l3min ||
> > +         network_offset > outer_th - outer_l3min ||
> >           inner_nh < outer_th + sizeof(struct udphdr) ||
> >           inner_th < inner_nh + inner_l3min)
> >               return -EINVAL;
> >
> >       /* Let the basic parsing deal with plain GSO features. */
> >       ret =3D __virtio_net_hdr_to_skb(skb, hdr, true,
> > -                                   hdr->gso_type & ~gso_tunnel_type);
> > +                                   hdr->gso_type & ~gso_tunnel_type,
> > +                                   network_offset);
> >       if (ret)
> >               return ret;
> >
> > diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> > index 50cae32ae..04c80e23d 100644
> > --- a/net/packet/af_packet.c
> > +++ b/net/packet/af_packet.c
> > @@ -2901,7 +2901,8 @@ static int tpacket_snd(struct packet_sock *po,
> struct msghdr *msg)
> >               }
> >
> >               if (has_vnet_hdr) {
> > -                     if (virtio_net_hdr_to_skb(skb, &vnet_hdr,
> vio_le())) {
> > +                     if (virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le(=
),
> > +
>  skb_network_offset(skb))) {
> >                               tp_len =3D -EINVAL;
> >                               goto tpacket_error;
> >                       }
>
> Will this do the right thing for ETH_P_IP sockets? even with vlan tags
> in the frame?
>
>
> > @@ -3103,7 +3104,8 @@ static int packet_snd(struct socket *sock, struct
> msghdr *msg, size_t len)
> >       packet_parse_headers(skb, sock);
> >
> >       if (vnet_hdr_sz) {
> > -             err =3D virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
> > +             err =3D virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le(),
> > +                                         skb_network_offset(skb));
> >               if (err)
> >                       goto out_free;
> >               len +=3D vnet_hdr_sz;
> > --
> > 2.46.0
>
>

--=20
PGP Key ID: 53911E7F16446D4C :)

--0000000000005824fc065c07d210
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks, I=E2=80=99ve addressed these points in v6 and will=
 post the full revised series shortly when the timing gate opens.=C2=A0</di=
v><br><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" cla=
ss=3D"gmail_attr">On Mon, Sep 21, 2026 at 6:44=E2=80=AFPM Michael S. Tsirki=
n &lt;<a href=3D"mailto:mst@redhat.com">mst@redhat.com</a>&gt; wrote:<br></=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left:1px solid rgb(204,204,204);padding-left:1ex">On Sun, Sep 20, 2026 =
at 10:53:40PM -0400, Paulos Yibelo wrote:<br>
&gt; __virtio_net_hdr_to_skb() rejects a CHECKSUM_PARTIAL start smaller tha=
n<br>
&gt; an estimated minimum network-header length. Its input offsets are rela=
tive<br>
&gt; to skb-&gt;data.<br>
&gt; <br>
&gt; Using skb_network_offset() here is unsafe. TUN/TAP, virtio-net, and UM=
L<br>
&gt; parse a received virtio header before skb-&gt;network_header is establ=
ished.<br>
&gt; On an skb with headroom, the resulting negative offset enlarges the<br=
>
&gt; apparent distance to the transport header and can admit a checksum sta=
rt<br>
&gt; inside the network header.<br>
&gt; <br>
&gt; Pass the data-relative L3 offset to the converter explicitly. IFF_TUN =
uses<br>
&gt; zero, AF_PACKET supplies its established network offset, and Ethernet<=
br>
&gt; receive paths parse Ethernet and nested VLAN headers with<br>
&gt; skb_header_pointer(), without changing skb state. Use the same origin =
for<br>
&gt; tunnel-offset validation, and make UML propagate conversion failures.<=
br>
&gt; <br>
&gt; This does not require a virtual-machine guest. A TUN or TAP device wit=
h<br>
&gt; virtio-net header support is sufficient to reach these paths.<br>
&gt; <br>
&gt; Fixes: 49d14b54a527 (&quot;net: test for not too small csum_start in v=
irtio_net_hdr_to_skb()&quot;)<br>
&gt; Fixes: a2fb4bc4e2a6 (&quot;net: implement virtio helpers to handle UDP=
 GSO tunneling.&quot;)<br>
&gt; Reported-by: Paulos Yibelo &lt;<a href=3D"mailto:habte.yibelo@gmail.co=
m" target=3D"_blank">habte.yibelo@gmail.com</a>&gt;<br>
&gt; Link: <a href=3D"https://lore.kernel.org/netdev/20260920004733.6473-2-=
habte.yibelo@gmail.com/" rel=3D"noreferrer" target=3D"_blank">https://lore.=
kernel.org/netdev/20260920004733.6473-2-habte.yibelo@gmail.com/</a><br>
&gt; Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable=
@vger.kernel.org</a><br>
&gt; Signed-off-by: Paulos Yibelo &lt;<a href=3D"mailto:habte.yibelo@gmail.=
com" target=3D"_blank">habte.yibelo@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt; Changes in v5:<br>
&gt; - Replace the not-yet-established skb network-header offset with an<br=
>
&gt;=C2=A0 =C2=A0explicit data-relative L3 origin.<br>
&gt; - Cover all in-tree callers, including Ethernet/VLAN receive paths,<br=
>
&gt;=C2=A0 =C2=A0tunnel metadata, and UML error propagation.<br>
&gt; - Drop the prior Acked-by and Reviewed-by tags because the code change=
d.<br>
&gt; <br>
&gt; Changes in v4:<br>
&gt; - State that a TUN device is sufficient and no guest is required, as<b=
r>
&gt;=C2=A0 =C2=A0noted by Michael S. Tsirkin.<br>
&gt; <br>
&gt; Changes in v3:<br>
&gt; - Keep the network-relative comparison on one line for readability, as=
<br>
&gt;=C2=A0 =C2=A0requested by David Ahern.<br>
&gt; <br>
&gt; Changes in v2:<br>
&gt; - Make nh_min_len an int and remove the casts, as suggested by Michael=
 S.<br>
&gt;=C2=A0 =C2=A0Tsirkin.<br>
&gt; <br>
&gt;=C2=A0 arch/um/drivers/vector_transports.c | 10 +++-<br>
&gt;=C2=A0 drivers/net/tun_vnet.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 | 28 ++++++++++-<br>
&gt;=C2=A0 drivers/net/virtio_net.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 8 ++-<br>
&gt;=C2=A0 include/linux/virtio_net.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 7=
6 +++++++++++++++++++++++------<br>
&gt;=C2=A0 net/packet/af_packet.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 |=C2=A0 6 ++-<br>
&gt;=C2=A0 5 files changed, 106 insertions(+), 22 deletions(-)<br>
&gt; <br>
&gt; diff --git a/arch/um/drivers/vector_transports.c b/arch/um/drivers/vec=
tor_transports.c<br>
&gt; index ddd127ee9..79bc05fc6 100644<br>
&gt; --- a/arch/um/drivers/vector_transports.c<br>
&gt; +++ b/arch/um/drivers/vector_transports.c<br>
&gt; @@ -197,6 +197,7 @@ static int raw_verify_header(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0uint8_t *header, struct sk_buff *skb, struct=
 vector_private *vp)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct virtio_net_hdr *vheader =3D (struct v=
irtio_net_hdr *) header;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int network_offset;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((vheader-&gt;gso_type !=3D VIRTIO_NET_HD=
R_GSO_NONE) &amp;&amp;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(vp-&gt;req_size=
 !=3D 65536)) {<br>
&gt; @@ -209,8 +210,13 @@ static int raw_verify_header(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((vheader-&gt;flags &amp; VIRTIO_NET_HDR_=
F_DATA_VALID) &gt; 0)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 =C2=A0virtio_net_hdr_to_skb(skb, vheader, virtio_legacy=
_is_little_endian());<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0network_offset =3D virtio_net_hdr_get_l3_offset(s=
kb, vheader);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (network_offset &lt; 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return network_offset=
;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return virtio_net_hdr_to_skb(skb, vheader,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 virtio_legacy_is_little_e=
ndian(),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 network_offset);<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 static bool get_uint_param(<br>
&gt; diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h<br>
&gt; index f4c652b1f..1c83c359d 100644<br>
&gt; --- a/drivers/net/tun_vnet.h<br>
&gt; +++ b/drivers/net/tun_vnet.h<br>
&gt; @@ -177,10 +177,27 @@ static inline int tun_vnet_hdr_put(int sz, struc=
t iov_iter *iter,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return __tun_vnet_hdr_put(sz, 0, iter, hdr);=
<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; +static inline int<br>
&gt; +tun_vnet_hdr_get_l3_offset(unsigned int flags, const struct sk_buff *=
skb,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 const struct virtio_net_hdr *hdr)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ((flags &amp; TUN_TYPE_MASK) !=3D IFF_TAP)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return virtio_net_hdr_get_l3_offset(skb, hdr);<br=
>
&gt; +}<br>
&gt; +<br>
&gt;=C2=A0 static inline int tun_vnet_hdr_to_skb(unsigned int flags, struct=
 sk_buff *skb,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct =
virtio_net_hdr *hdr)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return virtio_net_hdr_to_skb(skb, hdr, tun_vnet_i=
s_little_endian(flags));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int network_offset =3D tun_vnet_hdr_get_l3_offset=
(flags, skb, hdr);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (network_offset &lt; 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return network_offset=
;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return virtio_net_hdr_to_skb(skb, hdr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tun_vnet_is_little_endian=
(flags),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 network_offset);<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 /*<br>
&gt; @@ -199,10 +216,17 @@ tun_vnet_hdr_tnl_to_skb(unsigned int flags, netd=
ev_features_t features,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0struct sk_buff *skb,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0const struct virtio_net_hdr_v1_hash_tunnel *hdr)<br>
&gt;=C2=A0 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0const struct virtio_net_hdr *vnet_hdr =3D (const =
struct virtio_net_hdr *)hdr;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int network_offset =3D tun_vnet_hdr_get_l3_offset=
(flags, skb, vnet_hdr);<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (network_offset &lt; 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return network_offset=
;<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return virtio_net_hdr_tnl_to_skb(skb, hdr,<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0features &amp; NETIF_F_GSO_UDP_TUN=
NEL,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0features &amp; NETIF_F_GSO_UDP_TUN=
NEL_CSUM,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tun_vnet_is_little_endian(flags));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tun_vnet_is_little_endian(flags),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0network_offset);<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 static inline int tun_vnet_hdr_from_skb(unsigned int flags,<br>
&gt; diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c<br>
&gt; index e34c52d05..059eeb18e 100644<br>
&gt; --- a/drivers/net/virtio_net.c<br>
&gt; +++ b/drivers/net/virtio_net.c<br>
&gt; @@ -2502,6 +2502,7 @@ static void virtnet_receive_done(struct virtnet_=
info *vi, struct receive_queue *<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct virtio_net_common_hdr *hdr;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0struct net_device *dev =3D vi-&gt;dev;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int network_offset;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0hdr =3D skb_vnet_common_hdr(skb);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (dev-&gt;features &amp; NETIF_F_RXHASH &a=
mp;&amp; vi-&gt;has_rss_hash_report)<br>
&gt; @@ -2515,9 +2516,12 @@ static void virtnet_receive_done(struct virtnet=
_info *vi, struct receive_queue *<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto frame_err;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (virtio_net_hdr_tnl_to_skb(skb, &amp;hdr-&gt;t=
nl_hdr, vi-&gt;rx_tnl,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0network_offset =3D virtio_net_hdr_get_l3_offset(s=
kb, &amp;hdr-&gt;hdr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (network_offset &lt; 0 ||<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0virtio_net_hdr_tnl_to_skb(skb, &amp=
;hdr-&gt;tnl_hdr, vi-&gt;rx_tnl,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vi-&gt;rx_tnl=
_csum,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0virtio_is_little_en=
dian(vi-&gt;vdev))) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0virtio_is_little_en=
dian(vi-&gt;vdev),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0network_offset)) {<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0net_warn_ratelim=
ited(&quot;%s: bad gso: type: %x, size: %u, flags %x tunnel %d tnl csum %d\=
n&quot;,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dev-&gt;name, hdr-&=
gt;hdr.gso_type,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 hdr-&gt;hdr.gso_siz=
e, hdr-&gt;hdr.flags,<br>
&gt; diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h<b=
r>
&gt; index c381b916c..a4c005796 100644<br>
&gt; --- a/include/linux/virtio_net.h<br>
&gt; +++ b/include/linux/virtio_net.h<br>
&gt; @@ -48,11 +48,49 @@ static inline int virtio_net_hdr_set_proto(struct =
sk_buff *skb,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; +/*<br>
&gt; + * Return the L3 offset of an Ethernet frame starting at skb-&gt;data=
.<br>
&gt; + * The offset is unused without NEEDS_CSUM, so avoid parsing and retu=
rn zero.<br>
&gt; + */<br>
&gt; +static inline int<br>
&gt; +virtio_net_hdr_get_l3_offset(const struct sk_buff *skb,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 const struct virtio_net_hdr *hdr)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0unsigned int parse_depth =3D VLAN_MAX_DEPTH;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0const struct ethhdr *eth;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct ethhdr ethbuf;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0__be16 protocol;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int depth =3D ETH_HLEN;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!(hdr-&gt;flags &amp; VIRTIO_NET_HDR_F_NEEDS_=
CSUM))<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0eth =3D skb_header_pointer(skb, 0, sizeof(ethbuf)=
, &amp;ethbuf);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (!eth)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0protocol =3D eth-&gt;h_proto;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0while (eth_type_vlan(protocol)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct vlan_hdr=
 *vh;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct vlan_hdr vhdr;=
<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vh =3D skb_header_poi=
nter(skb, depth, sizeof(vhdr), &amp;vhdr);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!vh || !--parse_d=
epth)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -EINVAL;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0protocol =3D vh-&gt;h=
_vlan_encapsulated_proto;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0depth +=3D VLAN_HLEN;=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return depth;<br>
&gt; +}<br>
&gt; +<br>
&gt;=C2=A0 static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0const struct virtio_net_hdr *hdr,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool =
little_endian, u8 hdr_gso_type)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool =
little_endian, u8 hdr_gso_type,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int n=
etwork_offset)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0unsigned int nh_min_len =3D sizeof(struct iphdr);=
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int nh_min_len =3D sizeof(struct iphdr);<br>
<br>
<br>
So why is this IPv4 specific assumption still here? Confused.<br>
<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int gso_type =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int thlen =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int p_off =3D 0;<br>
&gt; @@ -98,16 +136,20 @@ static inline int __virtio_net_hdr_to_skb(struct =
sk_buff *skb,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 start =3D __=
virtio16_to_cpu(little_endian, hdr-&gt;csum_start);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 off =3D __vi=
rtio16_to_cpu(little_endian, hdr-&gt;csum_offset);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 needed =3D s=
tart + max_t(u32, thlen, off + sizeof(__sum16));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int transport_offset;=
<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pskb_may_pu=
ll(skb, needed))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return -EINVAL;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!skb_partial=
_csum_set(skb, start, off))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return -EINVAL;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (skb_transport_off=
set(skb) &lt; nh_min_len)<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0transport_offset =3D =
skb_transport_offset(skb);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (transport_offset =
&lt; nh_min_len || network_offset &lt; 0 ||<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0network=
_offset &gt; transport_offset - nh_min_len)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return -EINVAL;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nh_min_len =3D skb_tr=
ansport_offset(skb);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nh_min_len =3D transp=
ort_offset;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p_off =3D nh_min=
_len + thlen;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!pskb_may_pu=
ll(skb, p_off))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return -EINVAL;<br>
&gt; @@ -206,9 +248,11 @@ static inline int __virtio_net_hdr_to_skb(struct =
sk_buff *skb,<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const =
struct virtio_net_hdr *hdr,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool little_=
endian)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bool little_=
endian,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int network_=
offset)<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return __virtio_net_hdr_to_skb(skb, hdr, little_e=
ndian, hdr-&gt;gso_type);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return __virtio_net_hdr_to_skb(skb, hdr, little_e=
ndian, hdr-&gt;gso_type,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 network_offset);<b=
r>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 /* This function must be called after virtio_net_hdr_from_skb().=
 */<br>
&gt; @@ -287,7 +331,7 @@ static inline int virtio_net_hdr_from_skb(const st=
ruct sk_buff *skb,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; -static inline unsigned int virtio_l3min(bool is_ipv6)<br>
&gt; +static inline int virtio_l3min(bool is_ipv6)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return is_ipv6 ? sizeof(struct ipv6hdr) : si=
zeof(struct iphdr);<br>
&gt;=C2=A0 }<br>
&gt; @@ -297,18 +341,19 @@ virtio_net_hdr_tnl_to_skb(struct sk_buff *skb,<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0const struct virtio_net_hdr_v1_hash_tunnel *vhdr,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0bool tnl_hdr_negotiated,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0bool tnl_csum_negotiated,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0bool little_endian)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0bool little_endian, int network_offset)<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0const struct virtio_net_hdr *hdr =3D (const =
struct virtio_net_hdr *)vhdr;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0unsigned int inner_nh, outer_th, inner_th;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0unsigned int inner_l3min, outer_l3min;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0u8 gso_inner_type, gso_tunnel_type;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0bool outer_isv6, inner_isv6;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int inner_nh, outer_th, inner_th;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int inner_l3min, outer_l3min;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0gso_tunnel_type =3D hdr-&gt;gso_type &amp; V=
IRTIO_NET_HDR_GSO_UDP_TUNNEL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!gso_tunnel_type)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return virtio_net_hdr=
_to_skb(skb, hdr, little_endian);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return virtio_net_hdr=
_to_skb(skb, hdr, little_endian,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 network_offset);<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Tunnel not supported/negotiated, but the =
hdr asks for it. */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!tnl_hdr_negotiated)<br>
&gt; @@ -332,19 +377,22 @@ virtio_net_hdr_tnl_to_skb(struct sk_buff *skb,<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0outer_isv6 =3D gso_tunnel_type &amp; VIRTIO_=
NET_HDR_GSO_UDP_TUNNEL_IPV6;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0inner_isv6 =3D gso_inner_type =3D=3D VIRTIO_=
NET_HDR_GSO_TCPV6;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0inner_l3min =3D virtio_l3min(inner_isv6);<br=
>
&gt; -=C2=A0 =C2=A0 =C2=A0outer_l3min =3D ETH_HLEN + virtio_l3min(outer_isv=
6);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0outer_l3min =3D virtio_l3min(outer_isv6);<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0inner_th =3D __virtio16_to_cpu(little_endian=
, hdr-&gt;csum_start);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0inner_nh =3D le16_to_cpu(vhdr-&gt;inner_nh_o=
ffset);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0outer_th =3D le16_to_cpu(vhdr-&gt;outer_th_o=
ffset);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (outer_th &lt; outer_l3min ||<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (network_offset &lt; 0 ||<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0outer_th &lt; outer_l3min ||<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0network_offset &gt; outer_th - oute=
r_l3min ||<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inner_nh &lt; outer_th + sizeo=
f(struct udphdr) ||<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0inner_th &lt; inner_nh + inner=
_l3min)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<=
br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Let the basic parsing deal with plain GSO=
 features. */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D __virtio_net_hdr_to_skb(skb, hdr, tr=
ue,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0hdr-&gt;gso_type &a=
mp; ~gso_tunnel_type);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0hdr-&gt;gso_type &a=
mp; ~gso_tunnel_type,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0network_offset);<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt;=C2=A0 <br>
&gt; diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c<br>
&gt; index 50cae32ae..04c80e23d 100644<br>
&gt; --- a/net/packet/af_packet.c<br>
&gt; +++ b/net/packet/af_packet.c<br>
&gt; @@ -2901,7 +2901,8 @@ static int tpacket_snd(struct packet_sock *po, s=
truct msghdr *msg)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (has_vnet_hdr=
) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (virtio_net_hdr_to_skb(skb, &amp;vnet_hdr, vio_le())) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (virtio_net_hdr_to_skb(skb, &amp;vnet_hdr, vio_le(),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0skb_network_offset(skb))) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tp_len =3D -EINVAL;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto tpacket_error;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0}<br>
<br>
Will this do the right thing for ETH_P_IP sockets? even with vlan tags<br>
in the frame?<br>
<br>
<br>
&gt; @@ -3103,7 +3104,8 @@ static int packet_snd(struct socket *sock, struc=
t msghdr *msg, size_t len)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0packet_parse_headers(skb, sock);<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (vnet_hdr_sz) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D virtio_net_hd=
r_to_skb(skb, &amp;vnet_hdr, vio_le());<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D virtio_net_hd=
r_to_skb(skb, &amp;vnet_hdr, vio_le(),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0skb_network_offset(skb));<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0goto out_free;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0len +=3D vnet_hd=
r_sz;<br>
&gt; -- <br>
&gt; 2.46.0<br>
<br>
</blockquote></div><div><br clear=3D"all"></div><div><br></div><span class=
=3D"gmail_signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_s=
ignature"><div dir=3D"ltr">PGP Key ID:=C2=A0<span style=3D"color:rgb(64,64,=
64);font-family:CeraPro,-apple-system,&quot;system-ui&quot;,&quot;Segoe UI&=
quot;,Roboto,&quot;Helvetica Neue&quot;,Arial,&quot;Noto Sans&quot;,sans-se=
rif,&quot;Apple Color Emoji&quot;,&quot;Segoe UI Emoji&quot;,&quot;Segoe UI=
 Symbol&quot;,&quot;Noto Color Emoji&quot;;font-size:14px">53911E7F16446D4C=
</span>=C2=A0:)<br></div></div>

--0000000000005824fc065c07d210--
--0000000000005824ff065c07d212
Content-Type: application/octet-stream; 
	name="0002-ip-reject-partial-checksums-covering-network-headers.patch"
Content-Disposition: attachment; 
	filename="0002-ip-reject-partial-checksums-covering-network-headers.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mubyn4bo1>
X-Attachment-Id: f_mubyn4bo1

RnJvbSBmYjk5YTgyZTNmMTNlNmEyODAwYWMxZGYwZWJiY2Q2YmM1MjVkZjAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsb3MgWWliZWxvIDxoYWJ0ZS55aWJlbG9AZ21haWwuY29t
PgpEYXRlOiBTdW4sIDIwIFNlcCAyMDI2IDIyOjE2OjQ5IC0wNDAwClN1YmplY3Q6IFtQQVRDSCBu
ZXQgdjYgMi8yXSBpcDogcmVqZWN0IHBhcnRpYWwgY2hlY2tzdW1zIGNvdmVyaW5nIG5ldHdvcmsK
IGhlYWRlcnMKCmlwX2RvX2ZyYWdtZW50KCkgYW5kIG5mX2JyX2lwX2ZyYWdtZW50KCkgY29tcGxl
dGUgYSBDSEVDS1NVTV9QQVJUSUFMIHNrYgpiZWZvcmUgcmVhZGluZyB0aGUgSVB2NCBoZWFkZXIg
bGVuZ3RoLiBpcDZfZnJhZ21lbnQoKSBhbmQgYnJfaXA2X2ZyYWdtZW50KCkKY29tcGxldGUgb25l
IGFmdGVyIHBhcnNpbmcgdGhlIElQdjYgaGVhZGVyIGNoYWluLiBBIHZpcnR1YWxpemF0aW9uCmlu
dGVyZmFjZSBjYW4gc3VwcGx5IGEgY2hlY2tzdW0gc3RhcnQgd2hpY2gsIGFmdGVyIGxpbmstbGF5
ZXIgcmVtb3ZhbCwKc3RpbGwgcG9pbnRzIGluc2lkZSB0aGF0IHBhcnNlZCBuZXR3b3JrIGhlYWRl
ci4KCnNrYl9jaGVja3N1bV9oZWxwKCkgdGhlbiB3cml0ZXMgdGhlIGNvbXBsZXRlZCBjaGVja3N1
bSBpbnRvIGhlYWRlciBieXRlcwp0aGUgc3RhY2sgaGFzIGFscmVhZHkgY29uc3VtZWQuIEZvciBJ
UHY0LCBjaGFuZ2luZyBpcGgtPmlobCBhZnRlciByb3V0aW5nCmFuZCB2YWxpZGF0aW9uIGNhbiBt
YWtlIGZyYWdtZW50YXRpb24gY29weSBiZXlvbmQgdGhlIHNrYidzIGxvZ2ljYWwgbGluZWFyCmhl
YWQgaW50byB0cmFuc21pdHRlZCBvcHRpb25zLiBBIG5lZ2F0aXZlIGNoZWNrc3VtLXN0YXJ0IG9m
ZnNldCBpcyByZWplY3RlZApieSBza2JfY2hlY2tzdW1faGVscCgpLCBidXQgb25seSBhZnRlciBh
IFdBUk5fT05DRSB3aGljaCBjYW4gcGFuaWMgYQpwYW5pY19vbl93YXJuIHN5c3RlbS4KClZhbGlk
YXRlIHRoZSBjaGVja3N1bSBzdGFydCBhZ2FpbnN0IHRoZSBwYXJzZWQgaGVhZGVyIGxlbmd0aCBi
ZWZvcmUKY29tcGxldGluZyBpdC4gRm9yIElQdjQsIHJlYWQgYW5kIHZhbGlkYXRlIElITCBmaXJz
dCwgcmV0YWluIGl0LCBhbmQKcmVhY3F1aXJlIGlwaCBhZnRlciBza2JfY2hlY2tzdW1faGVscCgp
IGluIGJvdGggaW1wbGVtZW50YXRpb25zLiBGb3IgSVB2NiwKdXNlIHRoZSBsZW5ndGggcmV0dXJu
ZWQgYnkgaXA2X2ZpbmRfMXN0ZnJhZ29wdCgpIGluIGJvdGggaW1wbGVtZW50YXRpb25zLgoKQ29t
cGFyZSB0aGUgc2lnbmVkIGNoZWNrc3VtLXN0YXJ0IG9mZnNldCB3aXRoIHRoZSBib3VuZGVkIHNp
Z25lZCBoZWFkZXIKbGVuZ3RoIHNvIGludGVnZXIgcHJvbW90aW9uIGNhbm5vdCBieXBhc3MgZWl0
aGVyIGJvdW5kYXJ5LgoKRml4ZXM6IGRiZDMzOTNjNTZhOCAoImlwdjQ6IGFkZCBkZWZlbnNpdmUg
Y2hlY2sgZm9yIENIRUNLU1VNX1BBUlRJQUwgc2ticyBpbiBpcF9mcmFnbWVudCIpCkZpeGVzOiA0
MDVjOTJmN2E1NDEgKCJpcHY2OiBhZGQgZGVmZW5zaXZlIGNoZWNrIGZvciBDSEVDS1NVTV9QQVJU
SUFMIHNrYnMgaW4gaXBfZnJhZ21lbnQiKQpGaXhlczogM2MxNzFmNDk2ZWY1ICgibmV0ZmlsdGVy
OiBicmlkZ2U6IGFkZCBjb25uZWN0aW9uIHRyYWNraW5nIHN5c3RlbSIpCkZpeGVzOiA3NjRkZDE2
M2FjOTIgKCJuZXRmaWx0ZXI6IG5mX2Nvbm50cmFja19icmlkZ2U6IGFkZCBzdXBwb3J0IGZvciBJ
UHY2IikKUmVwb3J0ZWQtYnk6IFBhdWxvcyBZaWJlbG8gPGhhYnRlLnlpYmVsb0BnbWFpbC5jb20+
Ckxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDI2MDkyMDAwNDczMy42NDcz
LTMtaGFidGUueWliZWxvQGdtYWlsLmNvbS8KQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcKQXNz
aXN0ZWQtYnk6IExMTQpTaWduZWQtb2ZmLWJ5OiBQYXVsb3MgWWliZWxvIDxoYWJ0ZS55aWJlbG9A
Z21haWwuY29tPgotLS0KIG5ldC9icmlkZ2UvbmV0ZmlsdGVyL25mX2Nvbm50cmFja19icmlkZ2Uu
YyB8IDIxICsrKysrKysrKysrKysrKy0tLS0tCiBuZXQvaXB2NC9pcF9vdXRwdXQuYyAgICAgICAg
ICAgICAgICAgICAgICAgfCAyMyArKysrKysrKysrKysrKysrLS0tLS0tCiBuZXQvaXB2Ni9pcDZf
b3V0cHV0LmMgICAgICAgICAgICAgICAgICAgICAgfCAxMiArKysrKysrKy0tLQogbmV0L2lwdjYv
bmV0ZmlsdGVyLmMgICAgICAgICAgICAgICAgICAgICAgIHwgMTIgKysrKysrKystLS0KIDQgZmls
ZXMgY2hhbmdlZCwgNTEgaW5zZXJ0aW9ucygrKSwgMTcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvbmV0L2JyaWRnZS9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2JyaWRnZS5jIGIvbmV0L2JyaWRn
ZS9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2JyaWRnZS5jCmluZGV4IDdlY2I4YTI2Yi4uZDgxZWQ4
NjkyIDEwMDY0NAotLS0gYS9uZXQvYnJpZGdlL25ldGZpbHRlci9uZl9jb25udHJhY2tfYnJpZGdl
LmMKKysrIGIvbmV0L2JyaWRnZS9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX2JyaWRnZS5jCkBAIC0z
OCwxOCArMzgsMjkgQEAgc3RhdGljIGludCBuZl9icl9pcF9mcmFnbWVudChzdHJ1Y3QgbmV0ICpu
ZXQsIHN0cnVjdCBzb2NrICpzaywKIAlzdHJ1Y3QgaXBoZHIgKmlwaDsKIAlpbnQgZXJyID0gMDsK
IAotCS8qIGZvciBvZmZsb2FkZWQgY2hlY2tzdW1zIGNsZWFudXAgY2hlY2tzdW0gYmVmb3JlIGZy
YWdtZW50YXRpb24gKi8KLQlpZiAoc2tiLT5pcF9zdW1tZWQgPT0gQ0hFQ0tTVU1fUEFSVElBTCAm
JgotCSAgICAoZXJyID0gc2tiX2NoZWNrc3VtX2hlbHAoc2tiKSkpCisJaXBoID0gaXBfaGRyKHNr
Yik7CisJaGxlbiA9IGlwaC0+aWhsICogNDsKKwlpZiAodW5saWtlbHkoaGxlbiA8IHNpemVvZigq
aXBoKSB8fCBobGVuID4gc2tiX2hlYWRsZW4oc2tiKSkpIHsKKwkJZXJyID0gLUVJTlZBTDsKIAkJ
Z290byBibGFja2hvbGU7CisJfQogCi0JaXBoID0gaXBfaGRyKHNrYik7CisJLyogQ29tcGxldGUg
b2ZmbG9hZGVkIGNoZWNrc3VtcyBvbmx5IGFmdGVyIHRoZSB2YWxpZGF0ZWQgSVAgaGVhZGVyLiAq
LworCWlmIChza2ItPmlwX3N1bW1lZCA9PSBDSEVDS1NVTV9QQVJUSUFMKSB7CisJCWlmICh1bmxp
a2VseShza2JfY2hlY2tzdW1fc3RhcnRfb2Zmc2V0KHNrYikgPCAoaW50KWhsZW4pKSB7CisJCQll
cnIgPSAtRUlOVkFMOworCQkJZ290byBibGFja2hvbGU7CisJCX0KKwkJZXJyID0gc2tiX2NoZWNr
c3VtX2hlbHAoc2tiKTsKKwkJaWYgKGVycikKKwkJCWdvdG8gYmxhY2tob2xlOworCQlpcGggPSBp
cF9oZHIoc2tiKTsKKwl9CiAKIAkvKgogCSAqCVNldHVwIHN0YXJ0aW5nIHZhbHVlcwogCSAqLwog
Ci0JaGxlbiA9IGlwaC0+aWhsICogNDsKIAlmcmFnX21heF9zaXplIC09IGhsZW47CiAJbGxfcnMg
PSBMTF9SRVNFUlZFRF9TUEFDRShza2ItPmRldik7CiAJbXR1ID0gc2tiLT5kZXYtPm10dTsKZGlm
ZiAtLWdpdCBhL25ldC9pcHY0L2lwX291dHB1dC5jIGIvbmV0L2lwdjQvaXBfb3V0cHV0LmMKaW5k
ZXggYTI0Y2M4ZWUxLi5mYTZhNzRkMjAgMTAwNjQ0Ci0tLSBhL25ldC9pcHY0L2lwX291dHB1dC5j
CisrKyBiL25ldC9pcHY0L2lwX291dHB1dC5jCkBAIC03NzAsMTYgKzc3MCwyOCBAQCBpbnQgaXBf
ZG9fZnJhZ21lbnQoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBza19i
dWZmICpza2IsCiAJc3RydWN0IGlwX2ZyYWdfc3RhdGUgc3RhdGU7CiAJaW50IGVyciA9IDA7CiAK
LQkvKiBmb3Igb2ZmbG9hZGVkIGNoZWNrc3VtcyBjbGVhbnVwIGNoZWNrc3VtIGJlZm9yZSBmcmFn
bWVudGF0aW9uICovCi0JaWYgKHNrYi0+aXBfc3VtbWVkID09IENIRUNLU1VNX1BBUlRJQUwgJiYK
LQkgICAgKGVyciA9IHNrYl9jaGVja3N1bV9oZWxwKHNrYikpKQotCQlnb3RvIGZhaWw7Ci0KIAkv
KgogCSAqCVBvaW50IGludG8gdGhlIElQIGRhdGFncmFtIGhlYWRlci4KIAkgKi8KIAogCWlwaCA9
IGlwX2hkcihza2IpOworCWhsZW4gPSBpcGgtPmlobCAqIDQ7CisJaWYgKHVubGlrZWx5KGhsZW4g
PCBzaXplb2YoKmlwaCkgfHwgaGxlbiA+IHNrYl9oZWFkbGVuKHNrYikpKSB7CisJCWVyciA9IC1F
SU5WQUw7CisJCWdvdG8gZmFpbDsKKwl9CisKKwkvKiBDb21wbGV0ZSBvZmZsb2FkZWQgY2hlY2tz
dW1zIG9ubHkgYWZ0ZXIgdGhlIHZhbGlkYXRlZCBJUCBoZWFkZXIuICovCisJaWYgKHNrYi0+aXBf
c3VtbWVkID09IENIRUNLU1VNX1BBUlRJQUwpIHsKKwkJaWYgKHVubGlrZWx5KHNrYl9jaGVja3N1
bV9zdGFydF9vZmZzZXQoc2tiKSA8IChpbnQpaGxlbikpIHsKKwkJCWVyciA9IC1FSU5WQUw7CisJ
CQlnb3RvIGZhaWw7CisJCX0KKwkJZXJyID0gc2tiX2NoZWNrc3VtX2hlbHAoc2tiKTsKKwkJaWYg
KGVycikKKwkJCWdvdG8gZmFpbDsKKwkJaXBoID0gaXBfaGRyKHNrYik7CisJfQogCiAJbXR1ID0g
aXBfc2tiX2RzdF9tdHUoc2ssIHNrYik7CiAJaWYgKElQQ0Ioc2tiKS0+ZnJhZ19tYXhfc2l6ZSAm
JiBJUENCKHNrYiktPmZyYWdfbWF4X3NpemUgPCBtdHUpCkBAIC03ODksNyArODAxLDYgQEAgaW50
IGlwX2RvX2ZyYWdtZW50KHN0cnVjdCBuZXQgKm5ldCwgc3RydWN0IHNvY2sgKnNrLCBzdHJ1Y3Qg
c2tfYnVmZiAqc2tiLAogCSAqCVNldHVwIHN0YXJ0aW5nIHZhbHVlcy4KIAkgKi8KIAotCWhsZW4g
PSBpcGgtPmlobCAqIDQ7CiAJaWYgKG10dSA8IGhsZW4gKyA4KSB7CiAJCWVyciA9IC1FTVNHU0la
RTsKIAkJZ290byBmYWlsOwpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvaXA2X291dHB1dC5jIGIvbmV0
L2lwdjYvaXA2X291dHB1dC5jCmluZGV4IDU1MDk2NTA1OC4uZDE1N2I2YWRlIDEwMDY0NAotLS0g
YS9uZXQvaXB2Ni9pcDZfb3V0cHV0LmMKKysrIGIvbmV0L2lwdjYvaXA2X291dHB1dC5jCkBAIC05
NDIsOSArOTQyLDE1IEBAIGludCBpcDZfZnJhZ21lbnQoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3Qg
c29jayAqc2ssIHN0cnVjdCBza19idWZmICpza2IsCiAJZnJhZ19pZCA9IGlwdjZfc2VsZWN0X2lk
ZW50KG5ldCwgJmlwdjZfaGRyKHNrYiktPmRhZGRyLAogCQkJCSAgICAmaXB2Nl9oZHIoc2tiKS0+
c2FkZHIpOwogCi0JaWYgKHNrYi0+aXBfc3VtbWVkID09IENIRUNLU1VNX1BBUlRJQUwgJiYKLQkg
ICAgKGVyciA9IHNrYl9jaGVja3N1bV9oZWxwKHNrYikpKQotCQlnb3RvIGZhaWw7CisJaWYgKHNr
Yi0+aXBfc3VtbWVkID09IENIRUNLU1VNX1BBUlRJQUwpIHsKKwkJaWYgKHVubGlrZWx5KHNrYl9j
aGVja3N1bV9zdGFydF9vZmZzZXQoc2tiKSA8IChpbnQpaGxlbikpIHsKKwkJCWVyciA9IC1FSU5W
QUw7CisJCQlnb3RvIGZhaWw7CisJCX0KKwkJZXJyID0gc2tiX2NoZWNrc3VtX2hlbHAoc2tiKTsK
KwkJaWYgKGVycikKKwkJCWdvdG8gZmFpbDsKKwl9CiAKIAlwcmV2aGRyID0gc2tiX25ldHdvcmtf
aGVhZGVyKHNrYikgKyBuZXh0aGRyX29mZnNldDsKIAlocm9vbSA9IExMX1JFU0VSVkVEX1NQQUNF
KHJ0LT5kc3QuZGV2KTsKZGlmZiAtLWdpdCBhL25ldC9pcHY2L25ldGZpbHRlci5jIGIvbmV0L2lw
djYvbmV0ZmlsdGVyLmMKaW5kZXggYTcwMjVlYzg3Li5kYTdhZGExMmYgMTAwNjQ0Ci0tLSBhL25l
dC9pcHY2L25ldGZpbHRlci5jCisrKyBiL25ldC9pcHY2L25ldGZpbHRlci5jCkBAIC0xNDQsOSAr
MTQ0LDE1IEBAIGludCBicl9pcDZfZnJhZ21lbnQoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3Qgc29j
ayAqc2ssIHN0cnVjdCBza19idWZmICpza2IsCiAJZnJhZ19pZCA9IGlwdjZfc2VsZWN0X2lkZW50
KG5ldCwgJmlwdjZfaGRyKHNrYiktPmRhZGRyLAogCQkJCSAgICAmaXB2Nl9oZHIoc2tiKS0+c2Fk
ZHIpOwogCi0JaWYgKHNrYi0+aXBfc3VtbWVkID09IENIRUNLU1VNX1BBUlRJQUwgJiYKLQkgICAg
KGVyciA9IHNrYl9jaGVja3N1bV9oZWxwKHNrYikpKQotCQlnb3RvIGJsYWNraG9sZTsKKwlpZiAo
c2tiLT5pcF9zdW1tZWQgPT0gQ0hFQ0tTVU1fUEFSVElBTCkgeworCQlpZiAodW5saWtlbHkoc2ti
X2NoZWNrc3VtX3N0YXJ0X29mZnNldChza2IpIDwgKGludClobGVuKSkgeworCQkJZXJyID0gLUVJ
TlZBTDsKKwkJCWdvdG8gYmxhY2tob2xlOworCQl9CisJCWVyciA9IHNrYl9jaGVja3N1bV9oZWxw
KHNrYik7CisJCWlmIChlcnIpCisJCQlnb3RvIGJsYWNraG9sZTsKKwl9CiAKIAlwcmV2aGRyID0g
c2tiX25ldHdvcmtfaGVhZGVyKHNrYikgKyBuZXh0aGRyX29mZnNldDsKIAlocm9vbSA9IExMX1JF
U0VSVkVEX1NQQUNFKHNrYi0+ZGV2KTsKLS0gCjIuNDYuMAoK
--0000000000005824ff065c07d212
Content-Type: application/octet-stream; 
	name="0001-net-validate-virtio-checksum-start-after-network-hea.patch"
Content-Disposition: attachment; 
	filename="0001-net-validate-virtio-checksum-start-after-network-hea.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mubyn4bi0>
X-Attachment-Id: f_mubyn4bi0

RnJvbSBkZmFiM2JhZDQ3MzJjNGI5NzM0NzQyMWEwYTNhNGM2OTBlOTEyYmU0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBQYXVsb3MgWWliZWxvIDxoYWJ0ZS55aWJlbG9AZ21haWwuY29t
PgpEYXRlOiBNb24sIDIxIFNlcCAyMDI2IDE5OjM4OjUxIC0wNDAwClN1YmplY3Q6IFtQQVRDSCBu
ZXQgdjYgMS8yXSBuZXQ6IHZhbGlkYXRlIHZpcnRpbyBjaGVja3N1bSBzdGFydCBhZnRlciBuZXR3
b3JrCiBoZWFkZXIKCl9fdmlydGlvX25ldF9oZHJfdG9fc2tiKCkgY2hlY2tzIGEgbWluaW11bSBu
ZXR3b3JrLWhlYWRlciBsZW5ndGggZm9yCkNIRUNLU1VNX1BBUlRJQUwgcGFja2V0cy4gSXRzIGNo
ZWNrc3VtIHN0YXJ0IGlzIHJlbGF0aXZlIHRvIHNrYi0+ZGF0YSwKYnV0IHNvbWUgY2FsbGVycyBo
YXZlIG5vdCBlc3RhYmxpc2hlZCBza2ItPm5ldHdvcmtfaGVhZGVyIHdoZW4gdGhleQpjb252ZXJ0
IHRoZSB2aXJ0aW8gaGVhZGVyLgoKUGFzcyB0aGUgZGF0YS1yZWxhdGl2ZSBMMyBvcmlnaW4gZXhw
bGljaXRseS4gRXRoZXJuZXQgcmVjZWl2ZSBwYXRocwpwYXJzZSB0aGUgZnJhbWUgYW5kIG5lc3Rl
ZCBWTEFOIGhlYWRlcnMgd2l0aG91dCBjaGFuZ2luZyBza2Igc3RhdGUuCkFGX1BBQ0tFVCB1c2Vz
IHRoZSBmcmFtZSdzIGFjdHVhbCBMMyBvcmlnaW4gZXZlbiB3aGVuIHRoZSBzb2NrZXQKcHJvdG9j
b2wgaXMgRVRIX1BfSVAgYW5kIHRoZSByYXcgZnJhbWUgY2FycmllcyBWTEFOIHRhZ3MuIE5vbi1F
dGhlcm5ldApBRl9QQUNLRVQgZGV2aWNlcyByZXRhaW4gdGhlaXIgZXN0YWJsaXNoZWQgc2tiIG5l
dHdvcmsgb2Zmc2V0LgoKQWxzbyBwYXNzIHRoZSBhY3R1YWwgTDMgcHJvdG9jb2wgc28gSVB2NiBw
YWNrZXRzIHVzZSB0aGUgNDAtYnl0ZSBiYXNlCmhlYWRlciBtaW5pbXVtIGV2ZW4gd2l0aG91dCBU
Q1B2NiBHU08uIElGRl9UVU4gb2J0YWlucyB0aGF0IHByb3RvY29sCmZyb20gdGhlIHBhY2tldCBi
ZWZvcmUgc2tiLT5wcm90b2NvbCBpcyBzZXQuIE5hbWUgdGhlIEV0aGVybmV0IHBhcnNlcgphY2Nv
cmRpbmdseSwgdXNlIHRoZSBzYW1lIG9yaWdpbiBmb3IgdHVubmVsIHZhbGlkYXRpb24sIGFuZCBw
cm9wYWdhdGUKY29udmVyc2lvbiBmYWlsdXJlcyBpbiBVTUwuCgpUaGUgYm91bmQgcmVtYWlucyBh
IG1pbmltdW07IGZyYWdtZW50YXRpb24gcGF0aHMgc2VwYXJhdGVseSB2YWxpZGF0ZQp0aGUgcGFy
c2VkIElQdjQgb3IgSVB2NiBoZWFkZXIgbGVuZ3RoIGJlZm9yZSBjb21wbGV0aW5nIGEgY2hlY2tz
dW0uCgpGaXhlczogNDlkMTRiNTRhNTI3ICgibmV0OiB0ZXN0IGZvciBub3QgdG9vIHNtYWxsIGNz
dW1fc3RhcnQgaW4gdmlydGlvX25ldF9oZHJfdG9fc2tiKCkiKQpGaXhlczogYTJmYjRiYzRlMmE2
ICgibmV0OiBpbXBsZW1lbnQgdmlydGlvIGhlbHBlcnMgdG8gaGFuZGxlIFVEUCBHU08gdHVubmVs
aW5nLiIpClJlcG9ydGVkLWJ5OiBQYXVsb3MgWWliZWxvIDxoYWJ0ZS55aWJlbG9AZ21haWwuY29t
PgpMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyNjA5MjAwMDQ3MzMuNjQ3
My0yLWhhYnRlLnlpYmVsb0BnbWFpbC5jb20vCkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCkFz
c2lzdGVkLWJ5OiBMTE0KU2lnbmVkLW9mZi1ieTogUGF1bG9zIFlpYmVsbyA8aGFidGUueWliZWxv
QGdtYWlsLmNvbT4KLS0tCiBhcmNoL3VtL2RyaXZlcnMvdmVjdG9yX3RyYW5zcG9ydHMuYyB8IDEz
ICsrKystCiBkcml2ZXJzL25ldC90dW5fdm5ldC5oICAgICAgICAgICAgICB8IDUyICsrKysrKysr
KysrKysrKystCiBkcml2ZXJzL25ldC92aXJ0aW9fbmV0LmMgICAgICAgICAgICB8IDEwICsrKy0K
IGluY2x1ZGUvbGludXgvdmlydGlvX25ldC5oICAgICAgICAgIHwgODcgKysrKysrKysrKysrKysr
KysrKysrKysrLS0tLS0KIG5ldC9wYWNrZXQvYWZfcGFja2V0LmMgICAgICAgICAgICAgIHwgMjQg
KysrKysrKy0KIDUgZmlsZXMgY2hhbmdlZCwgMTYzIGluc2VydGlvbnMoKyksIDIzIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvdW0vZHJpdmVycy92ZWN0b3JfdHJhbnNwb3J0cy5jIGIv
YXJjaC91bS9kcml2ZXJzL3ZlY3Rvcl90cmFuc3BvcnRzLmMKaW5kZXggZGRkMTI3ZWU5Li41YTlk
OGY0OWEgMTAwNjQ0Ci0tLSBhL2FyY2gvdW0vZHJpdmVycy92ZWN0b3JfdHJhbnNwb3J0cy5jCisr
KyBiL2FyY2gvdW0vZHJpdmVycy92ZWN0b3JfdHJhbnNwb3J0cy5jCkBAIC0xOTcsNiArMTk3LDgg
QEAgc3RhdGljIGludCByYXdfdmVyaWZ5X2hlYWRlcigKIAl1aW50OF90ICpoZWFkZXIsIHN0cnVj
dCBza19idWZmICpza2IsIHN0cnVjdCB2ZWN0b3JfcHJpdmF0ZSAqdnApCiB7CiAJc3RydWN0IHZp
cnRpb19uZXRfaGRyICp2aGVhZGVyID0gKHN0cnVjdCB2aXJ0aW9fbmV0X2hkciAqKSBoZWFkZXI7
CisJX19iZTE2IG5ldHdvcmtfcHJvdG9jb2w7CisJaW50IG5ldHdvcmtfb2Zmc2V0OwogCiAJaWYg
KCh2aGVhZGVyLT5nc29fdHlwZSAhPSBWSVJUSU9fTkVUX0hEUl9HU09fTk9ORSkgJiYKIAkJKHZw
LT5yZXFfc2l6ZSAhPSA2NTUzNikpIHsKQEAgLTIwOSw4ICsyMTEsMTQgQEAgc3RhdGljIGludCBy
YXdfdmVyaWZ5X2hlYWRlcigKIAlpZiAoKHZoZWFkZXItPmZsYWdzICYgVklSVElPX05FVF9IRFJf
Rl9EQVRBX1ZBTElEKSA+IDApCiAJCXJldHVybiAxOwogCi0JdmlydGlvX25ldF9oZHJfdG9fc2ti
KHNrYiwgdmhlYWRlciwgdmlydGlvX2xlZ2FjeV9pc19saXR0bGVfZW5kaWFuKCkpOwotCXJldHVy
biAwOworCW5ldHdvcmtfb2Zmc2V0ID0gdmlydGlvX25ldF9oZHJfZXRoX2dldF9sM19vZmZzZXQo
c2tiLCB2aGVhZGVyLAorCQkJCQkJCSAgJm5ldHdvcmtfcHJvdG9jb2wpOworCWlmIChuZXR3b3Jr
X29mZnNldCA8IDApCisJCXJldHVybiBuZXR3b3JrX29mZnNldDsKKworCXJldHVybiB2aXJ0aW9f
bmV0X2hkcl90b19za2Ioc2tiLCB2aGVhZGVyLAorCQkJCSAgICAgdmlydGlvX2xlZ2FjeV9pc19s
aXR0bGVfZW5kaWFuKCksCisJCQkJICAgICBuZXR3b3JrX29mZnNldCwgbmV0d29ya19wcm90b2Nv
bCk7CiB9CiAKIHN0YXRpYyBib29sIGdldF91aW50X3BhcmFtKApAQCAtNDkxLDQgKzQ5OSwzIEBA
IGludCBidWlsZF90cmFuc3BvcnRfZGF0YShzdHJ1Y3QgdmVjdG9yX3ByaXZhdGUgKnZwKQogCQly
ZXR1cm4gYnVpbGRfYmVzc190cmFuc3BvcnRfZGF0YSh2cCk7CiAJcmV0dXJuIDA7CiB9Ci0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3R1bl92bmV0LmggYi9kcml2ZXJzL25ldC90dW5fdm5ldC5o
CmluZGV4IGY0YzY1MmIxZi4uZTAwNDIxM2ZhIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC90dW5f
dm5ldC5oCisrKyBiL2RyaXZlcnMvbmV0L3R1bl92bmV0LmgKQEAgLTE3NywxMCArMTc3LDQ5IEBA
IHN0YXRpYyBpbmxpbmUgaW50IHR1bl92bmV0X2hkcl9wdXQoaW50IHN6LCBzdHJ1Y3QgaW92X2l0
ZXIgKml0ZXIsCiAJcmV0dXJuIF9fdHVuX3ZuZXRfaGRyX3B1dChzeiwgMCwgaXRlciwgaGRyKTsK
IH0KIAorc3RhdGljIGlubGluZSBpbnQKK3R1bl92bmV0X2hkcl9nZXRfbDNfb2Zmc2V0KHVuc2ln
bmVkIGludCBmbGFncywgY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwKKwkJCSAgIGNvbnN0IHN0
cnVjdCB2aXJ0aW9fbmV0X2hkciAqaGRyLAorCQkJICAgX19iZTE2ICpuZXR3b3JrX3Byb3RvY29s
KQoreworCWlmICgoZmxhZ3MgJiBUVU5fVFlQRV9NQVNLKSAhPSBJRkZfVEFQKSB7CisJCXU4IHZl
cnNpb24sIGZpcnN0X2J5dGU7CisJCWNvbnN0IHU4ICpmaXJzdDsKKworCQkqbmV0d29ya19wcm90
b2NvbCA9IDA7CisJCWlmICghKGhkci0+ZmxhZ3MgJiBWSVJUSU9fTkVUX0hEUl9GX05FRURTX0NT
VU0pKQorCQkJcmV0dXJuIDA7CisKKwkJZmlyc3QgPSBza2JfaGVhZGVyX3BvaW50ZXIoc2tiLCAw
LCBzaXplb2YoZmlyc3RfYnl0ZSksCisJCQkJCSAgICZmaXJzdF9ieXRlKTsKKwkJaWYgKCFmaXJz
dCkKKwkJCXJldHVybiAtRUlOVkFMOworCisJCXZlcnNpb24gPSAqZmlyc3QgPj4gNDsKKwkJaWYg
KHZlcnNpb24gPT0gNCkKKwkJCSpuZXR3b3JrX3Byb3RvY29sID0gaHRvbnMoRVRIX1BfSVApOwor
CQllbHNlIGlmICh2ZXJzaW9uID09IDYpCisJCQkqbmV0d29ya19wcm90b2NvbCA9IGh0b25zKEVU
SF9QX0lQVjYpOworCQlyZXR1cm4gMDsKKwl9CisKKwlyZXR1cm4gdmlydGlvX25ldF9oZHJfZXRo
X2dldF9sM19vZmZzZXQoc2tiLCBoZHIsCisJCQkJCSAgICAgIG5ldHdvcmtfcHJvdG9jb2wpOwor
fQorCiBzdGF0aWMgaW5saW5lIGludCB0dW5fdm5ldF9oZHJfdG9fc2tiKHVuc2lnbmVkIGludCBm
bGFncywgc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAkJCQkgICAgICBjb25zdCBzdHJ1Y3QgdmlydGlv
X25ldF9oZHIgKmhkcikKIHsKLQlyZXR1cm4gdmlydGlvX25ldF9oZHJfdG9fc2tiKHNrYiwgaGRy
LCB0dW5fdm5ldF9pc19saXR0bGVfZW5kaWFuKGZsYWdzKSk7CisJX19iZTE2IG5ldHdvcmtfcHJv
dG9jb2w7CisJaW50IG5ldHdvcmtfb2Zmc2V0ID0gdHVuX3ZuZXRfaGRyX2dldF9sM19vZmZzZXQo
ZmxhZ3MsIHNrYiwgaGRyLAorCQkJCQkJICAgICAgICZuZXR3b3JrX3Byb3RvY29sKTsKKworCWlm
IChuZXR3b3JrX29mZnNldCA8IDApCisJCXJldHVybiBuZXR3b3JrX29mZnNldDsKKworCXJldHVy
biB2aXJ0aW9fbmV0X2hkcl90b19za2Ioc2tiLCBoZHIsCisJCQkJICAgICB0dW5fdm5ldF9pc19s
aXR0bGVfZW5kaWFuKGZsYWdzKSwKKwkJCQkgICAgIG5ldHdvcmtfb2Zmc2V0LCBuZXR3b3JrX3By
b3RvY29sKTsKIH0KIAogLyoKQEAgLTE5OSwxMCArMjM4LDE5IEBAIHR1bl92bmV0X2hkcl90bmxf
dG9fc2tiKHVuc2lnbmVkIGludCBmbGFncywgbmV0ZGV2X2ZlYXR1cmVzX3QgZmVhdHVyZXMsCiAJ
CQlzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCQkJY29uc3Qgc3RydWN0IHZpcnRpb19uZXRfaGRyX3Yx
X2hhc2hfdHVubmVsICpoZHIpCiB7CisJY29uc3Qgc3RydWN0IHZpcnRpb19uZXRfaGRyICp2bmV0
X2hkciA9IChjb25zdCBzdHJ1Y3QgdmlydGlvX25ldF9oZHIgKiloZHI7CisJX19iZTE2IG5ldHdv
cmtfcHJvdG9jb2w7CisJaW50IG5ldHdvcmtfb2Zmc2V0ID0gdHVuX3ZuZXRfaGRyX2dldF9sM19v
ZmZzZXQoZmxhZ3MsIHNrYiwgdm5ldF9oZHIsCisJCQkJCQkgICAgICAgJm5ldHdvcmtfcHJvdG9j
b2wpOworCisJaWYgKG5ldHdvcmtfb2Zmc2V0IDwgMCkKKwkJcmV0dXJuIG5ldHdvcmtfb2Zmc2V0
OworCiAJcmV0dXJuIHZpcnRpb19uZXRfaGRyX3RubF90b19za2Ioc2tiLCBoZHIsCiAJCQkJZmVh
dHVyZXMgJiBORVRJRl9GX0dTT19VRFBfVFVOTkVMLAogCQkJCWZlYXR1cmVzICYgTkVUSUZfRl9H
U09fVURQX1RVTk5FTF9DU1VNLAotCQkJCXR1bl92bmV0X2lzX2xpdHRsZV9lbmRpYW4oZmxhZ3Mp
KTsKKwkJCQl0dW5fdm5ldF9pc19saXR0bGVfZW5kaWFuKGZsYWdzKSwKKwkJCQluZXR3b3JrX29m
ZnNldCwgbmV0d29ya19wcm90b2NvbCk7CiB9CiAKIHN0YXRpYyBpbmxpbmUgaW50IHR1bl92bmV0
X2hkcl9mcm9tX3NrYih1bnNpZ25lZCBpbnQgZmxhZ3MsCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC92aXJ0aW9fbmV0LmMgYi9kcml2ZXJzL25ldC92aXJ0aW9fbmV0LmMKaW5kZXggZTM0YzUyZDA1
Li44ZTkzZGFkMjggMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3ZpcnRpb19uZXQuYworKysgYi9k
cml2ZXJzL25ldC92aXJ0aW9fbmV0LmMKQEAgLTI1MDIsNiArMjUwMiw4IEBAIHN0YXRpYyB2b2lk
IHZpcnRuZXRfcmVjZWl2ZV9kb25lKHN0cnVjdCB2aXJ0bmV0X2luZm8gKnZpLCBzdHJ1Y3QgcmVj
ZWl2ZV9xdWV1ZSAqCiB7CiAJc3RydWN0IHZpcnRpb19uZXRfY29tbW9uX2hkciAqaGRyOwogCXN0
cnVjdCBuZXRfZGV2aWNlICpkZXYgPSB2aS0+ZGV2OworCV9fYmUxNiBuZXR3b3JrX3Byb3RvY29s
OworCWludCBuZXR3b3JrX29mZnNldDsKIAogCWhkciA9IHNrYl92bmV0X2NvbW1vbl9oZHIoc2ti
KTsKIAlpZiAoZGV2LT5mZWF0dXJlcyAmIE5FVElGX0ZfUlhIQVNIICYmIHZpLT5oYXNfcnNzX2hh
c2hfcmVwb3J0KQpAQCAtMjUxNSw5ICsyNTE3LDEzIEBAIHN0YXRpYyB2b2lkIHZpcnRuZXRfcmVj
ZWl2ZV9kb25lKHN0cnVjdCB2aXJ0bmV0X2luZm8gKnZpLCBzdHJ1Y3QgcmVjZWl2ZV9xdWV1ZSAq
CiAJCWdvdG8gZnJhbWVfZXJyOwogCX0KIAotCWlmICh2aXJ0aW9fbmV0X2hkcl90bmxfdG9fc2ti
KHNrYiwgJmhkci0+dG5sX2hkciwgdmktPnJ4X3RubCwKKwluZXR3b3JrX29mZnNldCA9IHZpcnRp
b19uZXRfaGRyX2V0aF9nZXRfbDNfb2Zmc2V0KHNrYiwgJmhkci0+aGRyLAorCQkJCQkJCSAgJm5l
dHdvcmtfcHJvdG9jb2wpOworCWlmIChuZXR3b3JrX29mZnNldCA8IDAgfHwKKwkgICAgdmlydGlv
X25ldF9oZHJfdG5sX3RvX3NrYihza2IsICZoZHItPnRubF9oZHIsIHZpLT5yeF90bmwsCiAJCQkJ
ICAgICAgdmktPnJ4X3RubF9jc3VtLAotCQkJCSAgICAgIHZpcnRpb19pc19saXR0bGVfZW5kaWFu
KHZpLT52ZGV2KSkpIHsKKwkJCQkgICAgICB2aXJ0aW9faXNfbGl0dGxlX2VuZGlhbih2aS0+dmRl
diksCisJCQkJICAgICAgbmV0d29ya19vZmZzZXQsIG5ldHdvcmtfcHJvdG9jb2wpKSB7CiAJCW5l
dF93YXJuX3JhdGVsaW1pdGVkKCIlczogYmFkIGdzbzogdHlwZTogJXgsIHNpemU6ICV1LCBmbGFn
cyAleCB0dW5uZWwgJWQgdG5sIGNzdW0gJWRcbiIsCiAJCQkJICAgICBkZXYtPm5hbWUsIGhkci0+
aGRyLmdzb190eXBlLAogCQkJCSAgICAgaGRyLT5oZHIuZ3NvX3NpemUsIGhkci0+aGRyLmZsYWdz
LApkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC92aXJ0aW9fbmV0LmggYi9pbmNsdWRlL2xpbnV4
L3ZpcnRpb19uZXQuaAppbmRleCBjMzgxYjkxNmMuLmI4OWQ4MjFhMCAxMDA2NDQKLS0tIGEvaW5j
bHVkZS9saW51eC92aXJ0aW9fbmV0LmgKKysrIGIvaW5jbHVkZS9saW51eC92aXJ0aW9fbmV0LmgK
QEAgLTQ4LDE2ICs0OCw2MSBAQCBzdGF0aWMgaW5saW5lIGludCB2aXJ0aW9fbmV0X2hkcl9zZXRf
cHJvdG8oc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAlyZXR1cm4gMDsKIH0KIAorLyoKKyAqIFJldHVy
biB0aGUgTDMgb2Zmc2V0IGFuZCBwcm90b2NvbCBvZiBhbiBFdGhlcm5ldCBmcmFtZSBzdGFydGlu
ZyBhdCBza2ItPmRhdGEuCisgKiBUaGUgb2Zmc2V0IGlzIHVudXNlZCB3aXRob3V0IE5FRURTX0NT
VU0sIHNvIGF2b2lkIHBhcnNpbmcgYW5kIHJldHVybiB6ZXJvLgorICovCitzdGF0aWMgaW5saW5l
IGludAordmlydGlvX25ldF9oZHJfZXRoX2dldF9sM19vZmZzZXQoY29uc3Qgc3RydWN0IHNrX2J1
ZmYgKnNrYiwKKwkJCQkgY29uc3Qgc3RydWN0IHZpcnRpb19uZXRfaGRyICpoZHIsCisJCQkJIF9f
YmUxNiAqbmV0d29ya19wcm90b2NvbCkKK3sKKwl1bnNpZ25lZCBpbnQgcGFyc2VfZGVwdGggPSBW
TEFOX01BWF9ERVBUSDsKKwljb25zdCBzdHJ1Y3QgZXRoaGRyICpldGg7CisJc3RydWN0IGV0aGhk
ciBldGhidWY7CisJX19iZTE2IHByb3RvY29sOworCWludCBkZXB0aCA9IEVUSF9ITEVOOworCisJ
Km5ldHdvcmtfcHJvdG9jb2wgPSAwOworCWlmICghKGhkci0+ZmxhZ3MgJiBWSVJUSU9fTkVUX0hE
Ul9GX05FRURTX0NTVU0pKQorCQlyZXR1cm4gMDsKKworCWV0aCA9IHNrYl9oZWFkZXJfcG9pbnRl
cihza2IsIDAsIHNpemVvZihldGhidWYpLCAmZXRoYnVmKTsKKwlpZiAoIWV0aCkKKwkJcmV0dXJu
IC1FSU5WQUw7CisKKwlwcm90b2NvbCA9IGV0aC0+aF9wcm90bzsKKwl3aGlsZSAoZXRoX3R5cGVf
dmxhbihwcm90b2NvbCkpIHsKKwkJY29uc3Qgc3RydWN0IHZsYW5faGRyICp2aDsKKwkJc3RydWN0
IHZsYW5faGRyIHZoZHI7CisKKwkJdmggPSBza2JfaGVhZGVyX3BvaW50ZXIoc2tiLCBkZXB0aCwg
c2l6ZW9mKHZoZHIpLCAmdmhkcik7CisJCWlmICghdmggfHwgIS0tcGFyc2VfZGVwdGgpCisJCQly
ZXR1cm4gLUVJTlZBTDsKKworCQlwcm90b2NvbCA9IHZoLT5oX3ZsYW5fZW5jYXBzdWxhdGVkX3By
b3RvOworCQlkZXB0aCArPSBWTEFOX0hMRU47CisJfQorCisJKm5ldHdvcmtfcHJvdG9jb2wgPSBw
cm90b2NvbDsKKwlyZXR1cm4gZGVwdGg7Cit9CisKIHN0YXRpYyBpbmxpbmUgaW50IF9fdmlydGlv
X25ldF9oZHJfdG9fc2tiKHN0cnVjdCBza19idWZmICpza2IsCiAJCQkJCSAgY29uc3Qgc3RydWN0
IHZpcnRpb19uZXRfaGRyICpoZHIsCi0JCQkJCSAgYm9vbCBsaXR0bGVfZW5kaWFuLCB1OCBoZHJf
Z3NvX3R5cGUpCisJCQkJCSAgYm9vbCBsaXR0bGVfZW5kaWFuLCB1OCBoZHJfZ3NvX3R5cGUsCisJ
CQkJCSAgaW50IG5ldHdvcmtfb2Zmc2V0LAorCQkJCQkgIF9fYmUxNiBuZXR3b3JrX3Byb3RvY29s
KQogewotCXVuc2lnbmVkIGludCBuaF9taW5fbGVuID0gc2l6ZW9mKHN0cnVjdCBpcGhkcik7CisJ
aW50IG5oX21pbl9sZW4gPSBzaXplb2Yoc3RydWN0IGlwaGRyKTsKIAl1bnNpZ25lZCBpbnQgZ3Nv
X3R5cGUgPSAwOwogCXVuc2lnbmVkIGludCB0aGxlbiA9IDA7CiAJdW5zaWduZWQgaW50IHBfb2Zm
ID0gMDsKIAl1bnNpZ25lZCBpbnQgaXBfcHJvdG87CiAKKwlpZiAobmV0d29ya19wcm90b2NvbCA9
PSBodG9ucyhFVEhfUF9JUFY2KSkKKwkJbmhfbWluX2xlbiA9IHNpemVvZihzdHJ1Y3QgaXB2Nmhk
cik7CisKIAlpZiAoaGRyX2dzb190eXBlICE9IFZJUlRJT19ORVRfSERSX0dTT19OT05FKSB7CiAJ
CXN3aXRjaCAoaGRyX2dzb190eXBlICYgflZJUlRJT19ORVRfSERSX0dTT19FQ04pIHsKIAkJY2Fz
ZSBWSVJUSU9fTkVUX0hEUl9HU09fVENQVjQ6CkBAIC05OCwxNiArMTQzLDIwIEBAIHN0YXRpYyBp
bmxpbmUgaW50IF9fdmlydGlvX25ldF9oZHJfdG9fc2tiKHN0cnVjdCBza19idWZmICpza2IsCiAJ
CXUzMiBzdGFydCA9IF9fdmlydGlvMTZfdG9fY3B1KGxpdHRsZV9lbmRpYW4sIGhkci0+Y3N1bV9z
dGFydCk7CiAJCXUzMiBvZmYgPSBfX3ZpcnRpbzE2X3RvX2NwdShsaXR0bGVfZW5kaWFuLCBoZHIt
PmNzdW1fb2Zmc2V0KTsKIAkJdTMyIG5lZWRlZCA9IHN0YXJ0ICsgbWF4X3QodTMyLCB0aGxlbiwg
b2ZmICsgc2l6ZW9mKF9fc3VtMTYpKTsKKwkJaW50IHRyYW5zcG9ydF9vZmZzZXQ7CiAKIAkJaWYg
KCFwc2tiX21heV9wdWxsKHNrYiwgbmVlZGVkKSkKIAkJCXJldHVybiAtRUlOVkFMOwogCiAJCWlm
ICghc2tiX3BhcnRpYWxfY3N1bV9zZXQoc2tiLCBzdGFydCwgb2ZmKSkKIAkJCXJldHVybiAtRUlO
VkFMOwotCQlpZiAoc2tiX3RyYW5zcG9ydF9vZmZzZXQoc2tiKSA8IG5oX21pbl9sZW4pCisKKwkJ
dHJhbnNwb3J0X29mZnNldCA9IHNrYl90cmFuc3BvcnRfb2Zmc2V0KHNrYik7CisJCWlmICh0cmFu
c3BvcnRfb2Zmc2V0IDwgbmhfbWluX2xlbiB8fCBuZXR3b3JrX29mZnNldCA8IDAgfHwKKwkJICAg
IG5ldHdvcmtfb2Zmc2V0ID4gdHJhbnNwb3J0X29mZnNldCAtIG5oX21pbl9sZW4pCiAJCQlyZXR1
cm4gLUVJTlZBTDsKIAotCQluaF9taW5fbGVuID0gc2tiX3RyYW5zcG9ydF9vZmZzZXQoc2tiKTsK
KwkJbmhfbWluX2xlbiA9IHRyYW5zcG9ydF9vZmZzZXQ7CiAJCXBfb2ZmID0gbmhfbWluX2xlbiAr
IHRobGVuOwogCQlpZiAoIXBza2JfbWF5X3B1bGwoc2tiLCBwX29mZikpCiAJCQlyZXR1cm4gLUVJ
TlZBTDsKQEAgLTIwNiw5ICsyNTUsMTIgQEAgc3RhdGljIGlubGluZSBpbnQgX192aXJ0aW9fbmV0
X2hkcl90b19za2Ioc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAogc3RhdGljIGlubGluZSBpbnQgdmly
dGlvX25ldF9oZHJfdG9fc2tiKHN0cnVjdCBza19idWZmICpza2IsCiAJCQkJCWNvbnN0IHN0cnVj
dCB2aXJ0aW9fbmV0X2hkciAqaGRyLAotCQkJCQlib29sIGxpdHRsZV9lbmRpYW4pCisJCQkJCWJv
b2wgbGl0dGxlX2VuZGlhbiwKKwkJCQkJaW50IG5ldHdvcmtfb2Zmc2V0LAorCQkJCQlfX2JlMTYg
bmV0d29ya19wcm90b2NvbCkKIHsKLQlyZXR1cm4gX192aXJ0aW9fbmV0X2hkcl90b19za2Ioc2ti
LCBoZHIsIGxpdHRsZV9lbmRpYW4sIGhkci0+Z3NvX3R5cGUpOworCXJldHVybiBfX3ZpcnRpb19u
ZXRfaGRyX3RvX3NrYihza2IsIGhkciwgbGl0dGxlX2VuZGlhbiwgaGRyLT5nc29fdHlwZSwKKwkJ
CQkgICAgICAgbmV0d29ya19vZmZzZXQsIG5ldHdvcmtfcHJvdG9jb2wpOwogfQogCiAvKiBUaGlz
IGZ1bmN0aW9uIG11c3QgYmUgY2FsbGVkIGFmdGVyIHZpcnRpb19uZXRfaGRyX2Zyb21fc2tiKCku
ICovCkBAIC0yODcsNyArMzM5LDcgQEAgc3RhdGljIGlubGluZSBpbnQgdmlydGlvX25ldF9oZHJf
ZnJvbV9za2IoY29uc3Qgc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAlyZXR1cm4gMDsKIH0KIAotc3Rh
dGljIGlubGluZSB1bnNpZ25lZCBpbnQgdmlydGlvX2wzbWluKGJvb2wgaXNfaXB2NikKK3N0YXRp
YyBpbmxpbmUgaW50IHZpcnRpb19sM21pbihib29sIGlzX2lwdjYpCiB7CiAJcmV0dXJuIGlzX2lw
djYgPyBzaXplb2Yoc3RydWN0IGlwdjZoZHIpIDogc2l6ZW9mKHN0cnVjdCBpcGhkcik7CiB9CkBA
IC0yOTcsMTggKzM0OSwyMCBAQCB2aXJ0aW9fbmV0X2hkcl90bmxfdG9fc2tiKHN0cnVjdCBza19i
dWZmICpza2IsCiAJCQkgIGNvbnN0IHN0cnVjdCB2aXJ0aW9fbmV0X2hkcl92MV9oYXNoX3R1bm5l
bCAqdmhkciwKIAkJCSAgYm9vbCB0bmxfaGRyX25lZ290aWF0ZWQsCiAJCQkgIGJvb2wgdG5sX2Nz
dW1fbmVnb3RpYXRlZCwKLQkJCSAgYm9vbCBsaXR0bGVfZW5kaWFuKQorCQkJICBib29sIGxpdHRs
ZV9lbmRpYW4sIGludCBuZXR3b3JrX29mZnNldCwKKwkJCSAgX19iZTE2IG5ldHdvcmtfcHJvdG9j
b2wpCiB7CiAJY29uc3Qgc3RydWN0IHZpcnRpb19uZXRfaGRyICpoZHIgPSAoY29uc3Qgc3RydWN0
IHZpcnRpb19uZXRfaGRyICopdmhkcjsKLQl1bnNpZ25lZCBpbnQgaW5uZXJfbmgsIG91dGVyX3Ro
LCBpbm5lcl90aDsKLQl1bnNpZ25lZCBpbnQgaW5uZXJfbDNtaW4sIG91dGVyX2wzbWluOwogCXU4
IGdzb19pbm5lcl90eXBlLCBnc29fdHVubmVsX3R5cGU7CiAJYm9vbCBvdXRlcl9pc3Y2LCBpbm5l
cl9pc3Y2OworCWludCBpbm5lcl9uaCwgb3V0ZXJfdGgsIGlubmVyX3RoOworCWludCBpbm5lcl9s
M21pbiwgb3V0ZXJfbDNtaW47CiAJaW50IHJldDsKIAogCWdzb190dW5uZWxfdHlwZSA9IGhkci0+
Z3NvX3R5cGUgJiBWSVJUSU9fTkVUX0hEUl9HU09fVURQX1RVTk5FTDsKIAlpZiAoIWdzb190dW5u
ZWxfdHlwZSkKLQkJcmV0dXJuIHZpcnRpb19uZXRfaGRyX3RvX3NrYihza2IsIGhkciwgbGl0dGxl
X2VuZGlhbik7CisJCXJldHVybiB2aXJ0aW9fbmV0X2hkcl90b19za2Ioc2tiLCBoZHIsIGxpdHRs
ZV9lbmRpYW4sCisJCQkJCSAgICAgbmV0d29ya19vZmZzZXQsIG5ldHdvcmtfcHJvdG9jb2wpOwog
CiAJLyogVHVubmVsIG5vdCBzdXBwb3J0ZWQvbmVnb3RpYXRlZCwgYnV0IHRoZSBoZHIgYXNrcyBm
b3IgaXQuICovCiAJaWYgKCF0bmxfaGRyX25lZ290aWF0ZWQpCkBAIC0zMzIsMTkgKzM4NiwyNCBA
QCB2aXJ0aW9fbmV0X2hkcl90bmxfdG9fc2tiKHN0cnVjdCBza19idWZmICpza2IsCiAJb3V0ZXJf
aXN2NiA9IGdzb190dW5uZWxfdHlwZSAmIFZJUlRJT19ORVRfSERSX0dTT19VRFBfVFVOTkVMX0lQ
VjY7CiAJaW5uZXJfaXN2NiA9IGdzb19pbm5lcl90eXBlID09IFZJUlRJT19ORVRfSERSX0dTT19U
Q1BWNjsKIAlpbm5lcl9sM21pbiA9IHZpcnRpb19sM21pbihpbm5lcl9pc3Y2KTsKLQlvdXRlcl9s
M21pbiA9IEVUSF9ITEVOICsgdmlydGlvX2wzbWluKG91dGVyX2lzdjYpOworCW91dGVyX2wzbWlu
ID0gdmlydGlvX2wzbWluKG91dGVyX2lzdjYpOworCWlmIChuZXR3b3JrX3Byb3RvY29sID09IGh0
b25zKEVUSF9QX0lQVjYpKQorCQlvdXRlcl9sM21pbiA9IHNpemVvZihzdHJ1Y3QgaXB2Nmhkcik7
CiAKIAlpbm5lcl90aCA9IF9fdmlydGlvMTZfdG9fY3B1KGxpdHRsZV9lbmRpYW4sIGhkci0+Y3N1
bV9zdGFydCk7CiAJaW5uZXJfbmggPSBsZTE2X3RvX2NwdSh2aGRyLT5pbm5lcl9uaF9vZmZzZXQp
OwogCW91dGVyX3RoID0gbGUxNl90b19jcHUodmhkci0+b3V0ZXJfdGhfb2Zmc2V0KTsKLQlpZiAo
b3V0ZXJfdGggPCBvdXRlcl9sM21pbiB8fAorCWlmIChuZXR3b3JrX29mZnNldCA8IDAgfHwKKwkg
ICAgb3V0ZXJfdGggPCBvdXRlcl9sM21pbiB8fAorCSAgICBuZXR3b3JrX29mZnNldCA+IG91dGVy
X3RoIC0gb3V0ZXJfbDNtaW4gfHwKIAkgICAgaW5uZXJfbmggPCBvdXRlcl90aCArIHNpemVvZihz
dHJ1Y3QgdWRwaGRyKSB8fAogCSAgICBpbm5lcl90aCA8IGlubmVyX25oICsgaW5uZXJfbDNtaW4p
CiAJCXJldHVybiAtRUlOVkFMOwogCiAJLyogTGV0IHRoZSBiYXNpYyBwYXJzaW5nIGRlYWwgd2l0
aCBwbGFpbiBHU08gZmVhdHVyZXMuICovCiAJcmV0ID0gX192aXJ0aW9fbmV0X2hkcl90b19za2Io
c2tiLCBoZHIsIHRydWUsCi0JCQkJICAgICAgaGRyLT5nc29fdHlwZSAmIH5nc29fdHVubmVsX3R5
cGUpOworCQkJCSAgICAgIGhkci0+Z3NvX3R5cGUgJiB+Z3NvX3R1bm5lbF90eXBlLAorCQkJCSAg
ICAgIG5ldHdvcmtfb2Zmc2V0LCBuZXR3b3JrX3Byb3RvY29sKTsKIAlpZiAocmV0KQogCQlyZXR1
cm4gcmV0OwogCmRpZmYgLS1naXQgYS9uZXQvcGFja2V0L2FmX3BhY2tldC5jIGIvbmV0L3BhY2tl
dC9hZl9wYWNrZXQuYwppbmRleCA1MGNhZTMyYWUuLjBiMzdkNTQ3NCAxMDA2NDQKLS0tIGEvbmV0
L3BhY2tldC9hZl9wYWNrZXQuYworKysgYi9uZXQvcGFja2V0L2FmX3BhY2tldC5jCkBAIC0yNTUw
LDYgKzI1NTAsMjYgQEAgc3RhdGljIHZvaWQgdHBhY2tldF9kZXN0cnVjdF9za2Ioc3RydWN0IHNr
X2J1ZmYgKnNrYikKIAlzb2NrX3dmcmVlKHNrYik7CiB9CiAKK3N0YXRpYyBpbnQgcGFja2V0X3Zu
ZXRfaGRyX3RvX3NrYihzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAorCQkJCSAgY29uc3Qgc3RydWN0IHZp
cnRpb19uZXRfaGRyICp2bmV0X2hkcikKK3sKKwlfX2JlMTYgbmV0d29ya19wcm90b2NvbCA9IDA7
CisJaW50IG5ldHdvcmtfb2Zmc2V0OworCisJaWYgKHNrYi0+ZGV2LT50eXBlID09IEFSUEhSRF9F
VEhFUikgeworCQluZXR3b3JrX29mZnNldCA9IHZpcnRpb19uZXRfaGRyX2V0aF9nZXRfbDNfb2Zm
c2V0KHNrYiwgdm5ldF9oZHIsCisJCQkJCQkJCSAgJm5ldHdvcmtfcHJvdG9jb2wpOworCX0gZWxz
ZSB7CisJCW5ldHdvcmtfb2Zmc2V0ID0gc2tiX25ldHdvcmtfb2Zmc2V0KHNrYik7CisJCW5ldHdv
cmtfcHJvdG9jb2wgPSBza2ItPnByb3RvY29sOworCX0KKwlpZiAobmV0d29ya19vZmZzZXQgPCAw
KQorCQlyZXR1cm4gbmV0d29ya19vZmZzZXQ7CisKKwlyZXR1cm4gdmlydGlvX25ldF9oZHJfdG9f
c2tiKHNrYiwgdm5ldF9oZHIsIHZpb19sZSgpLAorCQkJCSAgICAgbmV0d29ya19vZmZzZXQsIG5l
dHdvcmtfcHJvdG9jb2wpOworfQorCiBzdGF0aWMgaW50IF9fcGFja2V0X3NuZF92bmV0X3BhcnNl
KHN0cnVjdCB2aXJ0aW9fbmV0X2hkciAqdm5ldF9oZHIsIHNpemVfdCBsZW4pCiB7CiAJaWYgKCh2
bmV0X2hkci0+ZmxhZ3MgJiBWSVJUSU9fTkVUX0hEUl9GX05FRURTX0NTVU0pICYmCkBAIC0yOTAx
LDcgKzI5MjEsNyBAQCBzdGF0aWMgaW50IHRwYWNrZXRfc25kKHN0cnVjdCBwYWNrZXRfc29jayAq
cG8sIHN0cnVjdCBtc2doZHIgKm1zZykKIAkJfQogCiAJCWlmIChoYXNfdm5ldF9oZHIpIHsKLQkJ
CWlmICh2aXJ0aW9fbmV0X2hkcl90b19za2Ioc2tiLCAmdm5ldF9oZHIsIHZpb19sZSgpKSkgewor
CQkJaWYgKHBhY2tldF92bmV0X2hkcl90b19za2Ioc2tiLCAmdm5ldF9oZHIpKSB7CiAJCQkJdHBf
bGVuID0gLUVJTlZBTDsKIAkJCQlnb3RvIHRwYWNrZXRfZXJyb3I7CiAJCQl9CkBAIC0zMTAzLDcg
KzMxMjMsNyBAQCBzdGF0aWMgaW50IHBhY2tldF9zbmQoc3RydWN0IHNvY2tldCAqc29jaywgc3Ry
dWN0IG1zZ2hkciAqbXNnLCBzaXplX3QgbGVuKQogCXBhY2tldF9wYXJzZV9oZWFkZXJzKHNrYiwg
c29jayk7CiAKIAlpZiAodm5ldF9oZHJfc3opIHsKLQkJZXJyID0gdmlydGlvX25ldF9oZHJfdG9f
c2tiKHNrYiwgJnZuZXRfaGRyLCB2aW9fbGUoKSk7CisJCWVyciA9IHBhY2tldF92bmV0X2hkcl90
b19za2Ioc2tiLCAmdm5ldF9oZHIpOwogCQlpZiAoZXJyKQogCQkJZ290byBvdXRfZnJlZTsKIAkJ
bGVuICs9IHZuZXRfaGRyX3N6OwoKYmFzZS1jb21taXQ6IDFlMjRjNGYyZWU0NGJlMGVlZTk0MDky
YjVkMTNjYmRiNGJkZjBkNjAKLS0gCjIuNDYuMAoK
--0000000000005824ff065c07d212--
