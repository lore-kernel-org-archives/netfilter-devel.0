From: Gargi Sharma <gs051095@gmail.com>
Subject: [PATCH 2/3] ebtables: extensions: Constify option struct
Date: Tue, 28 Mar 2017 16:57:50 +0530
Message-ID: <54ae426a3c02ffa3dc6e6e11bacd74f6e1173693.1490699407.git.gs051095@gmail.com>
References: <cover.1490699407.git.gs051095@gmail.com>
Cc: pablo@netfilter.org, outreachy-kernel@googlegroups.com,
        Gargi Sharma <gs051095@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33720 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932180AbdC1L2j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 07:28:39 -0400
Received: by mail-pg0-f66.google.com with SMTP id 79so20693341pgf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 04:28:38 -0700 (PDT)
In-Reply-To: <cover.1490699407.git.gs051095@gmail.com>
In-Reply-To: <cover.1490699407.git.gs051095@gmail.com>
References: <cover.1490699407.git.gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct  of the type option is only used to initialise a field
inside the ebt_u_target struct and is not modified anywhere.

Signed-off-by: Gargi Sharma <gs051095@gmail.com>
---
 extensions/ebt_arpreply.c | 2 +-
 extensions/ebt_inat.c     | 4 ++--
 extensions/ebt_mark.c     | 2 +-
 extensions/ebt_nat.c      | 4 ++--
 extensions/ebt_redirect.c | 2 +-
 extensions/ebt_standard.c | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/extensions/ebt_arpreply.c b/extensions/ebt_arpreply.c
index c3757f3..51eda66 100644
--- a/extensions/ebt_arpreply.c
+++ b/extensions/ebt_arpreply.c
@@ -19,7 +19,7 @@ static int mac_supplied;
 
 #define REPLY_MAC '1'
 #define REPLY_TARGET '2'
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "arpreply-mac" ,    required_argument, 0, REPLY_MAC    },
 	{ "arpreply-target" , required_argument, 0, REPLY_TARGET },
diff --git a/extensions/ebt_inat.c b/extensions/ebt_inat.c
index 1aa9435..681975d 100644
--- a/extensions/ebt_inat.c
+++ b/extensions/ebt_inat.c
@@ -23,7 +23,7 @@ static int s_sub_supplied, d_sub_supplied;
 #define NAT_D_SUB '2'
 #define NAT_S_TARGET '3'
 #define NAT_D_TARGET '3'
-static struct option opts_s[] =
+static const struct option opts_s[] =
 {
 	{ "isnat-list"     , required_argument, 0, NAT_S },
 	{ "isnat-sub"      , required_argument, 0, NAT_S_SUB },
@@ -31,7 +31,7 @@ static struct option opts_s[] =
 	{ 0 }
 };
 
-static struct option opts_d[] =
+static const struct option opts_d[] =
 {
 	{ "idnat-list"     , required_argument, 0, NAT_D },
 	{ "idnat-sub"      , required_argument, 0, NAT_D_SUB },
diff --git a/extensions/ebt_mark.c b/extensions/ebt_mark.c
index 5776b1c..4cf1378 100644
--- a/extensions/ebt_mark.c
+++ b/extensions/ebt_mark.c
@@ -20,7 +20,7 @@ static int mark_supplied;
 #define MARK_ORMARK  '3'
 #define MARK_ANDMARK '4'
 #define MARK_XORMARK '5'
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "mark-target" , required_argument, 0, MARK_TARGET },
 	/* an oldtime messup, we should have always used the scheme
diff --git a/extensions/ebt_nat.c b/extensions/ebt_nat.c
index e6afbf8..00d9cd4 100644
--- a/extensions/ebt_nat.c
+++ b/extensions/ebt_nat.c
@@ -21,7 +21,7 @@ static int to_source_supplied, to_dest_supplied;
 #define NAT_S_TARGET '2'
 #define NAT_D_TARGET '2'
 #define NAT_S_ARP '3'
-static struct option opts_s[] =
+static const struct option opts_s[] =
 {
 	{ "to-source"     , required_argument, 0, NAT_S },
 	{ "to-src"        , required_argument, 0, NAT_S },
@@ -30,7 +30,7 @@ static struct option opts_s[] =
 	{ 0 }
 };
 
-static struct option opts_d[] =
+static const struct option opts_d[] =
 {
 	{ "to-destination", required_argument, 0, NAT_D },
 	{ "to-dst"        , required_argument, 0, NAT_D },
diff --git a/extensions/ebt_redirect.c b/extensions/ebt_redirect.c
index e470818..3f8227a 100644
--- a/extensions/ebt_redirect.c
+++ b/extensions/ebt_redirect.c
@@ -14,7 +14,7 @@
 #include <linux/netfilter_bridge/ebt_redirect.h>
 
 #define REDIRECT_TARGET '1'
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "redirect-target", required_argument, 0, REDIRECT_TARGET },
 	{ 0 }
diff --git a/extensions/ebt_standard.c b/extensions/ebt_standard.c
index 67d4d7c..81edead 100644
--- a/extensions/ebt_standard.c
+++ b/extensions/ebt_standard.c
@@ -11,7 +11,7 @@
 #include <getopt.h>
 #include "../include/ebtables_u.h"
 
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{0}
 };
-- 
2.7.4

