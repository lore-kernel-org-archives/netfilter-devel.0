Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF7CC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 03:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AC4F2083D
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 03:50:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JYk7XCgI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfBYDuM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Feb 2019 22:50:12 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:44128 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbfBYDuM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Feb 2019 22:50:12 -0500
Received: by mail-yw1-f67.google.com with SMTP id x21so3129258ywx.11
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Feb 2019 19:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NJl0S5P1ErsAfvwD0QxLoxwNtmbpZqO5gpAgUlFSZ+U=;
        b=JYk7XCgIjr7zPx3tkQi08tfirDQHeejQvpfehpSfKe6/Tl6PZ13ScjspbOjlBwh+oU
         4T9Iz8mrycjBeM3n8m9RbpRWYNB07EjMUxFfjIVEGLHc8smUzTIB6d8Xo7I65ER3FGaD
         DvCX49ysUrDGl3ojZmb7iFZWv+7O52iXgwH+L3wZUWPNCrpoUIIDpZ6VFPzOlPOkd/ln
         6xRVBdgGkuwOIfsk/hedi5T/6qKj7KABYNU4kl5tDikuhlM1ZNkbOnfj9r461pPIxl7Q
         G7YWg4U2vmNOomQ4302wY1A7VVo0xhAYVlevsoth7VgHVsyu3zWGdb0kNsCYuG+QJfo7
         /KzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NJl0S5P1ErsAfvwD0QxLoxwNtmbpZqO5gpAgUlFSZ+U=;
        b=JYH1WekhnALA9CfmaSNc+oDLKcWNuoiR0OvbqgnpMbS9NlLMEpO6nE0QR2GfOubcIY
         sM6xEFZJJy0vdiULckMbDwwnvFe9cMK5eswFGylkT5iTv3gorjIVM66whoz3/zO6QEgG
         SLdnNH6sSrsn01e/3+KjKLPPOxDJSdJDmISViwtoOj9J56tNh4+b2969jovmNYUFugv4
         6uv/uqxbRlJGqrbPXOChvhhlhEitPCYLRdzdrGrZfqcLGA6wLHmdUPQLTKeNXSWOgPCF
         a5rzl4gm5t8Ihbi8uYMBkSY5yT5D+7HsUJ755FgDHqy20X4//2OmGFznzRJ7Q5x2TzWi
         Vghw==
X-Gm-Message-State: AHQUAubpG0ZpRpR+oH2DCwk//O1EqeMnpszAOFHFzBZvphTP5A4RpL6d
        KCLlvH6KWr25KgE/Cc6y8dXgAQBb
X-Google-Smtp-Source: AHgI3IY3x6roAGmKrZj8eTizif4ZxYeme3oerTmtIhrnPiQXJUbLj0a070LoxJGqBX2vbKbIfCsLEg==
X-Received: by 2002:a81:788c:: with SMTP id t134mr12608453ywc.167.1551066610929;
        Sun, 24 Feb 2019 19:50:10 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id 79sm998388ywr.110.2019.02.24.19.50.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 19:50:09 -0800 (PST)
Subject: Re: [PATCH] netfilter: force access of RCU protected data in
 nft_update_chain_stats
To:     Li RongQing <lirongqing@baidu.com>, netfilter-devel@vger.kernel.org
References: <1551059920-14120-1-git-send-email-lirongqing@baidu.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4818220f-1c66-df00-e397-4efbeba82665@gmail.com>
Date:   Sun, 24 Feb 2019 19:50:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1551059920-14120-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 02/24/2019 05:58 PM, Li RongQing wrote:
> basechain->stats is rcu protected data, cannot assure that
> twice accesses have the same result, so dereference it once.
> 
> basechain->stats is allocated by percpu allocater, if it is not NULL,
> its percpu variable does not need to be checked with NULL
> 
> Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  net/netfilter/nf_tables_core.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
> index 2a00aef7b6d4..9be622c76a62 100644
> --- a/net/netfilter/nf_tables_core.c
> +++ b/net/netfilter/nf_tables_core.c
> @@ -98,20 +98,20 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
>  					    const struct nft_pktinfo *pkt)
>  {
>  	struct nft_base_chain *base_chain;
> -	struct nft_stats *stats;
> +	struct nft_stats *stats, *pstat;
>  
>  	base_chain = nft_base_chain(chain);
> -	if (!rcu_access_pointer(base_chain->stats))
> +
> +	stats = rcu_dereference(base_chain->stats);

This looks bogus to me.

Where is the needed rcu_read_lock() before rcu_dereference() ?

This rcu_access_pointer() test is fine, and avoids a local_bh_disable()/local_bh_enable()
if they are not needed.


> +	if (!stats)
>  		return;
>  
>  	local_bh_disable();
> -	stats = this_cpu_ptr(rcu_dereference(base_chain->stats));
> -	if (stats) {
> -		u64_stats_update_begin(&stats->syncp);
> -		stats->pkts++;
> -		stats->bytes += pkt->skb->len;
> -		u64_stats_update_end(&stats->syncp);
> -	}
> +	pstat = this_cpu_ptr(stats);
> +	u64_stats_update_begin(&pstat->syncp);
> +	pstat->pkts++;
> +	pstat->bytes += pkt->skb->len;
> +	u64_stats_update_end(&pstat->syncp);
>  	local_bh_enable();
>  }
>  
> 


