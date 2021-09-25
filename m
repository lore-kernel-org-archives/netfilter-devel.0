Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304DEC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BD436109D
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbhIYPvG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Sep 2021 11:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238018AbhIYPvG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 11:51:06 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA78C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 08:49:31 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id E0FDB593C1A2B; Sat, 25 Sep 2021 17:49:27 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id E00AA60E54FD7;
        Sat, 25 Sep 2021 17:49:27 +0200 (CEST)
Date:   Sat, 25 Sep 2021 17:49:27 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [conntrack-tools 6/6] build: fix dependency-tracking of
 yacc-generated header
In-Reply-To: <20210925151035.850310-7-jeremy@azazel.net>
Message-ID: <4626n855-s692-r9sn-30rn-rosr6s179sn@vanv.qr>
References: <20210925151035.850310-1-jeremy@azazel.net> <20210925151035.850310-7-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Saturday 2021-09-25 17:10, Jeremy Sowden wrote:
>List it as a built source in order to force make to create it before
>compilation.  Otherwise, a parallel make can end up attempting to
>compile the output of lex before yacc has finished generating its own
>output:
>
>--- a/src/Makefile.am
>+++ b/src/Makefile.am
>@@ -6,6 +6,7 @@ endif
> 
> AM_YFLAGS = -d
> 
>+BUILT_SOURCES = read_config_yy.h
> MAINTAINERCLEANFILES = read_config_yy.c read_config_yy.h read_config_lex.c

I have a strong reason to believe that you could just 
write

 read_config_yy.h: read_config_yy.y

(detail https://lists.gnu.org/archive/html/automake/2021-09/msg00011.html )
