From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] netfilter: nf_tables: Add extra bits for object handles
Date: Wed, 24 Jan 2018 05:07:22 +0530
Message-ID: <20180123233722.7388-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:45097 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752028AbeAWXhm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 18:37:42 -0500
Received: by mail-pg0-f65.google.com with SMTP id m136so1379170pga.12
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 15:37:42 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add extra bits for table, chain, sets and object handle.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 net/netfilter/nf_tables_trace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index e1dc527a493b..f804c3924d32 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -212,7 +212,11 @@ void nft_trace_notify(struct nft_traceinfo *info)
 		nla_total_size(sizeof(__be16)) +	/* oiftype */
 		nla_total_size(sizeof(u32)) +		/* mark */
 		nla_total_size(sizeof(u32)) +		/* nfproto */
-		nla_total_size(sizeof(u32));		/* policy */
+		nla_total_size(sizeof(u32)); +		/* policy */
+		nla_total_size_64bit(sizeof(__be64)) +	/* table handle */
+		nla_total_size_64bit(sizeof(__be64)) +	/* chain handle */
+		nla_total_size_64bit(sizeof(__be64)) +	/* set handle */
+		nla_total_size_64bit(sizeof(__be64))	/* object handle */
 
 	if (nft_trace_have_verdict_chain(info))
 		size += nla_total_size(strlen(info->verdict->chain->name)); /* jump target */
-- 
2.11.0

