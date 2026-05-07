Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FC23191D0;
	Thu,  7 May 2026 23:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778197524; cv=none; b=I+zsNxSdSEz9a38me85iGqxvt85tizVk9xQqygaYtkdRjT3qAnr+LxQAWElgD8Z39TqhEVJ0DcsOglp5pRdcWr//kDfZ7VdrwQAMiUaPrg0MlHGsqrl2T70Iwz21NkvjyJmEKtDUQTUSgHnDd3UGgaktLjQHm2eM9GUp0bYHt1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778197524; c=relaxed/simple;
	bh=Rwx2dyJN5OeIwY2b0MS6uB5ze7XT8RLvUe1M5pAl+Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toVlubQFst0u7NpQO6VUXzmrMPetQ3wpv8+UqtcYlbRI8omMMg5Mi1qeTJMKEMSrZiUQSIdFw2nnyrvxTS6H5XIUjMCJnLCbYz929Uh+JTnvJcQJc4KNEfJVlb6imzwbUngVw50kV31FC/F2SCktFQJQlpddZfUkUqpf8cCo5fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iM3kaQfd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iM3kaQfd"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6C6CD60251;
	Fri,  8 May 2026 01:45:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778197514;
	bh=KHvdJb6vxqHy5YtM29r/lP1H4y+EHXhBx9V1uFnpTg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iM3kaQfdtpObPSXbF8i7p34MD0Et2xFIafV+7EInMcz8LLawmuyeUF0MTnaMLQGt7
	 /2eTNBustVCH8s0ClmtIYsxjPhJ1U2X8J78BNAFAQfHSPRouXwpfZr0Y+F8820/puJ
	 HjfxI6U3MNHvqSWqDqXsulfEVDTtqUG7hP+v7LtzUE3bFfvWbIhgjQ811YdGzwebdL
	 yLg0mGgi+Aj+n28GN+3Ei9ECk79euyXgGAJ3egbhbNpUib2KaY6Yoj6NpzfjecHKEF
	 cD6vwHyvTEfGJF6oz8mYS5VDglPBAjI/SIRK3xxmqESfzS7Kimtr0YZ537QuCj+nfi
	 w8Co6zKY/qRAQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 01/13] netfilter: x_tables: allow initial table replace without emitting audit log message
Date: Fri,  8 May 2026 01:44:57 +0200
Message-ID: <20260507234509.603182-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260507234509.603182-1-pablo@netfilter.org>
References: <20260507234509.603182-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

At the moment we emit the audit log a bit too early, which makes it
necessary to also emit an unregister log in case we have to unwind
errors after possible hook register failure.

Followup patch will be slightly simpler if we can delay the
register message until after the hooks have been wired up.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.47.3

