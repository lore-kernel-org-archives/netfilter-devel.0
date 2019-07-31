Return-Path: <SRS0=6+Vk=V4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC4F7C32751
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 00:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4419206E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Jul 2019 00:21:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="YlnCXahE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387528AbfGaAVo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 20:21:44 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46445 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726535AbfGaAVn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 20:21:43 -0400
Received: by mail-qt1-f193.google.com with SMTP id h21so64787708qtn.13
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 17:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zZuVIM8QeDsvHulJTgwwSmVbK1Pr+l5Dyla7hZ8EFwg=;
        b=YlnCXahE7T3HbfquvfIE4Nb7ZxledzCWkncuYT1RAH2rRAOjnmvoFqwB2dnqN27Jh+
         A5GRS1GjQSsFTd//RfN/7nIR2yPPXHOxdlPlbcgpnUbKNSVXy8Ohr/HFd8UtRTe51iC2
         C4rQXKADVIkNkutwUO/poItq2OZY2OK1owOuFqm6OUParARyMD9XfuQ1dCJq6ToxA3mn
         8gzHQ35svUUcaKaSYInFMWMB4W9ARI55JgIy8aj3dw9vpECkYbjhuiBv+vFNlvhQCH2k
         IMFt80EyHJzMYkHBXhsfalcDvYDEun787MUzZzehWLJpOqUwLxJqlEHNchfJmbQM90D8
         E/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zZuVIM8QeDsvHulJTgwwSmVbK1Pr+l5Dyla7hZ8EFwg=;
        b=BADeJxMDwPIDfC3rHyLNXodrp+5VvyD2i4FQPNJyiZTm6jxFJICI+kLb38A1tShx3p
         tf8m/ZX1RQmDgycxj/H/JHyI9b/XWyWKKlybZuJfl/cuw0BQ1I6r230SEYztYBaLmoOT
         RTOUGTAu9fd8TUqCMhgmCLQ7QQNsqEtRz6BC00cEcHujrz8o0iaCbBBQ+xwOLG3W0ro9
         I6ZufFXVSqkPfDaBfj4oZBhUH+lUEqAak1YbvB9xJG0PaQ8ZwQKLGnWVXrALePwDVbss
         f9mC9uKW94tjiy5DTsFfnR7hg/sHbDxHA0gtPukuH/itRX2IIc2DmCsqJwDDfhNZlkCI
         wc1Q==
X-Gm-Message-State: APjAAAUEkCXXLqJVW/sePRf5gIZYzB2Gx3LuZ3/tuC+A0dRKZcjcRqaq
        U7Zv4n5skM/uFc+vuItqaBFRTA==
X-Google-Smtp-Source: APXvYqz928PF9WpXi6Qo5dBYR/bjI2MVi1C5o3EqzqDoLBW0LylinIUJOI9mO3yoInO6tSzuI9e1Cg==
X-Received: by 2002:ac8:40cc:: with SMTP id f12mr82158214qtm.256.1564532502789;
        Tue, 30 Jul 2019 17:21:42 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z18sm30324878qka.12.2019.07.30.17.21.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 17:21:42 -0700 (PDT)
Date:   Tue, 30 Jul 2019 17:21:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, wenxu@ucloud.cn, jiri@resnulli.us,
        marcelo.leitner@gmail.com, saeedm@mellanox.com,
        gerlitz.or@gmail.com, paulb@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: map basechain priority to
 hardware priority
Message-ID: <20190730172130.1f11de90@cakuba.netronome.com>
In-Reply-To: <20190730105417.14538-1-pablo@netfilter.org>
References: <20190730105417.14538-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 30 Jul 2019 12:54:17 +0200, Pablo Neira Ayuso wrote:
> This patch maps basechain netfilter priorities from -8192 to 8191 to
> hardware priority 0xC000 + 1. tcf_auto_prio() uses 0xC000 if the user
> specifies no priority, then it subtract 1 for each new tcf_proto object.
> This patch uses the hardware priority range from 0xC000 to 0xFFFF for
> netfilter.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> This follows a rather conservative approach, I could just expose the
> 2^16 hardware priority range, but we may need to split this priority
> range among the ethtool_rx, tc and netfilter subsystems to start with
> and it should be possible to extend the priority range later on.
> 
> By netfilter priority, I'm refering to the basechain priority:
> 
> 	add chain x y { type filter hook ingress device eth0 priority 0; }
>                                                              ^^^^^^^^^^^
> 
> This is no transparently mapped to hardware, this patch shifts it to
> make it fit into the 0xC000 + 1 .. 0xFFFF hardware priority range.

Mmm.. so the ordering of tables is intended to be decided by priority
and not block type (nft, tc, ethtool)?  I was always expecting we 
would just follow the software order when it comes to inter-subsystem
decisions.  So ethtool first, then XDP, then TC, then nft, then
bridging etc. TC vs NFT based on:

static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
				    struct packet_type **ppt_prev)
{
...
	if (static_branch_unlikely(&ingress_needed_key)) {
		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev);
		if (!skb)
			goto out;

		if (nf_ingress(skb, &pt_prev, &ret, orig_dev) < 0)
			goto out;
	}

Are they solid use cases for choosing the ordering arbitrarily?
