Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC87FC77B7A
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 21:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbjFFVEd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 17:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbjFFVEb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 17:04:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69476171D
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 14:04:29 -0700 (PDT)
Date:   Tue, 6 Jun 2023 23:04:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: Re: [PATCH nf-next,v2 5/7] netfilter: nf_tables: add meta + cmp
 combo match
Message-ID: <ZH+fWLdwN+4QVW2V@calendula>
References: <20230606163533.1533-1-pablo@netfilter.org>
 <20230606163533.1533-6-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230606163533.1533-6-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 06, 2023 at 06:35:31PM +0200, Pablo Neira Ayuso wrote:
> This patch allows to coalesce meta iifname,oifname + cmp into one combo
> expression.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: fix nft_cmp16_mask() bitmask byteorder.

nft_cmp16_mask() byteorder was correct in v1, and it is not fine in
this iteration, I will fix this in v3.
