Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6F4C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 20:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242660AbiERUrL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 16:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242666AbiERUrK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 16:47:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3896016D10B
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 13:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652906828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6fGaMCZY5et8TukPAizblMAmglbYj53OBTyrqhmz88w=;
        b=cVw8lB6ycwgkNtMaujoonmCH3c43j4mLhPqGyUusbGpl9XAeLScJNlroWkIZvoLg1LtyL3
        nLDlCctElwXCqP9YS8a2sIH20skfPleHRiFo84FUIlW2TnKOvFxpLacnBHmBP0O5ysei/a
        aXKn5BEp/wao2smXzyexWcxn9eOOROo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-9mBLu34BN0O0P6TpH-L2eQ-1; Wed, 18 May 2022 16:47:07 -0400
X-MC-Unique: 9mBLu34BN0O0P6TpH-L2eQ-1
Received: by mail-ed1-f72.google.com with SMTP id n7-20020a05640206c700b0042aaeb9d702so2263361edy.19
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 13:47:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6fGaMCZY5et8TukPAizblMAmglbYj53OBTyrqhmz88w=;
        b=FaFpArQZYxjm7AqFl5LQdR/IDHkHKUtdpl2iKkFWvB4dLY0k7LizfUyRVRXOLDbi4s
         EVJDx+aovWQgt1pLRqwxe4GMHzDqv7umzOI1RuhJEtNH7rDQp5tTtEokiwDorTq3fA5l
         PBo0jt/pNLBabof0dnBKitjFnn3YjXYzkk2e16ccra7kXvlSF2rFRVzjs+/rZGmJ1Yjl
         ejBrErwhSlrO20KqG2XuyZO3htNzU60In4HHQZ3vVZp6z2GawMqq5FgHIDaEbpA1f5Jj
         PMktmoV/6gglAwCrGPWmrvKU8g8OYVRoZ4Tf0Sf5469/6gshTWTi6WsMj6ARuD7Jr26c
         bilA==
X-Gm-Message-State: AOAM532paLyENlOpujSZgzh6rvFKRgl2MXiPedEFLJHF7NoZZAU/wC6i
        0SjMo33EYwQDYLOfYZ8V1GEnuntF4zeU7/Szo6s7rnLz8/yclmeElbXZ68UooCsuVz9dDaolUQp
        Jw10RwElLscPhQufZE3FDUJGCak7h
X-Received: by 2002:a05:6402:42c3:b0:427:d0e6:77e4 with SMTP id i3-20020a05640242c300b00427d0e677e4mr1713684edc.49.1652906823657;
        Wed, 18 May 2022 13:47:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxU+QcXpwCCUC54IoV+68Kfuh6QV3pxBg4jLbN9Abl1ZBDKxwxbxaitmQrB/0M+62Dhle2xRg==
X-Received: by 2002:a05:6402:42c3:b0:427:d0e6:77e4 with SMTP id i3-20020a05640242c300b00427d0e677e4mr1713571edc.49.1652906822014;
        Wed, 18 May 2022 13:47:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id hf1-20020a1709072c4100b006f3ef214da0sm1287460ejc.6.2022.05.18.13.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 13:47:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9E1D038ECC8; Wed, 18 May 2022 22:47:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, memxor@gmail.com
Subject: Re: [PATCH v3 bpf-next 4/5] net: netfilter: add kfunc helper to add
 a new ct entry
In-Reply-To: <40e7ce4b79c86c46e5fbf22e9cafb51b9172da19.1652870182.git.lorenzo@kernel.org>
References: <cover.1652870182.git.lorenzo@kernel.org>
 <40e7ce4b79c86c46e5fbf22e9cafb51b9172da19.1652870182.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 May 2022 22:47:00 +0200
Message-ID: <87y1yy8t6j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Introduce bpf_xdp_ct_add and bpf_skb_ct_add kfunc helpers in order to
> add a new entry to ct map from an ebpf program.
> Introduce bpf_nf_ct_tuple_parse utility routine.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/netfilter/nf_conntrack_bpf.c | 212 +++++++++++++++++++++++++++----
>  1 file changed, 189 insertions(+), 23 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> index a9271418db88..3d31b602fdf1 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -55,41 +55,114 @@ enum {
>  	NF_BPF_CT_OPTS_SZ = 12,
>  };
>  
> -static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
> -					  struct bpf_sock_tuple *bpf_tuple,
> -					  u32 tuple_len, u8 protonum,
> -					  s32 netns_id, u8 *dir)
> +static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
> +				 u32 tuple_len, u8 protonum, u8 dir,
> +				 struct nf_conntrack_tuple *tuple)
>  {
> -	struct nf_conntrack_tuple_hash *hash;
> -	struct nf_conntrack_tuple tuple;
> -	struct nf_conn *ct;
> +	union nf_inet_addr *src = dir ? &tuple->dst.u3 : &tuple->src.u3;
> +	union nf_inet_addr *dst = dir ? &tuple->src.u3 : &tuple->dst.u3;
> +	union nf_conntrack_man_proto *sport = dir ? (void *)&tuple->dst.u
> +						  : &tuple->src.u;
> +	union nf_conntrack_man_proto *dport = dir ? &tuple->src.u
> +						  : (void *)&tuple->dst.u;
>  
>  	if (unlikely(protonum != IPPROTO_TCP && protonum != IPPROTO_UDP))
> -		return ERR_PTR(-EPROTO);
> -	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
> -		return ERR_PTR(-EINVAL);
> +		return -EPROTO;
> +
> +	memset(tuple, 0, sizeof(*tuple));
>  
> -	memset(&tuple, 0, sizeof(tuple));
>  	switch (tuple_len) {
>  	case sizeof(bpf_tuple->ipv4):
> -		tuple.src.l3num = AF_INET;
> -		tuple.src.u3.ip = bpf_tuple->ipv4.saddr;
> -		tuple.src.u.tcp.port = bpf_tuple->ipv4.sport;
> -		tuple.dst.u3.ip = bpf_tuple->ipv4.daddr;
> -		tuple.dst.u.tcp.port = bpf_tuple->ipv4.dport;
> +		tuple->src.l3num = AF_INET;
> +		src->ip = bpf_tuple->ipv4.saddr;
> +		sport->tcp.port = bpf_tuple->ipv4.sport;
> +		dst->ip = bpf_tuple->ipv4.daddr;
> +		dport->tcp.port = bpf_tuple->ipv4.dport;
>  		break;
>  	case sizeof(bpf_tuple->ipv6):
> -		tuple.src.l3num = AF_INET6;
> -		memcpy(tuple.src.u3.ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
> -		tuple.src.u.tcp.port = bpf_tuple->ipv6.sport;
> -		memcpy(tuple.dst.u3.ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
> -		tuple.dst.u.tcp.port = bpf_tuple->ipv6.dport;
> +		tuple->src.l3num = AF_INET6;
> +		memcpy(src->ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
> +		sport->tcp.port = bpf_tuple->ipv6.sport;
> +		memcpy(dst->ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
> +		dport->tcp.port = bpf_tuple->ipv6.dport;
>  		break;
>  	default:
> -		return ERR_PTR(-EAFNOSUPPORT);
> +		return -EAFNOSUPPORT;
>  	}
> +	tuple->dst.protonum = protonum;
> +	tuple->dst.dir = dir;
> +
> +	return 0;
> +}
>  
> -	tuple.dst.protonum = protonum;
> +struct nf_conn *
> +__bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
> +			u32 tuple_len, u8 protonum, s32 netns_id, u32 timeout)
> +{
> +	struct nf_conntrack_tuple otuple, rtuple;
> +	struct nf_conn *ct;
> +	int err;
> +
> +	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
> +		return ERR_PTR(-EINVAL);
> +
> +	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
> +				    IP_CT_DIR_ORIGINAL, &otuple);
> +	if (err < 0)
> +		return ERR_PTR(err);
> +
> +	err = bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, protonum,
> +				    IP_CT_DIR_REPLY, &rtuple);
> +	if (err < 0)
> +		return ERR_PTR(err);
> +
> +	if (netns_id >= 0) {
> +		net = get_net_ns_by_id(net, netns_id);
> +		if (unlikely(!net))
> +			return ERR_PTR(-ENONET);
> +	}
> +
> +	ct = nf_conntrack_alloc(net, &nf_ct_zone_dflt, &otuple, &rtuple,
> +				GFP_ATOMIC);
> +	if (IS_ERR(ct))
> +		goto out;
> +
> +	ct->timeout = timeout * HZ + jiffies;
> +	ct->status |= IPS_CONFIRMED;
> +
> +	memset(&ct->proto, 0, sizeof(ct->proto));
> +	if (protonum == IPPROTO_TCP)
> +		ct->proto.tcp.state = TCP_CONNTRACK_ESTABLISHED;

Hmm, isn't it a bit limiting to hard-code this to ESTABLISHED
connections? Presumably for TCP you'd want to use this when you see a
SYN and then rely on conntrack to help with the subsequent state
tracking for when the SYN-ACK comes back? What's the usecase for
creating an entry in ESTABLISHED state, exactly?

(Of course, we'd need to be able to update the state as well, then...)

-Toke

