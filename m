Return-Path: <SRS0=TvDw=5Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12584C2D0EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 18:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E063620BED
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 18:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgCaSOT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Mar 2020 14:14:19 -0400
Received: from a3.inai.de ([88.198.85.195]:40042 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgCaSOT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 14:14:19 -0400
Received: by a3.inai.de (Postfix, from userid 25121)
        id 81CB15872C954; Tue, 31 Mar 2020 20:14:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 7F69360C5329E;
        Tue, 31 Mar 2020 20:14:17 +0200 (CEST)
Date:   Tue, 31 Mar 2020 20:14:17 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
In-Reply-To: <20200331163559.132240-1-zenczykowski@gmail.com>
Message-ID: <nycvar.YFH.7.76.2003312012340.6572@n3.vanv.qr>
References: <20200331163559.132240-1-zenczykowski@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2020-03-31 18:35, Maciej Żenczykowski wrote:
>Signed-off-by: Maciej Żenczykowski <maze@google.com>
>---
> include/uapi/linux/netfilter/xt_IDLETIMER.h | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
>index 434e6506abaa..49ddcdc61c09 100644
>--- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
>+++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
>@@ -48,6 +48,7 @@ struct idletimer_tg_info_v1 {
> 
> 	char label[MAX_IDLETIMER_LABEL_SIZE];
> 
>+	__u8 send_nl_msg;   /* unused: for compatibility with Android */
> 	__u8 timer_type;
> 
> 	/* for kernel module internal use only */
>-- 

This breaks the ABI for law-abiding Linux users (i.e. the GNU/Linux 
subgroup of it), which is equally terrible.

You will have to introduce a IDLETIMER v2.
