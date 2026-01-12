Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181713570D4
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 11:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768218707; cv=none; b=gd7WcV83MRRcb8f0a5LI20CeNls3XqnmvDFHNPyVsb0plGyfBC1iMhqD6dZ1Y6z2psuLIGwa4cgq020zWprGPEXBiCbgsbd4bpRhkrE+/m7tB/MxTc+vWa5cdFu63xQmAgPEJco6gUSipqjb5juDHDBS0Wp9QoKfB+TEIZ/80Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768218707; c=relaxed/simple;
	bh=feLaFnmGnrJ4Dof7GMHtDgGJ97t3WHZAfq+beo4QUpE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O34ZIeIRdqN6qQqD828HUjYAzU5XVaRBwAoDck0zCDXoeRKLVnP/l01c31cbhjvmUQFBTiQe8ewMSiKEz+99gKtRLO1azaBBGdNSoaUvbjqY/M/4X/e/Ory1hnxaqQ4+Z7sZjqTwVIjQx5buz7eKTsI8mDRFoaqQ5NcoBjTJIdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rJDrWcpE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rJDrWcpE"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3AE7060865
	for <netfilter-devel@vger.kernel.org>; Mon, 12 Jan 2026 12:42:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1768218142;
	bh=2fLoWYwU3XAACAA1tG5yN/ktUWRKOF+wv2bodxTPR60=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rJDrWcpEetBYMLbuoCU9Ghy1vYn1nghl+fJKsA/aIlJxFvZUtqGRXitO2YN2z2OJm
	 H9a5rNcJ6PQjreVV50yBCyF4BQlYfZiBFcQg9R2+rpqSws3q1LDdsLgO+vhSWAta4o
	 OqHy3WHsqk/E4U2kqAngoF+WGc0idanYLLhSqwuwtElnzzYTfLR2MKQQtrNRhDfB1w
	 sAc82KlHL2oIcyR7mHhTMaJ7U6Xwxew3B2mN5PTRR8YK1R6gKQcK4h0C+Gtp+BqEjp
	 JA2efPKf5Nm/NvxE//C2lOSWRN8pnv0bWMJ8IYrAMhvSm60x5NM4SRVBYbSktIYLV+
	 /s0DY0bG/cgAg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] mnl: restore create element command with large batches
Date: Mon, 12 Jan 2026 12:42:16 +0100
Message-ID: <20260112114216.305723-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260112114216.305723-1-pablo@netfilter.org>
References: <20260112114216.305723-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rework to reduce memory consumption has introduced a bug that result
in spurious EEXIST with large batches.

The code that tracks the start and end elements of the interval can add
the same element twice to the batch. This works with the add element
command, since it ignores EEXIST error, but it breaks the the create
element command.

Update this codepath to ensure both sides of the interval fit into the
netlink message, otherwise, trim the netlink message to remove them.
So the next netlink message includes the elements that represent the
interval that could not fit.

Fixes: 91dc281a82ea ("src: rework singleton interval transformation to reduce memory consumption")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/mnl.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 0a445189da82..eee0a33ceaeb 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -1880,16 +1880,17 @@ static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
 
 static bool mnl_nft_attr_nest_overflow(struct nlmsghdr *nlh,
 				       const struct nlattr *from,
-				       const struct nlattr *to)
+				       const struct nlattr *to,
+				       unsigned int nest_len)
 {
-	int len = (void *)to + to->nla_len - (void *)from;
+	int len = (void *)to + nest_len - (void *)from;
 
 	/* The attribute length field is 16 bits long, thus the maximum payload
 	 * that an attribute can convey is UINT16_MAX. In case of overflow,
 	 * discard the last attribute that did not fit into the nest.
 	 */
 	if (len > UINT16_MAX) {
-		nlh->nlmsg_len -= to->nla_len;
+		nlh->nlmsg_len -= nest_len;
 		return true;
 	}
 	return false;
@@ -1955,8 +1956,9 @@ static int mnl_nft_setelem_batch(const struct nftnl_set *nls, struct cmd *cmd,
 				 struct netlink_ctx *ctx)
 {
 	struct nftnl_set_elem *nlse, *nlse_high = NULL;
+	struct nlattr *nest1, *nest2, *nest3;
 	struct expr *expr = NULL, *next;
-	struct nlattr *nest1, *nest2;
+	unsigned int nest_len = 0;
 	struct nlmsghdr *nlh;
 	int i = 0;
 
@@ -1998,33 +2000,35 @@ next:
 			else
 				next = NULL;
 
-			if (!nlse_high) {
-				nlse = alloc_nftnl_setelem_interval(set, init, expr, next, &nlse_high);
-			} else {
-				nlse = nlse_high;
-				nlse_high = NULL;
-			}
+			nlse = alloc_nftnl_setelem_interval(set, init, expr, next, &nlse_high);
 		} else {
 			nlse = alloc_nftnl_setelem(init, expr);
 		}
 
 		cmd_add_loc(cmd, nlh, &expr->location);
 
-		/* remain with this element, range high still needs to be added. */
-		if (nlse_high)
-			expr = list_prev_entry(expr, list);
-
 		nest2 = mnl_attr_nest_start(nlh, ++i);
 		nftnl_set_elem_nlmsg_build_payload(nlh, nlse);
 		mnl_attr_nest_end(nlh, nest2);
 
 		netlink_dump_setelem(nlse, ctx);
 		nftnl_set_elem_free(nlse);
-		if (mnl_nft_attr_nest_overflow(nlh, nest1, nest2)) {
-			if (nlse_high) {
-				nftnl_set_elem_free(nlse_high);
-				nlse_high = NULL;
-			}
+
+		nest_len = nest2->nla_len;
+
+		if (nlse_high) {
+			nest3 = mnl_attr_nest_start(nlh, ++i);
+			nftnl_set_elem_nlmsg_build_payload(nlh, nlse_high);
+			mnl_attr_nest_end(nlh, nest3);
+
+			netlink_dump_setelem(nlse_high, ctx);
+			nftnl_set_elem_free(nlse_high);
+			nlse_high = NULL;
+
+			nest_len += nest3->nla_len;
+		}
+
+		if (mnl_nft_attr_nest_overflow(nlh, nest1, nest2, nest_len)) {
 			mnl_attr_nest_end(nlh, nest1);
 			mnl_nft_batch_continue(batch);
 			mnl_seqnum_inc(seqnum);
-- 
2.47.3

