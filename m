Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC4CC5519F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 16:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02AC620781
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 16:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgKVQXV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Nov 2020 11:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbgKVQXV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Nov 2020 11:23:21 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7628DC0613CF
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2020 08:23:21 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id A391E58730009; Sun, 22 Nov 2020 17:23:19 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id A230A60C43A52;
        Sun, 22 Nov 2020 17:23:19 +0100 (CET)
Date:   Sun, 22 Nov 2020 17:23:19 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 2/4] geoip: fix man-page typo'.
In-Reply-To: <20201122140530.250248-3-jeremy@azazel.net>
Message-ID: <386s1s8-54nr-r91o-218o-56po8r34r7q@vanv.qr>
References: <20201122140530.250248-1-jeremy@azazel.net> <20201122140530.250248-3-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Sunday 2020-11-22 15:05, Jeremy Sowden wrote:
>Subject: geoip: fix man-page typo'.
>Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Rhetoric: How much more interpunction do you want to add to the subject 
lines?
Neither apostrophe nor period belong into it.
