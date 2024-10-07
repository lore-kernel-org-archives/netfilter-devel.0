Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F347B1E519
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Oct 2024 10:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728296628; cv=none; b=t/+d3ZcFRx01wT/AmcnoKSsj70zH8usD13NcfSEWPlDUFFvYb9EKslFtMnm+rD1AjjndPFRkNh3p21s3G1XFe6lP139zYzdrgLPMA+fZW4eyHJAbQxYwTheUHZ/MopgSEygDJTSv8SXejozU623lpcGYReykyMFiqJ7k6W1NZEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728296628; c=relaxed/simple;
	bh=fkCDyurJeXF9eWM6p4XxHC0yHMwgrWdEcnBdvlKrKtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4hrZodArWASdK/eZYrXqMpH+rb+OeUz5QoSEjGzSyI8JtV/4sLxxn5IRGP6es8JpMYCMyxjjyopGnXwThBAv5Jg35zziqTFIBOFMTJV7LieW++ZBVHuOfJmAiuwKeIQmPzYEAqJZopRz8krWezPLNhXSJdmiEiOLHoBru9VNWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sxku1-0006fQ-2I; Mon, 07 Oct 2024 12:23:45 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 2/5] sets: add and use incomplete tag
Date: Mon,  7 Oct 2024 11:49:35 +0200
Message-ID: <20241007094943.7544-3-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241007094943.7544-1-fw@strlen.de>
References: <20241007094943.7544-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like previous patch:

Extend data and set representation to indicate an incomplete
dissection.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/data_reg.h  | 1 +
 include/set.h       | 1 +
 src/expr/data_reg.c | 6 ++++++
 src/set_elem.c      | 5 +++++
 4 files changed, 13 insertions(+)

diff --git a/include/data_reg.h b/include/data_reg.h
index 946354dc9881..982e7a5bf2ea 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -27,6 +27,7 @@ union nftnl_data_reg {
 		const char	*chain;
 		uint32_t	chain_id;
 	};
+	bool incomplete;
 };
 
 int nftnl_data_reg_snprintf(char *buf, size_t size,
diff --git a/include/set.h b/include/set.h
index 55018b6b9ba9..ea84e511f1f9 100644
--- a/include/set.h
+++ b/include/set.h
@@ -34,6 +34,7 @@ struct nftnl_set {
 	uint32_t		gc_interval;
 	uint64_t		timeout;
 	struct list_head	expr_list;
+	bool			incomplete;
 };
 
 struct nftnl_set_list;
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 149d52aea9b4..dbd7b3660c13 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -135,6 +135,9 @@ nftnl_parse_verdict(union nftnl_data_reg *data, const struct nlattr *attr, int *
 	if (!tb[NFTA_VERDICT_CODE])
 		return -1;
 
+	if (tb[NFTA_VERDICT_UNSPEC])
+		data->incomplete = true;
+
 	data->verdict = ntohl(mnl_attr_get_u32(tb[NFTA_VERDICT_CODE]));
 
 	switch(data->verdict) {
@@ -193,6 +196,9 @@ int nftnl_parse_data(union nftnl_data_reg *data, struct nlattr *attr, int *type)
 	if (mnl_attr_parse_nested(attr, nftnl_data_parse_cb, tb) < 0)
 		return -1;
 
+	if (tb[NFTA_DATA_UNSPEC])
+		data->incomplete = true;
+
 	if (tb[NFTA_DATA_VALUE]) {
 		if (type)
 			*type = DATA_VALUE;
diff --git a/src/set_elem.c b/src/set_elem.c
index 9207a0dbd689..3531c0767e16 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -589,6 +589,11 @@ static int nftnl_set_elems_parse2(struct nftnl_set *s, const struct nlattr *nest
 		e->flags |= (1 << NFTNL_SET_ELEM_OBJREF);
 	}
 
+	if (!s->incomplete)
+		s->incomplete = e->key.incomplete ||
+				e->key_end.incomplete ||
+				e->data.incomplete;
+
 	/* Add this new element to this set */
 	list_add_tail(&e->head, &s->element_list);
 
-- 
2.45.2

