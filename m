Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44650C04A95
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 11:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbiI1Lmo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 07:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbiI1Lmn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 07:42:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC442F3A5
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 04:42:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1odVSb-0003wr-AL; Wed, 28 Sep 2022 13:42:41 +0200
Date:   Wed, 28 Sep 2022 13:42:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 0/5] Fixes around ebtables' --proto match
Message-ID: <20220928114241.GJ12777@breakpoint.cc>
References: <20220927221512.7400-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927221512.7400-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> During some code merge, I created an ugly situation where local OPT_*
> defines in xtables-eb.c override OPT_* enum values from xshared.h with
> same name but different value.
> 
> The above became problematic when I curtly added --verbose support to
> ebtables-nft in order to support -vv debug output. The used OPT_VERBOSE
> symbol stemmed from xshared.h and its value clashed with OPT_PROTOCOL.
> In practice, this turned verbose mode on for rules with protocol match.
> 
> Fix all the above by merging the different OPT_* symbols in the first
> three patches.
> 
> The second more relevant issue was ebtables' lack of support for '-p
> LENGTH', foremost a mandatory prerequisite for 802_3 extension matches
> validity. The last two patches resolve this.

Series:
Reviewed-by: Florian Westphal <fw@strlen.de>
