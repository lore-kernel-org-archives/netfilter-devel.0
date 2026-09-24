Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8637331A43
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2026 02:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790215388; cv=none; b=YezbVDZq/M5qBPRx2Jj2hyAq5/2v/mO+yX/aHUf6Pl3tLtxZR8giwjobDow8kW4ntydXhJP/8p20qlwWU6CRR2cVHylZiCwvLzibVANJlDs3puuPz3gCgrE3OtPzIydyWHhGaFQTzq3qQazwD8Uoa3GtvCQyeduRbhrhypFatdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790215388; c=relaxed/simple;
	bh=hlX4pEWIoDa93Z0PteTeKbVBVhfAEdJD+lzJ1g8tlow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BSMuZ7Rfixx7e9+LT/j2YyG+rFrehmT8o8PYaOai0XaP59NGKJv4DppJgNinzfMxhv6PmPCTlm3pKApTlUJkmxWt0vMuJOMkpYGUlXj8z2Ypr2svpIHz7FzDgrJuV+0onBTc6d4sBcroOJtupi9t3qIlHrb4yNojMCW+HI5xAGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RnkrnOxd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MQZoOXTK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RnkrnOxd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MQZoOXTK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790215385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qHHzEr/PQ8Ota366roI4JQKjOGZB7hvFyWShQyVaC18=;
	b=RnkrnOxdk0twZH/YK+1gW+Hmbmo1hfujlTG52dIxC+2ufo9S7NIjEXyR8AmMzjunMsZN5v
	Zhs4pQsXefbfXQa+Ucr2WCISGDPsWnnZcvHb9AqBkxdyBz62swb1SSIkaIA3zv3Moaqkub
	1oWzZz9rnZyG1PwMTWccRfFZZRY3slA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-r7hvqMe2PIiRxnHQoghpgA-1; Wed, 23 Sep 2026 22:03:03 -0400
X-MC-Unique: r7hvqMe2PIiRxnHQoghpgA-1
X-Mimecast-MFC-AGG-ID: r7hvqMe2PIiRxnHQoghpgA_1790215382
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e6422198fso10106905e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 19:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790215382; x=1790820182; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qHHzEr/PQ8Ota366roI4JQKjOGZB7hvFyWShQyVaC18=;
        b=MQZoOXTKF4Ri2H3lraNLrJPxQVvF5MYJixm5aslN7cdjhQzIIPTG5VCE5Up+vDnK66
         pW9HCIgvSXMQEA87+hOOdOyH+MFc6iR9/B1kVoMEtoGI5uaoLu7kSBgAXQq/Lf3OsRct
         BObDorUOTibCDZiktKT6HodGSCFIE7QwstBZxSa5qRn1HIYTx54h0HjQXnzcEiHuOpCt
         9k4cw/V96jGm2nXlcOwvJ0MPE9sMaXd52cID2UWyxlf/4Jnk3i0805kLi35PerUyfhbr
         Za2ypP32QNOLjfaEmPRL7+5bVMjozx2F3a6cIj0qLJEe2WtzgT5NwgsNR2CH8cspaSmh
         u5jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790215382; x=1790820182;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qHHzEr/PQ8Ota366roI4JQKjOGZB7hvFyWShQyVaC18=;
        b=ijD2DAFAH8E6YPCImpJWNzviqUU30gmDdV8754yDW7WfAGKfXoRkO//9F93dVv+USK
         yiU52C2ehGdR1r370BCQud6lfdYkuVFC1KzPx1FSKeym2pqCLj/vmsFDrJ4eOifHH6ln
         JpGzlJWZVoDt00USbQwJZ6ANCO6HXXWoLZTbesI/6CrXbFam1VjmwIt+d15jzKP9j0NI
         fSPWsBq27m7CQ2/L89xB08OAR7RmHf4mYUv3C5++Jx1vAfCHNNcigCnZDvVo6PffCYX8
         0I6pGjmX2N94BFoOA15vKyUHqRzkKbiqFef1KmNprHcUqx8qReM8qzN7jhl0LnzGAsrg
         /SxA==
X-Forwarded-Encrypted: i=1; AKwUvBzlWFGxOBgAHa0UPUkiJYejcfudabDCm8qUsTsWNzQNnNmPGFPpChCRa9NPz005tpbHVAp7F1aIApX8jsBr5dU=@vger.kernel.org
X-Gm-Message-State: AFuF++kidUxx4ZVUCDNnDo4etS7ZNxcjT2eDzoU01o3NiXi9EPYGLFUQ
	IEeb9/PyLE3J3nhuIEl/ad+hePAPy+0NHO3CqDFtBbw5x+g0WUSur3RWE3x5lTwYh8Qoc1ML8gr
	zXthXprhTwZa77qbdqS5XYVKxBCV1u3SNLizl77/wXv5tbxjeAiz8uS/VpKsOEmdl0xvxfQ==
X-Gm-Gg: AYBFou3ocno8m8OaONmC5IGmyYGdGVeOFZyAv9MS2EmM+m2ndFfbEp1ph48hrieLz84
	55jovSV1MOHlvSNGkfPxUiWUs8NzMVnt9hcpdqQEglDkcIqeJdKO2glXSFmkGgJr9J2di4XMlOB
	1KDpTEjXhAq+ydTgkxAoanyaN8ohc11iULp7D/WpopS5zZJ+znp9frW9nBfaET0PuaxS1/F+XqS
	D0Ye0iZSdDrVDtalamoe0K0Yr1oiKdKZlfed5aKFj+HrojSlNHvf2LoFWUdTPGa0f7dLBskiIKc
	mubk1TowxcsIXkiQJPCV7EvoNT7WtvvU3ONNDSmFlRYwNR5W8nst6VmCLUsUIumMKvWgSBwCT70
	gplq91zaC76VM1RbE+1PkhHhyLetCtQ3asNZkfzZRuET+tWP45sCpMxQNkznSfiRYog==
X-Received: by 2002:a05:600c:a013:b0:49d:2555:1a6d with SMTP id 5b1f17b1804b1-49fe66f1ac3mr12576725e9.16.1790215381647;
        Wed, 23 Sep 2026 19:03:01 -0700 (PDT)
X-Received: by 2002:a05:600c:a013:b0:49d:2555:1a6d with SMTP id 5b1f17b1804b1-49fe66f1ac3mr12576185e9.16.1790215381049;
        Wed, 23 Sep 2026 19:03:01 -0700 (PDT)
Received: from redhat.com (2a02-ab04-0158-f000-2548-f3bd-8b42-b18f.dynamic.v6.chello.sk. [2a02:ab04:158:f000:2548:f3bd:8b42:b18f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5cbd134sm30854095e9.9.2026.09.23.19.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:03:00 -0700 (PDT)
Date: Wed, 23 Sep 2026 22:02:57 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Paulos Yibelo <habte.yibelo@gmail.com>, netdev@vger.kernel.org,
	richard@nod.at, anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net, jasowangio@gmail.com,
	eperezma@redhat.com, xuanzhuo@linux.alibaba.com,
	andrew+netdev@lunn.ch, pablo@netfilter.org, fw@strlen.de,
	phil@nwl.cc, razor@blackwall.org, idosch@nvidia.com,
	dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, linux-um@lists.infradead.org,
	virtualization@lists.linux.dev, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v6 1/2] net: validate virtio checksum start after
 network header
Message-ID: <20260923081209-mutt-send-email-mst@kernel.org>
References: <20260922030310.8684-1-habte.yibelo@gmail.com>
 <20260922030310.8684-2-habte.yibelo@gmail.com>
 <willemdebruijn.kernel.259bc7096258d@gmail.com>
 <willemdebruijn.kernel.2cdfef118aa1d@gmail.com>
 <20260923061215-mutt-send-email-mst@kernel.org>
 <CANn89iJaE5UarTdg6FMEp=rZ9mG3g=xrVRLyvMS5S02iE8CwGg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iJaE5UarTdg6FMEp=rZ9mG3g=xrVRLyvMS5S02iE8CwGg@mail.gmail.com>

On Wed, Sep 23, 2026 at 12:46:42PM +0200, Eric Dumazet wrote:
> On Wed, Sep 23, 2026 at 12:21 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Tue, Sep 22, 2026 at 09:27:26PM -0400, Willem de Bruijn wrote:
> > > Willem de Bruijn wrote:
> > > > Paulos Yibelo wrote:
> > > > > __virtio_net_hdr_to_skb() checks a minimum network-header length for
> > > > > CHECKSUM_PARTIAL packets. Its checksum start is relative to skb->data,
> > > > > but some callers have not established skb->network_header when they
> > > > > convert the virtio header.
> > > > >
> > > > > Pass the data-relative L3 origin explicitly. Ethernet receive paths
> > > > > parse the frame and nested VLAN headers without changing skb state.
> > > > > AF_PACKET uses the frame's actual L3 origin even when the socket
> > > > > protocol is ETH_P_IP and the raw frame carries VLAN tags. Non-Ethernet
> > > > > AF_PACKET devices retain their established skb network offset.
> > > > >
> > > > > Also pass the actual L3 protocol so IPv6 packets use the 40-byte base
> > > > > header minimum even without TCPv6 GSO. IFF_TUN obtains that protocol
> > > > > from the packet before skb->protocol is set. Name the Ethernet parser
> > > > > accordingly, use the same origin for tunnel validation, and propagate
> > > > > conversion failures in UML.
> > > > >
> > > > > The bound remains a minimum; fragmentation paths separately validate
> > > > > the parsed IPv4 or IPv6 header length before completing a checksum.
> > > > >
> > > > > Fixes: 49d14b54a527 ("net: test for not too small csum_start in virtio_net_hdr_to_skb()")
> > > > > Fixes: a2fb4bc4e2a6 ("net: implement virtio helpers to handle UDP GSO tunneling.")
> > > > > Reported-by: Paulos Yibelo <habte.yibelo@gmail.com>
> > > > > Link: https://lore.kernel.org/netdev/20260920004733.6473-2-habte.yibelo@gmail.com/
> > > > > Cc: stable@vger.kernel.org
> > > > > Assisted-by: LLM
> > > > > Signed-off-by: Paulos Yibelo <habte.yibelo@gmail.com>
> > > > > ---
> > > > >  arch/um/drivers/vector_transports.c | 13 ++++-
> > > > >  drivers/net/tun_vnet.h              | 52 ++++++++++++++++-
> > > > >  drivers/net/virtio_net.c            | 10 +++-
> > > > >  include/linux/virtio_net.h          | 87 ++++++++++++++++++++++++-----
> > > > >  net/packet/af_packet.c              | 24 +++++++-
> > > > >  5 files changed, 163 insertions(+), 23 deletions(-)
> > > >
> > > > The fix may still miss the case IPv4 packets have options.
> > > >
> > > > This version is a very large patch.
> > > >
> > > > Untested shorter first suggestion by bot, which looks plausible as a
> > > > starting point for discussion.
> > >
> > > Cleaned up some more:
> > >
> > >     diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
> > >     index f4c652b1fa44..c24607af2aad 100644
> > >     --- a/drivers/net/tun_vnet.h
> > >     +++ b/drivers/net/tun_vnet.h
> > >     @@ -180,6 +180,9 @@ static inline int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
> > >      static inline int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
> > >                            const struct virtio_net_hdr *hdr)
> > >      {
> > >     +    if ((flags & TUN_TYPE_MASK) == IFF_TUN)
> > >     +        skb_reset_network_header(skb);
> > >     +
> > >          return virtio_net_hdr_to_skb(skb, hdr, tun_vnet_is_little_endian(flags));
> > >      }
> > >
> > >     @@ -199,6 +202,9 @@ tun_vnet_hdr_tnl_to_skb(unsigned int flags, netdev_features_t features,
> > >                  struct sk_buff *skb,
> > >                  const struct virtio_net_hdr_v1_hash_tunnel *hdr)
> > >      {
> > >     +    if ((flags & TUN_TYPE_MASK) == IFF_TUN)
> > >     +        skb_reset_network_header(skb);
> > >     +
> > >
> > >     diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > >     index c381b916c1b5..02c448de0802 100644
> > >     --- a/include/linux/virtio_net.h
> > >     +++ b/include/linux/virtio_net.h
> > >     @@ -48,6 +48,42 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
> > >          return 0;
> > >      }
> > >
> > >     +static inline int virtio_net_hdr_nh_min_len(const struct sk_buff *skb,
> > >     +                        unsigned int nh_min_len)
> > >     +{
> > >     +    int thoff = skb_transport_offset(skb);
> > >     +    __be16 proto;
> > >     +    int nhoff;
> > >     +
> > >     +    if (skb_network_header_was_set(skb)) {
> > >     +        nhoff = skb_network_offset(skb);
> > >     +        proto = skb->protocol;
> > >     +    } else {
> > >     +        if (unlikely(thoff < ETH_HLEN))
> > >     +            return -EINVAL;
> > >     +        nhoff = ETH_HLEN;
> > >     +        proto = eth_hdr(skb)->h_proto;
> > >     +    }
> > >     +
> > >     +    if (eth_type_vlan(proto)) {
> > >     +        proto = __vlan_get_protocol(skb, proto, &nhoff);
> > >     +        if (!proto)
> > >     +            return -EINVAL;
> > >     +    }
> > >     +
> > >     +    if (proto == htons(ETH_P_IP)) {
> > >     +        const struct iphdr *iph = (void *)(skb->data + nhoff);
> > >     +
> > >     +        if (unlikely(thoff < nhoff + sizeof(*iph)))
> > >     +            return -EINVAL;
> > >     +        nh_min_len = max_t(u32, iph->ihl * 4, sizeof(*iph));
> > >     +    } else if (proto == htons(ETH_P_IPV6)) {
> > >     +        nh_min_len = sizeof(struct ipv6hdr);
> > >     +    }
> > >     +
> > >     +    return nhoff + nh_min_len;
> > >     +}
> > >     +
> > >      static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
> > >                            const struct virtio_net_hdr *hdr,
> > >                            bool little_endian, u8 hdr_gso_type)
> > >     @@ -98,13 +134,15 @@ static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
> > >              u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
> > >              u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
> > >              u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
> > >     +        int min_thoff;
> > >
> > >              if (!pskb_may_pull(skb, needed))
> > >                  return -EINVAL;
> > >
> > >              if (!skb_partial_csum_set(skb, start, off))
> > >                  return -EINVAL;
> > >     -        if (skb_transport_offset(skb) < nh_min_len)
> > >     +        min_thoff = virtio_net_hdr_nh_min_len(skb, nh_min_len);
> > >     +        if (min_thoff < 0 || skb_transport_offset(skb) < min_thoff)
> > >                  return -EINVAL;
> >
> >
> > Certainly looks much better. But I'd like to ask, generally:
> > doesn't the net stack need to protect against weird packets?
> >
> 
> It does, but csum_start/csum_offset are not "weird packet" material,
> they are skb metadata, not bytes on the wire.
> 
> For essentially every skb in the kernel, this metadata is produced by
> the kernel itself,
> from headers it has just built or just parsed, and the rest of the
> stack (GSO, skb_checksum_help(),
> fragmentation, netfilter, and every driver doing TX csum offload)
> consumes it as an invariant.
> The only producers of attacker/guest controlled CHECKSUM_PARTIAL metadata are
> the virtio_net_hdr_to_skb() callers: af_packet, tun/tap, virtio_net,
> and the UML vector driver.
> 
> So this is not "virtio specific validation", this is input validation
> at the one trust boundary
> where the invariant can be violated.


Thanks for the explanation Eric!

> 
> > It seems likely that not all drivers validate headers defensively,
> > and incoming packets can easily become outgoing ones.
> 
> Packets coming from a real NIC are CHECKSUM_UNNECESSARY,
> CHECKSUM_COMPLETE or CHECKSUM_NONE.
> They do not carry a remote-provided csum_start.
> (Remote checksum offload is the rare exception, and there the offsets
> are computed by the stack from headers it just parsed.)
> 
> Incoming packets becoming outgoing ones is precisely the problem here:
> a virtio_net RX skb with VIRTIO_NET_HDR_F_NEEDS_CSUM becomes
> an skb that can be bridged/forwarded/fragmented and then handed to a real NIC.

Well:

$ git grep 'skb->csum_start\ ='
drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:        skb->csum_start = (unsigned char *)th - skb->head;
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)uh - skb->head;
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)uh - skb->head;
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)tcp - skb->head;
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)tcp - skb->head;
drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:         skb->csum_start = skb_transport_header(skb) - skb->head;

What did I miss?

> 
> > So do we even need virtio specific validation, or is it enough to
> > validate everything in the net stack, where we are poking at the
> > header anyway?
> 
> The core stack cannot afford it.
> 
> 1) Drivers program skb->csum_start / skb->csum_offset straight into
> the TX descriptor, and the NIC will happily write two bytes wherever
> it was told, e.g. into the IP header of the frame we put on the wire.
> Auditing/adding checks in every driver is not realistic, and drivers
> must not pay for it.
> 
> 2) Catching this in the core would mean re-parsing L2/L3 in
> dev_hard_start_xmit()
> (or in every place that eventually looks at the transport header) for
> the 99.99+%
> of packets that were built by the stack and are known to be consistent.
> That is far more expensive than one check at injection time.
> 
> 3) Failing at injection returns -EINVAL to the sendmsg()/writev() caller,
> which is the correct and testable behavior. Failing later means dropping
> the packet deep in the xmit path, usually with a splat: the commit being fixed
> here (49d14b54a527) exists exactly because such a packet reached
> skb_checksum_help() from ip_do_fragment() and hit the "offset (-6) >=
> skb_headlen() (14)" WARN.
> 
> >
> > Or maybe it's more a defense in depth thing?
> >
> > My worries:
> > - more poking at the header, more cache misses, where we really
> >   do not need that
> 
> I do not expect anything measurable.
> 
> af_packet and tun: we have just copied that header from user space, it is in L1.
> virtio_net: we call eth_type_trans() right after, and GRO parses L3/L4
> immediately.
> 
> The whole block is under the CHECKSUM_PARTIAL condition, where we already
> do pskb_may_pull() and skb_partial_csum_set(), i.e. we already touch
> this cache line.
> Reading iph->ihl from a cache line we are about to read anyway is noise.
> 
> > - future protocol extensions that now will require surgery in
> >   virtio, instead of just being passed through to the host
> 
> Fair, and this is an argument about how the check is written, not
> about whether it exists.
> The rule should be:
> 
> Only tighten the bound for the protocols we already parse (IPv4/IPv6),
> and keep the existing generic minimum for anything else.
> 
> Then an unknown ethertype simply keeps flowing, no surgery is needed.
> Willem's version does that. A new protocol would only be impacted if it wanted
> csum_start to point inside what we consider the L3 header, and such a packet
> would not survive the rest of the stack anyway.
> 
> So: not defense in depth, but validation at the trust boundary, where
> it is cheapest
> and where we can still report the error to the producer.
> 
> >
> > What do others think?
> >
> > --
> > MST
> >

