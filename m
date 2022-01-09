Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B120C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 16:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbiAIQWZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 11:22:25 -0500
Received: from mail.netfilter.org ([217.70.188.207]:41540 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiAIQWZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 11:22:25 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 69B62607C1;
        Sun,  9 Jan 2022 17:19:34 +0100 (CET)
Date:   Sun, 9 Jan 2022 17:22:19 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Aaron Thompson <dev@aaront.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] conntrackd: cthelper: ssdp: Fix parsing
 of IPv6 M-SEARCH requests.
Message-ID: <YdsLu/KbgJ6ZfJhO@salvia>
References: <0101017e389aaaf3-3e2018c8-b439-403f-ba4c-0900581f733c-000000@us-west-2.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0101017e389aaaf3-3e2018c8-b439-403f-ba4c-0900581f733c-000000@us-west-2.amazonses.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jan 08, 2022 at 07:32:47AM +0000, Aaron Thompson wrote:
> Use the already correctly determined transport header offset instead of
> assuming that the packet is IPv4.

Applied, thanks
