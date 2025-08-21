Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392812F1FD6
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 09:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755767874; cv=none; b=CT6a9l4kG1W4luq/Te5vfJGAjZiO/eWdL1SUTOrLrmxTGn6vNsYh9yBcAmRoduzbtO0mQxabyVXa5iq88nNCfmLEUSHAhHvdN+Z5eS5FSzMNE+6Zyo9vsa2KT8FkO2S0iUKrJhKZ3eYB0CdaLIqltSTitHQNph+IhkYvfHamJmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755767874; c=relaxed/simple;
	bh=L9cww4Vorj/f0bKH/ABN0fv/JZhien69HGtrrjT3P5E=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mBzeu5+eJ6uVqC8syc+ux8idlbtlbDoQJG91lS2o8JcEizC6EOvArmaQWDiFWaAPD8vjdrR209NnEOl6N+B6X8YRtGCRew2IK0xqwKjOg6LA1SPW1YDfEegDVIlL8HtI0kQX8jIsVLG0EzK8r0xaLUCy1yhnxV+kKSt0ZzeMInM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CUs5TOkt; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ud9SDX+9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CUs5TOkt";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ud9SDX+9"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2D9BD60295; Thu, 21 Aug 2025 11:17:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755767867;
	bh=x53vkKjpbrtGGUk37jV3GGYN9C/HQC/dPpUGbRP0UaY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CUs5TOktk0TaGvV6OF1mYIPNhO7ma4KIYbBRrUIUp3pgA3ncOmSjbUScoWhJNRUws
	 9kQKpEUFSfrL+mlo9xuHMRZz1QPfJiLG+L4Pc1QiqC/OBQLuvQSRf+C9EsHdDK97Vb
	 ebkU1d87kq2Ebg1CQfq881LSi4wJ62vRaiElZD/4z98QAiaUafpam0z0veF1dwpW+0
	 oheqrv33A5ns6f2bDjywSAiQ91IYFiiHElYodygP8/wHybmB5+fLvgTP4AQF1Ifnyy
	 zb/AWHraTgco6ht8/wSOQFKmUj4STm/Si/9ShfRob1m9vWC2KwyvY7V01SsMTB08+6
	 3Ee7rFQbubUXg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AEB4160292
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Aug 2025 11:17:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755767866;
	bh=x53vkKjpbrtGGUk37jV3GGYN9C/HQC/dPpUGbRP0UaY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ud9SDX+9rGj4oh7ktZyYpWmRfiztDTZ+nabBk83FQ9MxCu1cwrXYFlSPgRJt2ELAU
	 +dpJmyxhktfO7PxdZIJYBlqaLkrySOQBea8BAcLgab/BwINqXkylcovzGhIzp+n3ca
	 XiSQamwdQl85PRdEof7IUDBkROZvSEhl90UykS4Kl9XDu4OKxRTyJUeplYIDjAexKk
	 T3dU2UvS14GFI7zdB6sMqWoa3tXt4U+cZHSwb+SDoD1iiyRn8CP/sjl1Cl1Mn5Npzx
	 RKUu5G2LCYt2pvwve2OcIerghEsJWMOSICCBtvtoxoE2aTVrqJUg7c7MYOGW4LhKyO
	 0dFj8VtHtEu+w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] tests: shell: combine flowtable devices with variable expression
Date: Thu, 21 Aug 2025 11:17:41 +0200
Message-Id: <20250821091741.2739718-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250821091741.2739718-1-pablo@netfilter.org>
References: <20250821091741.2739718-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expand test with flowtable devices defined with variables to improve
coverage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../flowtable/0012flowtable_variable_0        | 34 ++++++++++++++++++
 .../dumps/0012flowtable_variable_0.json-nft   | 36 +++++++++++++++++++
 .../dumps/0012flowtable_variable_0.nft        | 14 ++++++++
 3 files changed, 84 insertions(+)

diff --git a/tests/shell/testcases/flowtable/0012flowtable_variable_0 b/tests/shell/testcases/flowtable/0012flowtable_variable_0
index ff35548ed854..71d2638b4976 100755
--- a/tests/shell/testcases/flowtable/0012flowtable_variable_0
+++ b/tests/shell/testcases/flowtable/0012flowtable_variable_0
@@ -9,14 +9,20 @@ ft_deldev() {
 }
 
 iface_cleanup() {
+	ip link del dummy0 &>/dev/null || :
 	ip link del dummy1 &>/dev/null || :
 	if [ "$NFT_TEST_HAVE_ifname_based_hooks" = y ]; then
 		ft_deldev filter1 Main_ft1 dummy1
 		ft_deldev filter2 Main_ft2 dummy1
+		ft_deldev filter3 Main_ft3 dummy0
+		ft_deldev filter3 Main_ft3 dummy1
+		ft_deldev filter4 Main_ft4 dummy0
+		ft_deldev filter4 Main_ft4 dummy1
 	fi
 }
 trap 'iface_cleanup' EXIT
 
+ip link add name dummy0 type dummy
 ip link add name dummy1 type dummy
 
 EXPECTED="define if_main = { lo, dummy1 }
@@ -42,3 +48,31 @@ table filter2 {
 }"
 
 $NFT -f - <<< $EXPECTED
+
+RULESET="define var1 = \"dummy0\"
+define var2 = { dummy1 }
+define var3 = { lo, \$var1, \$var2 }
+
+table filter3 {
+	flowtable Main_ft3 {
+		hook ingress priority filter
+		counter
+		devices = { \$var3 }
+	}
+}"
+
+$NFT -f - <<< $RULESET
+
+RULESET="define var1 = \"dummy0\"
+define var2 = { dummy1 }
+define var3 = { lo, \$var1, \$var2 }
+
+table filter4 {
+	flowtable Main_ft4 {
+		hook ingress priority filter
+		counter
+		devices = \$var3
+	}
+}"
+
+$NFT -f - <<< $RULESET
diff --git a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.json-nft b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.json-nft
index 10f1df98874a..70f039fafbed 100644
--- a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.json-nft
+++ b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.json-nft
@@ -42,6 +42,42 @@
         "prio": 0,
         "dev": "lo"
       }
+    },
+    {
+      "table": {
+        "family": "ip",
+        "name": "filter3",
+        "handle": 0
+      }
+    },
+    {
+      "flowtable": {
+        "family": "ip",
+        "name": "Main_ft3",
+        "table": "filter3",
+        "handle": 0,
+        "hook": "ingress",
+        "prio": 0,
+        "dev": "lo"
+      }
+    },
+    {
+      "table": {
+        "family": "ip",
+        "name": "filter4",
+        "handle": 0
+      }
+    },
+    {
+      "flowtable": {
+        "family": "ip",
+        "name": "Main_ft4",
+        "table": "filter4",
+        "handle": 0,
+        "hook": "ingress",
+        "prio": 0,
+        "dev": "lo"
+      }
     }
   ]
 }
diff --git a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
index 7863822d754b..b598420a3451 100644
--- a/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
+++ b/tests/shell/testcases/flowtable/dumps/0012flowtable_variable_0.nft
@@ -12,3 +12,17 @@ table ip filter2 {
 		counter
 	}
 }
+table ip filter3 {
+	flowtable Main_ft3 {
+		hook ingress priority filter
+		devices = { "lo" }
+		counter
+	}
+}
+table ip filter4 {
+	flowtable Main_ft4 {
+		hook ingress priority filter
+		devices = { "lo" }
+		counter
+	}
+}
-- 
2.30.2

