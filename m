Return-Path: <SRS0=TL01=WX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA46C3A5A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 18:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C714420674
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 18:21:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Sg6GVqh4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbfH0SVi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 14:21:38 -0400
Received: from smtp-out.kfki.hu ([148.6.0.46]:49301 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbfH0SVh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 14:21:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id DE28D3C80105;
        Tue, 27 Aug 2019 20:21:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1566930091; x=1568744492; bh=d0QYWJwAUo
        ZjJHspnjU92An5niFYJC0GKb2AR5wQObg=; b=Sg6GVqh4OvCTexsWh0y6FdgivR
        sEPXNHKlbg27jG2AEs3dEfF+e49pu0pZ09f0X6yHjYkqZZwHToBIWU2RSBsf3vXi
        jLYQ4zpIlog3B5OcXbywNbLQpTfk+p4UL72lcE2arT6U5AFlKpkj+mXo24xhWsEu
        ifGkdD+pBBGU34zWw=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 27 Aug 2019 20:21:31 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id 468BD3C80104;
        Tue, 27 Aug 2019 20:21:30 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id E43B621F21; Tue, 27 Aug 2019 20:21:29 +0200 (CEST)
Date:   Tue, 27 Aug 2019 20:21:29 +0200 (CEST)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Dan Carpenter <dan.carpenter@oracle.com>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Aditya Pakki <pakki001@umn.edu>,
        Johannes Berg <johannes.berg@intel.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: ipset: Fix an error code in
 ip_set_sockfn_get()
In-Reply-To: <20190824144955.GA5337@mwanda>
Message-ID: <alpine.DEB.2.20.1908272020470.11996@blackhole.kfki.hu>
References: <20190824144955.GA5337@mwanda>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


Hi Dan,

On Sat, 24 Aug 2019, Dan Carpenter wrote:

> The copy_to_user() function returns the number of bytes remaining to be
> copied.  In this code, that positive return is checked at the end of the
> function and we return zero/success.  What we should do instead is
> return -EFAULT.
> 
> Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: I missed the other instance of this issue
> 
>  net/netfilter/ipset/ip_set_core.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Patch is applied in the ipset git tree, thanks!

Best regards,
Jozsef

> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index e64d5f9a89dd..e7288eab7512 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -2069,8 +2069,9 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
>  		}
>  
>  		req_version->version = IPSET_PROTOCOL;
> -		ret = copy_to_user(user, req_version,
> -				   sizeof(struct ip_set_req_version));
> +		if (copy_to_user(user, req_version,
> +				 sizeof(struct ip_set_req_version)))
> +			ret = -EFAULT;
>  		goto done;
>  	}
>  	case IP_SET_OP_GET_BYNAME: {
> @@ -2129,7 +2130,8 @@ ip_set_sockfn_get(struct sock *sk, int optval, void __user *user, int *len)
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
> 2.11.0
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
