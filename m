From: Steven Barth <cyrus@openwrt.org>
Subject: [PATCH 1/4] parser: rename VERSION token to HDRVERSION
Date: Tue,  6 Jan 2015 23:40:22 +0100
Message-ID: <1420584025-7817-2-git-send-email-cyrus@openwrt.org>
References: <1420584025-7817-1-git-send-email-cyrus@openwrt.org>
Cc: Steven Barth <cyrus@openwrt.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.core-networks.de ([82.96.72.7]:39869 "EHLO
	mail.core-networks.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbbAFWlD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:41:03 -0500
In-Reply-To: <1420584025-7817-1-git-send-email-cyrus@openwrt.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A token name of VERSION results in a macro being defined
with the same name. This prevents inclusion of config.h
in commonly used headers.

Signed-off-by: Steven Barth <cyrus@openwrt.org>
---
 src/parser_bison.y | 6 +++---
 src/scanner.l      | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3059d59..b20f4de 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -238,7 +238,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 %token OPERATION		"operation"
 
 %token IP			"ip"
-%token VERSION			"version"
+%token HDRVERSION		"version"
 %token HDRLENGTH		"hdrlength"
 %token TOS			"tos"
 %token LENGTH			"length"
@@ -1966,7 +1966,7 @@ ip_hdr_expr		:	IP	ip_hdr_field
 			}
 			;
 
-ip_hdr_field		:	VERSION		{ $$ = IPHDR_VERSION; }
+ip_hdr_field		:	HDRVERSION	{ $$ = IPHDR_VERSION; }
 			|	HDRLENGTH	{ $$ = IPHDR_HDRLENGTH; }
 			|	TOS		{ $$ = IPHDR_TOS; }
 			|	LENGTH		{ $$ = IPHDR_LENGTH; }
@@ -2013,7 +2013,7 @@ ip6_hdr_expr		:	IP6	ip6_hdr_field
 			}
 			;
 
-ip6_hdr_field		:	VERSION		{ $$ = IP6HDR_VERSION; }
+ip6_hdr_field		:	HDRVERSION	{ $$ = IP6HDR_VERSION; }
 			|	PRIORITY	{ $$ = IP6HDR_PRIORITY; }
 			|	FLOWLABEL	{ $$ = IP6HDR_FLOWLABEL; }
 			|	LENGTH		{ $$ = IP6HDR_LENGTH; }
diff --git a/src/scanner.l b/src/scanner.l
index ed87da6..52b0078 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -349,7 +349,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "operation"		{ return OPERATION; }
 
 "ip"			{ return IP; }
-"version"		{ return VERSION; }
+"version"		{ return HDRVERSION; }
 "hdrlength"		{ return HDRLENGTH; }
 "tos"			{ return TOS; }
 "length"		{ return LENGTH; }
-- 
2.1.4

