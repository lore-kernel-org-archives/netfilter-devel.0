Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1BFC43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 23:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D682621927
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 23:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfLSX4L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:56:11 -0500
Received: from correo.us.es ([193.147.175.20]:59078 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbfLSX4L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 18:56:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0CDA7C39F1
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 00:56:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2FE8DA70B
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 00:56:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E8025DA702; Fri, 20 Dec 2019 00:56:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B87E3DA702;
        Fri, 20 Dec 2019 00:56:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Dec 2019 00:56:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9BFD34265A5A;
        Fri, 20 Dec 2019 00:56:05 +0100 (CET)
Date:   Fri, 20 Dec 2019 00:56:05 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 3/3] netfilter: nf_tables: fix miss dec set use
 counter in the nf_tables_destroy_set
Message-ID: <20191219235605.hva2ea4edoa5rwrc@salvia>
References: <1576681153-10578-1-git-send-email-wenxu@ucloud.cn>
 <1576681153-10578-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576681153-10578-4-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 18, 2019 at 10:59:13PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> In the create rule path nf_tables_bind_set the set->use will inc, and
> with the activate operatoion also inc it. In the delete rule patch
> deactivate will dec it. So the destroy opertion should also deactivate
> it.
[...]

Is this a theoretical issue? Thanks.

[...]
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 174b362..d71793e 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -4147,8 +4147,10 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
>  
>  void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
>  {
> -	if (list_empty(&set->bindings) && nft_set_is_anonymous(set))
> +	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
> +		set->use--;
>  		nft_set_destroy(set);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(nf_tables_destroy_set);
>  
> -- 
> 1.8.3.1
> 
