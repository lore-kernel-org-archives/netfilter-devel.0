Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB9B37E2EB
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 18:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919004; cv=none; b=Gt6RcL8wKF81HiPA7xmgsxw4Qm8sQ+0VnJvgJZVglrslpM0gYwe84gMj7zPzhWkUtbZHpeQ3q1Q9UzHq9hAlcx5X3w6q+IksFn5SCCEFGImy2pnU3Fbdyi7ci2l83ijEZRfwjZu616BeThJcJ5f1XQ0xN10evq7D2b2jKDlmRUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919004; c=relaxed/simple;
	bh=fIxRM7tCKVKnp0szx1HRi1T7pEyqXkPX1UOCNf2vw4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTvXbkjQVsIRQ7oxAc+2dzwnxjYsp30UJjbaShX+4sJ6M+OVmzaasdXNx7XRzrcFZ+ZodQlUmfFU0vqX+OJnRhXwKyF19P2+w/jCKkZV6U0mafTkzApiqeL6u4DijkmeOi8GFRm9VUwinaIY++fEpq8RgE157lFSQxuST6JeTb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B1E9E6079C; Mon, 04 May 2026 20:23:21 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 1/8] netfilter: x_tables: allow initial table replace without emitting audit log message
Date: Mon,  4 May 2026 20:22:13 +0200
Message-ID: <20260504182310.1916-2-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260504182310.1916-1-fw@strlen.de>
References: <20260504182310.1916-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At the moment we emit the audit log a bit too early, which makes it
necessary to also emit an unregister log in case we have to unwind
errors after possible hook register failure.

Followup patch will be slightly simpler if we can delay the
register message until after the hooks have been wired up.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: new in this series.  As-is, we emit both a register
 and unregister notification in case something goes wrong
 at table init time.  Instead this minor refactor will permit
 next patch to only emit the success notification.

 net/netfilter/x_tables.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 2c67c2e6b132..bb0cb3959551 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1472,11 +1472,9 @@ struct xt_counters *xt_counters_alloc(unsigned int counters)
 }
 EXPORT_SYMBOL(xt_counters_alloc);
 
-struct xt_table_info *
-xt_replace_table(struct xt_table *table,
-	      unsigned int num_counters,
-	      struct xt_table_info *newinfo,
-	      int *error)
+static struct xt_table_info *
+do_replace_table(struct xt_table *table, unsigned int num_counters,
+		 struct xt_table_info *newinfo, int *error)
 {
 	struct xt_table_info *private;
 	unsigned int cpu;
@@ -1531,10 +1529,23 @@ xt_replace_table(struct xt_table *table,
 		}
 	}
 
-	audit_log_nfcfg(table->name, table->af, private->number,
-			!private->number ? AUDIT_XT_OP_REGISTER :
-					   AUDIT_XT_OP_REPLACE,
-			GFP_KERNEL);
+	return private;
+}
+
+struct xt_table_info *
+xt_replace_table(struct xt_table *table, unsigned int num_counters,
+		 struct xt_table_info *newinfo,
+		 int *error)
+{
+	struct xt_table_info *private;
+
+	private = do_replace_table(table, num_counters, newinfo, error);
+	if (private)
+		audit_log_nfcfg(table->name, table->af, private->number,
+				!private->number ? AUDIT_XT_OP_REGISTER :
+				AUDIT_XT_OP_REPLACE,
+				GFP_KERNEL);
+
 	return private;
 }
 EXPORT_SYMBOL_GPL(xt_replace_table);
-- 
2.53.0

