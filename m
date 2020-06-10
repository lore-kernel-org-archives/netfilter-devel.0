Return-Path: <SRS0=m7zW=7X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D9EC433E1
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jun 2020 12:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8D672072E
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jun 2020 12:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgFJMrG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Jun 2020 08:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgFJMrG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jun 2020 08:47:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F291C03E96B
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2020 05:47:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jj08D-0006IT-Jp; Wed, 10 Jun 2020 14:47:01 +0200
Date:   Wed, 10 Jun 2020 14:47:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v4.10] netfilter: nf_conntrack_h323: lost .data_len
 definition for Q.931/ipv6
Message-ID: <20200610124701.GB21317@breakpoint.cc>
References: <c2385b5c-309c-cc64-2e10-a0ef62897502@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2385b5c-309c-cc64-2e10-a0ef62897502@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Vasily Averin <vvs@virtuozzo.com> wrote:
> Could you please push this patch into stable@?
> it fixes memory corruption in kernels  v3.5 .. v4.10
> 
> Lost .data_len definition leads to write beyond end of
> struct nf_ct_h323_master. Usually it corrupts following
> struct nf_conn_nat, however if nat is not loaded it corrupts
> following slab object.
> 
> In mainline this problem went away in v4.11,
> after commit 9f0f3ebeda47 ("netfilter: helpers: remove data_len usage
> for inkernel helpers") however many stable kernels are still affected.
> 
> cc: stable@vger.kernel.org
> Fixes: 1afc56794e03 ("netfilter: nf_ct_helper: implement variable length helper private data") # v3.5
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Reviewed-by: Florian Westphal <fw@strlen.de>
