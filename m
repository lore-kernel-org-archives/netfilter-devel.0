Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B0FC32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F018120665
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 19:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfHMTOH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 15:14:07 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57392 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbfHMTOH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 15:14:07 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hxcFC-0003s8-Bn; Tue, 13 Aug 2019 21:14:06 +0200
Date:   Tue, 13 Aug 2019 21:14:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] netfilter: nft_meta: support for time matching
Message-ID: <20190813191406.lhsz3y4bbmuzixxi@breakpoint.cc>
References: <20190813183820.6659-1-a@juaristi.eus>
 <20190813183820.6659-2-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813183820.6659-2-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> +++ b/net/netfilter/nft_meta.c
> @@ -28,6 +28,27 @@
>  
>  static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
>  
> +static u8 nft_meta_weekday(unsigned long secs)
> +{
> +	u8 wday;
> +	unsigned int dse;
> +
> +	secs -= 60 * sys_tz.tz_minuteswest;
> +	dse = secs / 86400;

This will probably fail to compile (link) on 32bit arches.
You need to use do_div() here.

> +	wday = (4 + dse) % 7;

This is fine, as this only involves 32bit integers.
