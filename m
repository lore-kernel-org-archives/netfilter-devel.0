Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457C3C6FA91
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Sep 2022 09:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiIUJxR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Sep 2022 05:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiIUJw4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Sep 2022 05:52:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06240E8F;
        Wed, 21 Sep 2022 02:50:24 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oawN5-0006QR-0x; Wed, 21 Sep 2022 11:50:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <netfilter-devel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 3/4] headers: Remove some left-over license text in include/uapi/linux/netfilter/
Date:   Wed, 21 Sep 2022 11:49:59 +0200
Message-Id: <20220921095000.29569-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921095000.29569-1-fw@strlen.de>
References: <20220921095000.29569-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

When the SPDX-License-Identifier tag has been added, the corresponding
license text has not been removed.

Remove it now.

Also, in xt_connmark.h, move the copyright text at the top of the file
which is a much more common pattern.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/ipset/ip_set.h |  4 ----
 include/uapi/linux/netfilter/xt_AUDIT.h     |  4 ----
 include/uapi/linux/netfilter/xt_connmark.h  | 13 ++++---------
 include/uapi/linux/netfilter/xt_osf.h       | 14 --------------
 4 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/uapi/linux/netfilter/ipset/ip_set.h
index 6397d75899bc..79e5d68b87af 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -3,10 +3,6 @@
  *                         Patrick Schaaf <bof@bof.de>
  *                         Martin Josefsson <gandalf@wlug.westbo.se>
  * Copyright (C) 2003-2011 Jozsef Kadlecsik <kadlec@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 #ifndef _UAPI_IP_SET_H
 #define _UAPI_IP_SET_H
diff --git a/include/uapi/linux/netfilter/xt_AUDIT.h b/include/uapi/linux/netfilter/xt_AUDIT.h
index 1b314e2f84ac..56a3f6092e0c 100644
--- a/include/uapi/linux/netfilter/xt_AUDIT.h
+++ b/include/uapi/linux/netfilter/xt_AUDIT.h
@@ -4,10 +4,6 @@
  *
  * (C) 2010-2011 Thomas Graf <tgraf@redhat.com>
  * (C) 2010-2011 Red Hat, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #ifndef _XT_AUDIT_TARGET_H
diff --git a/include/uapi/linux/netfilter/xt_connmark.h b/include/uapi/linux/netfilter/xt_connmark.h
index f01c19b83a2b..41b578ccd03b 100644
--- a/include/uapi/linux/netfilter/xt_connmark.h
+++ b/include/uapi/linux/netfilter/xt_connmark.h
@@ -1,18 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/* Copyright (C) 2002,2004 MARA Systems AB <https://www.marasystems.com>
+ * by Henrik Nordstrom <hno@marasystems.com>
+ */
+
 #ifndef _XT_CONNMARK_H
 #define _XT_CONNMARK_H
 
 #include <linux/types.h>
 
-/* Copyright (C) 2002,2004 MARA Systems AB <https://www.marasystems.com>
- * by Henrik Nordstrom <hno@marasystems.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
 enum {
 	XT_CONNMARK_SET = 0,
 	XT_CONNMARK_SAVE,
diff --git a/include/uapi/linux/netfilter/xt_osf.h b/include/uapi/linux/netfilter/xt_osf.h
index 6e466236ca4b..f1f097896bdf 100644
--- a/include/uapi/linux/netfilter/xt_osf.h
+++ b/include/uapi/linux/netfilter/xt_osf.h
@@ -1,20 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
 /*
  * Copyright (c) 2003+ Evgeniy Polyakov <johnpol@2ka.mxt.ru>
- *
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
 #ifndef _XT_OSF_H
-- 
2.35.1

