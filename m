Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12D4CCA473
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jun 2022 15:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240479AbiFFPXt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 11:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240469AbiFFPXt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 11:23:49 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FC425D5F7;
        Mon,  6 Jun 2022 08:23:47 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654529026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ZNoVfDltUyVTzFGTCv9B0gHE/HH6O1A3o5xpCJOtSTE=;
        b=z7Y0I0zv1rNtnXBORuinDZHXKfB0UET0yYzy2eXGF7OQgmQqe9bF/zuZBYv8wyP3Bfbebu
        MSeRzx7LLnD2g103jiBcidKZH8O2HQrl7TVA18rqjvvDFu6gmN//w80lc3BYdgvnkVqRcS
        m+Pfg3/iU5qSREXCIDoOxZi6ltbENWjnt5EUxw5tZ9DZKwpfvoEdq6ukLWdOVwEVUkEtGG
        Kvn+8DmX8WFYGFsLZACvMnB3E7LTF4pxPjVFJTFjKjZ9a5cglydvy5opeAA5E9coFn+rjp
        hNx0SxYpS+sNpCzddlGpAKlKNpIMWJ2KeA/OZLytYsw1oXdAPATr1uABd/+ldQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654529026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=ZNoVfDltUyVTzFGTCv9B0gHE/HH6O1A3o5xpCJOtSTE=;
        b=G6M8IG84I728clYMxKjnaJZqQln3olgdCNHg6CI3oKke7UoVZ48a79DxF8BG+L5Dze215n
        g9jz/cJg2BnOakCg==
To:     netfilter-devel@vger.kernel.org
Cc:     linux-spdx@vger.kernel.org,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: netfilter: xtables: Bring SPDX identifier back
Date:   Mon, 06 Jun 2022 17:23:45 +0200
Message-ID: <87ee016cji.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit e2be04c7f995 ("License cleanup: add SPDX license identifier to
uapi header files with a license") added the correct SPDX identifier to
include/uapi/linux/netfilter/xt_IDLETIMER.h.

A subsequent commit removed it for no reason and reintroduced the UAPI
license incorrectness as the file is now missing the UAPI exception
again.

Add it back and remove the GPLv2 boilerplate while at it.

Fixes: 68983a354a65 ("netfilter: xtables: Add snapshot of hardidletimer target")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Manoj Basapathi <manojbm@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
---
 include/uapi/linux/netfilter/xt_IDLETIMER.h |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

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
