Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD367C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jan 2022 11:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239039AbiALLcT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jan 2022 06:32:19 -0500
Received: from mail.netfilter.org ([217.70.188.207]:48976 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbiALLcR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 06:32:17 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A4EB2605C6;
        Wed, 12 Jan 2022 12:29:24 +0100 (CET)
Date:   Wed, 12 Jan 2022 12:32:11 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [bug report] netfilter: nf_tables: add register tracking
 infrastructure
Message-ID: <Yd68O1lI+F5yUSGH@salvia>
References: <20220112111608.GA3019@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220112111608.GA3019@kili>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 12, 2022 at 02:16:08PM +0300, Dan Carpenter wrote:
> Hello Pablo Neira Ayuso,
> 
> The patch 12e4ecfa244b: "netfilter: nf_tables: add register tracking
> infrastructure" from Jan 9, 2022, leads to the following Smatch
> static checker warning:
> 
> 	net/netfilter/nf_tables_api.c:8303 nf_tables_commit_chain_prepare()
> 	error: uninitialized symbol 'last'.
> 
> net/netfilter/nf_tables_api.c
>     8259 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
>     8260 {
>     8261         const struct nft_expr *expr, *last;
>                                                ^^^^

Thanks:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220112113134.340731-1-pablo@netfilter.org/
