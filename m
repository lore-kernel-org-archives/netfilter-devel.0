Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEED1ACEDD
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 18:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749752261; cv=none; b=lnqgEDhexr938xw2qowxPhTOn8TbsNreeCIfWIJz+CfXQXHjl+ciqcu0GKvtcHFgE3RuRrsrrRp3TaYci/ojLCgvGOqN78WSIwIUk/pNxpNZIHrK+UQREnpY3B+rYuwv9GETT/0NFcFxZH/3B1D80M3ZSxGNM0yayvLokYho6HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749752261; c=relaxed/simple;
	bh=MyQS/Zaw3bbaHrlVcaZoZBtmh1Lx49OnnTojN4n0XzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u5YbC9U0SkMa9l9HPh5TK7qyT1qqSDfNDdM0oD3MpGqzoYHszHzgdTg0CiAHSkB4RFJjjM5ZmqiI04yj4OXGkKTkKS026zZbzdjhfkV+SK9+Nb5qPOtzTfvxoL6h9XrPP9ossPwx5P2XDVVNgQHnaBfBYtrNKNt5dGkg6zsxQzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9331D612C5; Thu, 12 Jun 2025 20:17:36 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nft] src: move BASECHAIN flag toggle to netlink linearize code for device update
Date: Thu, 12 Jun 2025 20:17:15 +0200
Message-ID: <20250612181724.18173-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The included bogon will crash nft because print side assumes that
a BASECHAIN flag presence also means that priority expression is
available.

Make the print side conditional.

Fixes: a66b5ad9540d ("src: allow for updating devices on existing netdev chain")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/rule.c                                       | 16 ++++++++++------
 .../bogons/nft-f/null_ingress_type_crash         |  6 ++++++
 2 files changed, 16 insertions(+), 6 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/null_ingress_type_crash

diff --git a/src/rule.c b/src/rule.c
index 264a2a44147d..661673e58eb7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1067,8 +1067,10 @@ static void chain_print_declaration(const struct chain *chain,
 		nft_print(octx, "\n\t\tcomment \"%s\"", chain->comment);
 	nft_print(octx, "\n");
 	if (chain->flags & CHAIN_F_BASECHAIN) {
-		nft_print(octx, "\t\ttype %s hook %s", chain->type.str,
-			  hooknum2str(chain->handle.family, chain->hook.num));
+		if (chain->type.str)
+			nft_print(octx, "\t\ttype %s hook %s", chain->type.str,
+				  hooknum2str(chain->handle.family, chain->hook.num));
+
 		if (chain->dev_array_len == 1) {
 			nft_print(octx, " device \"%s\"", chain->dev_array[0]);
 		} else if (chain->dev_array_len > 1) {
@@ -1080,10 +1082,12 @@ static void chain_print_declaration(const struct chain *chain,
 			}
 			nft_print(octx, " }");
 		}
-		nft_print(octx, " priority %s;",
-			  prio2str(octx, priobuf, sizeof(priobuf),
-				   chain->handle.family, chain->hook.num,
-				   chain->priority.expr));
+
+		if (chain->priority.expr)
+			nft_print(octx, " priority %s;",
+				  prio2str(octx, priobuf, sizeof(priobuf),
+					   chain->handle.family, chain->hook.num,
+					   chain->priority.expr));
 		if (chain->policy) {
 			mpz_export_data(&policy, chain->policy->value,
 					BYTEORDER_HOST_ENDIAN, sizeof(int));
diff --git a/tests/shell/testcases/bogons/nft-f/null_ingress_type_crash b/tests/shell/testcases/bogons/nft-f/null_ingress_type_crash
new file mode 100644
index 000000000000..2ed88af24c56
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/null_ingress_type_crash
@@ -0,0 +1,6 @@
+table netdev filter1 {
+	chain c {
+		devices = { lo }
+	}
+}
+list ruleset
-- 
2.49.0

