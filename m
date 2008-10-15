From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 3/3] Fix HWHDR plugin name
Date: Wed, 15 Oct 2008 11:50:14 +0200
Message-ID: <1224064214-9074-4-git-send-email-chifflier@inl.fr>
References: <1224064214-9074-1-git-send-email-chifflier@inl.fr>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 141-53.206-83.static-ip.oleane.fr ([83.206.53.141]:46703 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYJOKGi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:06:38 -0400
In-Reply-To: <1224064214-9074-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

MAC2STR has been renamed to HWHDR.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 filter/ulogd_filter_HWHDR.c |    4 ++--
 ulogd.conf.in               |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index 327b5fe..af44791 100644
--- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -1,4 +1,4 @@
-/* ulogd_filter_MAC2STR.c, Version $Revision: 1500 $
+/* ulogd_filter_HWHDR.c, Version $Revision: 1500 $
  *
  * ulogd interpreter plugin for HWMAC
  *
@@ -218,7 +218,7 @@ static int interp_mac2str(struct ulogd_pluginstance *pi)
 
 
 static struct ulogd_plugin mac2str_pluging = {
-	.name = "MAC2STR",
+	.name = "HWHDR",
 	.input = {
 		.keys = mac2str_inp,
 		.num_keys = ARRAY_SIZE(mac2str_inp),
diff --git a/ulogd.conf.in b/ulogd.conf.in
index a32234d..751892f 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -39,7 +39,7 @@ plugin="@libdir@/ulogd/ulogd_filter_IFINDEX.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2BIN.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
-plugin="@libdir@/ulogd/ulogd_filter_MAC2STR.so"
+plugin="@libdir@/ulogd/ulogd_filter_HWHDR.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 #plugin="@libdir@/ulogd/ulogd_filter_MARK.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
-- 
1.5.6.5

