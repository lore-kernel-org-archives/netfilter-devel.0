Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B45C4167B
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Apr 2022 19:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353719AbiDZTFX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 15:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353711AbiDZTFW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 15:05:22 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF68519917A
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 12:02:13 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id m20so17239311ejj.10
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 12:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jeN3MUVs6tnDNZp7NRTtPK2gIw1OmK6uwAto7uqSrx8=;
        b=OHztWIdNccTJW5s3fGbZDXZve/mviCLpv6OOOKg3zLST9/uKRzL9XDI76tMN2nbFd+
         usw1X/lKeoES3rAX5cuC8l7g4gReZkXz37dd144Tp/GtK4f/SXfTfY0MHu/J0KSPLydz
         uPB/JQhUWlkrhZhwABv3aiVsvMOP5aqhXaFDlzvTZUsAfUn574I5fbfqpka6AQ8UIwle
         FYIlO+7AAoDuxTBTMVEI4Bb6Md7j9TGjWCfig/2kESU3bqWSxd5E6xwbRi8KXC1zOJlt
         8CDrqi3LFpDZimR7x/JNyW02d4DEy0M7B2iAHsYgbiLAWlsVbJWo/apC4j2MAKKBTQir
         wnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jeN3MUVs6tnDNZp7NRTtPK2gIw1OmK6uwAto7uqSrx8=;
        b=bYrQ/dDT/h53UOjxezZu5UKqTXj8AGwiw+gnCqvfLL8A74YJRqAqi8nG46dO21yX4m
         +B8TBS05BuH28p8X/2B+QURy7FFb7JyYXBEmpo+YE9l0oc6Ox9Qv8qiziRXVxNCwif8d
         g7Q4urE4MPQvn+nJYSDKbKaAaiUYNpvzFJ+jKGdSB5XlwjO4pMfo2XEVNMdxtHD2v2sb
         1qVplBFcoCGfm3Fmsekx9234Kad8EyLgzbNxyrjHYkFkp10XiZZ215co092PFJ+JUJFl
         olyvum8uMSGssvA7XOII5tGvP8iWAuhpkcXOdfLP5+blKUAM08m3sUtp0+pBKnH/7uVM
         RXVg==
X-Gm-Message-State: AOAM531auW+m6jL1+lHtwBMMP0PvD1oxQXo2T/X0iJManttCNv9jmCA1
        FaFCMKOCJM88MIECkPyPFQtd2JeU86Ianw==
X-Google-Smtp-Source: ABdhPJyy7aIM+5OjwZFwK0cCIvtaY1knJubLeSH46+N6D/fVnxVCn4pwVAVTdkmJ9ux4kwLKJ4wxRQ==
X-Received: by 2002:a17:907:3d89:b0:6ef:eebf:1708 with SMTP id he9-20020a1709073d8900b006efeebf1708mr23657019ejc.620.1650999732395;
        Tue, 26 Apr 2022 12:02:12 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id o5-20020a170906974500b006dfc781498dsm5394829ejy.37.2022.04.26.12.02.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 12:02:11 -0700 (PDT)
Message-ID: <ab7923f2-d1e7-ce61-5df8-c05778ef3ebd@gmail.com>
Date:   Tue, 26 Apr 2022 22:02:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <5a292abd-7f2e-728f-5594-86d85fbd1c00@gmail.com>
 <20220425223421.GA14400@breakpoint.cc>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <20220425223421.GA14400@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 26.4.2022 1.34, Florian Westphal wrote:
> Topi Miettinen <toiwoton@gmail.com> wrote:
>> On 20.4.2022 21.54, Topi Miettinen wrote:
>>> Add socket expressions for checking GID or UID of the originating
>>> socket. These work also on input side, unlike meta skuid/skgid.
>>
>> Unfortunately, there's a reproducible kernel BUG when closing a local
>> connection:
>>
>> Apr 25 21:18:13 kernel:
>> ==================================================================
>> Apr 25 21:18:13 kernel: BUG: KASAN: null-ptr-deref in
>> nf_sk_lookup_slow_v6+0x45b/0x590 [nf_socket_ipv6]
> 
> You can pass this to scripts/faddr2line to get the location of the null deref.

Didn't work, but with grep and gdb I think I located the error to 
net/ipv6/netfilter/nf_socket_ipv6.c:

static struct sock *
nf_socket_get_sock_v6(struct net *net, struct sk_buff *skb, int doff,
                       const u8 protocol,
                       const struct in6_addr *saddr, const struct 
in6_addr *daddr,
                       const __be16 sport, const __be16 dport,
                       const struct net_device *in)
{
         switch (protocol) {
         case IPPROTO_TCP:
                 return inet6_lookup(net, &tcp_hashinfo, skb, doff,
                                     saddr, sport, daddr, dport,
                                     in->ifindex);
                                     ^^^^^^^^^^^
where in->ifindex would be a NULL deref.

-Topi
