Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC60C2D033
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 12:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rE6ve-0004Qc-NZ; Fri, 15 Dec 2023 13:04:30 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tcpopt: don't create exthdr expression without datatype
Date: Fri, 15 Dec 2023 13:04:22 +0100
Message-ID: <20231215120425.32532-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The reproducer crashes during concat evaluation, as the
exthdr expression lacks a datatype.

This should never happen, i->dtype must be set.

In this case the culprit is tcp option parsing, it will
wire up a non-existent template, because the "nop" option
has no length field (1 byte only).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/tcpopt.c                                                   | 2 +-
 tests/shell/testcases/bogons/nft-f/tcp_option_without_template | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/tcp_option_without_template

diff --git a/src/tcpopt.c b/src/tcpopt.c
index 8111a50718ac..f977e417536a 100644
--- a/src/tcpopt.c
+++ b/src/tcpopt.c
@@ -224,7 +224,7 @@ struct expr *tcpopt_expr_alloc(const struct location *loc,
 	}
 
 	tmpl = &desc->templates[field];
-	if (!tmpl)
+	if (!tmpl || !tmpl->dtype)
 		return NULL;
 
 	expr = expr_alloc(loc, EXPR_EXTHDR, tmpl->dtype,
diff --git a/tests/shell/testcases/bogons/nft-f/tcp_option_without_template b/tests/shell/testcases/bogons/nft-f/tcp_option_without_template
new file mode 100644
index 000000000000..fd732fd31aa5
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/tcp_option_without_template
@@ -0,0 +1 @@
+add rule f i tcp option nop length . @ih,32,3 1
-- 
2.41.0

