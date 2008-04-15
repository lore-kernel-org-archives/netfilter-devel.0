From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 04/10] Resolve libipt_set warnings
Date: Tue, 15 Apr 2008 12:33:22 +0200
Message-ID: <17a95547ff558bbc37b5c382aafd5f49e1a2ca4c.1208255176.git.jengelh@computergmbh.de>
References: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34599 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbYDOKd3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:33:29 -0400
In-Reply-To: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
References: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/libipt_set.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/extensions/libipt_set.h b/extensions/libipt_set.h
index 02de0fa..3e70d7b 100644
--- a/extensions/libipt_set.h
+++ b/extensions/libipt_set.h
@@ -12,9 +12,9 @@
 #endif
 
 static void
-parse_bindings(const char *optarg, struct ipt_set_info *info)
+parse_bindings(const char *opt_arg, struct ipt_set_info *info)
 {
-	char *saved = strdup(optarg);
+	char *saved = strdup(opt_arg);
 	char *ptr, *tmp = saved;
 	int i = 0;
 	
@@ -66,8 +66,8 @@ static void get_set_byname(const char *setname, struct ipt_set_info *info)
 	if (size != sizeof(struct ip_set_req_get_set))
 		exit_error(OTHER_PROBLEM,
 			   "Incorrect return size from kernel during ipset lookup, "
-			   "(want %ld, got %ld)\n",
-			   sizeof(struct ip_set_req_get_set), size);
+			   "(want %zu, got %zu)\n",
+			   sizeof(struct ip_set_req_get_set), (size_t)size);
 	if (req.set.index == IP_SET_INVALID_ID)
 		exit_error(PARAMETER_PROBLEM,
 			   "Set %s doesn't exist.\n", setname);
@@ -75,7 +75,7 @@ static void get_set_byname(const char *setname, struct ipt_set_info *info)
 	info->index = req.set.index;
 }
 
-static void get_set_byid(char * setname, ip_set_id_t index)
+static void get_set_byid(char * setname, ip_set_id_t idx)
 {
 	struct ip_set_req_get_set req;
 	socklen_t size = sizeof(struct ip_set_req_get_set);
@@ -83,7 +83,7 @@ static void get_set_byid(char * setname, ip_set_id_t index)
 
 	req.op = IP_SET_OP_GET_BYINDEX;
 	req.version = IP_SET_PROTOCOL_VERSION;
-	req.set.index = index;
+	req.set.index = idx;
 	res = get_set_getsockopt(&req, &size);
 	if (res != 0)
 		exit_error(OTHER_PROBLEM,
@@ -92,11 +92,11 @@ static void get_set_byid(char * setname, ip_set_id_t index)
 	if (size != sizeof(struct ip_set_req_get_set))
 		exit_error(OTHER_PROBLEM,
 			   "Incorrect return size from kernel during ipset lookup, "
-			   "(want %ld, got %ld)\n",
-			   sizeof(struct ip_set_req_get_set), size);
+			   "(want %zu, got %zu)\n",
+			   sizeof(struct ip_set_req_get_set), (size_t)size);
 	if (req.set.name[0] == '\0')
 		exit_error(PARAMETER_PROBLEM,
-			   "Set id %i in kernel doesn't exist.\n", index);
+			   "Set id %i in kernel doesn't exist.\n", idx);
 
 	strncpy(setname, req.set.name, IP_SET_MAXNAMELEN);
 }
-- 
1.5.5.rc3

