Return-Path: <SRS0=t7ih=D6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236F6C388F9
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Oct 2020 09:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEDFF2192A
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Oct 2020 09:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S461392AbgJWJYS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Oct 2020 05:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S461335AbgJWJYS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Oct 2020 05:24:18 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33699C0613CE
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2020 02:24:18 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id C79D95872C95F; Fri, 23 Oct 2020 11:24:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id C6A6060C26F0F;
        Fri, 23 Oct 2020 11:24:16 +0200 (CEST)
Date:   Fri, 23 Oct 2020 11:24:16 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 3/3] pknock: pknlusr: add man-page.
In-Reply-To: <20201022173006.635720-4-jeremy@azazel.net>
Message-ID: <2p319p4q-576n-34r9-6oqn-7n93p6892rr@vanv.qr>
References: <20201022173006.635720-1-jeremy@azazel.net> <20201022173006.635720-4-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2020-10-22 19:30, Jeremy Sowden wrote:

>Since pknlusr is now being installed, let's give it a man-page.

There's a lot of.. markup I have never seen before (and thus did not feel would
be necessary).
I pushed a shortened version; if anything should be different, please send more
patches on top. Thanks!
