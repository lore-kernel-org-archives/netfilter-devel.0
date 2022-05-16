Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A410C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 11:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbiEPLKZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 07:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbiEPLKY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 07:10:24 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 937302F004
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 04:10:22 -0700 (PDT)
Date:   Mon, 16 May 2022 13:10:19 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: remove pr_debug callsites
 from tcp tracker
Message-ID: <YoIxGyVSYTxoX2Ll@salvia>
References: <20220512150847.22858-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220512150847.22858-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 12, 2022 at 05:08:47PM +0200, Florian Westphal wrote:
> They are either obsolete or useless.
> 
> Those in the normal processing path cannot be enabled on a production
> system; they generate too much noise.
> 
> One pr_debug call resides in an error path and does provide useful info,
> merge it with the existing nf_log_invalid().

Applied, thanks
