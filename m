Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B081C43334
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Jul 2022 14:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiGKOiR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Jul 2022 10:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiGKOiQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Jul 2022 10:38:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1485365D7D
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2022 07:38:16 -0700 (PDT)
Date:   Mon, 11 Jul 2022 16:38:12 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/3] netfilter: conntrack sparse annotations
Message-ID: <Ysw11PfeElTzlr7i@salvia>
References: <20220622090047.24586-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220622090047.24586-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 22, 2022 at 11:00:44AM +0200, Florian Westphal wrote:
> This series reduces the number of generated sparse warnings
> in the netfilter codebase.
> 
> In some cases its just due to a missing '__rcu' annotation
> of the base pointer, but in some other cases there is a
> direct access to a __rcu annotated base pointer.

Series applied, thanks
