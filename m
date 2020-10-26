Return-Path: <SRS0=LVSz=EB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B6DC2D0A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Oct 2020 10:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E45D207E8
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Oct 2020 10:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769657AbgJZK0V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Oct 2020 06:26:21 -0400
Received: from a3.inai.de ([88.198.85.195]:56350 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1768334AbgJZK0U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Oct 2020 06:26:20 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 06:26:20 EDT
Received: by a3.inai.de (Postfix, from userid 25121)
        id C86515872642B; Mon, 26 Oct 2020 11:20:09 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id C34E560C26F0F;
        Mon, 26 Oct 2020 11:20:09 +0100 (CET)
Date:   Mon, 26 Oct 2020 11:20:09 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons] pnock: pknlusr: mention the group ID
 command-line paramater in the man-page.
In-Reply-To: <20201025181551.962197-1-jeremy@azazel.net>
Message-ID: <959466qq-rr2q-7334-3q5s-r3nsno359712@vanv.qr>
References: <20201025181551.962197-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sunday 2020-10-25 19:15, Jeremy Sowden wrote:

>-\fBpknlusr\fP
>+\fBpknlusr\fP [ \fIgroup-id\fP ]

processed
