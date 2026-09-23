Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5932547F3C4
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 10:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790158892; cv=none; b=GiDHfGFUhf5Xw7oTmsIR2aZhZP6SzZc5hD64oaCIJSTtSXwVEvQDxQ1x3JQGRyc2iF6UxUbBrHzHiC1OEJM42HIDy6Xmjla0qWNZF5ndoJbLLt+SFBS5UrZ/HqeFogokZwHJ99KZBYNxlTjJtmqdTbXtILYhVqY34KG7Pe6aSgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790158892; c=relaxed/simple;
	bh=4qjSqIjJRSLWY8kT8aUZHOXLRBvJpPrV+p/O0kGjplU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kL3Cy4YOExn310v8/fV8N9QlYhIh2jR1rlpf2o+18YknIOx+S/nu9lGgwrympmtLihFgc2pAOU+qDs+FBjQviHfge1XTDkO/dg1LcDTHpP1yARhV8KcPpwQikjW2s1+wYMRm9OLpf0gdr3rO4iQy5i1ctYTKC7+F+aWQzCytnR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Po4whxyI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AgxeiR2B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Po4whxyI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AgxeiR2B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790158877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A/yNGk5DmsVVa7FPt1z8YmmINF36yskI05CuGhzTjCI=;
	b=Po4whxyIPwX+uXFs8GVs8XB0kys95jd6YxDPNREAUKPBMSMba11cO+p6I1KpMBVrzsQVck
	IwLeUJjltTqXtDo9RGKM7swUQjKjNhgDCGe2Z1KCBc7W3qBxytf0a+NhMYYHV9AMZs4rVK
	oVZmhRg3dvEUAoOvOy68iyII5OGd7IA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-pahrMtOBOx2ievyqtQKIjA-1; Wed, 23 Sep 2026 06:21:16 -0400
X-MC-Unique: pahrMtOBOx2ievyqtQKIjA-1
X-Mimecast-MFC-AGG-ID: pahrMtOBOx2ievyqtQKIjA_1790158875
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso5251145e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 03:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790158875; x=1790763675; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A/yNGk5DmsVVa7FPt1z8YmmINF36yskI05CuGhzTjCI=;
        b=AgxeiR2BD+8mJAlnclSpLHirysbv4xwP4VXXNk6YBp9b7LG0/m4jQxks6dALYqJ3Ef
         GR/pXQMQCq7Ckk1EBOmMoQW1QJiuYFo+QOePNX06HrxXK1JK11JLj4EUhjfwZvU8AqxJ
         kYj3hxfuQLMHC/+YlKUqMWe3jfRYBNfEHf4uRzKOWjRwI5KILuYMHKIgSSz3LBY/dxr3
         ZFCeG0TdBFJRIII0J8W9UG69FycFUAHuVQc1DSuZVLRQak1MdKS/B53gvj4pNDJ1UXcE
         d+AJ4MDHPCHL1lNs2fNSQAYzVI/fmzHlWW9cpL2PveKrU/tE/+UOwzCX1OXxXQwpsYAr
         tVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790158875; x=1790763675;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A/yNGk5DmsVVa7FPt1z8YmmINF36yskI05CuGhzTjCI=;
        b=SvjkCAOLtZRAippxsONFI22zHosACoCGYYNcQTPysa5nqgYX3TrZU0r60xqekSloEL
         kQEoeApCiwvqFS0+ssitoBzCU3EyJSRBPmHMmPbxPtyI/aF4KjmqgMXz/w5+fycnB83m
         tD8EIWnjHAtDA5ZRr7DtW3iVqumwBPmohsyUsuNgF6VC7tjhlCMJjZlxLTF1yrdjSB1u
         +Lctetix4X+3Ai7qGq0xeMsC+pLQKi/pX/XX2hhkbSIsVS4L91Yc3Q+HGBV3Bse1jTNU
         GAJCJKM536igW21API/8riBz06sTmIQNNecwfCUWH9b6FrpamQjJG1sQ+3yYh+/gET6D
         2Npw==
X-Forwarded-Encrypted: i=1; AKwUvBwXc0y0A7sYrQOYwEZp449qlPq0cpliYPouwTPZfAPU1UTbxLZy69mSBCS3G2Noe66+rMvG4gpgZGBuIGwuetE=@vger.kernel.org
X-Gm-Message-State: AFuF++mMNwiEu9NiK3B6ao3WwYGYr32t9PySZ+5jxoSRiE1lS8PtnDGB
	9nIaLqAG0tQBsMrtmm226P/krxN4OvJtMbmZR8hsROWaGxl0xU7DWa9nVFIkqIoHCTsr8ZGpt0g
	ue/pjZvP2o79Ti4YbB8fsJ4i7n8iFjFaP1IEoByiqlFubehhJBVd7XbsGrovWr0Df5Bf5mw==
X-Gm-Gg: AYBFou2CELoiVu4JjPf6QpjyyA9JWdn767VcTg6pOTPq/rB9PySLTswDQzNvNIGewD6
	9KwWgEH9waeiFh7kfC674jZLzndlKsFfNZb2cB5q0W3RjganuUWa11K6tow4q7rkD93AnefzCsS
	eptFkHZeKIKY8qhoA4M6rkef46IevgsTsK46XCQU7J1PAysoPDl6yJ3gXFeYpHRnkP3I2ox9rlh
	oag7x0JhFGR3n/OekL6PpH2u3nDZAGa+q3zRqOw7nGVhCtS/0i/Glntni7YJk8p+QdPztFBslSf
	VLBtRoMYGLFEZM0ALrCjAgbPkBVP+tsxctB5rWSwTu6hgJfavFCr64V02RfzX/R1rYHu1g==
X-Received: by 2002:a05:600c:4712:b0:49d:2536:402e with SMTP id 5b1f17b1804b1-49fdf24f928mr27542135e9.30.1790158875125;
        Wed, 23 Sep 2026 03:21:15 -0700 (PDT)
X-Received: by 2002:a05:600c:4712:b0:49d:2536:402e with SMTP id 5b1f17b1804b1-49fdf24f928mr27541455e9.30.1790158874532;
        Wed, 23 Sep 2026 03:21:14 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:3fd7:5300:3d6b:52a4:a23f:9d0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdf9691e2sm57317795e9.1.2026.09.23.03.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 03:21:13 -0700 (PDT)
Date: Wed, 23 Sep 2026 06:21:09 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Paulos Yibelo <habte.yibelo@gmail.com>, netdev@vger.kernel.org,
	richard@nod.at, anton.ivanov@cambridgegreys.com,
	johannes@sipsolutions.net, jasowangio@gmail.com,
	eperezma@redhat.com, xuanzhuo@linux.alibaba.com,
	andrew+netdev@lunn.ch, pablo@netfilter.org, fw@strlen.de,
	phil@nwl.cc, razor@blackwall.org, idosch@nvidia.com,
	dsahern@kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	linux-um@lists.infradead.org, virtualization@lists.linux.dev,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v6 1/2] net: validate virtio checksum start after
 network header
Message-ID: <20260923061215-mutt-send-email-mst@kernel.org>
References: <20260922030310.8684-1-habte.yibelo@gmail.com>
 <20260922030310.8684-2-habte.yibelo@gmail.com>
 <willemdebruijn.kernel.259bc7096258d@gmail.com>
 <willemdebruijn.kernel.2cdfef118aa1d@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <willemdebruijn.kernel.2cdfef118aa1d@gmail.com>

On Tue, Sep 22, 2026 at 09:27:26PM -0400, Willem de Bruijn wrote:
> Willem de Bruijn wrote:
> > Paulos Yibelo wrote:
> > > __virtio_net_hdr_to_skb() checks a minimum network-header length for
> > > CHECKSUM_PARTIAL packets. Its checksum start is relative to skb->data,
> > > but some callers have not established skb->network_header when they
> > > convert the virtio header.
> > > 
> > > Pass the data-relative L3 origin explicitly. Ethernet receive paths
> > > parse the frame and nested VLAN headers without changing skb state.
> > > AF_PACKET uses the frame's actual L3 origin even when the socket
> > > protocol is ETH_P_IP and the raw frame carries VLAN tags. Non-Ethernet
> > > AF_PACKET devices retain their established skb network offset.
> > > 
> > > Also pass the actual L3 protocol so IPv6 packets use the 40-byte base
> > > header minimum even without TCPv6 GSO. IFF_TUN obtains that protocol
> > > from the packet before skb->protocol is set. Name the Ethernet parser
> > > accordingly, use the same origin for tunnel validation, and propagate
> > > conversion failures in UML.
> > > 
> > > The bound remains a minimum; fragmentation paths separately validate
> > > the parsed IPv4 or IPv6 header length before completing a checksum.
> > > 
> > > Fixes: 49d14b54a527 ("net: test for not too small csum_start in virtio_net_hdr_to_skb()")
> > > Fixes: a2fb4bc4e2a6 ("net: implement virtio helpers to handle UDP GSO tunneling.")
> > > Reported-by: Paulos Yibelo <habte.yibelo@gmail.com>
> > > Link: https://lore.kernel.org/netdev/20260920004733.6473-2-habte.yibelo@gmail.com/
> > > Cc: stable@vger.kernel.org
> > > Assisted-by: LLM
> > > Signed-off-by: Paulos Yibelo <habte.yibelo@gmail.com>
> > > ---
> > >  arch/um/drivers/vector_transports.c | 13 ++++-
> > >  drivers/net/tun_vnet.h              | 52 ++++++++++++++++-
> > >  drivers/net/virtio_net.c            | 10 +++-
> > >  include/linux/virtio_net.h          | 87 ++++++++++++++++++++++++-----
> > >  net/packet/af_packet.c              | 24 +++++++-
> > >  5 files changed, 163 insertions(+), 23 deletions(-)
> > 
> > The fix may still miss the case IPv4 packets have options.
> > 
> > This version is a very large patch.
> > 
> > Untested shorter first suggestion by bot, which looks plausible as a
> > starting point for discussion.
> 
> Cleaned up some more:
> 
>     diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vnet.h
>     index f4c652b1fa44..c24607af2aad 100644
>     --- a/drivers/net/tun_vnet.h
>     +++ b/drivers/net/tun_vnet.h
>     @@ -180,6 +180,9 @@ static inline int tun_vnet_hdr_put(int sz, struct iov_iter *iter,
>      static inline int tun_vnet_hdr_to_skb(unsigned int flags, struct sk_buff *skb,
>                            const struct virtio_net_hdr *hdr)
>      {
>     +    if ((flags & TUN_TYPE_MASK) == IFF_TUN)
>     +        skb_reset_network_header(skb);
>     +
>          return virtio_net_hdr_to_skb(skb, hdr, tun_vnet_is_little_endian(flags));
>      }
>      
>     @@ -199,6 +202,9 @@ tun_vnet_hdr_tnl_to_skb(unsigned int flags, netdev_features_t features,
>                  struct sk_buff *skb,
>                  const struct virtio_net_hdr_v1_hash_tunnel *hdr)
>      {
>     +    if ((flags & TUN_TYPE_MASK) == IFF_TUN)
>     +        skb_reset_network_header(skb);
>     +
> 
>     diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
>     index c381b916c1b5..02c448de0802 100644
>     --- a/include/linux/virtio_net.h
>     +++ b/include/linux/virtio_net.h
>     @@ -48,6 +48,42 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
>          return 0;
>      }
>      
>     +static inline int virtio_net_hdr_nh_min_len(const struct sk_buff *skb,
>     +                        unsigned int nh_min_len)
>     +{
>     +    int thoff = skb_transport_offset(skb);
>     +    __be16 proto;
>     +    int nhoff;
>     +
>     +    if (skb_network_header_was_set(skb)) {
>     +        nhoff = skb_network_offset(skb);
>     +        proto = skb->protocol;
>     +    } else {
>     +        if (unlikely(thoff < ETH_HLEN))
>     +            return -EINVAL;
>     +        nhoff = ETH_HLEN;
>     +        proto = eth_hdr(skb)->h_proto;
>     +    }
>     +
>     +    if (eth_type_vlan(proto)) {
>     +        proto = __vlan_get_protocol(skb, proto, &nhoff);
>     +        if (!proto)
>     +            return -EINVAL;
>     +    }
>     +
>     +    if (proto == htons(ETH_P_IP)) {
>     +        const struct iphdr *iph = (void *)(skb->data + nhoff);
>     +
>     +        if (unlikely(thoff < nhoff + sizeof(*iph)))
>     +            return -EINVAL;
>     +        nh_min_len = max_t(u32, iph->ihl * 4, sizeof(*iph));
>     +    } else if (proto == htons(ETH_P_IPV6)) {
>     +        nh_min_len = sizeof(struct ipv6hdr);
>     +    }
>     +
>     +    return nhoff + nh_min_len;
>     +}
>     +
>      static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
>                            const struct virtio_net_hdr *hdr,
>                            bool little_endian, u8 hdr_gso_type)
>     @@ -98,13 +134,15 @@ static inline int __virtio_net_hdr_to_skb(struct sk_buff *skb,
>              u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
>              u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
>              u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
>     +        int min_thoff;
>      
>              if (!pskb_may_pull(skb, needed))
>                  return -EINVAL;
>      
>              if (!skb_partial_csum_set(skb, start, off))
>                  return -EINVAL;
>     -        if (skb_transport_offset(skb) < nh_min_len)
>     +        min_thoff = virtio_net_hdr_nh_min_len(skb, nh_min_len);
>     +        if (min_thoff < 0 || skb_transport_offset(skb) < min_thoff)
>                  return -EINVAL;


Certainly looks much better. But I'd like to ask, generally:
doesn't the net stack need to protect against weird packets?

It seems likely that not all drivers validate headers defensively,
and incoming packets can easily become outgoing ones.
So do we even need virtio specific validation, or is it enough to
validate everything in the net stack, where we are poking at the
header anyway?

Or maybe it's more a defense in depth thing?

My worries:
- more poking at the header, more cache misses, where we really
  do not need that
- future protocol extensions that now will require surgery in
  virtio, instead of just being passed through to the host

What do others think?

-- 
MST

