Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D22C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Nov 2021 19:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8304561053
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Nov 2021 19:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhKATwc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 15:52:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhKATwb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 15:52:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635796197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qqc178qZXVlRBTkSP0Y4vQlYfIbVccbQXGvB2hKE2bQ=;
        b=Hte8Sl8ZxkVsb7GvAr17GBppIZdeUck9yV9UO2Y7jGKQkhMWbKlzQ+gx3qCI7sx/ooQKr5
        lVDUJwAJ0H4oM7WJd0/8M3fTfkiT3Qy+qYcO0dGXxP+3UZwLkaUAz2mr9WM9ZuSZzHhh+h
        oxzZEC0yKoeUpanFdC4e0dkfyZGAcHw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-sO93PObJOUi1tI5J0kB7BQ-1; Mon, 01 Nov 2021 15:49:56 -0400
X-MC-Unique: sO93PObJOUi1tI5J0kB7BQ-1
Received: by mail-ed1-f71.google.com with SMTP id x13-20020a05640226cd00b003dd4720703bso16587103edd.8
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Nov 2021 12:49:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qqc178qZXVlRBTkSP0Y4vQlYfIbVccbQXGvB2hKE2bQ=;
        b=5YGm2ytRGnqEDV++IYOpkSZgxCFuV+JSifTmkRLKynw58501C4MrrMlo8EY4hXfSJs
         fu0vrzuKFpRpt1xvci+AAv/GZR4aHnXN4UH6Ps80JT8NESxLPMyYI6KuE3AJPi2vl5mJ
         9rUxqaoOWm4ZLJVzFfSzLC2ANHa33CYumukSnSM42KoqiLpazaLTcDzt0oRp6j0kBXdK
         8fFDLLhrRia5WlNzSsFAlN74XecbQii/Ijbk5MWMwGjgDcAqNrref7OFVjQcANW5h6Cg
         j+CLy2fVAf19penJFmg8pCG5y1L2U1ETE2wpW0RVxTi4BVyASk7NpZ/DLJU9T/CLkDGY
         X1Kw==
X-Gm-Message-State: AOAM531ruOxLIBH+snfvztieKw6liQsTw4P0gH+zrXmW29IFH42U8QGg
        jy/gvggHgRqWk8Q/+PIK6U2Z2W1rrAYqrQa8bFkzoqE4cO/AsAFS+xkzka/bq7yWLwqpuHp8pVS
        hkJhptLZuc/gmP9IAQxAhYctuWtX+
X-Received: by 2002:a50:8744:: with SMTP id 4mr43744781edv.100.1635796195598;
        Mon, 01 Nov 2021 12:49:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgHydV0CV/xhpm8QAcsGfvxbZrz1g8h+fAKTtFLxBddFuMKEdw4igXKgtcQv3rCUwkr499hA==
X-Received: by 2002:a50:8744:: with SMTP id 4mr43744738edv.100.1635796195291;
        Mon, 01 Nov 2021 12:49:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t6sm9565835edj.27.2021.11.01.12.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 12:49:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 30EE4180248; Mon,  1 Nov 2021 20:49:54 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Florian Westphal <fw@strlen.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next v1 5/6] net: netfilter: Add unstable CT
 lookup helper for XDP and TC-BPF
In-Reply-To: <20211031191045.GA19266@breakpoint.cc>
References: <20211030144609.263572-1-memxor@gmail.com>
 <20211030144609.263572-6-memxor@gmail.com>
 <20211031191045.GA19266@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 01 Nov 2021 20:49:54 +0100
Message-ID: <87y2677j19.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>> This change adds conntrack lookup helpers using the unstable kfunc call
>> interface for the XDP and TC-BPF hooks.
>> 
>> Also add acquire/release functions (randomly returning NULL), and also
>> exercise the RET_PTR_TO_BTF_ID_OR_NULL path so that BPF program caller
>> has to check for NULL before dereferencing the pointer, for the TC hook.
>> These will be used in selftest.
>> 
>> Export get_net_ns_by_id and btf_type_by_id as nf_conntrack needs to call
>> them.
>
> It would be good to get a summary on how this is useful.
>
> I tried to find a use case but I could not.
> Entry will time out soon once packets stop appearing, so it can't be
> used for stack bypass.  Is it for something else?  If so, what?

I think Maxim's use case was to implement a SYN proxy in XDP, where the
XDP program just needs to answer the question "do I have state for this
flow already". For TCP flows terminating on the local box this can be
done via a socket lookup, but for a middlebox, a conntrack lookup is
useful. Maxim, please correct me if I got your use case wrong.

> For UDP it will work to let a packet pass through classic forward
> path once in a while, but this will not work for tcp, depending
> on conntrack settings (lose mode, liberal pickup etc. pp).

The idea is certainly to follow up with some kind of 'update' helper. At
a minimum a "keep this entry alive" update, but potentially more
complicated stuff as well. Details TBD, input welcome :)

>> +/* Unstable Kernel Helpers for XDP hook */
>> +static struct nf_conn *__bpf_nf_ct_lookup(struct net *net,
>> +					  struct bpf_sock_tuple *bpf_tuple,
>> +					  u32 tuple_len, u8 protonum,
>> +					  u64 netns_id, u64 flags)
>> +{
>> +	struct nf_conntrack_tuple_hash *hash;
>> +	struct nf_conntrack_tuple tuple;
>> +
>> +	if (flags != IP_CT_DIR_ORIGINAL && flags != IP_CT_DIR_REPLY)
>> +		return ERR_PTR(-EINVAL);
>
> The flags argument is not needed.
>
>> +	tuple.dst.dir = flags;
>
> .dir can be 0, its not used by nf_conntrack_find_get().
>
>> +	hash = nf_conntrack_find_get(net, &nf_ct_zone_dflt, &tuple);
>
> Ok, so default zone. Depending on meaning of "unstable helper" this
> is ok and can be changed in incompatible way later.

I'm not sure about the meaning of "unstable" either, TBH, but in either
case I'd rather avoid changing things if we don't have to, so I think
adding the zone as an argument from the get-go may be better...

-Toke

