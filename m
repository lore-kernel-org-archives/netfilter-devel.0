Return-Path: <SRS0=dbJk=VL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F56C73C66
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jul 2019 23:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34B0820C01
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jul 2019 23:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfGNX2K convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jul 2019 19:28:10 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46926 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728803AbfGNX2K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jul 2019 19:28:10 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hmnua-00018j-Ua; Mon, 15 Jul 2019 01:28:09 +0200
Date:   Mon, 15 Jul 2019 01:28:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nft_meta: support for time matching
Message-ID: <20190714232808.rb3wc44ij7ixz376@breakpoint.cc>
References: <20190707205707.6728-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190707205707.6728-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> This patch introduces meta matches in the kernel for time (a UNIX timestamp),
> day (a day of week, represented as an integer between 0-6), and
> hour (an hour in the current day, or: number of seconds since midnight).
> 
> All values are taken as unsigned 64-bit integers.
> 
> The 'time' keyword is internally converted to nanoseconds by nft in
> userspace, and hence the timestamp is taken in nanoseconds as well.

I think this is conceptually fine, thanks Ander.

Can you run this throuch scripts/checkpatch.pl and fix up the style
nits?

> +	case NFT_META_TIME_HOUR:
> +		len = sizeof(u64);

As in my other comment, I think this can be u32.
