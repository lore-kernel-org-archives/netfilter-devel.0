Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB4BC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 15:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17E242087C
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 15:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfCHPzs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 10:55:48 -0500
Received: from mail.us.es ([193.147.175.20]:52528 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbfCHPzs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 10:55:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 99BF65E539B
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 16:55:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 839ABDA863
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Mar 2019 16:55:46 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 78845DA846; Fri,  8 Mar 2019 16:55:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80FC6DA796;
        Fri,  8 Mar 2019 16:55:44 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 08 Mar 2019 16:55:44 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5F3A04265A2F;
        Fri,  8 Mar 2019 16:55:44 +0100 (CET)
Date:   Fri, 8 Mar 2019 16:55:43 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     tglx@linutronix.de
Cc:     Li RongQing <lirongqing@baidu.com>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sboyd@kernel.org, john.stultz@linaro.org
Subject: Re: [PATCH][v2] time: Introduce jiffies64_to_msecs()
Message-ID: <20190308155543.si2nqqm6j2otq27r@salvia>
References: <1551330806-12502-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551330806-12502-1-git-send-email-lirongqing@baidu.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 28, 2019 at 01:13:26PM +0800, Li RongQing wrote:
> there is a similar helper in net/netfilter/nf_tables_api.c,
> this maybe become a common request someday, so move it to
> time.c
> 
> Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

This is touching kernel/time.c bits, which is far from my realm.

What should I do with this? I can just place it in nf-next.git if I
get an ACK to do so. Otherwise, please just take this if this looks
good to you.

Thanks!

> ---
>  v1-->v2: using jiffies64_to_msecs in nf_tables_api.c
> 
>  include/linux/jiffies.h       |  1 +
>  kernel/time/time.c            | 10 ++++++++++
>  net/netfilter/nf_tables_api.c |  4 +---
>  3 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
> index fa928242567d..1b6d31da7cbc 100644
> --- a/include/linux/jiffies.h
> +++ b/include/linux/jiffies.h
> @@ -297,6 +297,7 @@ static inline u64 jiffies_to_nsecs(const unsigned long j)
>  }
>  
>  extern u64 jiffies64_to_nsecs(u64 j);
> +extern u64 jiffies64_to_msecs(u64 j);
>  
>  extern unsigned long __msecs_to_jiffies(const unsigned int m);
>  #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
> diff --git a/kernel/time/time.c b/kernel/time/time.c
> index 2edb5088a70b..0083eb711fb7 100644
> --- a/kernel/time/time.c
> +++ b/kernel/time/time.c
> @@ -719,6 +719,16 @@ u64 jiffies64_to_nsecs(u64 j)
>  }
>  EXPORT_SYMBOL(jiffies64_to_nsecs);
>  
> +u64 jiffies64_to_msecs(const u64 j)
> +{
> +#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
> +	return (MSEC_PER_SEC / HZ) * j;
> +#else
> +	return div_u64(j * HZ_TO_MSEC_NUM, HZ_TO_MSEC_DEN);
> +#endif
> +}
> +EXPORT_SYMBOL(jiffies64_to_msecs);
> +
>  /**
>   * nsecs_to_jiffies64 - Convert nsecs in u64 to jiffies64
>   *
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index e1a88ba2249e..8763b2798788 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3184,9 +3184,7 @@ static int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result)
>  
>  static __be64 nf_jiffies64_to_msecs(u64 input)
>  {
> -	u64 ms = jiffies64_to_nsecs(input);
> -
> -	return cpu_to_be64(div_u64(ms, NSEC_PER_MSEC));
> +	return cpu_to_be64(jiffies64_to_msecs(input));
>  }
>  
>  static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
> -- 
> 2.16.2
> 
