Received: from mail-yx2-f40.google.com (mail-yx2-f40.google.com [74.125.224.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538A5377ECC
	for <netfilter-devel@vger.kernel.org>; Sat,  3 Oct 2026 19:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791054647; cv=none; b=aVn18/svLFuDZQ8BEPaAlWxeXGHAapOQ9dzBb1LYQr3O6vOe5u0ZXwtP6gLABodMxICo6/HVHZ1Y7OlxIL8xuN+ImIqUK8xzn7UkIGPE6fFXXShZ0iK8VRctU1ERMLKG5m/ZLMJLA1m0Dakfc2A78A6WX3lJEPHkNFcvyE947qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791054647; c=relaxed/simple;
	bh=tl3Ivhth+yIArsY3F83nPCU+sVkDcaCpLXOLr56Yoso=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=LEogzNXcqMJISbn6bt/4ZynmbTkLkrenc2p/hYbUFVDOqItZK3iRS/KbFfRw6l3SDApM0kxJyPJL/6QWPsEpgdDpdRYSvgm9crfndo59yoes9+Ftvbd3ryCFn3cVuExeZ7o/YD9pAxpV/G8uH/o3zRhT2TqDACAT1+Ac0xA2N1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VMTGuzQ2; arc=none smtp.client-ip=74.125.224.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VMTGuzQ2"
Received: by mail-yx2-f40.google.com with SMTP id 956f58d0204a3-6756a6320f6so313633d50.2
        for <netfilter-devel@vger.kernel.org>; Sat, 03 Oct 2026 12:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791054643; x=1791659443; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :references:in-reply-to:message-id:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EbYhThltoOxQHsfuy7MYejv6tv/nxDz2ImJERWxdiI0=;
        b=VMTGuzQ26tefD2ZHtXwpf+dr4FMqml3nKipXHN9IDt9FsoPhK8TqNdey8GbRRQ4ifp
         IFAhOD88N5O2QCUDwWngTsJMsNiL9qRDFYnlm19q2Oa85YFbreoGNNoX4ClM3V4MEWNG
         UxCOuVCGexGFAl38BCKS7Hia3ZYv4Rong5exwWj/Ps7Ne/mM+mLFzplBVtIRQmOnGbvy
         /zA5GTwdhDJmsrvE0vKBZ4srhLoARYS0ASe35B6EzYKslQMs6apZTuAJouUiM/4IfTby
         2aWgEkEBAEI8h7bZAsN7DgSNtTcmLc+E7rqzpEMLpf5RiQzilsfocpWi+crhggIz5kHR
         QZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791054643; x=1791659443;
        h=content-transfer-encoding:content-type:mime-version:subject
         :references:in-reply-to:message-id:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EbYhThltoOxQHsfuy7MYejv6tv/nxDz2ImJERWxdiI0=;
        b=OBSKR2Oh4NM+pRdgh/tdSx3XZgHbhBoyZXI9bHawzWiStgCYcnVcV9ziPFMwUDMvu2
         VY0ZOgktczT2jhglkQfFJrDz3HOAguj3uNXfrYjkFnB2NzED4kYhcX3JDpnOFSn4aNqv
         LV5TYHs2gMbQ3HaSt2gDDRI4tVa/l8fqarjk+rQVWa0/bbLcV8ZQbeuBeiFW1H92RAfC
         bf4AambO+KGIMo80DPJWKD2msW1OdqLEzW3cJbDPfWrCK1EJW4vc7IOiItY2/cdQwoiv
         LXWUBNdf7ulTJcApyryVtswAsuE00MI4HZv5aEGBmSA+1KtzrbSaCyp0xujiKao8Jvyv
         rfhQ==
X-Forwarded-Encrypted: i=1; AKwUvBw/7gmWxg0gnENMFJIRcgRuzM+D96IjNTcD+bjBMGM1amAwrKX7qkbSvo4KMl0MHtfeZM0IgRelsWrgTC8Jnr0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ7JtaJLYzhb8Glgun43jMXej7EC7SZZ1PeLLLqcLPsvsIhNYcP
	K9JNT019KRaA7srmDEmiOviw5FkfYTQKjyI9Nbk5c1ziC8AqFdH104rE
X-Gm-Gg: AYBFou1X4LWacn9us4r90yzdyM0m7YCJUVmB9vffmg9GgBGDeYtY9n7t2cirLTPVVvu
	mHhJRmIP4Hal2RqW78t8ZcoRIRJwAjiQwG/gCBBzhtACP2n/IYkWJOwGmzA5J1M7Oku5H1A/Eh2
	5i8DVoxyKfRCW8ekqo7AwQXs2EwbzxDG2AN0v85B63k1/lrQ7KHcaI7vlfhF6PZxjrtqqcLGVnM
	2PoxtcGAY2+aNIqvpglAkfYlhmo3E40jYUfsYRi0XqU2mFkKmqcQzPCBAPxWlr0W6A9BXy5zjFz
	owfNliQECIUZ98u4bSf4fOftxXomZcKv9Az7L0ugYNnRQYxd1Ha0IpsL6jthVyVzqlArmygLxEt
	UakJVcJUixkmC8fNajOOclYSHGYCNEDjlWtVMjNgp81Wu109VWofMvJulK2blK1pq1D6a8G0lyh
	y9WuVEFtj6mumDxnGMuqAEEevQpSuwGE80cazfuObseIrnTcj2PTFUPDcvJ78VLJ7kt4d8OYoWZ
	YwVy8+p2Dzr+8mOLFqlf/8w6QFY7ipqRCJqsnajPXG8U001+fDXfQ==
X-Received: by 2002:a05:690e:1549:10b0:671:45a4:b282 with SMTP id 956f58d0204a3-677ac16150bmr2194265d50.99.1791054643209;
        Sat, 03 Oct 2026 12:10:43 -0700 (PDT)
Received: from gmail.com (111.46.245.35.bc.googleusercontent.com. [35.245.46.111])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-677c1b1b585sm1033871d50.5.2026.10.03.12.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 12:10:41 -0700 (PDT)
Date: Sat, 03 Oct 2026 15:10:41 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, 
 Paulos Yibelo <habte.yibelo@gmail.com>, 
 netdev@vger.kernel.org, 
 richard@nod.at, 
 anton.ivanov@cambridgegreys.com, 
 johannes@sipsolutions.net, 
 jasowangio@gmail.com, 
 eperezma@redhat.com, 
 xuanzhuo@linux.alibaba.com, 
 andrew+netdev@lunn.ch, 
 pablo@netfilter.org, 
 fw@strlen.de, 
 phil@nwl.cc, 
 razor@blackwall.org, 
 idosch@nvidia.com, 
 dsahern@kernel.org, 
 davem@davemloft.net, 
 kuba@kernel.org, 
 pabeni@redhat.com, 
 horms@kernel.org, 
 linux-um@lists.infradead.org, 
 virtualization@lists.linux.dev, 
 netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, 
 bridge@lists.linux.dev, 
 linux-kernel@vger.kernel.org
Message-ID: <willemdebruijn.kernel.14c03b9f51802@gmail.com>
In-Reply-To: <20261003135120-mutt-send-email-mst@kernel.org>
References: <20260922030310.8684-1-habte.yibelo@gmail.com>
 <20260922030310.8684-2-habte.yibelo@gmail.com>
 <willemdebruijn.kernel.259bc7096258d@gmail.com>
 <willemdebruijn.kernel.2cdfef118aa1d@gmail.com>
 <20260923061215-mutt-send-email-mst@kernel.org>
 <CANn89iJaE5UarTdg6FMEp=rZ9mG3g=xrVRLyvMS5S02iE8CwGg@mail.gmail.com>
 <20260923081209-mutt-send-email-mst@kernel.org>
 <willemdebruijn.kernel.326d14cfb0ee3@gmail.com>
 <20261003135120-mutt-send-email-mst@kernel.org>
Subject: Re: [PATCH net v6 1/2] net: validate virtio checksum start after
 network header
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> On Thu, Oct 01, 2026 at 06:52:23PM -0400, Willem de Bruijn wrote:
> > Michael S. Tsirkin wrote:
> > > On Wed, Sep 23, 2026 at 12:46:42PM +0200, Eric Dumazet wrote:
> > > > On Wed, Sep 23, 2026 at 12:21=E2=80=AFPM Michael S. Tsirkin <mst@=
redhat.com> wrote:
> > > > >
> > > > > On Tue, Sep 22, 2026 at 09:27:26PM -0400, Willem de Bruijn wrot=
e:
> > > > > > Willem de Bruijn wrote:
> > > > > > > Paulos Yibelo wrote:
> > > > > > > > __virtio_net_hdr_to_skb() checks a minimum network-header=
 length for
> > > > > > > > CHECKSUM_PARTIAL packets. Its checksum start is relative =
to skb->data,
> > > > > > > > but some callers have not established skb->network_header=
 when they
> > > > > > > > convert the virtio header.
> > > > > > > >
> > > > > > > > Pass the data-relative L3 origin explicitly. Ethernet rec=
eive paths
> > > > > > > > parse the frame and nested VLAN headers without changing =
skb state.
> > > > > > > > AF_PACKET uses the frame's actual L3 origin even when the=
 socket
> > > > > > > > protocol is ETH_P_IP and the raw frame carries VLAN tags.=
 Non-Ethernet
> > > > > > > > AF_PACKET devices retain their established skb network of=
fset.
> > > > > > > >
> > > > > > > > Also pass the actual L3 protocol so IPv6 packets use the =
40-byte base
> > > > > > > > header minimum even without TCPv6 GSO. IFF_TUN obtains th=
at protocol
> > > > > > > > from the packet before skb->protocol is set. Name the Eth=
ernet parser
> > > > > > > > accordingly, use the same origin for tunnel validation, a=
nd propagate
> > > > > > > > conversion failures in UML.
> > > > > > > >
> > > > > > > > The bound remains a minimum; fragmentation paths separate=
ly validate
> > > > > > > > the parsed IPv4 or IPv6 header length before completing a=
 checksum.
> > > > > > > >
> > > > > > > > Fixes: 49d14b54a527 ("net: test for not too small csum_st=
art in virtio_net_hdr_to_skb()")
> > > > > > > > Fixes: a2fb4bc4e2a6 ("net: implement virtio helpers to ha=
ndle UDP GSO tunneling.")
> > > > > > > > Reported-by: Paulos Yibelo <habte.yibelo@gmail.com>
> > > > > > > > Link: https://lore.kernel.org/netdev/20260920004733.6473-=
2-habte.yibelo@gmail.com/
> > > > > > > > Cc: stable@vger.kernel.org
> > > > > > > > Assisted-by: LLM
> > > > > > > > Signed-off-by: Paulos Yibelo <habte.yibelo@gmail.com>
> > > > > > > > ---
> > > > > > > >  arch/um/drivers/vector_transports.c | 13 ++++-
> > > > > > > >  drivers/net/tun_vnet.h              | 52 +++++++++++++++=
+-
> > > > > > > >  drivers/net/virtio_net.c            | 10 +++-
> > > > > > > >  include/linux/virtio_net.h          | 87 +++++++++++++++=
+++++++++-----
> > > > > > > >  net/packet/af_packet.c              | 24 +++++++-
> > > > > > > >  5 files changed, 163 insertions(+), 23 deletions(-)
> > > > > > >
> > > > > > > The fix may still miss the case IPv4 packets have options.
> > > > > > >
> > > > > > > This version is a very large patch.
> > > > > > >
> > > > > > > Untested shorter first suggestion by bot, which looks plaus=
ible as a
> > > > > > > starting point for discussion.
> > > > > >
> > > > > > Cleaned up some more:
> > > > > >
> > > > > >     diff --git a/drivers/net/tun_vnet.h b/drivers/net/tun_vne=
t.h
> > > > > >     index f4c652b1fa44..c24607af2aad 100644
> > > > > >     --- a/drivers/net/tun_vnet.h
> > > > > >     +++ b/drivers/net/tun_vnet.h
> > > > > >     @@ -180,6 +180,9 @@ static inline int tun_vnet_hdr_put(in=
t sz, struct iov_iter *iter,
> > > > > >      static inline int tun_vnet_hdr_to_skb(unsigned int flags=
, struct sk_buff *skb,
> > > > > >                            const struct virtio_net_hdr *hdr)
> > > > > >      {
> > > > > >     +    if ((flags & TUN_TYPE_MASK) =3D=3D IFF_TUN)
> > > > > >     +        skb_reset_network_header(skb);
> > > > > >     +
> > > > > >          return virtio_net_hdr_to_skb(skb, hdr, tun_vnet_is_l=
ittle_endian(flags));
> > > > > >      }
> > > > > >
> > > > > >     @@ -199,6 +202,9 @@ tun_vnet_hdr_tnl_to_skb(unsigned int =
flags, netdev_features_t features,
> > > > > >                  struct sk_buff *skb,
> > > > > >                  const struct virtio_net_hdr_v1_hash_tunnel *=
hdr)
> > > > > >      {
> > > > > >     +    if ((flags & TUN_TYPE_MASK) =3D=3D IFF_TUN)
> > > > > >     +        skb_reset_network_header(skb);
> > > > > >     +
> > > > > >
> > > > > >     diff --git a/include/linux/virtio_net.h b/include/linux/v=
irtio_net.h
> > > > > >     index c381b916c1b5..02c448de0802 100644
> > > > > >     --- a/include/linux/virtio_net.h
> > > > > >     +++ b/include/linux/virtio_net.h
> > > > > >     @@ -48,6 +48,42 @@ static inline int virtio_net_hdr_set_p=
roto(struct sk_buff *skb,
> > > > > >          return 0;
> > > > > >      }
> > > > > >
> > > > > >     +static inline int virtio_net_hdr_nh_min_len(const struct=
 sk_buff *skb,
> > > > > >     +                        unsigned int nh_min_len)
> > > > > >     +{
> > > > > >     +    int thoff =3D skb_transport_offset(skb);
> > > > > >     +    __be16 proto;
> > > > > >     +    int nhoff;
> > > > > >     +
> > > > > >     +    if (skb_network_header_was_set(skb)) {
> > > > > >     +        nhoff =3D skb_network_offset(skb);
> > > > > >     +        proto =3D skb->protocol;
> > > > > >     +    } else {
> > > > > >     +        if (unlikely(thoff < ETH_HLEN))
> > > > > >     +            return -EINVAL;
> > > > > >     +        nhoff =3D ETH_HLEN;
> > > > > >     +        proto =3D eth_hdr(skb)->h_proto;
> > > > > >     +    }
> > > > > >     +
> > > > > >     +    if (eth_type_vlan(proto)) {
> > > > > >     +        proto =3D __vlan_get_protocol(skb, proto, &nhoff=
);
> > > > > >     +        if (!proto)
> > > > > >     +            return -EINVAL;
> > > > > >     +    }
> > > > > >     +
> > > > > >     +    if (proto =3D=3D htons(ETH_P_IP)) {
> > > > > >     +        const struct iphdr *iph =3D (void *)(skb->data +=
 nhoff);
> > > > > >     +
> > > > > >     +        if (unlikely(thoff < nhoff + sizeof(*iph)))
> > > > > >     +            return -EINVAL;
> > > > > >     +        nh_min_len =3D max_t(u32, iph->ihl * 4, sizeof(*=
iph));
> > > > > >     +    } else if (proto =3D=3D htons(ETH_P_IPV6)) {
> > > > > >     +        nh_min_len =3D sizeof(struct ipv6hdr);
> > > > > >     +    }
> > > > > >     +
> > > > > >     +    return nhoff + nh_min_len;
> > > > > >     +}
> > > > > >     +
> > > > > >      static inline int __virtio_net_hdr_to_skb(struct sk_buff=
 *skb,
> > > > > >                            const struct virtio_net_hdr *hdr,
> > > > > >                            bool little_endian, u8 hdr_gso_typ=
e)
> > > > > >     @@ -98,13 +134,15 @@ static inline int __virtio_net_hdr_t=
o_skb(struct sk_buff *skb,
> > > > > >              u32 start =3D __virtio16_to_cpu(little_endian, h=
dr->csum_start);
> > > > > >              u32 off =3D __virtio16_to_cpu(little_endian, hdr=
->csum_offset);
> > > > > >              u32 needed =3D start + max_t(u32, thlen, off + s=
izeof(__sum16));
> > > > > >     +        int min_thoff;
> > > > > >
> > > > > >              if (!pskb_may_pull(skb, needed))
> > > > > >                  return -EINVAL;
> > > > > >
> > > > > >              if (!skb_partial_csum_set(skb, start, off))
> > > > > >                  return -EINVAL;
> > > > > >     -        if (skb_transport_offset(skb) < nh_min_len)
> > > > > >     +        min_thoff =3D virtio_net_hdr_nh_min_len(skb, nh_=
min_len);
> > > > > >     +        if (min_thoff < 0 || skb_transport_offset(skb) <=
 min_thoff)
> > > > > >                  return -EINVAL;
> > > > >
> > > > >
> > > > > Certainly looks much better. But I'd like to ask, generally:
> > > > > doesn't the net stack need to protect against weird packets?
> > > > >
> > > > =

> > > > It does, but csum_start/csum_offset are not "weird packet" materi=
al,
> > > > they are skb metadata, not bytes on the wire.
> > > > =

> > > > For essentially every skb in the kernel, this metadata is produce=
d by
> > > > the kernel itself,
> > > > from headers it has just built or just parsed, and the rest of th=
e
> > > > stack (GSO, skb_checksum_help(),
> > > > fragmentation, netfilter, and every driver doing TX csum offload)=

> > > > consumes it as an invariant.
> > > > The only producers of attacker/guest controlled CHECKSUM_PARTIAL =
metadata are
> > > > the virtio_net_hdr_to_skb() callers: af_packet, tun/tap, virtio_n=
et,
> > > > and the UML vector driver.
> > > > =

> > > > So this is not "virtio specific validation", this is input valida=
tion
> > > > at the one trust boundary
> > > > where the invariant can be violated.
> > > =

> > > =

> > > Thanks for the explanation Eric!
> > > =

> > > > =

> > > > > It seems likely that not all drivers validate headers defensive=
ly,
> > > > > and incoming packets can easily become outgoing ones.
> > > > =

> > > > Packets coming from a real NIC are CHECKSUM_UNNECESSARY,
> > > > CHECKSUM_COMPLETE or CHECKSUM_NONE.
> > > > They do not carry a remote-provided csum_start.
> > > > (Remote checksum offload is the rare exception, and there the off=
sets
> > > > are computed by the stack from headers it just parsed.)
> > > > =

> > > > Incoming packets becoming outgoing ones is precisely the problem =
here:
> > > > a virtio_net RX skb with VIRTIO_NET_HDR_F_NEEDS_CSUM becomes
> > > > an skb that can be bridged/forwarded/fragmented and then handed t=
o a real NIC.
> > > =

> > > Well:
> > > =

> > > $ git grep 'skb->csum_start\ =3D'
> > > drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:        skb->csum_s=
tart =3D (unsigned char *)th - skb->head;
> > > drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_s=
tart =3D (unsigned char *)uh - skb->head;
> > > drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_s=
tart =3D (unsigned char *)uh - skb->head;
> > > drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_s=
tart =3D (unsigned char *)tcp - skb->head;
> > > drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:        skb->csum_s=
tart =3D (unsigned char *)tcp - skb->head;
> > > drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c:         skb=
->csum_start =3D skb_transport_header(skb) - skb->head;
> > > =

> > > What did I miss?
> > > =

> > > > =

> > > > > So do we even need virtio specific validation, or is it enough =
to
> > > > > validate everything in the net stack, where we are poking at th=
e
> > > > > header anyway?
> > > > =

> > > > The core stack cannot afford it.
> > > > =

> > > > 1) Drivers program skb->csum_start / skb->csum_offset straight in=
to
> > > > the TX descriptor, and the NIC will happily write two bytes where=
ver
> > > > it was told, e.g. into the IP header of the frame we put on the w=
ire.
> > > > Auditing/adding checks in every driver is not realistic, and driv=
ers
> > > > must not pay for it.
> > > > =

> > > > 2) Catching this in the core would mean re-parsing L2/L3 in
> > > > dev_hard_start_xmit()
> > > > (or in every place that eventually looks at the transport header)=
 for
> > > > the 99.99+%
> > > > of packets that were built by the stack and are known to be consi=
stent.
> > > > That is far more expensive than one check at injection time.
> > > > =

> > > > 3) Failing at injection returns -EINVAL to the sendmsg()/writev()=
 caller,
> > > > which is the correct and testable behavior. Failing later means d=
ropping
> > > > the packet deep in the xmit path, usually with a splat: the commi=
t being fixed
> > > > here (49d14b54a527) exists exactly because such a packet reached
> > > > skb_checksum_help() from ip_do_fragment() and hit the "offset (-6=
) >=3D
> > > > skb_headlen() (14)" WARN.
> > > > =

> > > > >
> > > > > Or maybe it's more a defense in depth thing?
> > > > >
> > > > > My worries:
> > > > > - more poking at the header, more cache misses, where we really=

> > > > >   do not need that
> > > > =

> > > > I do not expect anything measurable.
> > > > =

> > > > af_packet and tun: we have just copied that header from user spac=
e, it is in L1.
> > > > virtio_net: we call eth_type_trans() right after, and GRO parses =
L3/L4
> > > > immediately.
> > > > =

> > > > The whole block is under the CHECKSUM_PARTIAL condition, where we=
 already
> > > > do pskb_may_pull() and skb_partial_csum_set(), i.e. we already to=
uch
> > > > this cache line.
> > > > Reading iph->ihl from a cache line we are about to read anyway is=
 noise.
> > > > =

> > > > > - future protocol extensions that now will require surgery in
> > > > >   virtio, instead of just being passed through to the host
> > > > =

> > > > Fair, and this is an argument about how the check is written, not=

> > > > about whether it exists.
> > > > The rule should be:
> > > > =

> > > > Only tighten the bound for the protocols we already parse (IPv4/I=
Pv6),
> > > > and keep the existing generic minimum for anything else.
> > > > =

> > > > Then an unknown ethertype simply keeps flowing, no surgery is nee=
ded.
> > > > Willem's version does that. A new protocol would only be impacted=
 if it wanted
> > > > csum_start to point inside what we consider the L3 header, and su=
ch a packet
> > > > would not survive the rest of the stack anyway.
> > > > =

> > > > So: not defense in depth, but validation at the trust boundary, w=
here
> > > > it is cheapest
> > > > and where we can still report the error to the producer.
> > =

> > Just an update that I have not forgotten about this. Just staging it
> > after Eric's related series, which simplifies the challenge, and the =
patch.
> > https://lore.kernel.org/netdev/20261001191140.2818991-1-edumazet@kern=
el.org/
> > =

> > The main complexity lies in having many callers into this path,
> > and whether you can trust
> > 1. that fields initialized (e.g., skb->dev, network_header, protocol)=

> > 2. that they can be trusted (any coming from userspace: no)
> > =

> > The list of callers and invariants on some of the state:
> > =

> > Caller                  skb->dev       network_hdr  skb->protocol skb=
->data
> > ---------------------------------------------------------------------=
------
> > virtio_net.c            ARPHRD_ETHER   ETH_HLEN     0 (unset)     Eth=
ernet
> > vector_transports.c     ARPHRD_ETHER   ETH_HLEN     0 (unset)     Eth=
ernet
> > tap.c (macvtap/ipvtap)  ARPHRD_ETHER   ETH_HLEN     eth h_proto   Eth=
ernet
> > tun.c (IFF_TAP)         ARPHRD_ETHER   ETH_HLEN     0 (unset)     Eth=
ernet
> > tun.c (IFF_TUN)         ARPHRD_NONE    0            pi.proto      Raw=
 L3
> > af_packet.c (ETHER)     ARPHRD_ETHER   14 (+vlan)   sll_protocol  Eth=
ernet
> > af_packet.c (non-ETHER) !=3D ETHER       hard_hdr_len sll_protocol  D=
ev L2+L3
> > =

> > After Eric's series skb->dev, skb->network_header, and skb->protocol =
can
> > be assumed to always be set.
> > =

> > Though skb->protocol, for instance, can still not be trusted. Nor can=

> > gso_type or even iphdr. Let alone that all three agree.
> > =

> > Goal is not to drop inconsistent packets (though I'd love to), but on=
ly
> > to protect the kernel.
> > =

> > A particularly tricky edge case is af_packet with non-ETHER protocol =
that
> > does set VIRTIO_NET_HDR_F_NEEDS_CSUM. I'm not aware of any non-IP tra=
nsports
> > that use CHECKSUM_PARTIAL. But a realistic use-case is an IP in MPLS =
packet,
> > for instance.
> =

> Just to clarify you intend to post a patch on top of that v3?

Yep, if/once that gets merged.

