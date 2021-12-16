Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C826C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 13:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbhLPNKh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 08:10:37 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58278 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237313AbhLPNKh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 08:10:37 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CC922625C5;
        Thu, 16 Dec 2021 14:08:07 +0100 (CET)
Date:   Thu, 16 Dec 2021 14:10:32 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Vitaly Zuevsky <vzuevsky@ns1.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove expired entries first
Message-ID: <Ybs6yD5tDeV4GzWO@salvia>
References: <20211209163926.25563-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211209163926.25563-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 09, 2021 at 05:39:26PM +0100, Florian Westphal wrote:
> When dumping conntrack table to userspace via ctnetlink, check if the ct has
> already expired before doing any of the 'skip' checks.
> 
> This expires dead entries faster.
> /proc handler also removes outdated entries first.

Applied, thanks
