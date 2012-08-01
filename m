From: Eric Leblond <eric@regit.org>
Subject: [PATCH 4/5] pgsql: only disable key if it starts with underscore
Date: Wed,  1 Aug 2012 23:27:15 +0200
Message-ID: <1343856436-11129-5-git-send-email-eric@regit.org>
References: <1343856436-11129-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49519 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab2HAV2f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:28:35 -0400
In-Reply-To: <1343856436-11129-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ulogd2 was magically making inactive the first key of description
table. This patch improves this system by only doing so when
the key start with an undescore. This way, system like nfacct which
do not have a primary key can be implemented easily.
---
 output/pgsql/ulogd_output_PGSQL.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index 9529b1c..44600b0 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -195,8 +195,10 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 		strncpy(upi->input.keys[i].name, buf, ULOGD_MAX_KEYLEN);
 	}
 
-	/* ID is a sequence */
-	upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
+	/* ID (starting by '.') is a sequence */
+	if (upi->input.keys[0].name[0] == '.') {
+	    upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
+	}
 
 	PQclear(pi->pgres);
 	return 0;
-- 
1.7.10.4

