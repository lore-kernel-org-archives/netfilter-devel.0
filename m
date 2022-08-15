Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72349C00140
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Aug 2022 19:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244867AbiHOTGz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Aug 2022 15:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245724AbiHOTGJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Aug 2022 15:06:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50ABD39B84;
        Mon, 15 Aug 2022 11:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A138610A4;
        Mon, 15 Aug 2022 18:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E12C433C1;
        Mon, 15 Aug 2022 18:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588485;
        bh=nm4OJZwJEZv1pIUYaeMBoUGeJreDgEESneK9E8E3b3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKdlEJhNFvP323RDwTZqZ+JXSA/zlg7Tkp+Pa0UkM9A1/q12QwxdFxSitlkOtBn6i
         blDIByiCiDINRiHzkqDNloh8yB2XT049BteJosQXkVvFb8GZ2DEoYjEoay9ozXzTVB
         dYh8fUMbUvhwNxcurrFAxxPaSkFLzFqQ8ccxD7Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 418/779] netfilter: xtables: Bring SPDX identifier back
Date:   Mon, 15 Aug 2022 20:01:02 +0200
Message-Id: <20220815180355.133254650@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 20646f5b1e798bcc20044ae90ac3702f177bf254 ]

Commit e2be04c7f995 ("License cleanup: add SPDX license identifier to
uapi header files with a license") added the correct SPDX identifier to
include/uapi/linux/netfilter/xt_IDLETIMER.h.

A subsequent commit removed it for no reason and reintroduced the UAPI
license incorrectness as the file is now missing the UAPI exception
again.

Add it back and remove the GPLv2 boilerplate while at it.

Fixes: 68983a354a65 ("netfilter: xtables: Add snapshot of hardidletimer target")
Cc: Manoj Basapathi <manojbm@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/xt_IDLETIMER.h | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
index 49ddcdc61c09..7bfb31a66fc9 100644
--- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
+++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
@@ -1,6 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
 /*
- * linux/include/linux/netfilter/xt_IDLETIMER.h
- *
  * Header file for Xtables timer target module.
  *
  * Copyright (C) 2004, 2010 Nokia Corporation
@@ -10,20 +9,6 @@
  * by Luciano Coelho <luciano.coelho@nokia.com>
  *
  * Contact: Luciano Coelho <luciano.coelho@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
  */
 
 #ifndef _XT_IDLETIMER_H
-- 
2.35.1



