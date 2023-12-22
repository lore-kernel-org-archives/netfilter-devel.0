Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E772231B
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2023 14:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rGgXZ-0006oB-Mz; Fri, 22 Dec 2023 15:30:17 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nft] datatype: do not assert when value exceeds expected width
Date: Fri, 22 Dec 2023 15:30:09 +0100
Message-ID: <20231222143012.8923-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Inputs:
ip protocol . th dport { tcp / 22,  }'
or
th dport . ip protocol { tcp / 22,  }'

are not rejected at this time. 'list ruleset' yields:
 ip protocol & nft: src/gmputil.c:77: mpz_get_uint8: Assertion `cnt <= 1' failed.
or
 th dport & nft: src/gmputil.c:87: mpz_get_be16: Assertion `cnt <= 1' failed.

While this should be caught at input too, the print path should be more
robust, e.g. when there are direct nfnetlink users.

After this patch, the print functions fall back to
'integer_type_print' which can handle large numbers too.

Note that the output printed this way cannot be read back by nft;
it will dump something like:

  tcp dport & 18446739675663040512 . ip protocol 0 . 0

but thats better than assert().

v2: same problem exists for service too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/datatype.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 86d55a524269..74899dec221f 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -715,7 +715,8 @@ const struct datatype ip6addr_type = {
 static void inet_protocol_type_print(const struct expr *expr,
 				      struct output_ctx *octx)
 {
-	if (!nft_output_numeric_proto(octx)) {
+	if (!nft_output_numeric_proto(octx) &&
+	    mpz_cmp_ui(expr->value, UINT8_MAX) <= 0) {
 		char name[NFT_PROTONAME_MAXSIZE];
 
 		if (nft_getprotobynumber(mpz_get_uint8(expr->value), name, sizeof(name))) {
@@ -796,7 +797,8 @@ static void inet_service_print(const struct expr *expr, struct output_ctx *octx)
 
 void inet_service_type_print(const struct expr *expr, struct output_ctx *octx)
 {
-	if (nft_output_service(octx)) {
+	if (nft_output_service(octx) &&
+	    mpz_cmp_ui(expr->value, UINT16_MAX) <= 0) {
 		inet_service_print(expr, octx);
 		return;
 	}
-- 
2.41.0

