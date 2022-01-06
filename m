Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37496C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 22:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244805AbiAFWPf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 17:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244435AbiAFWPf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 17:15:35 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0595AC061245
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 14:15:35 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
        id A39155872F691; Thu,  6 Jan 2022 23:15:31 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 9AE7060D35E87;
        Thu,  6 Jan 2022 23:15:31 +0100 (CET)
Date:   Thu, 6 Jan 2022 23:15:31 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 03/10] build: use pkg-config or upstream M4 for
 mysql
In-Reply-To: <20220106210937.1676554-4-jeremy@azazel.net>
Message-ID: <q6p24q-47r9-p184-69s7-165p7264o123@vanv.qr>
References: <20220106210937.1676554-1-jeremy@azazel.net> <20220106210937.1676554-4-jeremy@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2022-01-06 22:09, Jeremy Sowden wrote:

>Recent versions of mariadb and mysql have supported pkg-config.

(This made me read up on Stackexchange about exact rules for present
perfect, only to find it is not neatly delineated.) IMO better to
just use present. They (still) support pkg-config.

>+  dnl Recent versions of MySQL and MariaDB have included pkg-config support.


>+  dnl Older versions have included an mysql.m4 file which provides macros to

"had included", as I don't see that m4 file anymore on my (mariadb) systems.
(There are a few mysql-related m4 files in autoconf-archive,
but that's not the same package as mysql/mariadb, I suppose.)

>+    dnl The [MYSQL_CLIENT] macro calls [_MYSQL_CONFIG] to locate mysql_config.
>+
>+    _MYSQL_CONFIG

One caveat of m4 macros is that they may be left unexpanded if not found,
and it is up to the tarball producer to ensure the m4 macro is expanded.
Over the years, I built the opinion that this is not always a nice experience
to have.

I would do away with _MYSQL_CONFIG and just attempt to run `mysql_config` out
the blue. sh failing to execute mysql_config, or a compiler failing to find
mysql.h as part of AC_CHECK_HEADER is a nicer experience than _MYSQL_CONFIG
being left accidentally unexpanded.

>+      dnl Some distro's don't put mysql_config in the same package as the

distros

