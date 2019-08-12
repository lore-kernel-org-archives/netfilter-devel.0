Return-Path: <SRS0=yud9=WI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A595C31E40
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 15:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 473AB2070C
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 15:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfHLP1i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Aug 2019 11:27:38 -0400
Received: from a3.inai.de ([88.198.85.195]:60478 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbfHLP1h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Aug 2019 11:27:37 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Aug 2019 11:27:36 EDT
Received: by a3.inai.de (Postfix, from userid 25121)
        id B120C3BB6EF6; Mon, 12 Aug 2019 17:17:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id AA9AF3BB6EF2;
        Mon, 12 Aug 2019 23:17:52 +0800 (CST)
Date:   Mon, 12 Aug 2019 23:17:52 +0800 (CST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        =?UTF-8?Q?Franta_Hanzl=C3=ADk?= <franta@hanzlici.cz>
Subject: Re: [PATCH xtables-addons v2 1/2] xt_pknock, xt_SYSRQ: don't set
 shash_desc::flags.
In-Reply-To: <20190812115742.21770-2-jeremy@azazel.net>
Message-ID: <nycvar.YFH.7.76.1908122317330.19510@n3.vanv.qr>
References: <20190811113826.5e594d8f@franta.hanzlici.cz> <20190812115742.21770-1-jeremy@azazel.net> <20190812115742.21770-2-jeremy@azazel.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Monday 2019-08-12 19:57, Jeremy Sowden wrote:

>shash_desc::flags was removed from the kernel in 5.1.
>
>Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
>---
> extensions/pknock/xt_pknock.c | 1 -
> extensions/xt_SYSRQ.c         | 1 -
> 2 files changed, 2 deletions(-)
>
>diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
>index c76901ac4c1a..8021ea07e1b9 100644
>--- a/extensions/pknock/xt_pknock.c
>+++ b/extensions/pknock/xt_pknock.c
>@@ -1125,7 +1125,6 @@ static int __init xt_pknock_mt_init(void)
> 
> 	crypto.size = crypto_shash_digestsize(crypto.tfm);
> 	crypto.desc.tfm = crypto.tfm;
>-	crypto.desc.flags = 0;

But this will still be needed for 5.0 I guess, so it cannot just be 
unconditionally removed.
