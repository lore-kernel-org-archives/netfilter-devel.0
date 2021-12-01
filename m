Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898C3C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 13:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349507AbhLANNk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 08:13:40 -0500
Received: from mail.netfilter.org ([217.70.188.207]:53842 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244690AbhLANNj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 08:13:39 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B0497605C1;
        Wed,  1 Dec 2021 14:07:59 +0100 (CET)
Date:   Wed, 1 Dec 2021 14:10:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/3] netlink_delinearize cleanups
Message-ID: <Yad0NcCxBgserhOp@salvia>
References: <20211201115956.13252-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211201115956.13252-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 01, 2021 at 12:59:53PM +0100, Florian Westphal wrote:
> No indended behavioural changes here.
> binop postprocessing has been extended a lot and in a few places
> things only work because expr->map and expr->left alias to the same
> location.

LGTM.

We should add more type sanitization to expressions at some point, the
risk is that this might break a few things not covered by tests though.
