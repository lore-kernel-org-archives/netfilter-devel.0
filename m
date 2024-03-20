Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B05F495CB
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 14:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946675; cv=none; b=KVJqaAU3/hzg9tlROvLUTofOMgRr/hw1YCvCIeQ29VxYUmsuD6c8AI1Wdo2bIQUWtrb204IK59GoabXPybuOPv7zeuQQh9kJftkSFqrY7nUq+eUBUMNf264zgESia/DuuRpA/Ax0t+P0M9HR4IEXsdQUn94t/4z7qEjP4h11vfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946675; c=relaxed/simple;
	bh=+MWA8ZKftY1T7ZJUFUvZL7/n/ucOBpniVKph/OM2kQg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pAXNgCGQA39FPawIhekhqqJ97ckgeTgVn9qi1fUYBIvEaNFX4qKIwElnGWrSYjLPF3yRhPCXq0CvoDfttbKaXPAl++BfV8PMFmPZcA3Velg27oRvXOkiWiS9t0cgL8JwnmpT3KDK0J6nHZxznq9hQ4eDsdw0QaI5SvPq9sskEJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RU1jlRlu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RU1jlRlu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DN5yPfHbRS5eh7w2mEjqEuF1EYHo3vhvgSr6365nQsg=; b=RU1jlRluJHOAkjk7dMJBTvoach
	c8c6LPWG0KBCws5dsUWJIE29FX8S7gfAGdBZrqLPmk1BdhgObOxEAIhpOcY2gICVqWwQqd7CEaf+G
	lcfevSq4CJZycZ5aokkkprcYDrLpTOFFVmXSYc5+lVOKAq3VaVovkdIn5G+Q+OMlGJOHoBZ5b/h4a
	DLWUVTI0CI1GBlOgZu/IiN/QaxFswiO3TXRq83Z5KA6tSFF0JfU5kEaxxa3FtsdrWsyBXncscoT6s
	ro/EmEnpWaQhXZFkovJ3oMxjiQqs+Ff7fUAvm4Ag9Fi8uBqaeKHnq4oj0tsIUAdTwI8mH5RF3hszs
	6ZkFyStg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rmxO2-000000003fb-0qZD
	for netfilter-devel@vger.kernel.org;
	Wed, 20 Mar 2024 15:57:50 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Fix one json-nft dump for reordered output
Date: Wed, 20 Mar 2024 15:57:46 +0100
Message-ID: <20240320145746.3844-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Missed this one when regenerating all dumps.

Fixes: 2a0fe52eca32a ("tests: shell: Regenerate all json-nft dumps")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/sets/dumps/meter_0.json-nft     | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tests/shell/testcases/sets/dumps/meter_0.json-nft b/tests/shell/testcases/sets/dumps/meter_0.json-nft
index 71e83b19f1360..c318e4f269871 100644
--- a/tests/shell/testcases/sets/dumps/meter_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/meter_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "test",
+        "name": "test",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "ip6",
@@ -48,14 +56,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip6",
-        "table": "test",
-        "name": "test",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip6",
@@ -145,6 +145,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "test",
+        "name": "test",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -159,14 +167,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "test",
-        "name": "test",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
-- 
2.43.0

