From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 2/3] Fix pp_is_valid in mac2str plugin
Date: Wed, 15 Oct 2008 11:50:13 +0200
Message-ID: <1224064214-9074-3-git-send-email-chifflier@inl.fr>
References: <1224064214-9074-1-git-send-email-chifflier@inl.fr>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 141-53.206-83.static-ip.oleane.fr ([83.206.53.141]:46708 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYJOKGj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:06:39 -0400
In-Reply-To: <1224064214-9074-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes a segfault when RAW_MAC key is NULL in MAC2STR plugin.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 filter/ulogd_filter_HWHDR.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index cecd3e2..327b5fe 100644
--- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -174,7 +174,7 @@ static int interp_mac2str(struct ulogd_pluginstance *pi)
 			return fret;
 	}
 
-	if (!pp_is_valid(inp, KEY_RAW_MAC)) {
+	if (pp_is_valid(inp, KEY_RAW_MAC)) {
 		if (GET_VALUE(inp, KEY_RAW_MAC_ADDRLEN).ui16 == ETH_ALEN) {
 			ret[KEY_MAC_TYPE].u.value.ui16 = ARPHRD_ETHER;
 			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
-- 
1.5.6.5

