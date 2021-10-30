Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F943C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7372B60FC1
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhJ3RXj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJ3RXi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:23:38 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972AFC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:21:08 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 3ADE15872AC41; Sat, 30 Oct 2021 19:21:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 3556161BF343C;
        Sat, 30 Oct 2021 19:21:07 +0200 (CEST)
Date:   Sat, 30 Oct 2021 19:21:07 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 13/13] build: bump autoconf version to 2.71
In-Reply-To: <20211030160141.1132819-14-jeremy@azazel.net>
Message-ID: <q87qqs7q-4n50-3ppq-9867-q0n51n60p89n@vanv.qr>
References: <20211030160141.1132819-1-jeremy@azazel.net> <20211030160141.1132819-14-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Saturday 2021-10-30 18:01, Jeremy Sowden wrote:

>diff --git a/configure.ac b/configure.ac
>index ea245dae3796..8d18cc6eb7fb 100644
>--- a/configure.ac
>+++ b/configure.ac
>@@ -1,6 +1,6 @@
> dnl Process this file with autoconf to produce a configure script.
> AC_INIT([ulogd], [2.0.7])
>-AC_PREREQ([2.50])
>+AC_PREREQ([2.71])
> AC_CONFIG_AUX_DIR([build-aux])
> AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10b subdir-objects])
> AC_CONFIG_HEADERS([config.h])

That's not a good move; it puts unnecessary stones on the road to 
building from git (i.e. with full autoreconf) on e.g. SUSE 15.X (and some 
other distros I am sure) that only have autoconf 2.69 or .65 or whatever.

Unless there is a _specific new shiny m4 macro_ that is invoked somewhere,
I cannot see a reason to gratuitiously bump PREREQ.
