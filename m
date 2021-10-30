Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F397C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AB4760F9B
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhJ3RS7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJ3RS7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:18:59 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD9DC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:16:29 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id C7ADF5872AC41; Sat, 30 Oct 2021 19:16:27 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id C605A61BF343C;
        Sat, 30 Oct 2021 19:16:27 +0200 (CEST)
Date:   Sat, 30 Oct 2021 19:16:27 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 10/13] build: update obsolete autoconf macros
In-Reply-To: <20211030160141.1132819-11-jeremy@azazel.net>
Message-ID: <n5pq71os-8247-2o3-qo2-9023807oqnoq@vanv.qr>
References: <20211030160141.1132819-1-jeremy@azazel.net> <20211030160141.1132819-11-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Saturday 2021-10-30 18:01, Jeremy Sowden wrote:
>+++ b/configure.ac
>@@ -3,7 +3,7 @@ AC_INIT([ulogd], [2.0.7])
> AC_PREREQ([2.50])
> AC_CONFIG_AUX_DIR([build-aux])
> AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10b subdir-objects])
>-AC_CONFIG_HEADER([config.h])
>+AC_CONFIG_HEADERS([config.h])
> AC_CONFIG_MACRO_DIR([m4])
> 
> m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
>@@ -14,8 +14,7 @@ dnl Checks for programs.
> AC_PROG_MAKE_SET
> AC_PROG_CC
> AC_PROG_INSTALL
>-AC_DISABLE_STATIC
>-AC_PROG_LIBTOOL
>+LT_INIT([disable_static])

This ought to be disable-static. Dash, not underscore.
