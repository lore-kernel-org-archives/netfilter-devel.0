From: Gargi Sharma <gs051095@gmail.com>
Subject: [PATCH v3] ebtables: extensions: Constify option struct
Date: Tue, 28 Mar 2017 19:42:39 +0530
Message-ID: <1490710359-9207-1-git-send-email-gs051095@gmail.com>
Cc: pablo@netfilter.org, outreachy-kernel@googlegroups.com,
        Gargi Sharma <gs051095@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35970 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbdC1OOj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 10:14:39 -0400
Received: by mail-pg0-f67.google.com with SMTP id 81so21661906pgh.3
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 07:13:30 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct  of the type option is only used to initialise a field
inside the ebt_u_watcher or ebt_u_target or ebt_u_match struct and
is not modified anywhere.

Signed-off-by: Gargi Sharma <gs051095@gmail.com>
---
Changes in v3:
	- Correct the version number in subject prefix.
Changes in v2:
	- Squash patches in the patchset.
---
 extensions/ebt_802_3.c    | 2 +-
 extensions/ebt_among.c    | 2 +-
 extensions/ebt_arp.c      | 2 +-
 extensions/ebt_arpreply.c | 2 +-
 extensions/ebt_inat.c     | 4 ++--
 extensions/ebt_ip.c       | 2 +-
 extensions/ebt_limit.c    | 2 +-
 extensions/ebt_log.c      | 2 +-
 extensions/ebt_mark.c     | 2 +-
 extensions/ebt_mark_m.c   | 2 +-
 extensions/ebt_nat.c      | 4 ++--
 extensions/ebt_nflog.c    | 2 +-
 extensions/ebt_pkttype.c  | 2 +-
 extensions/ebt_redirect.c | 2 +-
 extensions/ebt_standard.c | 2 +-
 extensions/ebt_stp.c      | 2 +-
 extensions/ebt_ulog.c     | 2 +-
 extensions/ebt_vlan.c     | 2 +-
 18 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/extensions/ebt_802_3.c b/extensions/ebt_802_3.c
index dd22eb2..4584849 100644
--- a/extensions/ebt_802_3.c
+++ b/extensions/ebt_802_3.c
@@ -17,7 +17,7 @@
 #define _802_3_SAP '1'
 #define _802_3_TYPE '2'
 
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "802_3-sap"   , required_argument, 0, _802_3_SAP },
 	{ "802_3-type"  , required_argument, 0, _802_3_TYPE },
diff --git a/extensions/ebt_among.c b/extensions/ebt_among.c
index f97d07e..e4fc5ac 100644
--- a/extensions/ebt_among.c
+++ b/extensions/ebt_among.c
@@ -26,7 +26,7 @@
 #define AMONG_DST_F '3'
 #define AMONG_SRC_F '4'
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{"among-dst", required_argument, 0, AMONG_DST},
 	{"among-src", required_argument, 0, AMONG_SRC},
 	{"among-dst-file", required_argument, 0, AMONG_DST_F},
diff --git a/extensions/ebt_arp.c b/extensions/ebt_arp.c
index 64d337d..b281955 100644
--- a/extensions/ebt_arp.c
+++ b/extensions/ebt_arp.c
@@ -24,7 +24,7 @@
 #define ARP_MAC_S  '6'
 #define ARP_MAC_D  '7'
 #define ARP_GRAT   '8'
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "arp-opcode"    , required_argument, 0, ARP_OPCODE },
 	{ "arp-op"        , required_argument, 0, ARP_OPCODE },
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
diff --git a/extensions/ebt_ip.c b/extensions/ebt_ip.c
index 4e0b7f0..59559fe 100644
--- a/extensions/ebt_ip.c
+++ b/extensions/ebt_ip.c
@@ -25,7 +25,7 @@
 #define IP_SPORT  '5'
 #define IP_DPORT  '6'
 
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "ip-source"           , required_argument, 0, IP_SOURCE },
 	{ "ip-src"              , required_argument, 0, IP_SOURCE },
diff --git a/extensions/ebt_limit.c b/extensions/ebt_limit.c
index d189a09..2cbf4de 100644
--- a/extensions/ebt_limit.c
+++ b/extensions/ebt_limit.c
@@ -41,7 +41,7 @@ static int string_to_number(const char *s, unsigned int min, unsigned int max,
 #define ARG_LIMIT		'1'
 #define ARG_LIMIT_BURST		'2'
 
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "limit",		required_argument, 0, ARG_LIMIT },
 	{ "limit-burst",	required_argument, 0, ARG_LIMIT_BURST },
diff --git a/extensions/ebt_log.c b/extensions/ebt_log.c
index 1cf831a..97d5091 100644
--- a/extensions/ebt_log.c
+++ b/extensions/ebt_log.c
@@ -61,7 +61,7 @@ static int name_to_loglevel(char* arg)
 #define LOG_IP     '4'
 #define LOG_LOG    '5'
 #define LOG_IP6    '6'
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "log-prefix", required_argument, 0, LOG_PREFIX },
 	{ "log-level" , required_argument, 0, LOG_LEVEL  },
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
diff --git a/extensions/ebt_mark_m.c b/extensions/ebt_mark_m.c
index 2a259b0..7561f05 100644
--- a/extensions/ebt_mark_m.c
+++ b/extensions/ebt_mark_m.c
@@ -15,7 +15,7 @@
 
 #define MARK '1'
 
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "mark", required_argument, 0, MARK },
 	{ 0 }
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
diff --git a/extensions/ebt_nflog.c b/extensions/ebt_nflog.c
index 0cd10e0..405673a 100644
--- a/extensions/ebt_nflog.c
+++ b/extensions/ebt_nflog.c
@@ -25,7 +25,7 @@ enum {
 	NFLOG_NFLOG = 0x16,
 };
 
-static struct option nflog_opts[] = {
+static const struct option nflog_opts[] = {
 	{"nflog-group", required_argument, NULL, NFLOG_GROUP},
 	{"nflog-prefix", required_argument, NULL, NFLOG_PREFIX},
 	{"nflog-range", required_argument, NULL, NFLOG_RANGE},
diff --git a/extensions/ebt_pkttype.c b/extensions/ebt_pkttype.c
index 5b5cb03..486c85c 100644
--- a/extensions/ebt_pkttype.c
+++ b/extensions/ebt_pkttype.c
@@ -27,7 +27,7 @@ char *classes[] =
 	"\0"
 };
 
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "pkttype-type"        , required_argument, 0, '1' },
 	{ 0 }
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
diff --git a/extensions/ebt_stp.c b/extensions/ebt_stp.c
index 2b108a7..5c5fc33 100644
--- a/extensions/ebt_stp.c
+++ b/extensions/ebt_stp.c
@@ -27,7 +27,7 @@
 #define STP_FWDD	'l'
 #define STP_NUMOPS 12
 
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "stp-type"         , required_argument, 0, STP_TYPE},
 	{ "stp-flags"        , required_argument, 0, STP_FLAGS},
diff --git a/extensions/ebt_ulog.c b/extensions/ebt_ulog.c
index 162586d..54eec53 100644
--- a/extensions/ebt_ulog.c
+++ b/extensions/ebt_ulog.c
@@ -24,7 +24,7 @@
 #define ULOG_CPRANGE    '3'
 #define ULOG_QTHRESHOLD '4'
 #define ULOG_ULOG       '5'
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{ "ulog-prefix"    , required_argument, 0, ULOG_PREFIX     },
 	{ "ulog-nlgroup"   , required_argument, 0, ULOG_NLGROUP    },
diff --git a/extensions/ebt_vlan.c b/extensions/ebt_vlan.c
index 6714c82..0a37067 100644
--- a/extensions/ebt_vlan.c
+++ b/extensions/ebt_vlan.c
@@ -25,7 +25,7 @@
 #define VLAN_PRIO  '2'
 #define VLAN_ENCAP '3'
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{"vlan-id"   , required_argument, NULL, VLAN_ID},
 	{"vlan-prio" , required_argument, NULL, VLAN_PRIO},
 	{"vlan-encap", required_argument, NULL, VLAN_ENCAP},
-- 
2.7.4

