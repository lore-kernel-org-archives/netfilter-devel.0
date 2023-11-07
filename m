Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11148C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Nov 2023 11:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbjKGLnV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Nov 2023 06:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjKGLnT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Nov 2023 06:43:19 -0500
X-Greylist: delayed 431 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Nov 2023 03:43:11 PST
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF1711F
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2023 03:43:10 -0800 (PST)
Received: from mg.bb.i.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id E009320F72;
        Tue,  7 Nov 2023 13:35:55 +0200 (EET)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id C4B6E20F71;
        Tue,  7 Nov 2023 13:35:55 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
        by ink.ssi.bg (Postfix) with ESMTPSA id A53C33C0439;
        Tue,  7 Nov 2023 13:35:55 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ssi.bg; s=ink;
        t=1699356955; bh=IpLxLKQcA5+B+XHf9cjtzr7JHJl1jZEVcTO4wOq3kEI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References;
        b=a962KXGjNztlc4cnvOyimmH/YpMtXh3Qn55e8EflW1Mkjsukx2p9J+BtMC29H2sAz
         FBQRmMzUg/zjOBsvJMl/4otn1grwQYvnm9f6HYJ+eFqx4df1lSNM7aw95ZoHjepDYR
         z8+7okqvdRe0z7LI6g5Rx58j/zrlbsT7Fi4en92c=
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.17.1) with ESMTP id 3A7BZl2v040641;
        Tue, 7 Nov 2023 13:35:47 +0200
Date:   Tue, 7 Nov 2023 13:35:47 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] ipvs: add missing module descriptions
In-Reply-To: <20231107094807.2723-1-fw@strlen.de>
Message-ID: <cdbb47bd-c43a-d436-cc4b-96c1e2b9dbdc@ssi.bg>
References: <20231107094807.2723-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Tue, 7 Nov 2023, Florian Westphal wrote:

> W=1 builds warn on missing MODULE_DESCRIPTION, add them.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_core.c   | 1 +
>  net/netfilter/ipvs/ip_vs_dh.c     | 1 +
>  net/netfilter/ipvs/ip_vs_fo.c     | 1 +
>  net/netfilter/ipvs/ip_vs_ftp.c    | 1 +
>  net/netfilter/ipvs/ip_vs_lblc.c   | 1 +
>  net/netfilter/ipvs/ip_vs_lblcr.c  | 1 +
>  net/netfilter/ipvs/ip_vs_lc.c     | 1 +
>  net/netfilter/ipvs/ip_vs_nq.c     | 1 +
>  net/netfilter/ipvs/ip_vs_ovf.c    | 1 +
>  net/netfilter/ipvs/ip_vs_pe_sip.c | 1 +
>  net/netfilter/ipvs/ip_vs_rr.c     | 1 +
>  net/netfilter/ipvs/ip_vs_sed.c    | 1 +
>  net/netfilter/ipvs/ip_vs_sh.c     | 1 +
>  net/netfilter/ipvs/ip_vs_twos.c   | 1 +
>  net/netfilter/ipvs/ip_vs_wlc.c    | 1 +
>  net/netfilter/ipvs/ip_vs_wrr.c    | 1 +
>  16 files changed, 16 insertions(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 3230506ae3ff..a2c16b501087 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -2450,3 +2450,4 @@ static void __exit ip_vs_cleanup(void)
>  module_init(ip_vs_init);
>  module_exit(ip_vs_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("IP Virtual Server");
> diff --git a/net/netfilter/ipvs/ip_vs_dh.c b/net/netfilter/ipvs/ip_vs_dh.c
> index 5e6ec32aff2b..75f4c231f4a0 100644
> --- a/net/netfilter/ipvs/ip_vs_dh.c
> +++ b/net/netfilter/ipvs/ip_vs_dh.c
> @@ -270,3 +270,4 @@ static void __exit ip_vs_dh_cleanup(void)
>  module_init(ip_vs_dh_init);
>  module_exit(ip_vs_dh_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs destination hashing scheduler");
> diff --git a/net/netfilter/ipvs/ip_vs_fo.c b/net/netfilter/ipvs/ip_vs_fo.c
> index b846cc385279..ab117e5bc34e 100644
> --- a/net/netfilter/ipvs/ip_vs_fo.c
> +++ b/net/netfilter/ipvs/ip_vs_fo.c
> @@ -72,3 +72,4 @@ static void __exit ip_vs_fo_cleanup(void)
>  module_init(ip_vs_fo_init);
>  module_exit(ip_vs_fo_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs weighted failover scheduler");
> diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
> index ef1f45e43b63..f53899d12416 100644
> --- a/net/netfilter/ipvs/ip_vs_ftp.c
> +++ b/net/netfilter/ipvs/ip_vs_ftp.c
> @@ -635,3 +635,4 @@ static void __exit ip_vs_ftp_exit(void)
>  module_init(ip_vs_ftp_init);
>  module_exit(ip_vs_ftp_exit);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs ftp helper");
> diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
> index cf78ba4ce5ff..8ceec7a2fa8f 100644
> --- a/net/netfilter/ipvs/ip_vs_lblc.c
> +++ b/net/netfilter/ipvs/ip_vs_lblc.c
> @@ -632,3 +632,4 @@ static void __exit ip_vs_lblc_cleanup(void)
>  module_init(ip_vs_lblc_init);
>  module_exit(ip_vs_lblc_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs locality-based least-connection scheduler");
> diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
> index 9eddf118b40e..0fb64707213f 100644
> --- a/net/netfilter/ipvs/ip_vs_lblcr.c
> +++ b/net/netfilter/ipvs/ip_vs_lblcr.c
> @@ -817,3 +817,4 @@ static void __exit ip_vs_lblcr_cleanup(void)
>  module_init(ip_vs_lblcr_init);
>  module_exit(ip_vs_lblcr_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs locality-based least-connection with replication scheduler");
> diff --git a/net/netfilter/ipvs/ip_vs_lc.c b/net/netfilter/ipvs/ip_vs_lc.c
> index 9d34d81fc6f1..c2764505e380 100644
> --- a/net/netfilter/ipvs/ip_vs_lc.c
> +++ b/net/netfilter/ipvs/ip_vs_lc.c
> @@ -86,3 +86,4 @@ static void __exit ip_vs_lc_cleanup(void)
>  module_init(ip_vs_lc_init);
>  module_exit(ip_vs_lc_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs least connection scheduler");
> diff --git a/net/netfilter/ipvs/ip_vs_nq.c b/net/netfilter/ipvs/ip_vs_nq.c
> index f56862a87518..ed7f5c889b41 100644
> --- a/net/netfilter/ipvs/ip_vs_nq.c
> +++ b/net/netfilter/ipvs/ip_vs_nq.c
> @@ -136,3 +136,4 @@ static void __exit ip_vs_nq_cleanup(void)
>  module_init(ip_vs_nq_init);
>  module_exit(ip_vs_nq_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs never queue scheduler");
> diff --git a/net/netfilter/ipvs/ip_vs_ovf.c b/net/netfilter/ipvs/ip_vs_ovf.c
> index c03066fdd5ca..c7708b809700 100644
> --- a/net/netfilter/ipvs/ip_vs_ovf.c
> +++ b/net/netfilter/ipvs/ip_vs_ovf.c
> @@ -79,3 +79,4 @@ static void __exit ip_vs_ovf_cleanup(void)
>  module_init(ip_vs_ovf_init);
>  module_exit(ip_vs_ovf_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs overflow connection scheduler");
> diff --git a/net/netfilter/ipvs/ip_vs_pe_sip.c b/net/netfilter/ipvs/ip_vs_pe_sip.c
> index 0ac6705a61d3..e4ce1d9a63f9 100644
> --- a/net/netfilter/ipvs/ip_vs_pe_sip.c
> +++ b/net/netfilter/ipvs/ip_vs_pe_sip.c
> @@ -185,3 +185,4 @@ static void __exit ip_vs_sip_cleanup(void)
>  module_init(ip_vs_sip_init);
>  module_exit(ip_vs_sip_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs sip helper");
> diff --git a/net/netfilter/ipvs/ip_vs_rr.c b/net/netfilter/ipvs/ip_vs_rr.c
> index 38495c6f6c7c..6baa34dff9f0 100644
> --- a/net/netfilter/ipvs/ip_vs_rr.c
> +++ b/net/netfilter/ipvs/ip_vs_rr.c
> @@ -122,4 +122,5 @@ static void __exit ip_vs_rr_cleanup(void)
>  
>  module_init(ip_vs_rr_init);
>  module_exit(ip_vs_rr_cleanup);
> +MODULE_DESCRIPTION("ipvs round-robin scheduler");
>  MODULE_LICENSE("GPL");
> diff --git a/net/netfilter/ipvs/ip_vs_sed.c b/net/netfilter/ipvs/ip_vs_sed.c
> index 7663288e5358..a46f99a56618 100644
> --- a/net/netfilter/ipvs/ip_vs_sed.c
> +++ b/net/netfilter/ipvs/ip_vs_sed.c
> @@ -137,3 +137,4 @@ static void __exit ip_vs_sed_cleanup(void)
>  module_init(ip_vs_sed_init);
>  module_exit(ip_vs_sed_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs shortest expected delay scheduler");
> diff --git a/net/netfilter/ipvs/ip_vs_sh.c b/net/netfilter/ipvs/ip_vs_sh.c
> index c2028e412092..92e77d7a6b50 100644
> --- a/net/netfilter/ipvs/ip_vs_sh.c
> +++ b/net/netfilter/ipvs/ip_vs_sh.c
> @@ -376,3 +376,4 @@ static void __exit ip_vs_sh_cleanup(void)
>  module_init(ip_vs_sh_init);
>  module_exit(ip_vs_sh_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs source hashing scheduler");
> diff --git a/net/netfilter/ipvs/ip_vs_twos.c b/net/netfilter/ipvs/ip_vs_twos.c
> index 3308e4cc740a..8d5419edde50 100644
> --- a/net/netfilter/ipvs/ip_vs_twos.c
> +++ b/net/netfilter/ipvs/ip_vs_twos.c
> @@ -137,3 +137,4 @@ static void __exit ip_vs_twos_cleanup(void)
>  module_init(ip_vs_twos_init);
>  module_exit(ip_vs_twos_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs power of twos choice scheduler");
> diff --git a/net/netfilter/ipvs/ip_vs_wlc.c b/net/netfilter/ipvs/ip_vs_wlc.c
> index 09f584b564a0..9fa500927c0a 100644
> --- a/net/netfilter/ipvs/ip_vs_wlc.c
> +++ b/net/netfilter/ipvs/ip_vs_wlc.c
> @@ -109,3 +109,4 @@ static void __exit ip_vs_wlc_cleanup(void)
>  module_init(ip_vs_wlc_init);
>  module_exit(ip_vs_wlc_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs weighted least connection scheduler");
> diff --git a/net/netfilter/ipvs/ip_vs_wrr.c b/net/netfilter/ipvs/ip_vs_wrr.c
> index 1bc7a0789d85..85ce0d04afac 100644
> --- a/net/netfilter/ipvs/ip_vs_wrr.c
> +++ b/net/netfilter/ipvs/ip_vs_wrr.c
> @@ -263,3 +263,4 @@ static void __exit ip_vs_wrr_cleanup(void)
>  module_init(ip_vs_wrr_init);
>  module_exit(ip_vs_wrr_cleanup);
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("ipvs weighted round-robin scheduler");
> -- 
> 2.41.0

Regards

--
Julian Anastasov <ja@ssi.bg>

