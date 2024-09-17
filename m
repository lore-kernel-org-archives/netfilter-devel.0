Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C203399F
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2024 22:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726610530; cv=none; b=GP3e6ChS7oj4G9ejVGWPpb9I2OimfTfIf0E7RRw3GIEdmM+6KnJQd6pF4eRft6rnR9o6Z3/Xeyv844caWQF7/SPAJdzNfZNMTT/UpYn9N7BPyxxoccjJPagolHwlxzJNhPTewDpVYyOmMTpSR5g9xSY7Imlfq8U/xf118KUuCME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726610530; c=relaxed/simple;
	bh=YbOp+h2QaUdcsOi5EC9p8oj1cP7SHab1Wn+iQmwouuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ppae/EKpgQFvlR4VDQOKdUAB9IStjo+giSxbcFn/fWO5hoQmrDW7roVfYQR8b8M4lz0xdXK3R/wnXfNS+J8r9cQA5yTE5zWkVRj8rD54YMwfpHptkQdxOYSa8rgT+CejvD8ZP3swCkmRvkFNh870/p1JE65LJ1mC0Z118XNVynk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VSLdRNGD; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VSLdRNGD"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-82ce1cd202cso329380539f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2024 15:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726610528; x=1727215328; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/Y+CT7LjlVgPz+Msx8znPX3sb0XzEROhD6WTay/Nd9A=;
        b=VSLdRNGDSUTZaj9JyMp7jOGDbO2wGtj+Eg3nZi3KU/q+0v+fmGImTJcjyxA8iCD9ls
         Lsx8PD8+bFvSyv3iPe27t4bhb+0EFgfSXdZw7TwgzS/uIfzhLHrHTkjmh4NnxPp2J07k
         QtBTzOaIK5NZ+vcvi4tDNR2rywsMdUt9DfD1OVRRguQTXH6fzdfBq8VbjsN98W675QiR
         BTF5RlU7xKa9AALEEdfZo62OgmvxcFH1NEYe81XeKdp0TZibLFp3samt3GFkR7BbvuXs
         DROBt3hfQXhMW9RLwv664SHEZMHqwe/ze7tbmIH8lLoV1dwI9aP7hF5mXb2Pk3LSVxzB
         fpsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726610528; x=1727215328;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/Y+CT7LjlVgPz+Msx8znPX3sb0XzEROhD6WTay/Nd9A=;
        b=CKp7JPTD9AAJQGzLFppvkhTNmH26mT8EiYiNKVYOjI1PuSr2c8UneeFd4XKZhn4cmx
         hQTZ+1k8c5XXcATVpomB1CuOOgB19yz8YF/b3dHUGu5Z0AzVpp8NEwb6RdiX3Gjw56Qr
         3S2/im9SR/4n19q/yXxaonMSi2Odqvdqwq/XJ+cIxfxXo3yOnKeIIuXbD/dtLw2oNQue
         Ba86HqdkgezJlTTQfgUtMjTtlEZspON1Beqqn3N4y/Ehc1bAwv9ThsbTh0LDAo4mU2VP
         7xJuyEAVNkcnfz1kz6ZykG8lqZfx4J069BzrwLfoDDGlddP7pyS418XX+39QFZstE1VW
         QtQw==
X-Gm-Message-State: AOJu0YxKvwHZwkr+Dh0S3rDa6zN7hz9mFGcOia5s+H0OdL1lLSvTRCvr
	SML0CfyYem5aA8B5qkeaUro2F04kO6FxOl+nLdw9MJQE5rqEqInXDky7nWKv8IwGUhWA5/Ry3EV
	R6Pu/oc+mtpYu9AsHm/AK8BSd23tfGZialfA=
X-Google-Smtp-Source: AGHT+IEKZyy6kf8m9NgYXvbzYBw0ehinx68fw97SX6Be83Z68fo5W7ax25IxxFcYrMOuTjODXiZPWf5GBQroesc9SFI=
X-Received: by 2002:a05:6e02:1a24:b0:39a:eb57:dc7 with SMTP id
 e9e14a558f8ab-3a0848b02aemr205634725ab.1.1726610527714; Tue, 17 Sep 2024
 15:02:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912185832.11962-1-pablo@netfilter.org> <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
In-Reply-To: <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Tue, 17 Sep 2024 23:01:31 +0100
Message-ID: <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected packets
 from postrouting
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Sept 2024 at 07:24, Antonio Ojea
<antonio.ojea.garcia@gmail.com> wrote:
>
> On Thu, 12 Sept 2024 at 20:58, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > 368982cd7d1b ("netfilter: nfnetlink_queue: resolve clash for unconfirmed
> > conntracks") adjusts NAT again in case that packet loses race to confirm
> > the conntrack entry.
> >
> > The reinject path triggers a route lookup again for the output hook, but
> > not for the postrouting hook where queue to userspace is also possible.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Reported-by: Antonio Ojea <antonio.ojea.garcia@gmail.com>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > I tried but I am not managing to make a selftest that runs reliable.
> > I can reproduce it manually and validate that this works.
> >
> > ./nft_queue -d 1000 helps by introducing a delay of 1000ms in the
> > userspace queue processing which helps trigger the race more easily,
> > socat needs to send several packets in the same UDP flow.
> >
> > @Antonio: Could you try this patch meanwhile there is a testcase for
> > this.
>
> Let me test it and report back
>

Ok, I finally managed to get this tested, and it does not seem to
solve the problem, it keeps dnating twice after the packet is enqueued
by nfqueue

See trace obtained with pwru, origin 10.244.0.3, virtual IP of DNS
server 10.96.0.10 that DNATs to 10.244.0.2 and 10.244.0.4

21:44:13.066 0xffff97ff83662280 0   <empty>:3552     2007043994686
10.244.0.3:39492->10.96.0.10:53(udp) nf_checksum
21:44:13.066 0xffff97ff83662280 0   <empty>:3552     2007043995059
10.244.0.3:39492->10.96.0.10:53(udp) nf_ip_checksum
21:44:13.066 0xffff97ff83662280 0   <empty>:3552     2007043995538
10.244.0.3:39492->10.96.0.10:53(udp) nf_nat_ipv4_pre_routing
21:44:13.066 0xffff97ff83662280 0   <empty>:3552     2007043995957
10.244.0.3:39492->10.96.0.10:53(udp) nf_nat_inet_fn
21:44:13.066 0xffff97ff83662280 0   <empty>:3552     2007043996439
10.244.0.3:39492->10.96.0.10:53(udp) nft_nat_do_chain
21:44:13.067 0xffff97ff83662280 0   <empty>:3552     2007043999827
10.244.0.3:39492->10.96.0.10:53(udp) xt_dnat_target_v2
21:44:13.067 0xffff97ff83662280 0   <empty>:3552     2007044000721
10.244.0.3:39492->10.96.0.10:53(udp) nf_nat_manip_pkt
21:44:13.067 0xffff97ff83662280 0   <empty>:3552     2007044023444
10.244.0.3:39492->10.96.0.10:53(udp) nf_nat_ipv4_manip_pkt
21:44:13.067 0xffff97ff83662280 0   <empty>:3552     2007044024162
10.244.0.3:39492->10.96.0.10:53(udp) skb_ensure_writable
21:44:13.068 0xffff97ff83662280 0   <empty>:3552     2007044024819
10.244.0.3:39492->10.96.0.10:53(udp) l4proto_manip_pkt
21:44:13.068 0xffff97ff83662280 0   <empty>:3552     2007044025158
10.244.0.3:39492->10.96.0.10:53(udp) skb_ensure_writable
21:44:13.068 0xffff97ff83662280 0   <empty>:3552     2007044025711
10.244.0.3:39492->10.96.0.10:53(udp) nf_csum_update
21:44:13.068 0xffff97ff83662280 0   <empty>:3552     2007044026381
10.244.0.3:39492->10.96.0.10:53(udp) inet_proto_csum_replace4
21:44:13.068 0xffff97ff83662280 0   <empty>:3552     2007044026730
10.244.0.3:39492->10.96.0.10:53(udp) inet_proto_csum_replace4
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044027433
10.244.0.3:39492->10.244.0.2:53(udp) ip_rcv_finish
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044028188
10.244.0.3:39492->10.244.0.2:53(udp) udp_v4_early_demux
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044029235
10.244.0.3:39492->10.244.0.2:53(udp) ip_route_input_noref
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044029696
10.244.0.3:39492->10.244.0.2:53(udp) ip_route_input_slow
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044030986
10.244.0.3:39492->10.244.0.2:53(udp) fib_validate_source
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044031571
10.244.0.3:39492->10.244.0.2:53(udp) __fib_validate_source
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044032576
10.244.0.3:39492->10.244.0.2:53(udp) ip_forward
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044033236
10.244.0.3:39492->10.244.0.2:53(udp) nf_hook_slow
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044034004
10.244.0.3:39492->10.244.0.2:53(udp) selinux_ip_forward
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044034601
10.244.0.3:39492->10.244.0.2:53(udp) nft_do_chain_ipv4
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044037452
10.244.0.3:39492->10.244.0.2:53(udp) ip_output
21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044037796
10.244.0.3:39492->10.244.0.2:53(udp) nf_hook_slow
21:44:13.070 0xffff97ff83662280 0   <empty>:3552     2007044038241
10.244.0.3:39492->10.244.0.2:53(udp) nft_do_chain_inet
21:44:13.070 0xffff97ff83662280 0   <empty>:3552     2007044040343
10.244.0.3:39492->10.244.0.2:53(udp) nf_queue
--- snipped other skbs ---
21:44:13.149 0xffff97ff83662280 0   <empty>:1463     2007052515236
10.244.0.3:39492->10.244.0.2:53(udp) nf_conntrack_update
21:44:13.149 0xffff97ff83662280 0   <empty>:1463     2007052538616
10.244.0.3:39492->10.244.0.2:53(udp) nf_nat_manip_pkt
21:44:13.149 0xffff97ff83662280 0   <empty>:1463     2007052539511
10.244.0.3:39492->10.244.0.2:53(udp) nf_nat_ipv4_manip_pkt
21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052540123
10.244.0.3:39492->10.244.0.2:53(udp) skb_ensure_writable
21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052540589
10.244.0.3:39492->10.244.0.2:53(udp) l4proto_manip_pkt
21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052540875
10.244.0.3:39492->10.244.0.2:53(udp) skb_ensure_writable
21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052541326
10.244.0.3:39492->10.244.0.2:53(udp) nf_csum_update
21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052541944
10.244.0.3:39492->10.244.0.2:53(udp) inet_proto_csum_replace4
21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052542259
10.244.0.3:39492->10.244.0.2:53(udp) inet_proto_csum_replace4  <<<<
DNATed twice
21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052543321
10.244.0.3:39492->10.244.0.4:53(udp) ip_route_me_harder
21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052545374
10.244.0.3:39492->10.244.0.4:53(udp) __xfrm_decode_session
21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052546324
10.244.0.3:39492->10.244.0.4:53(udp) nf_nat_ipv4_out
21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052546676
10.244.0.3:39492->10.244.0.4:53(udp) nf_nat_inet_fn
21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052547186
10.244.0.3:39492->10.244.0.4:53(udp) selinux_ip_postroute
21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052547732
10.244.0.3:39492->10.244.0.4:53(udp) selinux_ip_postroute_compat
21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052548217
10.244.0.3:39492->10.244.0.4:53(udp) nf_confirm
21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052548744
10.244.0.3:39492->10.244.0.4:53(udp) ip_finish_output
21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052549162
10.244.0.3:39492->10.244.0.4:53(udp) __ip_finish_output
21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052549614
10.244.0.3:39492->10.244.0.4:53(udp) ip_finish_output2
21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052550159
10.244.0.3:39492->10.244.0.4:53(udp) __dev_queue_xmit
21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052550656
10.244.0.3:39492->10.244.0.4:53(udp) netdev_core_pick_tx
21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052551436
10.244.0.3:39492->10.244.0.4:53(udp) validate_xmit_skb
21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052551882
10.244.0.3:39492->10.244.0.4:53(udp) netif_skb_features
21:44:13.153 0xffff97ff83662280 0   <empty>:1463     2007052552291
10.244.0.3:39492->10.244.0.4:53(udp) passthru_features_check
21:44:13.153 0xffff97ff83662280 0   <empty>:1463     2007052552672
10.244.0.3:39492->10.244.0.4:53(udp) skb_network_protocol
21:44:13.153 0xffff97ff83662280 0   <empty>:1463     2007052553191
10.244.0.3:39492->10.244.0.4:53(udp) skb_csum_hwoffload_help
21:44:13.154 0xffff97ff83662280 0   <empty>:1463     2007052553566
10.244.0.3:39492->10.244.0.4:53(udp) validate_xmit_xfrm
21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052554026
10.244.0.3:39492->10.244.0.4:53(udp) dev_hard_start_xmit
21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052554482
10.244.0.3:39492->10.244.0.4:53(udp) veth_xmit
21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052555156
10.244.0.3:39492->10.244.0.4:53(udp) __dev_forward_skb
21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052555604
10.244.0.3:39492->10.244.0.4:53(udp) __dev_forward_skb2
21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052556045
10.244.0.3:39492->10.244.0.4:53(udp) skb_scrub_packet
21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052556449
10.244.0.3:39492->10.244.0.4:53(udp) eth_type_trans
21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052557536
10.244.0.3:39492->10.244.0.4:53(udp) __netif_rx
21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052559424
10.244.0.3:39492->10.244.0.4:53(udp) netif_rx_internal
21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052559872
10.244.0.3:39492->10.244.0.4:53(udp) enqueue_to_backlog
21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052560827
10.244.0.3:39492->10.244.0.4:53(udp) __netif_receive_skb_one_core
21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052561410
10.244.0.3:39492->10.244.0.4:53(udp) ip_rcv
21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052561845
10.244.0.3:39492->10.244.0.4:53(udp) ip_rcv_core
21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052564056
10.244.0.3:39492->10.244.0.4:53(udp)
kfree_skb_reason(SKB_DROP_REASON_OTHERHOST)




> >  net/netfilter/nfnetlink_queue.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> > index e0716da256bf..aeb354271e85 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -276,7 +276,8 @@ static int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry
> >  #ifdef CONFIG_INET
> >         const struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
> >
> > -       if (entry->state.hook == NF_INET_LOCAL_OUT) {
> > +       if (entry->state.hook == NF_INET_LOCAL_OUT ||
> > +           entry->state.hook == NF_INET_POST_ROUTING) {
> >                 const struct iphdr *iph = ip_hdr(skb);
> >
> >                 if (!(iph->tos == rt_info->tos &&
> > --
> > 2.30.2
> >
