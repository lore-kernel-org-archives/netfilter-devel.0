Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A9CC77B7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 06:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbjEJGlm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 02:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbjEJGll (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 02:41:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 22C8A5592
        for <netfilter-devel@vger.kernel.org>; Tue,  9 May 2023 23:41:08 -0700 (PDT)
Date:   Wed, 10 May 2023 08:40:42 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] testing: selftests: nft_flowtable.sh: check
 ingress/egress chain too
Message-ID: <ZFs8TAsFLOb+FQ6H@calendula>
References: <20230509144724.23992-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230509144724.23992-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 09, 2023 at 04:47:24PM +0200, Florian Westphal wrote:
> Make sure flowtable interacts correctly with ingress and egress
> chains, i.e. those get handled before and after flow table respectively.
> 
> Adds three more tests:
> 1. repeat flowtable test, but with 'ip dscp set cs3' done in
>    inet forward chain.
> 
> Expect that some packets have been mangled (before flowtable offload
> became effective) while some pass without mangling (after offload
> succeeds).
> 
> 2. repeat flowtable test, but with 'ip dscp set cs3' done in
>    veth0:ingress.
> 
> Expect that all packets pass with cs3 dscp field.
> 
> 3. same as 2, but use veth1:egress.  Expect the same outcome.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  This is on top of Boris changes to nft_flowtable.sh script.

This applies cleanly to nf.git, are you fine if I place this on that tree?

Thanks.
