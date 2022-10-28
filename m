Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB51EC38A02
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Oct 2022 18:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiJ1S1k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Oct 2022 14:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJ1S1j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2022 14:27:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30E11DC4CD
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2022 11:27:37 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ooU4u-0001VW-17; Fri, 28 Oct 2022 20:27:36 +0200
Date:   Fri, 28 Oct 2022 20:27:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2] netfilter: nf_tables: add support to destroy
 operation
Message-ID: <Y1wfGIaFVssu+/4B@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20221028100531.58666-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028100531.58666-1-ffmancera@riseup.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Oct 28, 2022 at 12:05:31PM +0200, Fernando Fernandez Mancera wrote:
[...]
> @@ -3636,6 +3642,9 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
>  		if (nla[NFTA_RULE_HANDLE]) {
>  			rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
>  			if (IS_ERR(rule)) {
> +				if (PTR_ERR(rule) == -ENOENT &&
> +				    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
> +					return 0;
>  				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
>  				return PTR_ERR(rule);
>  			}

I guess you're exceeding the 80 column limit here? Doesn't checkpatch.pl
complain?

Cheers, Phil
