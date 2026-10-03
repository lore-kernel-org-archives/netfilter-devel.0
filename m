Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F624357D09
	for <netfilter-devel@vger.kernel.org>; Sat,  3 Oct 2026 17:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791049925; cv=none; b=Lp2S3j6IRe1s/12aEJRgSZmj0xlZy51L6gBaoKd7bGfcPp7r6yn0LLmjux406PSSMfgKkwCtnuM0J8JxSFSzxEmANj7J5idgVBAzE5lyLS1GdN75AWYH3RyQizIiQZVOtl/GL4inkmTWObBPZNr48bCQnnIac+zwcaO0nWGRpqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791049925; c=relaxed/simple;
	bh=LxSo0PezTfxPRDBbdn47kApUz0tB5TmD0GtbCNA8k8E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLpQB3t6mQdsltn+fX5JL4sbbLUWw0/iYOVFRo0JgfzVw4bcw1BLbSeuIO2WrWc47iEgH4pwli9vIRyAVDFtyvbvE1JOExmJbu17UxoqGXV5B/GpYeDVBDkPAHHhDomjT2qcKtczN0+wFKf3Lr9pZJTy4OG9qugbFBKDgN2hnI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bY/zMwQx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eQgxpxKd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bY/zMwQx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eQgxpxKd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791049921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oMn4AjhTWafVggkZTdmVfVzt4VksIPVCHXSPtMZ/c+I=;
	b=bY/zMwQxtvT7H8BTLkOwiP92QpJQQ1oIjLu8wAV1R6PeWFnYsGn4bnu3Hcq9XS9lzKEEpK
	RHiGmGBrHgejPYuUi1i7PJK5k2f5nxO3WX1FSpNLSjDGCE6g9rSLQiRlqkbREPrw6GglRT
	bj6cfaL9xBbWORYhBfXijbZGowjwJfc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-_0nRdZl3M0-TCHjmIyz4Ig-1; Sat, 03 Oct 2026 13:51:59 -0400
X-MC-Unique: _0nRdZl3M0-TCHjmIyz4Ig-1
X-Mimecast-MFC-AGG-ID: _0nRdZl3M0-TCHjmIyz4Ig_1791049919
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48c50ed05abso160388f8f.0
        for <netfilter-devel@vger.kernel.org>; Sat, 03 Oct 2026 10:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791049919; x=1791654719; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oMn4AjhTWafVggkZTdmVfVzt4VksIPVCHXSPtMZ/c+I=;
        b=eQgxpxKda2FCvb4to/XVQzjjZwlnA+Jw+9H1o1sTW4taHsA8tLP+psCvubegTf4wwG
         yWt3CR7GRaJ7dPC+9aPUlqmVa2Mh+X+4Gk5kjWI6/uty+3xLDbRYSxcxnVK2uPK4fYiB
         iSJTxxPLVIM2XA163SAz0KfxAT/+FnF03XEZc/irTyyxZizPXSpHHPdbpSDIaOjODn+s
         7RDazAAdvdPi+RV+ldQ47nKDz6gt4+dpVFgER20mQir8yXqSYEHXUFvpOirt+duMyiOH
         TTxOzjMJwlTf43+PcJTPCDY1w9IRNUqyfNF2UzRkfORMMRv+c1jWR+jEBC+1fLf59MEI
         xQyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791049919; x=1791654719;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oMn4AjhTWafVggkZTdmVfVzt4VksIPVCHXSPtMZ/c+I=;
        b=Rn0iaP+J46NIaRdfaG0XeU2NYU3XGhmpLUseoqvYqMHR1SXAA3nFVPTg9Ab9QhhYgO
         z0KpJFQ6/Q5Jnti5nKNvrvSpnq9iPnxkHlHecJSjKzpkOD9j5vATIunYEmjrM+okL3pW
         PnJE2EVhEpmDASzarNtS3PANO7HiOh2B6wONxCPG1AnmgenQCmNnloAL/UB/GlcRMpl+
         rEzymFKvl0cE93VjEiXCTIqAO4kVYXk4Ev/a237hssnX2fvqwedEjr5U/6hL0llLW651
         pG8ewgpxYA7wuPsbr0StpuU6HuaNLAjtl1EKJTVfNJkKOXdWx7/shcE3k4w9oIyoQ2Cz
         aiaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzQL2rkZJUDwVZ8EDqxzjnHUUiIm+4jCBMvMK+bOYQmMuMDG/36i3XPeWf+ZwkRugs1nFyk8WdNOQf4aMMpEOc=@vger.kernel.org
X-Gm-Message-State: AFuF++nirOhH7IvfY8XqRhWYlRYoOMWcfcp+dj4nNNHU3Y/0iZB/XLzG
	pM2gXmaVZbJLe6dhnWFteoOTg7/M2SJrPOUaI0lUb4O82a6ivTZOtJD4MJOQYycRtnxCobeSG+/
	DzdxsvSuwCJrnFM6Oq0JdxYN5LUFq5A2BuYfFw5vhigLOejnh5mtNNif3W9ASHsqUtY92UQ==
X-Gm-Gg: AYBFou2W2zxwYBUrhqhHyVrbZPzv0cJ9kUzSbQjQoOvAzg5C80H/Kg310EwGkROOkj3
	MInGcMLpUihINUusxrtYzuv64qSUt2UBQbdR3Z+g3nO2ZXT4CWev0wg93E/sZnX+npLULRqM0GR
	r2iAXkiR0nZiksVkyEl8tdclhO6kPDdRiAaGaCe8765lecEvseHwynog/zVOxmw3CdhBeOzuyTr
	KsAvJD4qbFmapoiUe+ceQf7QSMyBJ12ktC3ag1lCa1QT6OiJgZ+1Egi/gdn6RQoWaLeMYuYHwgI
	3URfHAJEIkqx7b4RVa0qRetGBz6JHvPi+4eIqRABvQkLQpHuJ86RzZtBIh1lQJ0/o/k8XA==
X-Received: by 2002:a05:600c:37c9:b0:4a0:159b:d2a2 with SMTP id 5b1f17b1804b1-4a1680f4309mr44881015e9.29.1791049918378;
        Sat, 03 Oct 2026 10:51:58 -0700 (PDT)
X-Received: by 2002:a05:600c:37c9:b0:4a0:159b:d2a2 with SMTP id 5b1f17b1804b1-4a1680f4309mr44880635e9.29.1791049917776;
        Sat, 03 Oct 2026 10:51:57 -0700 (PDT)
Received: from redhat.com ([2a02:586:1d05:2c0:d92a:1b52:ee3f:b73d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0280ceaf0sm206358845e9.12.2026.10.03.10.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 10:51:56 -0700 (PDT)
Date: Sat, 3 Oct 2026 13:51:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>,
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
Message-ID: <20261003135120-mutt-send-email-mst@kernel.org>
References: <20260922030310.8684-1-habte.yibelo@gmail.com>
 <20260922030310.8684-2-habte.yibelo@gmail.com>
 <willemdebruijn.kernel.259bc7096258d@gmail.com>
 <willemdebruijn.kernel.2cdfef118aa1d@gmail.com>
 <20260923061215-mutt-send-email-mst@kernel.org>
 <CANn89iJaE5UarTdg6FMEp=rZ9mG3g=xrVRLyvMS5S02iE8CwGg@mail.gmail.com>
 <20260923081209-mutt-send-email-mst@kernel.org>
 <willemdebruijn.kernel.326d14cfb0ee3@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <willemdebruijn.kernel.326d14cfb0ee3@gmail.com>

On Thu, Oct 01, 2026 at 06:52:23PM -0400, Willem de Bruijn wrote:
> Michael S. Tsirkin wrote:
> > On Wed, Sep 23, 2026 at 12:46:42PM +0200, Eric Dumazet wrote:
> > > On Wed, Sep 23, 2026 at 12:21 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Sep 22, 2026 at 09:27:26PM -0400, Willem de Bruijn wrote:
> > > > > Willem de Bruijn wrote:
> > > > > > Paulos Yibelo wrote:
> > > > > > > __virtio_net_hdr_to_skb() checks a minimum network-header length for
> > > > > > > CHECKSUM_PARTIAL packets. Its checksum start is relative to skb->data,
> > > > > > > but some callers have not established skb->network_header when they
> > > > > > > convert the virtio header.
> > > > > > >
> > > > > > > Pass the data-relative L3 origin explicitly. Ethernet receive paths
> > > > > > > parse the frame and nested VLAN headers without changing skb state.
> > > > > > > AF_PACKET uses the frame's actual L3 origin even when the socket
> > > > > > > protocol is ETH_P_IP and the raw frame carries VLAN tags. Non-Ethernet
> > > > > > > AF_PACKET devices retain their established skb network offset.
> > > > > > >
> > > > > > > Also pass the actual L3 protocol so IPv6 packets use the 40-byte base
> > > > > > > header minimum even without TCPv6 GSO. IFF_TUN obtains that protocol
> > > > > > > from the packet before skb->protocol is set. Name the Ethernet parser
> > > > > > > accordingly, use the same origin for tunnel validation, and propagate
> > > > > > > conversion failures in UML.
> > > > > > >
> > > > > > > The bound remains a minimum; fragmentation paths separately validate
> > > > > > > the parsed IPv4 or IPv6 header length before completing a checksum.
> > > > > > >
> > > > > > > Fixes: 49d14b54a527 ("net: test for not too small csum_start in virtio_net_hdr_to_skb()")
> > > > > > > Fixes: a2fb4bc4e2a6 ("net: implement virtio helpers to handle UDP GSO tunneling.")
> > > > > > > Reported-by: Paulos Yibelo <habte.yibelo@gmail.com>
> > > > > > > Link: https://lore.kernel.org/netdev/20260920004733.6473-2-habte.yibelo@gmail.com/
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > Assisted-by: LLM
> > > > > > > Signed-off-by: Paulos Yibelo <habte.yibelo@gmail.com>
> > > > > > > ---
> > > > > > >  arch/um/drivers/vector_transports.c | 13 ++++-
> > > > > > >  drivers/net/tun_vnet.h              | 52 ++++++++++++++++-
> > > > > > >  drivers/net/virtio_net.c            | 10 +++-
> > > > > > >  include/linux/virtio_net.h          | 87 ++++++++++++++++++++++++-----
> > > > > > >  net/packet/af_packet.c              | 24 +++++++-
> > > > > > >  5 files changed, 163 insertions(+), 23 deletions(-)
> > > > > >
> > > > > > The fix may still miss the case IPv4 packets have options.
> > > > > >
> > > > > > This version is a very large patch.
> > > > > >
> > > > > > Untested shorter first suggestion by bot, which looks plausible as a
> > > > > > starting point for discussion.
> > > > >
> > > > > Cleaned up some more:
> > > > >
> > > > >     diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
> > > > >     index f4c652b1fa44..c24607af2aad 100644
> > > > >     --- a/drivers/net/tun_vnet.h
> > > > >     +++ b/drivers/net/tun_vnet.h
> > > > >     @@ -180,6 +180,9 @@ static inline int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
> > > > >      static inline int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
> > > > >                            const struct virtio_net_hdr *hdr)
> > > > >      {
> > > > >     +    if ((flags & TUN_TYPE_MASK) == IFF_TUN)
> > > > >     +        skb_reset_network_header(skb);
> > > > >     +
> > > > >          return virtio_net_hdr_to_skb(skb, hdr, tun_vnet_is_little_endian(flags));
> > > > >      }
> > > > >
> > > > >     @@ -199,6 +202,9 @@ tun_vnet_hdr_tnl_to_skb(unsigned int flags, netdev_features_t features,
> > > > >                  struct sk_buff *skb,
> > > > >                  const struct virtio_net_hdr_v1_hash_tunnel *hdr)
> > > > >      {
> > > > >     +    if ((flags & TUN_TYPE_MASK) == IFF_TUN)
> > > > >     +        skb_reset_network_header(skb);
> > > > >     +
> > > > >
> > > > >     diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > > > >     index c381b916c1b5..02c448de0802 100644
> > > > >     --- a/include/linux/virtio_net.h
> > > > >     +++ b/include/linux/virtio_net.h
> > > > >     @@ -48,6 +48,42 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
> > > > >          return 0;
> > > > >      }
> > > > >
> > > > >     +static inline int virtio_net_hdr_nh_min_len(const struct sk_buff *skb,
> > > > >     +                        unsigned int nh_min_len)
> > > > >     +{
> > > > >     +    int thoff = skb_transport_offset(skb);
> > > > >     +    __be16 proto;
> > > > >     +    int nhoff;
> > > > >     +
> > > > >     +    if (skb_network_header_was_set(skb)) {
> > > > >     +        nhoff = skb_network_offset(skb);
> > > > >     +        proto = skb->protocol;
> > > > >     +    } else {
> > > > >     +        if (unlikely(thoff < ETH_HLEN))
> > > > >     +            return -EINVAL;
> > > > >     +        nhoff = ETH_HLEN;
> > > > >     +        proto = eth_hdr(skb)->h_proto;
> > > > >     +    }
> > > > >     +
> > > > >     +    if (eth_type_vlan(proto)) {
> > > > >     +        proto = __vlan_get_protocol(skb, proto, &nhoff);
> > > > >     +        if (!proto)
> > > > >     +            return -EINVAL;
> > > > >     +    }
> > > > >     +
> > > > >     +    if (proto == htons(ETH_P_IP)) {
> > > > >     +        const struct iphdr *iph = (void *)(skb->data + nhoff);
> > > > >     +
> > > > >     +        if (unlikely(thoff < nhoff + sizeof(*iph)))
> > > > >     +            return -EINVAL;
> > > > >     +        nh_min_len = max_t(u32, iph->ihl * 4, sizeof(*iph));
> > > > >     +    } else if (proto == htons(ETH_P_IPV6)) {
> > > > >     +        nh_min_len = sizeof(struct ipv6hdr);
> > > > >     +    }
> > > > >     +
> > > > >     +    return nhoff + nh_min_len;
> > > > >     +}
> > > > >     +
> > > > >      static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
> > > > >                            const struct virtio_net_hdr *hdr,
> > > > >                            bool little_endian, u8 hdr_gso_type)
> > > > >     @@ -98,13 +134,15 @@ static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
> > > > >              u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
> > > > >              u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
> > > > >              u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
> > > > >     +        int min_thoff;
> > > > >
> > > > >              if (!pskb_may_pull(skb, needed))
> > > > >                  return -EINVAL;
> > > > >
> > > > >              if (!skb_partial_csum_set(skb, start, off))
> > > > >                  return -EINVAL;
> > > > >     -        if (skb_transport_offset(skb) < nh_min_len)
> > > > >     +        min_thoff = virtio_net_hdr_nh_min_len(skb, nh_min_len);
> > > > >     +        if (min_thoff < 0 || skb_transport_offset(skb) < min_thoff)
> > > > >                  return -EINVAL;
> > > >
> > > >
> > > > Certainly looks much better. But I'd like to ask, generally:
> > > > doesn't the net stack need to protect against weird packets?
> > > >
> > > 
> > > It does, but csum_start/csum_offset are not "weird packet" material,
> > > they are skb metadata, not bytes on the wire.
> > > 
> > > For essentially every skb in the kernel, this metadata is produced by
> > > the kernel itself,
> > > from headers it has just built or just parsed, and the rest of the
> > > stack (GSO, skb_checksum_help(),
> > > fragmentation, netfilter, and every driver doing TX csum offload)
> > > consumes it as an invariant.
> > > The only producers of attacker/guest controlled CHECKSUM_PARTIAL metadata are
> > > the virtio_net_hdr_to_skb() callers: af_packet, tun/tap, virtio_net,
> > > and the UML vector driver.
> > > 
> > > So this is not "virtio specific validation", this is input validation
> > > at the one trust boundary
> > > where the invariant can be violated.
> > 
> > 
> > Thanks for the explanation Eric!
> > 
> > > 
> > > > It seems likely that not all drivers validate headers defensively,
> > > > and incoming packets can easily become outgoing ones.
> > > 
> > > Packets coming from a real NIC are CHECKSUM_UNNECESSARY,
> > > CHECKSUM_COMPLETE or CHECKSUM_NONE.
> > > They do not carry a remote-provided csum_start.
> > > (Remote checksum offload is the rare exception, and there the offsets
> > > are computed by the stack from headers it just parsed.)
> > > 
> > > Incoming packets becoming outgoing ones is precisely the problem here:
> > > a virtio_net RX skb with VIRTIO_NET_HDR_F_NEEDS_CSUM becomes
> > > an skb that can be bridged/forwarded/fragmented and then handed to a real NIC.
> > 
> > Well:
> > 
> > $ git grep 'skb->csum_start\ ='
> > drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:        skb->csum_start = (unsigned char *)th - skb->head;
> > drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)uh - skb->head;
> > drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)uh - skb->head;
> > drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)tcp - skb->head;
> > drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_start = (unsigned char *)tcp - skb->head;
> > drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:         skb->csum_start = skb_transport_header(skb) - skb->head;
> > 
> > What did I miss?
> > 
> > > 
> > > > So do we even need virtio specific validation, or is it enough to
> > > > validate everything in the net stack, where we are poking at the
> > > > header anyway?
> > > 
> > > The core stack cannot afford it.
> > > 
> > > 1) Drivers program skb->csum_start / skb->csum_offset straight into
> > > the TX descriptor, and the NIC will happily write two bytes wherever
> > > it was told, e.g. into the IP header of the frame we put on the wire.
> > > Auditing/adding checks in every driver is not realistic, and drivers
> > > must not pay for it.
> > > 
> > > 2) Catching this in the core would mean re-parsing L2/L3 in
> > > dev_hard_start_xmit()
> > > (or in every place that eventually looks at the transport header) for
> > > the 99.99+%
> > > of packets that were built by the stack and are known to be consistent.
> > > That is far more expensive than one check at injection time.
> > > 
> > > 3) Failing at injection returns -EINVAL to the sendmsg()/writev() caller,
> > > which is the correct and testable behavior. Failing later means dropping
> > > the packet deep in the xmit path, usually with a splat: the commit being fixed
> > > here (49d14b54a527) exists exactly because such a packet reached
> > > skb_checksum_help() from ip_do_fragment() and hit the "offset (-6) >=
> > > skb_headlen() (14)" WARN.
> > > 
> > > >
> > > > Or maybe it's more a defense in depth thing?
> > > >
> > > > My worries:
> > > > - more poking at the header, more cache misses, where we really
> > > >   do not need that
> > > 
> > > I do not expect anything measurable.
> > > 
> > > af_packet and tun: we have just copied that header from user space, it is in L1.
> > > virtio_net: we call eth_type_trans() right after, and GRO parses L3/L4
> > > immediately.
> > > 
> > > The whole block is under the CHECKSUM_PARTIAL condition, where we already
> > > do pskb_may_pull() and skb_partial_csum_set(), i.e. we already touch
> > > this cache line.
> > > Reading iph->ihl from a cache line we are about to read anyway is noise.
> > > 
> > > > - future protocol extensions that now will require surgery in
> > > >   virtio, instead of just being passed through to the host
> > > 
> > > Fair, and this is an argument about how the check is written, not
> > > about whether it exists.
> > > The rule should be:
> > > 
> > > Only tighten the bound for the protocols we already parse (IPv4/IPv6),
> > > and keep the existing generic minimum for anything else.
> > > 
> > > Then an unknown ethertype simply keeps flowing, no surgery is needed.
> > > Willem's version does that. A new protocol would only be impacted if it wanted
> > > csum_start to point inside what we consider the L3 header, and such a packet
> > > would not survive the rest of the stack anyway.
> > > 
> > > So: not defense in depth, but validation at the trust boundary, where
> > > it is cheapest
> > > and where we can still report the error to the producer.
> 
> Just an update that I have not forgotten about this. Just staging it
> after Eric's related series, which simplifies the challenge, and the patch.
> https://lore.kernel.org/netdev/20261001191140.2818991-1-edumazet@kernel.org/
> 
> The main complexity lies in having many callers into this path,
> and whether you can trust
> 1. that fields initialized (e.g., skb->dev, network_header, protocol)
> 2. that they can be trusted (any coming from userspace: no)
> 
> The list of callers and invariants on some of the state:
> 
> Caller                  skb->dev       network_hdr  skb->protocol skb->data
> ---------------------------------------------------------------------------
> virtio_net.c            ARPHRD_ETHER   ETH_HLEN     0 (unset)     Ethernet
> vector_transports.c     ARPHRD_ETHER   ETH_HLEN     0 (unset)     Ethernet
> tap.c (macvtap/ipvtap)  ARPHRD_ETHER   ETH_HLEN     eth h_proto   Ethernet
> tun.c (IFF_TAP)         ARPHRD_ETHER   ETH_HLEN     0 (unset)     Ethernet
> tun.c (IFF_TUN)         ARPHRD_NONE    0            pi.proto      Raw L3
> af_packet.c (ETHER)     ARPHRD_ETHER   14 (+vlan)   sll_protocol  Ethernet
> af_packet.c (non-ETHER) != ETHER       hard_hdr_len sll_protocol  Dev L2+L3
> 
> After Eric's series skb->dev, skb->network_header, and skb->protocol can
> be assumed to always be set.
> 
> Though skb->protocol, for instance, can still not be trusted. Nor can
> gso_type or even iphdr. Let alone that all three agree.
> 
> Goal is not to drop inconsistent packets (though I'd love to), but only
> to protect the kernel.
> 
> A particularly tricky edge case is af_packet with non-ETHER protocol that
> does set VIRTIO_NET_HDR_F_NEEDS_CSUM. I'm not aware of any non-IP transports
> that use CHECKSUM_PARTIAL. But a realistic use-case is an IP in MPLS packet,
> for instance.

Just to clarify you intend to post a patch on top of that v3?

-- 
MST

