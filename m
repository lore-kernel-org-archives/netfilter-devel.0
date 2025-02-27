Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FFF25DB06
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Feb 2025 14:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740667981; cv=none; b=qW/OTdZNthqHcy6zzoNo0vTTvtzAlWrqrW+aZz0HSRWz343QcL2+KnbiM6C66jfVo7yyTWggvTN90AyHelxlXJlptmhNIWt0y4+12oibreuJwrI98Jq09CqksUfwydJQ2YqwF9+GzUNojitM8TUfMkNx61/lfv34TEO/iA/nZ7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740667981; c=relaxed/simple;
	bh=Y0KdCO1WSKqxDZU376Zv+EFZFG0Zuc1VMYgtmBUiIOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKZeOUZV5qNwAvWz5BRrgoWRuUwA3j2lZcCZnBjkKdg2rMeG2Mfo/hfOvUgxwNHJ1mByvYZim6FWcaQG874Uz4u2mWnWLfk1FKjei4Z2U8XyzV8isTv858Usyxt2i50E4nDWbQqKxQLSCUhiDi4MfUFX96wP8lDqyy1eZntV65g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tnfFv-0002Mk-JA; Thu, 27 Feb 2025 15:52:55 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/4] netlink_delinearize: also consider exthdr type when trimming binops
Date: Thu, 27 Feb 2025 15:52:09 +0100
Message-ID: <20250227145214.27730-4-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
In-Reply-To: <20250227145214.27730-1-fw@strlen.de>
References: <20250227145214.27730-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows trimming the binop for exthdrs, this will make nft render
   (tcp option mptcp unknown & 240) >> 4 . ip saddr @s1

as
    tcp option mptcp subtype . ip saddr @s1

Also extend the typeof set tests with a set concatenating a
sub-byte-sized exthdr expression with a payload one.

The additional call to expr_postprocess() is needed, without this,
typeof_sets_0.nft fails because
  frag frag-off @s4 accept

is shown as
 meta nfproto ipv6 frag frag-off @s4 accept

Previouly, EXPR_EXTHDR would cause payload_binop_postprocess()
to return false which will then make the caller invoke
expr_postprocess(), but after handling EXPR_EXTHDR this doesn't happen
anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_delinearize.c                     | 10 +++++++++-
 .../testcases/sets/dumps/typeof_sets_0.nft    | 10 ++++++++++
 tests/shell/testcases/sets/typeof_sets_0      | 19 +++++++++++++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b629916ebff8..698bae85c8cc 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2655,8 +2655,16 @@ static bool payload_binop_postprocess(struct rule_pp_ctx *ctx,
 	if (expr->left->etype != EXPR_BINOP || expr->left->op != OP_AND)
 		return false;
 
-	if (expr->left->left->etype != EXPR_PAYLOAD)
+	switch (expr->left->left->etype) {
+	case EXPR_EXTHDR:
+		break;
+	case EXPR_PAYLOAD:
+		break;
+	default:
 		return false;
+	}
+
+	expr_postprocess(ctx, &expr->left->left);
 
 	expr_set_type(expr->right, &integer_type,
 		      BYTEORDER_HOST_ENDIAN);
diff --git a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
index ed45d84a0eff..34aaab601cda 100644
--- a/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_sets_0.nft
@@ -65,6 +65,12 @@ table inet t {
 		elements = { mp-join, dss }
 	}
 
+	set s14 {
+		typeof tcp option mptcp subtype . ip daddr
+		elements = { remove-addr . 10.1.1.1,
+			     mp-join . 10.1.1.2 }
+	}
+
 	chain c1 {
 		osf name @s1 accept
 	}
@@ -112,4 +118,8 @@ table inet t {
 	chain c13 {
 		tcp option mptcp subtype @s13 accept
 	}
+
+	chain c14 {
+		tcp option mptcp subtype . ip saddr @s14 accept
+	}
 }
diff --git a/tests/shell/testcases/sets/typeof_sets_0 b/tests/shell/testcases/sets/typeof_sets_0
index 5ba7fc76ce15..ef2726db3b30 100755
--- a/tests/shell/testcases/sets/typeof_sets_0
+++ b/tests/shell/testcases/sets/typeof_sets_0
@@ -124,6 +124,11 @@ INPUT="table inet t {$INPUT_OSF_SET
 		typeof tcp option mptcp subtype
 		elements = { mp-join, dss }
 	}
+
+	set s14 {
+		typeof tcp option mptcp subtype . ip daddr
+		elements = { remove-addr . 10.1.1.1, mp-join . 10.1.1.2 }
+	}
 $INPUT_OSF_CHAIN
 	chain c2 {
 		ether type vlan vlan id @s2 accept
@@ -157,6 +162,10 @@ $INPUT_VERSION_CHAIN
 	chain c13 {
 		tcp option mptcp subtype @s13 accept
 	}
+
+	chain c14 {
+		tcp option mptcp subtype . ip saddr @s14 accept
+	}
 }"
 
 EXPECTED="table inet t {$INPUT_OSF_SET
@@ -210,6 +219,12 @@ $INPUT_VERSION_SET
 		typeof tcp option mptcp subtype
 		elements = { mp-join, dss }
 	}
+
+	set s14 {
+		typeof tcp option mptcp subtype . ip daddr
+		elements = { remove-addr . 10.1.1.1,
+			     mp-join . 10.1.1.2 }
+	}
 $INPUT_OSF_CHAIN
 	chain c2 {
 		vlan id @s2 accept
@@ -242,6 +257,10 @@ $INPUT_SCTP_CHAIN$INPUT_VERSION_CHAIN
 	chain c13 {
 		tcp option mptcp subtype @s13 accept
 	}
+
+	chain c14 {
+		tcp option mptcp subtype . ip saddr @s14 accept
+	}
 }"
 
 
-- 
2.45.3

