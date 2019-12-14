Return-Path: <SRS0=nEPA=2E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A80C2D0C9
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Dec 2019 08:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F9E720706
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Dec 2019 08:26:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="WLPgsouJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfLNI0f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Dec 2019 03:26:35 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55300 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfLNI0f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Dec 2019 03:26:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so1209244wmj.5
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Dec 2019 00:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q0lUZaL4JaaxCTkNcuW65mCYTdMNbMsi1L+1EhLTltk=;
        b=WLPgsouJHFJa14438GLMEazJJW0o4f1oBuWdma+7RbqTAsGi4Nqww0IX6UWD5SGou1
         mvMBwmAvrpK87HPEdMUg1oMDtCgaLDunVPH6W6et1Rp6IeBBniGqlmv9NWHmy9KQ0YE2
         bMgHiMwYl5aklyNz8QVxcVPctEMnxw9gba9isg/MhyU4ZbD49Or16mZ3MCHVGvKDrw5H
         hIFDciaLtDIq4aVVZmqoFvTgczmTmgCvnmYT4pszyhWaKJ1HdJ4ejDXc9mNcSWpO861i
         brBsaU8m/a1CaDf+Ji6dAsgkVGKJE2NTYCOTWjpu8R9984UR5tCkk2xtHtX2DSWa2sS3
         a9SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=q0lUZaL4JaaxCTkNcuW65mCYTdMNbMsi1L+1EhLTltk=;
        b=dmCFw2EnYXiMLlcl1OEjs0NVHBryRzuMQZvIvWhre/FiJHWsXdUwonucZBE+2lbeub
         5JaiwXfHvRtGfAozj0SkqTzXwXWXnmZ4NqGQ6yV3zV33VkYIp/EA8FsCRQPc+070HWCy
         iSSRIkDqvGw8JjAo0ZmCPBaLaIwzQQG1Isy9DuxdHO0b6MntGKASu7hjoSDbzdWXSefg
         zGb9z/n6GOhBKEMnzb0WjyM9fQICMW+SCSb3hMDe9X5S4f2sGIFaAUQWZ+4cqecwf7Fs
         N59EuFrM/dEv+g+CMyNplqXII8UUAU1SGDJHllB7fPYEngfNtRIBm06VDxz7HF8dIMCE
         w98A==
X-Gm-Message-State: APjAAAU6RaeuZYFaUI7O4RX6PEce3D3vvdDSt3yigIj+uINXx2KNfVSU
        7kslW1o1VqerhPku0r9GP8vAYA==
X-Google-Smtp-Source: APXvYqwZ1+ZETkPyIcvXV3KcK4DgfmgA4OAneThQa8x7NMj//JM3qG7GowwKM69Pi0lZOn/1TeJMfA==
X-Received: by 2002:a1c:3141:: with SMTP id x62mr17632584wmx.18.1576311992978;
        Sat, 14 Dec 2019 00:26:32 -0800 (PST)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id z18sm12979771wmf.21.2019.12.14.00.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 00:26:32 -0800 (PST)
Date:   Sat, 14 Dec 2019 09:26:31 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 nf-next 2/5] netfilter: nft_tunnel: add the missing
 ERSPAN_VERSION nla_policy
Message-ID: <20191214082630.GB5926@netronome.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
 <7bcaa9e0507fa9a5b6a48f56768a179281bf4ab2.1576226965.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bcaa9e0507fa9a5b6a48f56768a179281bf4ab2.1576226965.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 13, 2019 at 04:53:06PM +0800, Xin Long wrote:
> ERSPAN_VERSION is an attribute parsed in kernel side, nla_policy
> type should be added for it, like other attributes.
> 
> Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")

Is this really a fix?

> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  net/netfilter/nft_tunnel.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> index ef2065dd..6538895 100644
> --- a/net/netfilter/nft_tunnel.c
> +++ b/net/netfilter/nft_tunnel.c
> @@ -248,8 +248,9 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
>  }
>  
>  static const struct nla_policy nft_tunnel_opts_erspan_policy[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {
> +	[NFTA_TUNNEL_KEY_ERSPAN_VERSION]	= { .type = NLA_U32 },
>  	[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]	= { .type = NLA_U32 },
> -	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]	= { .type = NLA_U8 },
> +	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]		= { .type = NLA_U8 },
>  	[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]	= { .type = NLA_U8 },
>  };
>  
> -- 
> 2.1.0
> 
