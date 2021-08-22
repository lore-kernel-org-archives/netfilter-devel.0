Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CCBAC432BE
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 11:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 199D761266
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 11:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhHVLNG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 07:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbhHVLNG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 07:13:06 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BD1C061575
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 04:12:25 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 7299D586F770C; Sun, 22 Aug 2021 13:12:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 6DD1C60C2C522;
        Sun, 22 Aug 2021 13:12:23 +0200 (CEST)
Date:   Sun, 22 Aug 2021 13:12:23 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] Add DWARF object files to .gitignore.
In-Reply-To: <20210821101724.602037-1-jeremy@azazel.net>
Message-ID: <q825q55-4o2p-4527-6541-7139sospo2q@vanv.qr>
References: <20210821101724.602037-1-jeremy@azazel.net>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Saturday 2021-08-21 12:17, Jeremy Sowden wrote:

>If we build against a kernel with `CONFIG_DEBUG_INFO_SPLIT` enabled, the
>kernel compiler flags will include `-gsplit-dwarf`, and the linker will
>emit .dwo files.

Processed.
