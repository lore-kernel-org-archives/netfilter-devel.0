Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3BDC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 21:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLHVp4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 16:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHVp4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 16:45:56 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2B914A5B8
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 13:45:55 -0800 (PST)
Date:   Thu, 8 Dec 2022 22:45:53 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Robert O'Brien <robrien@foxtrot-research.com>
Subject: Re: [PATCH ulogd2 3/3] src: keep IPv4 addresses internally in
 IPv4-in-IPv6 format
Message-ID: <Y5JbEVwsHcxPKI6N@salvia>
References: <20221127002300.191936-1-jeremy@azazel.net>
 <20221127002300.191936-4-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221127002300.191936-4-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Nov 27, 2022 at 12:23:00AM +0000, Jeremy Sowden wrote:
> Hitherto, some plug-ins have converted converted IP addresses to
> host-endianness or assumed that they already have been, and several have
> assumed that all IP addresses are IPv4.  This can lead to garbled output
> if the expectations of plug-ins in a stack do not match.  Convert all IP
> addresses to IPv6, using IPv4-inIPv6 for IPv4.  Convert IPv4 addresses
> back for formatting.
> 
> Move a couple of `ULOGD_RET_BOOL` cases for consistency.

This patch does not apply here anymore. Please, rebase.

Thanks
