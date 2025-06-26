Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94589139579
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Jun 2025 00:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750899186; cv=none; b=gCY5fyXkAMXUi+mmqRRaSZMeUG+675NszeXgkWPaFYqwWytsotYcV3U1M9C0rW07C2Lluxm+VC/z75THrmwPgsDcoGnadUd7/qZ+qE5tR4MTTz90NvdaxMJAtQieqDooY0KQi1HI+f2uvpl0ZNFbLISFslADQ8llv8gTNmFj+aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750899186; c=relaxed/simple;
	bh=O+HGJpSmd5sc/7Mbk9g0mH7nIDAKopkK+/o/UG72u5U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UFjizyHGQJAHonK4d/1+fV+e8JoKpoksnmOl7WasrOJy6JgfVdmmWwQsuI+yjkRcF/F3bWsmUSBaKZqP725BD6SxsSE8rHdHSCOqazuMUPHxSbWe9MLX5RuhKhopjZkMUSW75nzwdlxtBXSgnUpPHwIUtZ3+WMISWoz6Xu6biRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 21DBA60164; Thu, 26 Jun 2025 02:52:57 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: prevent merge of sets with incompatible keys
Date: Thu, 26 Jun 2025 02:52:48 +0200
Message-ID: <20250626005250.11833-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Its not enough to check for interval flag, this would assert in interval
code due to concat being passed to the interval code:
BUG: unhandled key type 13

After fix:
same_set_name_but_different_keys_assert:8:6-7: Error: set already exists with
different datatype (concatenation of (IPv4 address, network interface index) vs
network interface index)
        set s4 {
            ^^

This also improves error verbosity when mixing datamap and objref maps:

invalid_transcation_merge_map_and_objref_map:9:13-13:
Error: map already exists with different datatype (IPv4 address vs string)

.. instead of 'Cannot merge map with incompatible existing map of same name'.
The 'Cannot merge map with incompatible existing map of same name' check
is kept in place to catch when ruleset contains a set and map with same name
and same key definition.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Followup to previous
 '[nft,v2] evaluate: check that set type is identical before merging',
  it has the welcome side effect to improve error reporting as well.

 src/evaluate.c                                      | 12 ++++++++++++
 src/intervals.c                                     |  2 +-
 .../nft-f/same_set_name_but_different_keys_assert   | 13 +++++++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/same_set_name_but_different_keys_assert

diff --git a/src/evaluate.c b/src/evaluate.c
index fc9d82f73b68..a2d5d7c29514 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -5304,6 +5304,18 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		if (set_is_interval(set->flags) && !set_is_interval(existing_set->flags))
 			return set_error(ctx, set,
 					 "existing %s lacks interval flag", type);
+		if (set->data && existing_set->data &&
+		    !datatype_equal(existing_set->data->dtype, set->data->dtype))
+			return set_error(ctx, set,
+					 "%s already exists with different datatype (%s vs %s)",
+					 type, existing_set->data->dtype->desc,
+					 set->data->dtype->desc);
+		if (!datatype_equal(existing_set->key->dtype, set->key->dtype))
+			return set_error(ctx, set,
+					 "%s already exists with different datatype (%s vs %s)",
+					 type, existing_set->key->dtype->desc,
+					 set->key->dtype->desc);
+		/* Catch attempt to merge set and map */
 		if (!set_type_compatible(set, existing_set))
 			return set_error(ctx, set, "Cannot merge %s with incompatible existing %s of same name",
 					type,
diff --git a/src/intervals.c b/src/intervals.c
index bf125a0c59d3..e5bbb0384964 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -70,7 +70,7 @@ static void setelem_expr_to_range(struct expr *expr)
 		expr->key = key;
 		break;
 	default:
-		BUG("unhandled key type %d\n", expr->key->etype);
+		BUG("unhandled key type %s\n", expr_name(expr->key));
 	}
 }
 
diff --git a/tests/shell/testcases/bogons/nft-f/same_set_name_but_different_keys_assert b/tests/shell/testcases/bogons/nft-f/same_set_name_but_different_keys_assert
new file mode 100644
index 000000000000..8fcfdf5cba03
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/same_set_name_but_different_keys_assert
@@ -0,0 +1,13 @@
+table ip t {
+	set s4 {
+		type ipv4_addr . iface_index
+		flags interval
+		elements = { 127.0.0.1 . "lo" }
+	}
+
+	set s4 {
+		type iface_index
+		flags interval
+		elements = { "lo" }
+	}
+}
-- 
2.49.0

