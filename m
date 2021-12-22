Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 753DBC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Dec 2021 23:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234213AbhLVXuV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Dec 2021 18:50:21 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41610 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbhLVXuT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Dec 2021 18:50:19 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7077C607C4;
        Thu, 23 Dec 2021 00:47:43 +0100 (CET)
Date:   Thu, 23 Dec 2021 00:50:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: exthdr: add support for tcp option
 removal
Message-ID: <YcO5tQz5ImOxtZLx@salvia>
References: <20211220143247.554667-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211220143247.554667-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 20, 2021 at 03:32:47PM +0100, Florian Westphal wrote:
> This allows to replace a tcp option with nop padding to selectively disable
> a particular tcp option.
> 
> Optstrip mode is chosen when userspace passes the exthdr expression with
> neither a source nor a destination register attribute.
> 
> This is identical to xtables TCPOPTSTRIP extension.

Is it worth to retain the bitmap approach?

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  proposed userspace syntax is:
> 
>  nft add rule f in delete tcp option sack-perm

   nft add rule f in tcp option reset sack-perm,...
