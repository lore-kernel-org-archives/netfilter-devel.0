Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0063CC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D253960F21
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhJ3RIH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhJ3RIG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:08:06 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E26C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:05:36 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 6AFB35872AC41; Sat, 30 Oct 2021 19:05:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 66E6C61BB99FF;
        Sat, 30 Oct 2021 19:05:34 +0200 (CEST)
Date:   Sat, 30 Oct 2021 19:05:34 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 02/13] gitignore: ignore util/.dirstamp
In-Reply-To: <20211030160141.1132819-3-jeremy@azazel.net>
Message-ID: <o699p255-rqo-5s10-s3sq-1q8q858646p9@vanv.qr>
References: <20211030160141.1132819-1-jeremy@azazel.net> <20211030160141.1132819-3-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Saturday 2021-10-30 18:01, Jeremy Sowden wrote:
>Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
>---
> .gitignore | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/.gitignore b/.gitignore
>index 3f218218dfc9..fd2189de5748 100644
>--- a/.gitignore
>+++ b/.gitignore
>@@ -27,3 +27,4 @@ TAGS
> /doc/ulogd.*
> !/doc/ulogd.sgml
> ulogd.conf.5
>+/util/.dirstamp

.dirstamp should be globally ignored, without a path anchor.
(Best shotgun hypothesis I have that this file is created whenever
a Makefile.am contains a '/' in some _SOURCES)
