Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5446FC43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 01:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30F37610A2
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Sep 2021 01:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbhIUB5Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Sep 2021 21:57:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39646 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236231AbhIUBt4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 21:49:56 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 38B4B63EB1;
        Tue, 21 Sep 2021 03:47:10 +0200 (CEST)
Date:   Tue, 21 Sep 2021 03:48:25 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/2] netfilter: nf_nat_masquerade: don't block rtnl
 lock
Message-ID: <YUk56VxnSw1FzeCD@salvia>
References: <20210915144639.25024-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210915144639.25024-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 15, 2021 at 04:46:37PM +0200, Florian Westphal wrote:
> nf_nat_masquerade registers conntrack notifiers to early-expire
> conntracks that have been using the downed device/removed address.
> 
> With large number of disappearing devices (ppp), iterating the table
> for every notification blocks the rtnl lock for multiple seconds.
> 
> This change unconditionally defers the walk to the system work queue
> so that rtnl lock is not blocked longer than needed.
> 
> This is not a regression, the notifier and cleanup walk have existed
> since the functionality was added more than 20 years ago.

Series applied, thanks.
