Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2856AC3A59D
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 09:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C088D22CE3
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 09:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="PgVBt2Ls"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbfHVJMC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 05:12:02 -0400
Received: from smtp-out.kfki.hu ([148.6.0.48]:35279 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730869AbfHVJMC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 05:12:02 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 16691CC010B;
        Thu, 22 Aug 2019 11:12:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1566465117; x=1568279518; bh=jbRmKNfADC
        RLyLz60GpWjHYifY1zElMiJFfvn5gEdew=; b=PgVBt2LsuCRH7cvkILaMJ0r65o
        ED80sfPU72NloBR27k+GgFVscXJO4rnMCOVtFZhYtVzKm7jLEBlFF0ithTdxcHAA
        rlrBqw+oSuDLE8dwQYUqFLDeRcRpvOtmrUSh9e0XMpNlVlj3kL63LXRDhOFIpbtI
        yUGwS+0OmAHXSJn7I=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 22 Aug 2019 11:11:57 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 0F0C2CC010A;
        Thu, 22 Aug 2019 11:11:56 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 9C47020DD8; Thu, 22 Aug 2019 11:11:56 +0200 (CEST)
Date:   Thu, 22 Aug 2019 11:11:56 +0200 (CEST)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Dan Carpenter <dan.carpenter@oracle.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Aditya Pakki <pakki001@umn.edu>, Qian Cai <cai@gmx.us>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: Fix an error code in
 ip_set_sockfn_get()
In-Reply-To: <20190821071830.GI26957@mwanda>
Message-ID: <alpine.DEB.2.20.1908221109390.11879@blackhole.kfki.hu>
References: <20190821071830.GI26957@mwanda>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Dan,

On Wed, 21 Aug 2019, Dan Carpenter wrote:

> The copy_to_user() function returns the number of bytes remaining to be
> copied.  In this code, that positive return is checked at the end of the
> function and we return zero/success.  What we should do instead is
> return -EFAULT.

Yes, you are right. There's another usage of copy_to_user() in this 
function, could you fix it as well?

Best regards,
Jozsef
 
> Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/netfilter/ipset/ip_set_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index e64d5f9a89dd..15b8d4318207 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -2129,7 +2129,8 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
>  	}	/* end of switch(op) */
>  
>  copy:
> -	ret = copy_to_user(user, data, copylen);
> +	if (copy_to_user(user, data, copylen))
> +		ret = -EFAULT;
>  
>  done:
>  	vfree(data);
> -- 
> 2.20.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
