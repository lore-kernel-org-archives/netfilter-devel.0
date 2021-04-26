Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD40C433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 10:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B8A060FE9
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 10:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbhDZKr7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 06:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhDZKr6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 06:47:58 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB80C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Apr 2021 03:47:14 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id BF57E587232F7; Mon, 26 Apr 2021 12:47:12 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id BAB4A60C2198E;
        Mon, 26 Apr 2021 12:47:12 +0200 (CEST)
Date:   Mon, 26 Apr 2021 12:47:12 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: allow to turn off xtables compat
 layer
In-Reply-To: <20210426101440.25335-1-fw@strlen.de>
Message-ID: <25p6qsnp-r7p1-ps60-s7np-nsq1899446n2@vanv.qr>
References: <20210426101440.25335-1-fw@strlen.de>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Monday 2021-04-26 12:14, Florian Westphal wrote:

>The compat layer needs to parse untrusted input (the ruleset)
>to translate it to a 64bit compatible format.
>
>We had a number of bugs in this department in the past, so allow users
>to turn this feature off.
>
>+++ b/include/linux/netfilter/x_tables.h
>@@ -158,7 +158,7 @@ struct xt_match {
> 
> 	/* Called when entry of this type deleted. */
> 	void (*destroy)(const struct xt_mtdtor_param *);
>-#ifdef CONFIG_COMPAT
>+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
> 	/* Called when userspace align differs from kernel space one */
> 	void (*compat_from_user)(void *dst, const void *src);
> 	int (*compat_to_user)(void __user *dst, const void *src);

There are not a lot of '\.compat_to_user' instaces anymore. It would appear we
managed to throw out most of the flexing structs over the past 15 years.

Perhaps the remaining one (struct xt_rateinfo) could be respecified
as a v1, with the plan to ditch the v0.

Then the entire xtables_compat code could go as well.
