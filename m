Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE90EB64DC
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Jun 2023 08:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjFYIsJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Jun 2023 04:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbjFYIsI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Jun 2023 04:48:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564B21A1
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jun 2023 01:48:06 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qDLPf-00026m-Fx; Sun, 25 Jun 2023 10:48:03 +0200
Date:   Sun, 25 Jun 2023 10:48:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ulogd2 PATCH] Makefile: Create LZMA-compressed dist-files
Message-ID: <ZJf/QztHGFhrfg1z@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20230623144520.970-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230623144520.970-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 23, 2023 at 04:45:20PM +0200, Phil Sutter wrote:
> Use a more modern alternative to bzip2.
> 
> Suggested-by: Jan Engelhardt <jengelh@inai.de>
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
