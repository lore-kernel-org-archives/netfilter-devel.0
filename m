Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D86A0C5519F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 16:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B07220781
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 16:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgKVQzF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Nov 2020 11:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbgKVQzF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Nov 2020 11:55:05 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD407C0613CF
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2020 08:55:04 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 53BC25875029A; Sun, 22 Nov 2020 17:55:03 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 4DB8A60D39B05;
        Sun, 22 Nov 2020 17:55:03 +0100 (CET)
Date:   Sun, 22 Nov 2020 17:55:03 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 0/4] geoip: script fixes
In-Reply-To: <20201122140530.250248-1-jeremy@azazel.net>
Message-ID: <702191n9-1n33-9027-n968-nqs36r0q288@vanv.qr>
References: <20201122140530.250248-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sunday 2020-11-22 15:05, Jeremy Sowden wrote:

>A couple of fixes and some man-pages for the MaxMind geoip scripts.
>
>Jeremy Sowden (4):
>  geoip: remove superfluous xt_geoip_fetch_maxmind script.
>  geoip: fix man-page typo'.
>  geoip: add man-pages for MaxMind scripts.
>  geoip: use correct download URL for MaxMind DB's.

Applied.
