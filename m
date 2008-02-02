From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 22/34]  Fix description and indenting.
Date: Sat,  2 Feb 2008 22:24:17 +0100
Message-ID: <12019874711938-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
 <12019874704067-git-send-email-eric@inl.fr>
 <12019874703897-git-send-email-eric@inl.fr>
 <12019874712066-git-send-email-eric@inl.fr>
 <1201987471474-git-send-email-eric@inl.fr>
 <1201987471346-git-send-email-eric@inl.fr>
 <12019874712309-git-send-email-eric@inl.fr>
 <12019874714080-git-send-email-eric@inl.fr>
 <12019874712041-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:45989 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761648AbYBBWNt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:13:49 -0500
In-Reply-To: <12019874712041-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 68a4ed7... 8a67cbe... M	filter/ulogd_filter_IP2STR.c
 filter/ulogd_filter_IP2STR.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index 68a4ed7..8a67cbe 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -1,6 +1,6 @@
 /* ulogd_filter_IP2STR.c, Version $Revision: 1500 $
  *
- * ulogd interpreter plugin for ifindex to ifname conversion
+ * ulogd interpreter plugin for internal IP storage format to string conversion
  *
  * (C) 2008 by Eric Leblond <eric@inl.fr>
  *
@@ -119,7 +119,6 @@ static struct ulogd_key ip2str_keys[] = {
 #define GET_FLAGS(res, x)	(res[x].u.source->flags)
 #define pp_is_valid(res, x)	(res[x].u.source && (GET_FLAGS(res, x) & ULOGD_RETF_VALID))
 
-
 static char *ip2str(struct ulogd_key* inp, int index, char family)
 {
 	char tmp[IPADDR_LENGTH];
@@ -152,8 +151,7 @@ static int interp_ip2str(struct ulogd_pluginstance *pi)
 	/* Iter on all addr fields */
 	for(i = START_KEY; i < MAX_KEY; i++) {
 		if (pp_is_valid(inp, i)) {
-			ret[i-1].u.value.ptr = ip2str(inp, i,
-						      oob_family);
+			ret[i-1].u.value.ptr = ip2str(inp, i, oob_family);
 			ret[i-1].flags |= ULOGD_RETF_VALID;
 		}
 	}
-- 
1.5.2.5

