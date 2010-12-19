From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/11] libipset: static annotations
Date: Sun, 19 Dec 2010 06:18:13 +0100
Message-ID: <1292735894-17534-12-git-send-email-jengelh@medozas.de>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42687 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab0LSFS1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:27 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 lib/session.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/session.c b/lib/session.c
index 628c1b9..5d341ab 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -273,7 +273,7 @@ struct ipset_attr_policy {
 };
 
 /* Attribute policies and mapping to options */
-const struct ipset_attr_policy cmd_attrs[] = {
+static const struct ipset_attr_policy cmd_attrs[] = {
 	[IPSET_ATTR_PROTOCOL] = {
 		.type = MNL_TYPE_U8,
 	},
@@ -317,7 +317,7 @@ const struct ipset_attr_policy cmd_attrs[] = {
 	},
 };
 
-const struct ipset_attr_policy create_attrs[] = {
+static const struct ipset_attr_policy create_attrs[] = {
 	[IPSET_ATTR_IP]	= {
 		.type = MNL_TYPE_NESTED,
 		.opt = IPSET_OPT_IP,
@@ -392,7 +392,7 @@ const struct ipset_attr_policy create_attrs[] = {
 	},
 };
 
-const struct ipset_attr_policy adt_attrs[] = {
+static const struct ipset_attr_policy adt_attrs[] = {
 	[IPSET_ATTR_IP]	= {
 		.type = MNL_TYPE_NESTED,
 		.opt = IPSET_OPT_IP,
@@ -454,7 +454,7 @@ const struct ipset_attr_policy adt_attrs[] = {
 	},
 };
 
-const struct ipset_attr_policy ipaddr_attrs[] = {
+static const struct ipset_attr_policy ipaddr_attrs[] = {
 	[IPSET_ATTR_IPADDR_IPV4] = {
 		.type = MNL_TYPE_U32,
 	},
-- 
1.7.1

