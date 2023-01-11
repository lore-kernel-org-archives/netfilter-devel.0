Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5E4C5479D
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 18:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbjAKSDh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 13:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbjAKSDd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 13:03:33 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECA7FFCE4
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 10:03:32 -0800 (PST)
Date:   Wed, 11 Jan 2023 19:03:30 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [libnetfilter_conntrack PATCH] conntrack: increase the length of
 `l4proto_map`
Message-ID: <Y7758rNEafF9XurG@salvia>
References: <20221223123806.2685611-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221223123806.2685611-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 23, 2022 at 12:38:06PM +0000, Jeremy Sowden wrote:
> With addition of MPTCP `IPPROTO_MAX` is greater than 256, so extend the
> array to account for the new upper bound.

Applied, thanks.

I don't expect we will ever see IPPROTO_MPTCP in this path though.
To my understanding, this definition is targeted at the
setsockopt/getsockopt() use-case. IP headers and the ctnetlink
interface also assumes 8-bits protocol numbers.
