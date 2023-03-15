Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A70C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 22:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCOWWZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 18:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCOWWY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 18:22:24 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14D330B10
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 15:22:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pcZVm-00015j-94; Wed, 15 Mar 2023 23:22:22 +0100
Date:   Wed, 15 Mar 2023 23:22:22 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Matthieu De Beule <matthieu.debeule@proton.ch>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Correct documentation errors in nf_tables.h
Message-ID: <20230315222222.GA4072@breakpoint.cc>
References: <20230314094412.56298-1-matthieu.debeule@proton.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314094412.56298-1-matthieu.debeule@proton.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Matthieu De Beule <matthieu.debeule@proton.ch> wrote:

Subject should have '[PATCH nf-next] netfilter: ' prefix.

> For NFTA_RANGE_OP incorrectly said it was a nft_cmp_ops instead of nft_range_ops
> NFTA_LOG_GROUP and NFTA_LOG_QTHRESHOLD were documented as NLA_U32 instead of NLA_U16

scripts/checkpatch.pl 0001*
ERROR: Missing Signed-off-by: line by nominal patch author 'Matthieu De Beule <matthieu.debeule@proton.ch>'

Please fix this up and send a v2.
