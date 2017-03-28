From: Gargi Sharma <gs051095@gmail.com>
Subject: [PATCH 3/3] ebtables: extensions: Constify option struct
Date: Tue, 28 Mar 2017 16:57:51 +0530
Message-ID: <fe1daf441eafb6393160a7523cc8962cd68d310d.1490699407.git.gs051095@gmail.com>
References: <cover.1490699407.git.gs051095@gmail.com>
Cc: pablo@netfilter.org, outreachy-kernel@googlegroups.com,
        Gargi Sharma <gs051095@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34579 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932181AbdC1L2X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 07:28:23 -0400
Received: by mail-pg0-f66.google.com with SMTP id o123so17896416pga.1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2017 04:28:22 -0700 (PDT)
In-Reply-To: <cover.1490699407.git.gs051095@gmail.com>
In-Reply-To: <cover.1490699407.git.gs051095@gmail.com>
References: <cover.1490699407.git.gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The struct  of the type option is only used to initialise a field
inside the ebt_u_match struct and is not modified anywhere.

Signed-off-by: Gargi Sharma <gs051095@gmail.com>
---
 extensions/ebt_802_3.c   | 2 +-
 extensions/ebt_among.c   | 2 +-
 extensions/ebt_arp.c     | 2 +-
 extensions/ebt_ip.c      | 2 +-
 extensions/ebt_limit.c   | 2 +-
 extensions/ebt_mark_m.c  | 2 +-
 extensions/ebt_pkttype.c | 2 +-
 extensions/ebt_stp.c     | 2 +-
 extensions/ebt_vlan.c    | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

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

