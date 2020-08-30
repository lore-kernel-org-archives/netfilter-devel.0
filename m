Return-Path: <SRS0=XBPj=CI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722E7C433E2
	for <netfilter-devel@archiver.kernel.org>; Sun, 30 Aug 2020 11:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FCEF2087D
	for <netfilter-devel@archiver.kernel.org>; Sun, 30 Aug 2020 11:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgH3Ljl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 30 Aug 2020 07:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgH3Ljl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Aug 2020 07:39:41 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF18C061573
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Aug 2020 04:39:39 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 0078A5872C96D; Sun, 30 Aug 2020 13:39:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id F036560FF69D8;
        Sun, 30 Aug 2020 13:39:28 +0200 (CEST)
Date:   Sun, 30 Aug 2020 13:39:28 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons] build: clean some extra build
 artefacts.
In-Reply-To: <20200829204127.2709641-1-jeremy@azazel.net>
Message-ID: <nycvar.YFH.7.77.849.2008301337350.1576@n3.vanv.qr>
References: <20200829204127.2709641-1-jeremy@azazel.net>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Saturday 2020-08-29 22:41, Jeremy Sowden wrote:

>Because extensions/Makefile.am does not contain a `SUBDIRS` variable
>listing extensions/ACCOUNT and extensions/pknock, when `make distclean`
>is run, make does not recurse into them.  Add a `distclean-local` target
>to extensions/Makefile.am to fix this.

I find it suspicious that the userspace tools are not even built.
Therefore, I just added those directories to SUBDIRS. This should 
conveniently also cure the need for an extra call to distcleaning.
