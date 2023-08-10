Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C5BC001DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 11:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbjHJLyD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 07:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbjHJLyD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 07:54:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414E791
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 04:54:02 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qU4Eq-0004ln-Cp; Thu, 10 Aug 2023 13:54:00 +0200
Date:   Thu, 10 Aug 2023 13:54:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH v2 1/2] nft-ruleparse: Introduce
 nft_create_target()
Message-ID: <ZNTP2ASMnaAyhSIW@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20230804231537.17705-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804231537.17705-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 05, 2023 at 01:15:36AM +0200, Phil Sutter wrote:
> Like nft_create_match(), this is a small wrapper around the typical
> target extension lookup and (standard) init code.
> 
> To use it from nft_parse_target() and nft_parse_log(), introduce an
> inner variant which accepts the target payload size as parameter.
> 
> The call to rule_parse_ops::target callback was problematic with
> standard target, because the callbacks initialized
> iptables_command_state::jumpto with the target name, "standard" in that
> case. Perform its tasks in nft_create_target(), keep it only for bridge
> family's special handling of watcher "targets".
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
