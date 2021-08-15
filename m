Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43CBC4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 11:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8219861029
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Aug 2021 11:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhHOLab (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Aug 2021 07:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhHOLaa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Aug 2021 07:30:30 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02CCC061764
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Aug 2021 04:30:00 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 3B7F65872F7AD; Sun, 15 Aug 2021 13:29:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 36EC360FC86E5;
        Sun, 15 Aug 2021 13:29:59 +0200 (CEST)
Date:   Sun, 15 Aug 2021 13:29:59 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] libxt_ACCOUNT_cl: correct LDFLAGS variable name.
In-Reply-To: <20210814143359.4582-1-jeremy@azazel.net>
Message-ID: <7213o87n-4rps-8s85-49r3-82sp51pq41pq@vanv.qr>
References: <20210814143359.4582-1-jeremy@azazel.net>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Saturday 2021-08-14 16:33, Jeremy Sowden wrote:

>The LT library name is libxt_ACCOUNT_cl.la, so the variable should be
>`libxt_ACCOUNT_cl_la_LDFLAGS`.

Applied.
