Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF1EC38145
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Sep 2022 15:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiIHPho (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 11:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiIHPhP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 11:37:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653A8E6B8E
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2022 08:37:13 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oWJaZ-0006XQ-2h; Thu, 08 Sep 2022 17:37:11 +0200
Date:   Thu, 8 Sep 2022 17:37:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft 0/3] nft: prefer meta pkttype to
 libxt_pkttype
Message-ID: <YxoMJxDrzmh0nQRM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20220908151242.26838-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908151242.26838-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 08, 2022 at 05:12:39PM +0200, Florian Westphal wrote:
> low hanging fruit: use native meta+cmp instead of libxt_pkttype.
> First patch adds dissection, second patch switches to native expression.
> 
> Last patch adds support for 'otherhost' mnemonic, useless for iptables
> but useful for ebtables.

Reviewed-by: Phil Sutter <phil@nwl.cc>
