Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C83C31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40C5D2063F
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 22:09:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbfFQWJb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:09:31 -0400
Received: from mail.us.es ([193.147.175.20]:55430 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbfFQWJa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 18:09:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C4248C04E0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 00:09:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B35ECDA702
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 00:09:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A8D86DA701; Tue, 18 Jun 2019 00:09:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9440DA702;
        Tue, 18 Jun 2019 00:09:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 00:09:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 978424265A2F;
        Tue, 18 Jun 2019 00:09:26 +0200 (CEST)
Date:   Tue, 18 Jun 2019 00:09:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laura Garcia Liebana <nevola@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] src: enable set expiration date for set elements
Message-ID: <20190617220926.rgt5x5gsrzcxsa7l@salvia>
References: <20190617161424.gc46x7z5nv24m6pz@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617161424.gc46x7z5nv24m6pz@nevthink>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Laura,

On Mon, Jun 17, 2019 at 06:14:24PM +0200, Laura Garcia Liebana wrote:
[...]
> diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
> index 8394560aa695..df19844e994f 100644
> --- a/net/netfilter/nft_dynset.c
> +++ b/net/netfilter/nft_dynset.c
> @@ -24,6 +24,7 @@ struct nft_dynset {
>  	enum nft_registers		sreg_data:8;
>  	bool				invert;
>  	u64				timeout;
> +	u64				expiration;
>  	struct nft_expr			*expr;
>  	struct nft_set_binding		binding;
>  };
> @@ -51,16 +52,18 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
>  	const struct nft_dynset *priv = nft_expr_priv(expr);
>  	struct nft_set_ext *ext;
>  	u64 timeout;
> +	u64 expiration;
>  	void *elem;
>  
>  	if (!atomic_add_unless(&set->nelems, 1, set->size))
>  		return NULL;
>  
>  	timeout = priv->timeout ? : set->timeout;
> +	expiration = priv->expiration;
>  	elem = nft_set_elem_init(set, &priv->tmpl,
>  				 &regs->data[priv->sreg_key],
>  				 &regs->data[priv->sreg_data],
> -				 timeout, GFP_ATOMIC);
> +				 timeout, expiration, GFP_ATOMIC);
                                          ^^^^^^^^^^

Probably better to replace 'expiration' by 0? priv->expiration is
never used / always set to zero, right?

Thanks!
