Return-Path: <SRS0=/QgY=EH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B969CC2D0A3
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Nov 2020 20:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 893DD2074B
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Nov 2020 20:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgKAUVn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Nov 2020 15:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgKAUVn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Nov 2020 15:21:43 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFE4C0617A6
        for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2020 12:21:42 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kZJr7-0005ZR-00; Sun, 01 Nov 2020 21:21:37 +0100
Date:   Sun, 1 Nov 2020 21:21:36 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] doc: correct chain name in example of adding a rule.
Message-ID: <20201101202136.GD15770@breakpoint.cc>
References: <20201101193313.10879-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101193313.10879-1-jeremy@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> The example adds a rule to the `output` chain, not the `input` chain.

Applied, thanks.
