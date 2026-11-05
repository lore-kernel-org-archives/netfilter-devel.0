Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900248;
	b=ULSKHf2KY1c5b0CEruonmPNPhVaGwnyZZRh5gjDyXJnYIw1vymVSn3Wt+i3BPWym9Yx0
	 nGXh7PLfQ1MmnP0vjTgRnqrSbl1pp8TsGo/VPj+yuLRM5Avg/Fo0H6u4dTVM0T39FzEIu
	 iYEy3SrcSKB7B3PGi232m8NiTrJm67Gh3ybY66vcpHa7Qvd35LENKLkRE20nuN30TQ6dw
	 3upuOaul64E0XptJ3ooBN7WcTbtXeXUgov4xiQyeGhDTtmbyFDihe5GTZqBHEyTz+lLvQ
	 LDrtVSaN3RN0tsp3AZUXxvy5bf3gyEHCCUtBwNAimEH8Rnk+cda9oFVyx7bH9LUj0Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900248;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9BMXR8ymGi9JKYWGcdzzRKWEPZ0mhXqSHKuywUKsWOI=;
	b=njBkazAz2QAYevFcsvjSMYW42Yix2oFLD7Mg82Tx9FB4mbeiHm1tqAndjCHyybY7Q86Y
	 0YVkeAShtVD4DdvNbJqGqa9r46HEfRhxG5guS5sbaHfrESQNCA1+w6USn4IHxXwnDE1pD
	 UagQGe4ITyfn81BbmLKi97091tSpVMmQJLzJe2OgovJR2GLvkKcQJfLo84vOleQFa9DJo
	 vh5z4fyJHET4dqbW+EI8d2Hjjfq589zAuhg0OhYu3ORPVzpEci75i2FCFK9vLNUfJND07
	 atmVoiaOUlrPVmxTWtdjzpjMrjcVRg3aFc2uc2Lf+b7F02lL41dCVfQqtbd8uxvkxQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=ZOhKSPoY;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24D3606A33C
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 17:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D24D3606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=ZOhKSPoY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9BMXR8ymGi9JKYWGcdzzRKWEPZ0mhXqSHKuywUKsWOI=; b=ZOhKSPoYrikFPiWk5lFuC5gyN9
	UmoirVuItHntGhFwOTCOXoyS1EsfJNA9RTBYMFClMC+iuY28JT18D+Wo/8p5ReYb89BUmuBDeGhjr
	HxU1BeNQKTYoNsGrfn4e9ymDhMM39Rfbp8SlYcJfjPQrtqnQjrcld0PLUmiGTOSlzCeyOuvX3IoOv
	ssT8vawwHkR5HMUJlGuYV/1wJM/C10ANCcaMu36unJSHRitMxsXLanuKTzK8fsicS68kVpiMd6l7r
	ShDZoJf/x507btlpgMQxFYvQqfyElKfAthUObwCWO9NKSjY856/6LKGMGX/nkUqPbYuRJYXWpWwfx
	dF01bZpw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=tia)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xP1Op-000000005lc-1OfB;
	Thu, 05 Nov 2026 18:37:19 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	xelra <xelra@protonmail.com>
Subject: [nft PATCH 1/3] parser_bison: Fix for comment following exclusive start cond
Date: Thu,  5 Nov 2026 18:37:11 +0100
Message-ID: <20261105173713.72238-2-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105173713.72238-1-phil@nwl.cc>
References: <20261105173713.72238-1-phil@nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixed commit missed "comment" as yet another global scope keyword which
may immediately follow the limit statement, probably because rule
comments may not appear at arbitrary positions but strictly at rule end.
Therefore they are defined at an easily overlooked spot in parser_bison.y.

Fixes: dedd9f78393ec ("scanner: Accept all statements' first words in all scopes")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/scanner.l                                  |  2 +-
 .../dumps/exclusive_start_cond.json-nft        | 18 ++++++++++++++++++
 .../parsing/dumps/exclusive_start_cond.nft     |  1 +
 .../testcases/parsing/exclusive_start_cond     |  3 +++
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index 37729ebc3cc55..b35dddd94eb4a 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -378,7 +378,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "position"		{ return POSITION; }
 "index"			{ return INDEX; }
-"comment"		{ return COMMENT; }
+<*>"comment"		{ return COMMENT; }
 
 "constant"		{ return CONSTANT; }
 "interval"		{ return INTERVAL; }
diff --git a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
index 46ea3dcf24dd3..1de5007c6fc9d 100644
--- a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
+++ b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
@@ -2003,6 +2003,24 @@
         ]
       }
     },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "comment": "foobar",
+        "expr": [
+          {
+            "limit": {
+              "rate": 1,
+              "burst": 5,
+              "per": "second"
+            }
+          }
+        ]
+      }
+    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
index 7a7ce2141e057..1b9b369e67640 100644
--- a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
+++ b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
@@ -83,6 +83,7 @@ table ip t {
 		limit rate 1/second burst 5 packets fib daddr . iif check exists
 		limit rate 1/second burst 5 packets osf name "foo"
 		limit rate 1/second burst 5 packets ipsec in spi 0
+		limit rate 1/second burst 5 packets comment "foobar"
 		meta l4proto 6 limit rate 1/second burst 5 packets tproxy to 0.0.0.1
 		meta l4proto 17 limit rate 1/second burst 5 packets vxlan vni 0
 		meta l4proto 17 limit rate 1/second burst 5 packets geneve vni 0
diff --git a/tests/shell/testcases/parsing/exclusive_start_cond b/tests/shell/testcases/parsing/exclusive_start_cond
index f769e7dd1432a..1fce6826f7cca 100755
--- a/tests/shell/testcases/parsing/exclusive_start_cond
+++ b/tests/shell/testcases/parsing/exclusive_start_cond
@@ -95,6 +95,9 @@ stmts+=("osf name foo")
 # xfrm_expr
 stmts+=("ipsec in spi 0")
 
+# comment_spec
+stmts+=("comment foobar")
+
 $NFT -f - <<EOF
 table t {
 	flowtable ft {
-- 
2.54.0

