Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AC7C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 16:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiAOQs2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 11:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiAOQs1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 11:48:27 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E4FC061574
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 08:48:27 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1n8mE4-0006Xg-BX; Sat, 15 Jan 2022 17:48:24 +0100
Date:   Sat, 15 Jan 2022 17:48:24 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH 08/11] src: add a helper that returns a payload
 dependency for a particular base
Message-ID: <YeL62HGr/mHp37pe@strlen.de>
References: <20211221193657.430866-1-jeremy@azazel.net>
 <20211221193657.430866-9-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221193657.430866-9-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> Currently, with only one base and dependency stored this is superfluous,
> but it will become more useful when the next commit adds support for
> storing a payload for every base.

> +	dep = payload_dependency_get(ctx, PROTO_BASE_NETWORK_HDR)->expr;

This new helper can return NULL, would you mind reworking this to add
error checks here?

I've applied all patches up to this one.
