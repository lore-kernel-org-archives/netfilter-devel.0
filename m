Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A43C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Aug 2021 09:46:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05CDD61058
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Aug 2021 09:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhHAJqr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Aug 2021 05:46:47 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47682 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhHAJqr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Aug 2021 05:46:47 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3E4A460033;
        Sun,  1 Aug 2021 11:46:04 +0200 (CEST)
Date:   Sun, 1 Aug 2021 11:46:31 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: clusterip: don't register hook in
 all netns
Message-ID: <20210801094631.GA15328@salvia>
References: <20210722084834.27027-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210722084834.27027-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 22, 2021 at 10:48:31AM +0200, Florian Westphal wrote:
> This series stops ipt_CLUSTERIP from registering arp mangling hook
> unconditionally.
> 
> Hook gets installed/removed from checkentry/destroy callbacks.
> 
> Before this, modprobe ipt_CLUSTERIP would add a hook in each netns.
> While at it, also get rid of x_tables.h/xt storage space in struct net,
> there is no need for this.

Series applied, thanks.

I made a small update to 2/3 here:

@@ -517,6 +531,19 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
                return ret;
        }

+       if (cn->hook_users == 0) {
+               ret = nf_register_net_hook(par->net, &cip_arp_ops);
+
+               if (ret < 0) {
+                       clusterip_config_entry_put(config); <--
+                       clusterip_config_put(config); <--

to use config instead cipinfo->config which is set on later.
