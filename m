Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F231C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Mar 2022 22:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245024AbiCJWrQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Mar 2022 17:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244773AbiCJWrQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Mar 2022 17:47:16 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0CC117924F
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Mar 2022 14:46:14 -0800 (PST)
Received: from netfilter.org (unknown [46.222.150.172])
        by mail.netfilter.org (Postfix) with ESMTPSA id 53642625FB;
        Thu, 10 Mar 2022 23:44:11 +0100 (CET)
Date:   Thu, 10 Mar 2022 23:46:09 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: Re: [PATCH nf] netfilter: nf_tables: cancel register tracking if
 .reduce is not defined
Message-ID: <Yip/sZy4bSD5/VhO@salvia>
References: <20220310223737.5261-1-pablo@netfilter.org>
 <Yip+xOb4KfpbvfTq@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yip+xOb4KfpbvfTq@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 10, 2022 at 11:42:17PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 10, 2022 at 11:37:37PM +0100, Pablo Neira Ayuso wrote:
> > Cancel all register tracking if the the reduce function is not defined.
> > Add missing reduce function to cmp since this is a read-only operation.
> > 
> > This unbreaks selftests/netfilter/nft_nat_zones.sh.
> > 
> > Fixes: 12e4ecfa244b ("netfilter: nf_tables: add register tracking infrastructure")
> > Suggested-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> 
> Actually intended to nf-next.

Oh, this is nf material indeed. Sorry for the confusion.
