Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0975D3D0A2
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2023 16:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rFdB9-0002Bl-W9; Tue, 19 Dec 2023 17:42:48 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] datatype: do not assert when value exceeds 255
Date: Tue, 19 Dec 2023 17:42:39 +0100
Message-ID: <20231219164242.27511-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before:
nft list ruleset
chain c {
   ip protocol & nft: src/gmputil.c:77: mpz_get_uint8: Assertion `cnt <= 1' failed.
Aborted (core dumped)

After:
table ip t {
        chain c {
                ip protocol & 18446739675663040512 . th dport 0 . 0
	}
}

Note that nft should not have allowed to add such rule in the first
place, input is:

ip protocol . th dport { tcp / 22,  }'

... which should be rejected, but is currently allowed.
The decoding is incorrect too (as seen by 0 . 0).

But technically a 'direct nfnetlink user' could create this too
and decoding should work in all cases.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/datatype.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 86d55a524269..5abfd978a39b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -715,7 +715,8 @@ const struct datatype ip6addr_type = {
 static void inet_protocol_type_print(const struct expr *expr,
 				      struct output_ctx *octx)
 {
-	if (!nft_output_numeric_proto(octx)) {
+	if (!nft_output_numeric_proto(octx) &&
+	    mpz_cmp_ui(expr->value, UINT_MAX) <= 0) {
 		char name[NFT_PROTONAME_MAXSIZE];
 
 		if (nft_getprotobynumber(mpz_get_uint8(expr->value), name, sizeof(name))) {
-- 
2.41.0

