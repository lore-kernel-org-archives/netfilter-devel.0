Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB8CEB64DA
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 12:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjGEMh3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 08:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjGEMh2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 08:37:28 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 98C49116
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Jul 2023 05:37:27 -0700 (PDT)
Date:   Wed, 5 Jul 2023 14:37:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, faicker.mo@ucloud.cn
Subject: Re: [PATCH nf] netfilter: conntrack: gre: don't set assured flag for
 clash entries
Message-ID: <ZKVkA08uTHPBl1cq@calendula>
References: <20230703114318.20997-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230703114318.20997-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 03, 2023 at 01:43:18PM +0200, Florian Westphal wrote:
> Now that conntrack core is allowd to insert clashing entries, make sure
> GRE won't set assured flag on NAT_CLASH entries, just like UDP.
> 
> Doing so prevents early_drop logic for these entries.

Applied, thanks.
