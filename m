Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC07DC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Apr 2022 08:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350233AbiDSJAq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Apr 2022 05:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345443AbiDSJAq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Apr 2022 05:00:46 -0400
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF7326554;
        Tue, 19 Apr 2022 01:58:04 -0700 (PDT)
Received: from madeliefje.horms.nl (86-88-72-229.fixed.kpn.net [86.88.72.229])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id E98862014F;
        Tue, 19 Apr 2022 08:57:31 +0000 (UTC)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id A335535C8; Tue, 19 Apr 2022 10:57:31 +0200 (CEST)
Date:   Tue, 19 Apr 2022 10:57:31 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Pengcheng Yang <yangpc@wangsu.com>, lvs-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] ipvs: correctly print the memory size of
 ip_vs_conn_tab
Message-ID: <Yl55e0mDsrgcCAX2@vergenet.net>
References: <1649761545-1864-1-git-send-email-yangpc@wangsu.com>
 <dd2f82a6-bf70-2b10-46e0-9d81e4dde6@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd2f82a6-bf70-2b10-46e0-9d81e4dde6@ssi.bg>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.5 at zeeaster
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 15, 2022 at 04:22:47PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Tue, 12 Apr 2022, Pengcheng Yang wrote:
> 
> > The memory size of ip_vs_conn_tab changed after we use hlist
> > instead of list.
> > 
> > Fixes: 731109e78415 ("ipvs: use hlist instead of list")
> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > ---
> 
> 	v2 looks better to me for nf-next, thanks!
> 
> Acked-by: Julian Anastasov <ja@ssi.bg>

Acked-by: Simon Horman <horms@verge.net.au>

> > v2: use pointer dereference instead of struct types
> > 
> >  net/netfilter/ipvs/ip_vs_conn.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> > index 2c467c4..fb67f1c 100644
> > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > +++ b/net/netfilter/ipvs/ip_vs_conn.c
> > @@ -1495,7 +1495,7 @@ int __init ip_vs_conn_init(void)
> >  	pr_info("Connection hash table configured "
> >  		"(size=%d, memory=%ldKbytes)\n",
> >  		ip_vs_conn_tab_size,
> > -		(long)(ip_vs_conn_tab_size*sizeof(struct list_head))/1024);
> > +		(long)(ip_vs_conn_tab_size*sizeof(*ip_vs_conn_tab))/1024);
> >  	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
> >  		  sizeof(struct ip_vs_conn));
> >  
> > -- 
> > 1.8.3.1
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 
