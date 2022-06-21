Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698FAC43334
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jun 2022 08:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiFUItF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jun 2022 04:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiFUItF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jun 2022 04:49:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73A5A26100
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2022 01:49:03 -0700 (PDT)
Date:   Tue, 21 Jun 2022 10:48:57 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/2] netfilter: fix two nf_dup bugs with egress hook
Message-ID: <YrGF+bXbFWHVVRkI@salvia>
References: <20220620141731.7362-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220620141731.7362-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 20, 2022 at 04:17:29PM +0200, Florian Westphal wrote:
> We need to be more careful now that nf_dup is exposed to new
> egress hook.
> 
> When called from egress hook, we need to skip push of mac header,
> this is only ok for ingress invocation.
> 
> Also add a  recursion counter to prevent re-entry into the expression.

Series applied, thanks
