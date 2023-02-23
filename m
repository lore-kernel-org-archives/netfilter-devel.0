Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54293C61DA4
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Feb 2023 22:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBWWCD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Feb 2023 17:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBWWCC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2023 17:02:02 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A3251911
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2023 14:01:59 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 041E25872D164; Thu, 23 Feb 2023 23:01:56 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id F23C860D9ABC8;
        Thu, 23 Feb 2023 23:01:56 +0100 (CET)
Date:   Thu, 23 Feb 2023 23:01:56 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: bridge: introduce broute meta
 statement
In-Reply-To: <20230223202246.15640-1-sriram.yagnaraman@est.tech>
Message-ID: <qrnr732-rn50-40q9-sqop-31p63885s928@vanv.qr>
References: <20230223202246.15640-1-sriram.yagnaraman@est.tech>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2023-02-23 21:22, Sriram Yagnaraman wrote:
>+++ b/net/bridge/netfilter/nft_meta_bridge.c
>@@ -8,6 +8,7 @@
> #include <net/netfilter/nf_tables.h>
> #include <net/netfilter/nft_meta.h>
> #include <linux/if_bridge.h>
>+#include <../br_private.h>

This hurts my eye. At least, let's have "../br_private.h"?
