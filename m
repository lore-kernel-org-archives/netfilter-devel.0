Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EFD1C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B26B60F9B
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhJ3RRk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJ3RRk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:17:40 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E94C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:15:09 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 902A85872AC41; Sat, 30 Oct 2021 19:15:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 8C49D61BF3435;
        Sat, 30 Oct 2021 19:15:08 +0200 (CEST)
Date:   Sat, 30 Oct 2021 19:15:08 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 08/13] build: only conditionally enter sub-directories
 containing optional code
In-Reply-To: <20211030160141.1132819-9-jeremy@azazel.net>
Message-ID: <q66o80p6-878q-15pr-roo7-3po7395878r0@vanv.qr>
References: <20211030160141.1132819-1-jeremy@azazel.net> <20211030160141.1132819-9-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Saturday 2021-10-30 18:01, Jeremy Sowden wrote:
>diff --git a/input/Makefile.am b/input/Makefile.am
>index 8f2e934fcdfa..668fc2b1444a 100644
>--- a/input/Makefile.am
>+++ b/input/Makefile.am
>@@ -1 +1,9 @@
>-SUBDIRS = packet flow sum
>+if BUILD_NFCT
>+    OPT_SUBDIR_FLOW = flow
>+endif
>+
>+if BUILD_NFACCT
>+    OPT_SUBDIR_SUM = sum
>+endif
>+
>+SUBDIRS = packet $(OPT_SUBDIR_FLOW) $(OPT_SUBDIR_SUM)

You use += in a previous patch, so why not use it here as well.

SUBDIRS = packet
if BUILD_NFCT
SUBDIRS += flow
endif
if BUILD_NFACCT
SUBDIRS += sum
endif

