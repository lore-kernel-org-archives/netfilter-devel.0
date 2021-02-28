Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9729FC433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Feb 2021 16:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FB0564E4A
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Feb 2021 16:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhB1Q6U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Feb 2021 11:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhB1Q6T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Feb 2021 11:58:19 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45E7C061756
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Feb 2021 08:57:38 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 19690592CCBA5; Sun, 28 Feb 2021 17:57:35 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 1495660E5A1DF;
        Sun, 28 Feb 2021 17:57:35 +0100 (CET)
Date:   Sun, 28 Feb 2021 17:57:35 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     andy@asjohnson.com
cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE: [PATCH] xtables-addons 3.15 doesn't compile on 32-bit x86
In-Reply-To: <20210228075456.fcdaf64278890662106b299d41e0899d.6d7dc7cab7.wbe@email05.godaddy.com>
Message-ID: <5sp61o25-o492-1ons-3o9-qq8q205spnr2@vanv.qr>
References: <20210228075456.fcdaf64278890662106b299d41e0899d.6d7dc7cab7.wbe@email05.godaddy.com>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sunday 2021-02-28 15:54, andy@asjohnson.com wrote:

>The original patch for long division on x86 didn't take into account
>the use of short circuit logic for checking if peer is NULL before
>testing it. Here is a revised patch to v3.16:
>
>--- xtables-addons-3.16-orig/extensions/pknock/xt_pknock.c
>+++ xtables-addons-3.16-patched/extensions/pknock/xt_pknock.c
>@@ -311,9 +311,13 @@
> static inline bool
> autoclose_time_passed(const struct peer *peer, unsigned int
>autoclose_time)
> {

Applied.

