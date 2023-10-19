Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B642CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 11:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345414AbjJSLxI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 07:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345422AbjJSLxH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 07:53:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62981A3
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 04:53:05 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qtRa8-0007mc-A7; Thu, 19 Oct 2023 13:52:52 +0200
Date:   Thu, 19 Oct 2023 13:52:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v3 1/3] netfilter: nf_tables: Open-code audit log
 call in nf_tables_getrule()
Message-ID: <20231019115252.GG12544@breakpoint.cc>
References: <20231019113347.8753-1-phil@nwl.cc>
 <20231019113347.8753-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019113347.8753-2-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> -	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
> +	tablename = nla_strdup(nla[NFTA_RULE_TABLE], GFP_ATOMIC);
> +	buf = kasprintf(GFP_ATOMIC, "%s:%u", tablename, nft_net->base_seq);

You can use %.*s:%u", nla_len(nla[NFTA_RULE_TABLE]), nla_data(nla[NFTA_RULE_TABLE) ...
here to avoid the extra strdup.
