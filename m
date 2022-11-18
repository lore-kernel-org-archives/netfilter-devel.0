Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA310C352A1
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Nov 2022 13:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbiKRNgk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Nov 2022 08:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241973AbiKRNgR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Nov 2022 08:36:17 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F3794A6B
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Nov 2022 05:34:34 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ow1Vn-0002e2-TN; Fri, 18 Nov 2022 14:34:31 +0100
Date:   Fri, 18 Nov 2022 14:34:31 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 0/4] xt: Implement dump and restore support
Message-ID: <20221118133431.GE15714@breakpoint.cc>
References: <20221117174546.21715-1-phil@nwl.cc>
 <20221117211347.GB15714@breakpoint.cc>
 <Y3dUxJZ6J4mg/KNh@orbyte.nwl.cc>
 <Y3daXmuU0Nsyeij6@salvia>
 <Y3dhhVpfoA73W3kA@orbyte.nwl.cc>
 <20221118114643.GD15714@breakpoint.cc>
 <Y3d2qqm2r8Z8Tbih@orbyte.nwl.cc>
 <Y3d4JEmztrNTbK99@salvia>
 <Y3d5eqTGTwEAa2Dq@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3d5eqTGTwEAa2Dq@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> This one:
> 
> Subject: [nft PATCH] Warn for tables with compat expressions in rules
> Date: Wed, 12 Oct 2022 17:31:07 +0200
> Message-Id: <20221012153107.24574-1-phil@nwl.cc>

This is:
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20221012153107.24574-1-phil@nwl.cc/

LGTM, no objections from me.
