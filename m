Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFAFAC10F06
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 12:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6E2220657
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 12:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfCKMbw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:31:52 -0400
Received: from mail.us.es ([193.147.175.20]:46378 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbfCKMbw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 08:31:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6E03527F8B3
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 13:31:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C77DBAABF
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 13:31:48 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 51BB0BAABE; Mon, 11 Mar 2019 13:31:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EF1EBAAB2;
        Mon, 11 Mar 2019 13:31:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 Mar 2019 13:31:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 278444265A4E;
        Mon, 11 Mar 2019 13:31:46 +0100 (CET)
Date:   Mon, 11 Mar 2019 13:31:45 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     gregkh@linuxfoundation.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        netfilter-devel@vger.kernel.org, gregkh@linuxfoundation.org,
        Taehee Yoo <ap420073@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 2/2] netfilter: xt_TEE: add missing code to get
 interface index in checkentry.
Message-ID: <20190311123145.ixyboiw3szsymaa4@salvia>
References: <1552088294-18087-1-git-send-email-subashab@codeaurora.org>
 <1552088294-18087-2-git-send-email-subashab@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552088294-18087-2-git-send-email-subashab@codeaurora.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Greg,

Cc'ing stable@vger.kernel.org.

Subash (he's on Cc) needs these two fixes for 4.19:

f24d2d4f9586985509320f90308723d3d0c4e47f
netfilter: xt_TEE: fix wrong interface selection

18c0ab87364ac5128a152055fdcb1d27e01caf01
netfilter: xt_TEE: add missing code to get interface index in checkentry.

Subash forgot to Cc stable@vger.kernel.org in his two patches, sorry
about that.

Thanks!

On Fri, Mar 08, 2019 at 04:38:14PM -0700, Subash Abhinov Kasiviswanathan wrote:
> From: Taehee Yoo <ap420073@gmail.com>
> 
> commit 18c0ab87364ac5128a152055fdcb1d27e01caf01 upstream.
> 
> checkentry(tee_tg_check) should initialize priv->oif from dev if possible.
> But only netdevice notifier handler can set that.
> Hence priv->oif is always -1 until notifier handler is called.
> 
> Fixes: 9e2f6c5d78db ("netfilter: Rework xt_TEE netdevice notifier")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/xt_TEE.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
> index 673ad20..1dae02a 100644
> --- a/net/netfilter/xt_TEE.c
> +++ b/net/netfilter/xt_TEE.c
> @@ -104,6 +104,8 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
>  		return -EINVAL;
>  
>  	if (info->oif[0]) {
> +		struct net_device *dev;
> +
>  		if (info->oif[sizeof(info->oif)-1] != '\0')
>  			return -EINVAL;
>  
> @@ -115,6 +117,11 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
>  		priv->oif     = -1;
>  		info->priv    = priv;
>  
> +		dev = dev_get_by_name(par->net, info->oif);
> +		if (dev) {
> +			priv->oif = dev->ifindex;
> +			dev_put(dev);
> +		}
>  		mutex_lock(&tn->lock);
>  		list_add(&priv->list, &tn->priv_list);
>  		mutex_unlock(&tn->lock);
> -- 
> 1.9.1
> 
