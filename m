Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1346AC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3D7020854
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 15:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbfCRPmS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:42:18 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:51560 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfCRPmS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Mar 2019 11:42:18 -0400
Received: from [195.39.71.253] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1h5uP0-0003T0-L0; Mon, 18 Mar 2019 16:42:16 +0100
Date:   Mon, 18 Mar 2019 16:42:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] xtables-legacy: add missing config.h include
Message-ID: <20190318154214.snghtdepv4h3e4k4@salvia>
References: <20190308143709.27721-1-l.stach@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190308143709.27721-1-l.stach@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Lucas,

I can blindly take this, since I guess you're fixing a problem there.

I guess it's a compilation issue with some specific toolchain? Because
I cannot reproduce this here.

Thanks!

On Fri, Mar 08, 2019 at 03:37:09PM +0100, Lucas Stach wrote:
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> ---
>  iptables/xtables-legacy-multi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/iptables/xtables-legacy-multi.c b/iptables/xtables-legacy-multi.c
> index e68814dd082e..3b7905ff76b1 100644
> --- a/iptables/xtables-legacy-multi.c
> +++ b/iptables/xtables-legacy-multi.c
> @@ -1,3 +1,4 @@
> +#include <config.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> -- 
> 2.20.1
> 
