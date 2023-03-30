Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF61C761A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Mar 2023 11:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjC3LwM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 07:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbjC3Lvp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 07:51:45 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE98186
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Mar 2023 04:51:13 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 95829587438DA; Thu, 30 Mar 2023 13:51:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 8E89D61C7F2A5;
        Thu, 30 Mar 2023 13:51:10 +0200 (CEST)
Date:   Thu, 30 Mar 2023 13:51:10 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
cc:     netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH] nft: autocomplete for libreadline
In-Reply-To: <20230330112535.31483-1-sriram.yagnaraman@est.tech>
Message-ID: <69r697s-n01r-s6qs-q766-1n31826q6s0@vanv.qr>
References: <20230330112535.31483-1-sriram.yagnaraman@est.tech>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2023-03-30 13:25, Sriram Yagnaraman wrote:

>-libnftables_LIBVERSION=2:0:1
>+libnftables_LIBVERSION=3:0:1

^ This looks very much incorrect.

>--- a/include/nftables/libnftables.h
>+++ b/include/nftables/libnftables.h
>+char **nft_get_expected_tokens(struct nft_ctx *nft, const char *line, const char *text);
>--- a/include/parser.h
>+++ b/include/parser.h
>+extern char **expected_matches (struct nft_ctx *nft, struct parser_state *state,
>+				const char *text);
