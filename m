Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BC7282E5
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2024 12:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rOGi0-0006Bj-Vc; Fri, 12 Jan 2024 13:32:24 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] rule: do not crash if to-be-printed flowtable lacks priority
Date: Fri, 12 Jan 2024 13:32:17 +0100
Message-ID: <20240112123220.12812-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Print an empty flowtable rather than crashing when dereferencing
flowtable->priority.expr (its NULL).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/rule.c                                        | 15 +++++++++------
 .../testcases/bogons/flowtable-no-priority-crash  |  6 ++++++
 2 files changed, 15 insertions(+), 6 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/flowtable-no-priority-crash

diff --git a/src/rule.c b/src/rule.c
index 172ba1f606e9..4138c21b81bc 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2088,12 +2088,15 @@ static void flowtable_print_declaration(const struct flowtable *flowtable,
 	if (nft_output_handle(octx))
 		nft_print(octx, " # handle %" PRIu64, flowtable->handle.handle.id);
 	nft_print(octx, "%s", opts->nl);
-	nft_print(octx, "%s%shook %s priority %s%s",
-		  opts->tab, opts->tab,
-		  hooknum2str(NFPROTO_NETDEV, flowtable->hook.num),
-		  prio2str(octx, priobuf, sizeof(priobuf), NFPROTO_NETDEV,
-			   flowtable->hook.num, flowtable->priority.expr),
-		  opts->stmt_separator);
+
+	if (flowtable->priority.expr) {
+		nft_print(octx, "%s%shook %s priority %s%s",
+			  opts->tab, opts->tab,
+			  hooknum2str(NFPROTO_NETDEV, flowtable->hook.num),
+			  prio2str(octx, priobuf, sizeof(priobuf), NFPROTO_NETDEV,
+				   flowtable->hook.num, flowtable->priority.expr),
+			  opts->stmt_separator);
+	}
 
 	if (flowtable->dev_array_len > 0) {
 		nft_print(octx, "%s%sdevices = { ", opts->tab, opts->tab);
diff --git a/tests/shell/testcases/bogons/flowtable-no-priority-crash b/tests/shell/testcases/bogons/flowtable-no-priority-crash
new file mode 100644
index 000000000000..b327a2bdd341
--- /dev/null
+++ b/tests/shell/testcases/bogons/flowtable-no-priority-crash
@@ -0,0 +1,6 @@
+reset rules
+table inet filter {
+	flowtable f {
+		devices = { lo }
+	}
+}
-- 
2.41.0

