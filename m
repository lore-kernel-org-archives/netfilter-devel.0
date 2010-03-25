From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/12] netfilter: xtables: untangle spaghetti if clauses in checkentry
Date: Thu, 25 Mar 2010 17:04:18 +0100
Message-ID: <1269533065-22318-7-git-send-email-jengelh@medozas.de>
References: <1269533065-22318-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41693 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab0CYQEi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:04:38 -0400
In-Reply-To: <1269533065-22318-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As I'm changing the return values soon, I want to have a clear visual
path.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_dccp.c |   10 +++++++---
 net/netfilter/xt_sctp.c |   20 ++++++++++++--------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 0989f29..8f6014f 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -127,9 +127,13 @@ static bool dccp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_dccp_info *info = par->matchinfo;
 
-	return !(info->flags & ~XT_DCCP_VALID_FLAGS)
-		&& !(info->invflags & ~XT_DCCP_VALID_FLAGS)
-		&& !(info->invflags & ~info->flags);
+	if (info->flags & ~XT_DCCP_VALID_FLAGS)
+		return false;
+	if (info->invflags & ~XT_DCCP_VALID_FLAGS)
+		return false;
+	if (info->invflags & ~info->flags)
+		return false;
+	return true;
 }
 
 static struct xt_match dccp_mt_reg[] __read_mostly = {
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 43c7e1d..977b182 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -148,14 +148,18 @@ static bool sctp_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_sctp_info *info = par->matchinfo;
 
-	return !(info->flags & ~XT_SCTP_VALID_FLAGS)
-		&& !(info->invflags & ~XT_SCTP_VALID_FLAGS)
-		&& !(info->invflags & ~info->flags)
-		&& ((!(info->flags & XT_SCTP_CHUNK_TYPES)) ||
-			(info->chunk_match_type &
-				(SCTP_CHUNK_MATCH_ALL
-				| SCTP_CHUNK_MATCH_ANY
-				| SCTP_CHUNK_MATCH_ONLY)));
+	if (info->flags & ~XT_SCTP_VALID_FLAGS)
+		return false;
+	if (info->invflags & ~XT_SCTP_VALID_FLAGS)
+		return false;
+	if (info->invflags & ~info->flags)
+		return false;
+	if (!(info->flags & XT_SCTP_CHUNK_TYPES))
+		return true;
+	if (info->chunk_match_type & (SCTP_CHUNK_MATCH_ALL |
+	    SCTP_CHUNK_MATCH_ANY | SCTP_CHUNK_MATCH_ONLY))
+		return true;
+	return false;
 }
 
 static struct xt_match sctp_mt_reg[] __read_mostly = {
-- 
1.7.0.2

