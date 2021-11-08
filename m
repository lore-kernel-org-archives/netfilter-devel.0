Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D42E0C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 11:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B29FE60F36
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Nov 2021 11:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbhKHLXy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 06:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbhKHLXy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 06:23:54 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9635C061570
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Nov 2021 03:21:09 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mk2i2-000593-Tz; Mon, 08 Nov 2021 12:21:06 +0100
Date:   Mon, 8 Nov 2021 12:21:06 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] Unbreak xtables-translate
Message-ID: <20211108112106.GC1668@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jeremy Sowden <jeremy@azazel.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20211106204544.13136-1-phil@nwl.cc>
 <YYf41EwPa8YBKNpY@azazel.net>
 <YYf5vzKUJB3bgQpV@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYf5vzKUJB3bgQpV@azazel.net>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hey Jeremy,

On Sun, Nov 07, 2021 at 04:07:27PM +0000, Jeremy Sowden wrote:
[...]
> Apologies, I'm talking nonsense: .jumpto is a pointer, not an array.
> Ignore me. :)

I wondered at first, but indeed assigning an empty string to an array is
identical to setting all fields zero. :)

Thanks for the review!

Cheers, Phil
