Return-Path: <SRS0=pcvh=2J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889E5C43603
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 23:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 592AE21655
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Dec 2019 23:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfLSXnT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 18:43:19 -0500
Received: from correo.us.es ([193.147.175.20]:56498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfLSXnT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 18:43:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3D6AAC39F1
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 00:43:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E3BBDA70C
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 00:43:16 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 23CFBDA70B; Fri, 20 Dec 2019 00:43:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E154DDA701;
        Fri, 20 Dec 2019 00:43:13 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Dec 2019 00:43:13 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C302542EF42A;
        Fri, 20 Dec 2019 00:43:13 +0100 (CET)
Date:   Fri, 20 Dec 2019 00:43:14 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/3] netfilter: nf_tables: fix rule release in err path
Message-ID: <20191219234314.s6qcowqx5og7xhdk@salvia>
References: <1576681153-10578-1-git-send-email-wenxu@ucloud.cn>
 <1576681153-10578-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576681153-10578-2-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 18, 2019 at 10:59:11PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The err2 failed path in nf_tables_newrule fail err2  should only destory this new rule
> without deactivate it. Because the rule is not been activated.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a8caf73..27e6a6f 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3130,7 +3130,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
>  
>  	return 0;
>  err2:
> -	nf_tables_rule_release(&ctx, rule);
> +	nf_tables_rule_destroy(&ctx, rule);

This is not correct, the rule might have a reference to a chain jump,
nft_data_release() needs to be called in that case.

>  err1:
>  	for (i = 0; i < n; i++) {
>  		if (info[i].ops) {
> -- 
> 1.8.3.1
> 
