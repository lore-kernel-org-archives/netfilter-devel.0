Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568BAC2C6
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Apr 2025 11:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745063097; cv=none; b=ERW7mqyC6m2vHtYdp9a7ZJfAUne4OFP+iM2l3UJcYdKg64hAEQcXWzSKjpDC3x82uY4PsupVfZXnmaYIGKWepVQaFr0WUXXEDFhK+/bf/uYQKlExqTkB80tZzjF3jpbyjr6HRO2N4pJo/KPjB/aNwelXobCAqWd3hejtacofaTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745063097; c=relaxed/simple;
	bh=I2VPkbxuWESyYmOve7/ltvrYvE5Yt6Rjq7qY82gNdqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C58RnUOMqY2lOI3mEAXMI4zYmpX3As+Fi31wEPMZCIDGkqSJgOe7z4OZKb6zk2lWYO9yjbmmxKcOPCd1Y6EaK6zxCmQBatPtbl6ByI8d7nfaGXGds9j0kNBoYbFGdvHuSLYh78XfgidCfLL7IE8zpqqi+B8Z6QvqqP2KvrW9Gyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1u66co-0001Kt-5I; Sat, 19 Apr 2025 13:44:46 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Kevin Vigouroux <ke.vigouroux@laposte.net>
Subject: [PATCH nft] evalute: make vlan pcp updates work
Date: Sat, 19 Apr 2025 13:44:39 +0200
Message-ID: <20250419114442.45696-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On kernel side, nft_payload_set_vlan() requires a 2 or 4 byte
write to the vlan header.

As-is, nft emits a 1 byte write:
  [ payload load 1b @ link header + 14 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000001f ) ^ 0x00000020 ]

... which the kernel doesn't support.  Expand all vlan header updates to
a 2 or 4 byte write and update the existing vlan id test case.

Reported-by: Kevin Vigouroux <ke.vigouroux@laposte.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c                                | 42 +++++++++++++++++--
 .../shell/testcases/packetpath/vlan_mangling  |  2 +
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index d13b11413244..9c7f23cb080e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3258,6 +3258,40 @@ static bool stmt_evaluate_payload_need_csum(const struct expr *payload)
 	return desc && desc->checksum_key;
 }
 
+static bool stmt_evaluate_is_vlan(const struct expr *payload)
+{
+	return payload->payload.base == PROTO_BASE_LL_HDR &&
+	       payload->payload.desc == &proto_vlan;
+}
+
+/** stmt_evaluate_payload_need_aligned_fetch
+ *
+ * @payload:	payload expression to check
+ *
+ * Some types of stores need to round up to an even sized byte length,
+ * typically 1 -> 2 or 3 -> 4 bytes.
+ *
+ * This includes anything that needs inet checksum fixups and also writes
+ * to the vlan header.  This is because of VLAN header removal in the
+ * kernel: nftables kernel side provides illusion of a linear packet, i.e.
+ * ethernet_header|vlan_header|network_header.
+ *
+ * When a write to the vlan header is performed, kernel side updates the
+ * pseudoheader, but only accepts 2 or 4 byte writes to vlan proto/TCI.
+ *
+ * Return true if load needs to be expanded to cover even amount of bytes
+ */
+static bool stmt_evaluate_payload_need_aligned_fetch(const struct expr *payload)
+{
+	if (stmt_evaluate_payload_need_csum(payload))
+		return true;
+
+	if (stmt_evaluate_is_vlan(payload))
+		return true;
+
+	return false;
+}
+
 static int stmt_evaluate_exthdr(struct eval_ctx *ctx, struct stmt *stmt)
 {
 	struct expr *exthdr;
@@ -3287,7 +3321,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 	unsigned int masklen, extra_len = 0;
 	struct expr *payload;
 	mpz_t bitmask, ff;
-	bool need_csum;
+	bool aligned_fetch;
 
 	if (stmt->payload.expr->payload.inner_desc) {
 		return expr_error(ctx->msgs, stmt->payload.expr,
@@ -3310,7 +3344,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 	if (stmt->payload.val->etype == EXPR_RANGE)
 		return stmt_error_range(ctx, stmt, stmt->payload.val);
 
-	need_csum = stmt_evaluate_payload_need_csum(payload);
+	aligned_fetch = stmt_evaluate_payload_need_aligned_fetch(payload);
 
 	if (!payload_needs_adjustment(payload)) {
 
@@ -3318,7 +3352,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 		 * update checksum and the length is not even because
 		 * kernel checksum functions cannot deal with odd lengths.
 		 */
-		if (!need_csum || ((payload->len / BITS_PER_BYTE) & 1) == 0)
+		if (!aligned_fetch || ((payload->len / BITS_PER_BYTE) & 1) == 0)
 			return 0;
 	}
 
@@ -3334,7 +3368,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 				  "uneven load cannot span more than %u bytes, got %u",
 				  sizeof(data), payload_byte_size);
 
-	if (need_csum && payload_byte_size & 1) {
+	if (aligned_fetch && payload_byte_size & 1) {
 		payload_byte_size++;
 
 		if (payload_byte_offset & 1) { /* prefer 16bit aligned fetch */
diff --git a/tests/shell/testcases/packetpath/vlan_mangling b/tests/shell/testcases/packetpath/vlan_mangling
index e3fd443ebcf9..3fc2ebb2a517 100755
--- a/tests/shell/testcases/packetpath/vlan_mangling
+++ b/tests/shell/testcases/packetpath/vlan_mangling
@@ -48,12 +48,14 @@ table netdev t {
 
 	chain in {
 		type filter hook ingress device veth0 priority filter;
+		vlan pcp 0 counter
 		ether saddr da:d3:00:01:02:03 vlan id 123 jump in_update_vlan
 	}
 
 	chain out_update_vlan {
 		vlan type arp vlan id set 123 counter
 		ip daddr 10.1.1.1 icmp type echo-reply vlan id set 123 counter
+		vlan pcp set 6 counter
 	}
 
 	chain out {
-- 
2.49.0

