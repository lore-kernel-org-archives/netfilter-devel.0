Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED29C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D69D760240
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhJ3Rfp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhJ3Rfp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:35:45 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FAFC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:33:14 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 40FED5872AC41; Sat, 30 Oct 2021 19:33:13 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 3DC076168E381;
        Sat, 30 Oct 2021 19:33:13 +0200 (CEST)
Date:   Sat, 30 Oct 2021 19:33:13 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 13/26] input: UNIXSOCK: stat socket-path first
 before creating the socket.
In-Reply-To: <20211030164432.1140896-14-jeremy@azazel.net>
Message-ID: <521n426p-7nn-655-nq5r-6364po1or38@vanv.qr>
References: <20211030164432.1140896-1-jeremy@azazel.net> <20211030164432.1140896-14-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Saturday 2021-10-30 18:44, Jeremy Sowden wrote:
>If the path is already bound, we close the socket immediately.
>diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
>index f97c2e174b2d..d88609f203c4 100644
>--- a/input/packet/ulogd_inppkt_UNIXSOCK.c
>+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
>@@ -479,10 +479,17 @@ static int _create_unix_socket(const char *unix_path)
> 	int s;
> 	struct stat st_dummy;
> 
>+	if (stat(unix_path, &st_dummy) == 0 && st_dummy.st_size > 0) {
>+		ulogd_log(ULOGD_ERROR,
>+			  "ulogd2: unix socket '%s' already exists\n",
>+			  unix_path);
>+		return -1;
>+	}
>+

That stat call should just be entirely deleted.

I fully expect that Coverity's static analyzer (or something like it)
is going to flag this piece of code as running afoul of TOCTOU.

A foreign event may cause the socket to come into existence between stat() and
bind(), and therefore the code needs to handle the bind(2) failure _in any
case_, and can report "Oh but it exists" at that time.

So even if the stat call is fine from a security POV, it is redundant code.
