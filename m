Return-Path: <SRS0=WUGc=VY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8ECC7618F
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Jul 2019 00:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 934E5229F9
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Jul 2019 00:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="tH3fXljO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfG0Aww (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Jul 2019 20:52:52 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41200 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfG0Aww (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jul 2019 20:52:52 -0400
Received: by mail-qt1-f195.google.com with SMTP id d17so54288995qtj.8
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2019 17:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IxMznPIC5UfZy1+kJ9CB0q6LfRe/nhn6D+AfcZZVl1M=;
        b=tH3fXljO9Laly2uDYB7Djus4nkymtuIlKMP9pgDBVP08Po/aJvqah1VAIaQ9g3wjuu
         Ub3EouXyNRyqEs/sAwKx9lhPTi9fPgHf7e3ww6ko29OpwFdhL+iaTejnz2xz3hadeEkC
         4jE9YEwVlCcO11wTsiAWmo6RKVFX9Y+YNKBpSTPjrDyr0+lCAYdk3sYrtZzVAPQM+lkD
         2IQh4mEknUoAd3AZCTMjlIZZ4wT87ZTEdkwNshID30Ny4ZJGS24l7mVPmZ10KdJDks7o
         gV+Qc0zamMugoo3IwEqqGOPElcNFY1t4hfakF8gO2iy93ORtWRuw3jwGeYOMpHo/X9I6
         oilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IxMznPIC5UfZy1+kJ9CB0q6LfRe/nhn6D+AfcZZVl1M=;
        b=CF1+QRbg0r2QtHvFoLL1lsWshDiFYQxdJBdyP4LsQZGSHDmR2M1dxn9hqH8+IEBSzJ
         YWZRIs7n9HTqQCwm6o08OFXMgKipItxwrdvciXewDLescGfL2Ju9cHBFfSC5gI4MBJqC
         CoXNs4o2plBIVjSv7Q9Kjc4bGqzuVlvza4s0Uvr9DnzIoSGrTxMAj7aA1mmmdRu6gzLq
         E0ITtRWAEeUncS9SDRNoYMhYeDIp7Ov6WlhgimBk6z/RUzrpiRII/ehFoMHbwChtAFUy
         B6B4IUvE46GAzaiArYK2TbH7vj5ikLIMWcyIN7AUcYW26P50OYGHU+cwCLsBq3MvXz6k
         aF4g==
X-Gm-Message-State: APjAAAXIXLYGX8EUU0cj9WsRA8JIQoiuhltBNbbOAuM1YlJQsbg+YZL/
        hnpKA9o5VdxjCquV/8e1JyKTdg==
X-Google-Smtp-Source: APXvYqwxJJB54EGa8+t++FLHaXG/WjxD0k3jR6VANPo76Sa7x4BHiGzRXJZBxbuNPFIRXgpcySkPxA==
X-Received: by 2002:ac8:5311:: with SMTP id t17mr67017784qtn.304.1564188771648;
        Fri, 26 Jul 2019 17:52:51 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id n184sm22906920qkc.114.2019.07.26.17.52.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 17:52:51 -0700 (PDT)
Date:   Fri, 26 Jul 2019 17:52:45 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] flow_offload: support get tcf block
 immediately
Message-ID: <20190726175245.4467d94b@cakuba.netronome.com>
In-Reply-To: <1564148047-6428-3-git-send-email-wenxu@ucloud.cn>
References: <1564148047-6428-1-git-send-email-wenxu@ucloud.cn>
        <1564148047-6428-3-git-send-email-wenxu@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 26 Jul 2019 21:34:06 +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Because the new flow-indr-block can't get the tcf_block
> directly.
> It provide a callback to find the tcf block immediately
> when the device register and contain a ingress block.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Please CC people who gave you feedback on your subsequent submissions.

> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 66f89bc..3b2e848 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -391,6 +391,10 @@ struct flow_indr_block_dev {
>  	struct flow_block *flow_block;
>  };
>  
> +typedef void flow_indr_get_default_block_t(struct flow_indr_block_dev *indr_dev);
> +
> +void flow_indr_set_default_block_cb(flow_indr_get_default_block_t *cb);
> +
>  struct flow_indr_block_dev *flow_indr_block_dev_lookup(struct net_device *dev);
>  
>  int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 9f1ae67..db8469d 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -298,6 +298,14 @@ struct flow_indr_block_dev *
>  }
>  EXPORT_SYMBOL(flow_indr_block_dev_lookup);
>  
> +static flow_indr_get_default_block_t *flow_indr_get_default_block;

This static variable which can only be set to the TC's callback really
is not a great API design :/

> +void flow_indr_set_default_block_cb(flow_indr_get_default_block_t *cb)
> +{
> +	flow_indr_get_default_block = cb;
> +}
> +EXPORT_SYMBOL(flow_indr_set_default_block_cb);
> +
>  static struct flow_indr_block_dev *flow_indr_block_dev_get(struct net_device *dev)
>  {
>  	struct flow_indr_block_dev *indr_dev;
> @@ -312,6 +320,10 @@ static struct flow_indr_block_dev *flow_indr_block_dev_get(struct net_device *de
>  
>  	INIT_LIST_HEAD(&indr_dev->cb_list);
>  	indr_dev->dev = dev;
> +
> +	if (flow_indr_get_default_block)
> +		flow_indr_get_default_block(indr_dev);
> +
>  	if (rhashtable_insert_fast(&indr_setup_block_ht, &indr_dev->ht_node,
>  				   flow_indr_setup_block_ht_params)) {
>  		kfree(indr_dev);

