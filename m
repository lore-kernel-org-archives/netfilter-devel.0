Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4BF2F0C40
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 12:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755692787; cv=none; b=asBq0urFnF6YM1M339U+IbYm1rhd6GN+GVTByx9Qy+ng7tVzVURPN69VeYt7G+07DgS8b1tiJiHBNww5kptaolaMwG6qI6TkAmtSZ2SVkEvzgOH22Cl4g3uozkaRXUeg5k5wsS2W3IDR3EwkGq7n1p3OW3af105bZDwF2s2gt1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755692787; c=relaxed/simple;
	bh=CbIU4O7dPt5LB8jL2Rp+u/OECPg0rfUbUS8dLXS5Vug=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Rts/TROdfdkuS6dFLfoUdlAcgNwoueySVIkh+Ivp5zQa2L6UCb5Oxnjh6RvaKrj3j2M1BzhaVnqfMDLd3RNSdP6Arndpzq9xJK25hq+v+Cp3bvZ04nnuVHdMHsU2nPD0XfyQV5cr9SAtDUqx3MCL3v6xfNdCkkm8zEA+HyM+W20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NWw2mhM9; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Og5YepbY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NWw2mhM9";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Og5YepbY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6705E605E1; Wed, 20 Aug 2025 14:26:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755692775;
	bh=3rIdytro+QKI60Ni9cbdB1IaNM/obbuPRAj+GiA5GN0=;
	h=From:To:Subject:Date:From;
	b=NWw2mhM9yidl0R/OYEPgbXZYYXgcxdlv1TPjfr0iWVQiKktw+XDJJUDlMd5kM2iFw
	 s1/A9Ir9QHDy3qw6NmTOeq7A745PIudeQQWMHtOrtHgOND85V96hOKPiRlBAJL7UKM
	 6uHapVtRU6PLA7x94bGskC96DT7lc1zabxfIdg0HFuMQLx6ZfogYpg1LxBDD9MyoBd
	 lfWFNYPLQDRjN5ZLKWU9D3VWiY5x8k5UAKaC8bt9KXYDZFnirWEXOgJ5k69P+4zKM/
	 QoWC/Ju1LtMYQAMSg9+QzzQFdjM5Td/rGFLeNvPlEBtEeWsjpswu4TCh7Dd4WlFjwH
	 o92WGnBMBycjA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DE96C605E1
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 14:26:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755692774;
	bh=3rIdytro+QKI60Ni9cbdB1IaNM/obbuPRAj+GiA5GN0=;
	h=From:To:Subject:Date:From;
	b=Og5YepbYnRn1ZEBxVTC8CjYRecdMTnuhmab/OEUxHI/BHQUR0pXqPrhE2gk++3g9i
	 qUCJ8KtE7rhSkTZSt4FISR8Fr2lhm6/ZVD66o1jDhtk6w/MzkPd20T3OLd8++NE05H
	 vB/H01/wcPqraqAD/w/TsMV2z6+OLHriyhe/WXJKAK282gC31oe5Kt2JgbchK5VERt
	 NrwaHoyivWBqeP26NKmmYvdWyTPmKdW0GH5MMEqMyIqrOBZFtSYIuFlieneWcr5XtS
	 H5QrCnMBJ9Mbd0lq3DipIf8HDgKTIzhA8Kv7Ah7Tqrsn7wQ89OCClO4IfB7Yfyc4mT
	 rWRBb4lHMvEzA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] tests: shell: cover sets as set elems evaluation
Date: Wed, 20 Aug 2025 14:26:08 +0200
Message-Id: <20250820122609.1790954-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend tests/shell coverage to exercise merging nested sets, provided
by fixes such as:

  a6b75b837f5e ("evaluate: set: Allow for set elems to be sets")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testcases/sets/dumps/recursive_merge.nft  |  8 +++++++
 tests/shell/testcases/sets/recursive_merge    | 22 +++++++++++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 tests/shell/testcases/sets/dumps/recursive_merge.nft
 create mode 100755 tests/shell/testcases/sets/recursive_merge

diff --git a/tests/shell/testcases/sets/dumps/recursive_merge.nft b/tests/shell/testcases/sets/dumps/recursive_merge.nft
new file mode 100644
index 000000000000..9206f9f98d8c
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/recursive_merge.nft
@@ -0,0 +1,8 @@
+table ip x {
+	chain y {
+		ip saddr { 1.1.1.0, 2.2.2.0, 3.3.3.0 }
+		ip saddr { 4.4.4.0, 5.5.5.0, 6.6.6.0 }
+		ip saddr { 4.4.4.0, 5.5.5.0, 6.6.6.0, 8.8.8.0 }
+		ip saddr { 1.1.1.0, 2.2.2.0, 7.7.7.0, 9.9.9.0 }
+	}
+}
diff --git a/tests/shell/testcases/sets/recursive_merge b/tests/shell/testcases/sets/recursive_merge
new file mode 100755
index 000000000000..f12f63babb0b
--- /dev/null
+++ b/tests/shell/testcases/sets/recursive_merge
@@ -0,0 +1,22 @@
+#!/bin/bash
+set -e
+
+RULESET="define myset2 = {
+      2.2.3.0,
+}
+define myset = {
+      1.1.1.0,
+      2.2.2.0,
+      $myset2,
+}
+define myset3 = {
+      { 1.1.1.0, 2.2.2.0 }
+}
+add table ip x
+add chain ip x y
+add rule ip x y ip saddr { \$myset, 3.3.3.0 }
+add rule ip x y ip saddr { { 4.4.4.0, 5.5.5.0 }, 6.6.6.0 }
+add rule ip x y ip saddr { { 8.8.8.0, { 4.4.4.0, 5.5.5.0 } }, 6.6.6.0 }
+add rule ip x y ip saddr { 9.9.9.0, \$myset3, 7.7.7.0 }"
+
+$NFT -f - <<< "$RULESET"
-- 
2.30.2

