Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A41C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 05:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbiBDFTe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 00:19:34 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49198 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiBDFTe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 00:19:34 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5451860014;
        Fri,  4 Feb 2022 06:19:28 +0100 (CET)
Date:   Fri, 4 Feb 2022 06:19:30 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next] netfilter: exthdr: add support for tcp option
 removal
Message-ID: <Yfy3Ygk75CD80r2N@salvia>
References: <20220128120036.13449-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220128120036.13449-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 28, 2022 at 01:00:36PM +0100, Florian Westphal wrote:
> This allows to replace a tcp option with nop padding to selectively disable
> a particular tcp option.
> 
> Optstrip mode is chosen when userspace passes the exthdr expression with
> neither a source nor a destination register attribute.
> 
> This is identical to xtables TCPOPTSTRIP extension.
> The only difference is that TCPOPTSTRIP allows to pass in a bitmap
> of options to remove rather than a single number.
> 
> Unlike TCPOPTSTRIP this expression can be used multiple times
> in the same rule to get the same effect.
> 
> We could add a new nested attribute later on in case there is a
> use case for single-expression-multi-remove.

Also applied, thanks
