Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D2AC16062C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Feb 2024 16:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709223257; cv=none; b=WKEIdqJye9UILEPyB5n9TfW3lrwsp/2PZeWlUqyKS+99Bpft9p+zo8Pb+5KmflXTtVPD068ojHbWpojiL1StK/kKsJO2HyAOFNQYtF4whVX/a52EBKtpOumWgKQvwjR+J7Wn+jsFtj9dX4WA03fxkCJheNkBsFaFX+cpkh6EC6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709223257; c=relaxed/simple;
	bh=K22tyCu6/L6Nu+yKiUbrYDpduwBH9g4opv4gQ7X6/cc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=hAOJdlskrKqCOgO+P9Yhsfqv/vhuhfGMcCO9wYl+1O3iXiveKgYxxMcqYXrgKFLJRlecwDrTMaObEU+Hyma1PHYoxuqdBU/NZNCqf7u297C/VQX6JrhUl5mk5MwfRlOQsuX8Pyxj+QlXzN89p4qmfWJcvG6ATwIVBOgYjKOA7K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] rule: fix ASAN errors in priority to string conversion
Date: Thu, 29 Feb 2024 17:14:08 +0100
Message-Id: <20240229161408.194625-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ASAN reports several errors when listing this ruleset:

 table ip x {
        chain y {
                type filter hook input priority -2147483648; policy accept;
        }
 }

src/rule.c:1002:8: runtime error: negation of -2147483648 cannot be represented in type 'int'; cast to an unsigned type to negate this value to itself
src/rule.c:1001:11: runtime error: signed integer overflow: -2147483648 - 50 cannot be represented in type 'int'

Use int64_t for the offset to avoid an underflow when calculating
closest existing priority definition.

Use llabs() because abs() is undefined with INT32_MIN.

Fixes: c8a0e8c90e2d ("src: Set/print standard chain prios with textual names")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 342c43fb1b4b..adab584e9a79 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -977,10 +977,11 @@ static const char *prio2str(const struct output_ctx *octx,
 			    const struct expr *expr)
 {
 	const struct prio_tag *prio_arr;
-	int std_prio, offset, prio;
+	const uint32_t reach = 10;
 	const char *std_prio_str;
-	const int reach = 10;
+	int std_prio, prio;
 	size_t i, arr_size;
+	int64_t offset;
 
 	mpz_export_data(&prio, expr->value, BYTEORDER_HOST_ENDIAN, sizeof(int));
 	if (family == NFPROTO_BRIDGE) {
@@ -995,19 +996,21 @@ static const char *prio2str(const struct output_ctx *octx,
 		for (i = 0; i < arr_size; ++i) {
 			std_prio = prio_arr[i].val;
 			std_prio_str = prio_arr[i].str;
-			if (abs(prio - std_prio) <= reach) {
+
+			offset = (int64_t)prio - std_prio;
+			if (llabs(offset) <= reach) {
 				if (!std_prio_family_hook_compat(std_prio,
 								 family, hook))
 					break;
-				offset = prio - std_prio;
+
 				strncpy(buf, std_prio_str, bufsize);
 				if (offset > 0)
 					snprintf(buf + strlen(buf),
-						 bufsize - strlen(buf), " + %d",
+						 bufsize - strlen(buf), " + %" PRIu64,
 						 offset);
 				else if (offset < 0)
 					snprintf(buf + strlen(buf),
-						 bufsize - strlen(buf), " - %d",
+						 bufsize - strlen(buf), " - %" PRIu64,
 						 -offset);
 				return buf;
 			}
-- 
2.30.2

