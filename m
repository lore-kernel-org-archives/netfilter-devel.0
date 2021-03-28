Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D326FC433DB
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Mar 2021 19:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98E0E61969
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Mar 2021 19:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhC1Tb0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhC1TbD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Mar 2021 15:31:03 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE22C061762
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Mar 2021 12:31:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 1613C67400F1;
        Sun, 28 Mar 2021 21:30:52 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sun, 28 Mar 2021 21:30:49 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 36ED067400EB;
        Sun, 28 Mar 2021 21:30:49 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 2389A340D5D; Sun, 28 Mar 2021 21:30:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 1F038340D5C;
        Sun, 28 Mar 2021 21:30:49 +0200 (CEST)
Date:   Sun, 28 Mar 2021 21:30:49 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Wan Jiabing <wanjiabing@vivo.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Subject: Re: [PATCH] netfilter: ipset: Remove duplicate declaration
In-Reply-To: <20210327025454.917202-1-wanjiabing@vivo.com>
Message-ID: <508fa09b-b2a2-b88f-35b1-d6d3d2a24254@netfilter.org>
References: <20210327025454.917202-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 27 Mar 2021, Wan Jiabing wrote:

> struct ip_set is declared twice. One is declared at 79th line,
> so remove the duplicate.

Yes, it's a duplicate. Pablo, could you apply it?

> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef
> ---
>  include/linux/netfilter/ipset/ip_set.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
> index 46d9a0c26c67..10279c4830ac 100644
> --- a/include/linux/netfilter/ipset/ip_set.h
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@ -124,8 +124,6 @@ struct ip_set_ext {
>  	bool target;
>  };
>  
> -struct ip_set;
> -
>  #define ext_timeout(e, s)	\
>  ((unsigned long *)(((void *)(e)) + (s)->offset[IPSET_EXT_ID_TIMEOUT]))
>  #define ext_counter(e, s)	\
> -- 
> 2.25.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
