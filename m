Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33EBC432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 00:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 747BF6023F
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 00:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhH3ARS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Aug 2021 20:17:18 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38472 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhH3ARR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Aug 2021 20:17:17 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 77EA460201;
        Mon, 30 Aug 2021 02:15:25 +0200 (CEST)
Date:   Mon, 30 Aug 2021 02:16:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log 0/6] Implementation of some fields
 omitted by `ipulog_get_packet`.
Message-ID: <20210830001621.GA15908@salvia>
References: <20210828193824.1288478-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210828193824.1288478-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 28, 2021 at 08:38:18PM +0100, Jeremy Sowden wrote:
> The first four patches contain some miscellaneous improvements, then the
> last two add code to retrieve time-stamps and interface names from
> packets.

Applied, thanks.

> Incidentally, I notice that the last release of libnetfilter_log was in
> 2012.  Time for 1.0.2, perhaps?

I'll prepare for release, thanks for signalling.
