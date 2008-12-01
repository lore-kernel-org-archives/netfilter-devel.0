From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 2/4] Fix light memory error in parse_mac2str
Date: Mon,  1 Dec 2008 13:41:54 +0100
Message-ID: <1228135316-12578-3-git-send-email-chifflier@inl.fr>
References: <1228135316-12578-1-git-send-email-chifflier@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:55865 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYLANYo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 08:24:44 -0500
In-Reply-To: <1228135316-12578-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When len is 0 (for ex. when the input mac is NULL), parse_mac2str tries
to calloc a 0-bytes bloc, which leads to a conditional jump based
on uninitialized value (spotted by valgrind).

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 filter/ulogd_filter_HWHDR.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index af44791..8df4f00 100644
--- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -111,13 +111,19 @@ static struct ulogd_key mac2str_keys[] = {
 static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
 			 int okey, int len)
 {
-	char *mac_str = calloc(len/sizeof(char)*3, sizeof(char));
-	char *buf_cur = mac_str;
+	char *mac_str;
+	char *buf_cur;
 	int i;
 
+	if (len > 0)
+		mac_str = calloc(len/sizeof(char)*3, sizeof(char));
+	else
+		mac_str = strdup("");
+
 	if (mac_str == NULL)
 		return ULOGD_IRET_ERR;
 
+	buf_cur = mac_str;
 	for (i = 0; i < len; i++)
 		buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
 				i == len - 1 ? 0 : ':');
-- 
1.5.6.5

