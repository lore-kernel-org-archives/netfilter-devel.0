Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36D71DF248
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 16:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742403487; cv=none; b=LsQZCtv2nQ4e1+sKcCx2gBNgCbizIjyHsEGYv2vUe9J28TM8eCpQwTdXixX1daeEu3Bn5jbWaCP1IFctgmfIualtthvdvjFgGGh3I3nD14LrYxK690PClsKF5RUYBYbLI8mOLCRFny5QoxQJdAnMpTBD7rHINSLq0oBy8SH5EqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742403487; c=relaxed/simple;
	bh=f3dXuoyOydDZza3VkOnFLfOt+ZolWXqMCkrH2rSXb7c=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=szVIJfo1h3Ifn6yOoy3rE6eSH0pkyP7+t1M1Rm4dZu+TgvXNX/nZNZVfsNEwSFyHx5S9dhZ2GtFK5yiNE++NubngCLmTFg0/qmgJzpiam1hZUpmQGE0IY9c/a0r5VpcBsXGrD4CDmkEvHAB8ApxBY9KlJZERMxnldia2gYabG54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MvCe3KTk; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MvCe3KTk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MvCe3KTk";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MvCe3KTk"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 88C81605B0; Wed, 19 Mar 2025 17:57:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742403476;
	bh=mlQDow5x3Ea0JWpkDTb1Q4lA+3wsZlbkmGIFb28XWc0=;
	h=From:To:Subject:Date:From;
	b=MvCe3KTkil3uY38V7PE0Mo5hOO+3PaLqclZAGofkowKds7+ct71zxjcPASYBjzweQ
	 2p/zSBhm5yHZnl1GykVp+NtaEPBs40KUR8LTOFJ9gsxZk+sXU1ztcasnA6uJCJULKU
	 FxAQdJORG52prvFuJ1g4dc2heGWGGsFd5dX3aNeU9u34IP09Ok4+uYl0TouGar1YGY
	 OZ4OTfjOYdMTecd9JjCXNJgHFUC0TEnIePVwzaqmMs54NbLeWWq2J7w0BglpUtaOo8
	 Vfr7qr3Czru827q52kYGiwToQVTlYu+bT9LQOV0o2wVG7uPdyahy9E/XM+T3b9lH5R
	 mBKhXY63yvnXQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 29F4A6059E
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 17:57:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742403476;
	bh=mlQDow5x3Ea0JWpkDTb1Q4lA+3wsZlbkmGIFb28XWc0=;
	h=From:To:Subject:Date:From;
	b=MvCe3KTkil3uY38V7PE0Mo5hOO+3PaLqclZAGofkowKds7+ct71zxjcPASYBjzweQ
	 2p/zSBhm5yHZnl1GykVp+NtaEPBs40KUR8LTOFJ9gsxZk+sXU1ztcasnA6uJCJULKU
	 FxAQdJORG52prvFuJ1g4dc2heGWGGsFd5dX3aNeU9u34IP09Ok4+uYl0TouGar1YGY
	 OZ4OTfjOYdMTecd9JjCXNJgHFUC0TEnIePVwzaqmMs54NbLeWWq2J7w0BglpUtaOo8
	 Vfr7qr3Czru827q52kYGiwToQVTlYu+bT9LQOV0o2wVG7uPdyahy9E/XM+T3b9lH5R
	 mBKhXY63yvnXQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: py: remove unknown fields
Date: Wed, 19 Mar 2025 17:57:52 +0100
Message-Id: <20250319165752.1856-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Amend tests/py after libnftnl fixes:

 a7dfa49d34c7 ("expr: ct: print key name of id field")
 dba1b687a9a7 ("expr: payload: print tunnel header")

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/any/ct.t.payload      | 2 +-
 tests/py/inet/geneve.t.payload | 2 +-
 tests/py/inet/vxlan.t.payload  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 6016009425ec..645041341ca8 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -511,7 +511,7 @@ ip test-ip4 output
 
 # ct id 12345
 ip test-ip4 output
-  [ ct load unknown => reg 1 ]
+  [ ct load id => reg 1 ]
   [ cmp eq reg 1 0x39300000 ]
 
 # ct status ! dnat
diff --git a/tests/py/inet/geneve.t.payload b/tests/py/inet/geneve.t.payload
index 1ce54de6cd3a..5977873886af 100644
--- a/tests/py/inet/geneve.t.payload
+++ b/tests/py/inet/geneve.t.payload
@@ -4,7 +4,7 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000c117 ]
-  [ inner type 2 hdrsize 8 flags f [ payload load 3b @ unknown header + 4 => reg 1 ] ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 3b @ tunnel header + 4 => reg 1 ] ]
   [ cmp eq reg 1 0x000a0000 ]
 
 # udp dport 6081 geneve ip saddr 10.141.11.2
diff --git a/tests/py/inet/vxlan.t.payload b/tests/py/inet/vxlan.t.payload
index cde8e56f8b4b..b9e4ca2c57b0 100644
--- a/tests/py/inet/vxlan.t.payload
+++ b/tests/py/inet/vxlan.t.payload
@@ -4,7 +4,7 @@ netdev test-netdev ingress
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000b512 ]
-  [ inner type 1 hdrsize 8 flags f [ payload load 3b @ unknown header + 4 => reg 1 ] ]
+  [ inner type 1 hdrsize 8 flags f [ payload load 3b @ tunnel header + 4 => reg 1 ] ]
   [ cmp eq reg 1 0x000a0000 ]
 
 # udp dport 4789 vxlan ip saddr 10.141.11.2
-- 
2.30.2

