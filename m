Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC0026CE2C
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2025 16:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750783099; cv=none; b=V4mgwyxTc0h8JHQkfxMC/Vfs1fea3spERaK/QQHHdLsh1Jffc/ycBhXoYD0jnDAzSEMso9STIR7hTh732JHMnQetDmNwToYhffxjCUltHOI12tlMHuI1MIkSVg0rJVGBaGj/fItQOrRw86iOPUdcr6zsvywEFzR2lld66maKRwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750783099; c=relaxed/simple;
	bh=kAAIPgO38isADE91zJJi8kuDeejliKd7p5RaUQo/iC0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=k/ApcdjlcDmQ1Z8GOlxY5u+SbbTNlC3v4+yAPW4y/xH+ZijpwCdpPTWt6J7gZG7EPWWC26U6iK3v4qoAmFLEigp2G1eh6lELYh3UROyqAL6kVSFyH8+r8sRZokBppZIUO0VUNz9axsFU++pOj4wzHhL3Hq9cwixvJPlLk8gv5AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=F6sJMKW1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HbALKVhs; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="F6sJMKW1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HbALKVhs"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 76A2D6026E; Tue, 24 Jun 2025 18:38:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750783089;
	bh=Hq3F2trAMtOxgXbDxO8lAwkZ4RzKkMPrY7dx/2Vsets=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6sJMKW1LPKzSTjTht12mfVfh2kO/FsHEGVKk22Um3qRvUvBC6REGiLemmlKFlWtP
	 UblakD1VuOj+z8l3INpxsp9vii21ABBpKEGem689xALnF5xHHHBz2ZVf1OESdIRk1j
	 XzykX1MI4emEiaU4jJQnk2gza4SLHwggVxAUZw1vHjmxFwvcBZKXvwduN+22R1+0Hw
	 kRILvSVxjHa3xZvqZ58VSYAhnggVagM0ugdB9zmhSWvArHCMoYv+ek9lIw/BYFj4bs
	 hePK9Ej4pnMuEdZcU/qTmt7mI/jnfpuw3UFMqeJ6fvYJF2asZHFIohwL0y3cmz5T+D
	 uAXymqEIUIktw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9522960269;
	Tue, 24 Jun 2025 18:38:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750783088;
	bh=Hq3F2trAMtOxgXbDxO8lAwkZ4RzKkMPrY7dx/2Vsets=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbALKVhsPK8x9db8A6Ny4IMH94lrz83U2GUdRogdvQYFPTSZe6HewtG0gesktr8CN
	 zlgsBXKvh6o2Gp8VkxC0b1qdafJij5wVqRGdx7uuGT+lBP4AR4CqCR8U4LH9cJEVkz
	 VNV326FUrhpmOshCkRAZUztAD8pvajE9ixFEylFZDVurNTn80BC4XqtZhvL6Iyadd4
	 +QHEHgpcj3TvX2cKT04rZ2OlgiWSvKtPHKcFZ+UetkMrZiUelLJFEB7bC6k2jf0x6/
	 2UTZJ88B4B/59MBSflwbgOVWn14P1jMdvghftnDJOQJ3ZbRwAsbUeNViZSXP/vS/zI
	 AD+ilenMCZ0gg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc
Subject: [PATCH nft 2/2] fib: allow to use it in set statements
Date: Tue, 24 Jun 2025 18:38:01 +0200
Message-Id: <20250624163801.215307-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250624163801.215307-1-pablo@netfilter.org>
References: <20250624163801.215307-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow to use fib expression in set statements, eg.

 meta mark set ip saddr . fib daddr check map { 1.2.3.4 . exists : 0x00000001 }

Fixes: 4a75ed32132d ("src: add fib expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y          | 1 +
 tests/py/inet/fib.t         | 2 ++
 tests/py/inet/fib.t.payload | 8 ++++++++
 3 files changed, 11 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index e1afbbb6e56e..f9cc909836bc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3873,6 +3873,7 @@ primary_stmt_expr	:	symbol_expr			{ $$ = $1; }
 			|	payload_expr			{ $$ = $1; }
 			|	keyword_expr			{ $$ = $1; }
 			|	socket_expr			{ $$ = $1; }
+			|	fib_expr			{ $$ = $1; }
 			|	osf_expr			{ $$ = $1; }
 			|	'('	basic_stmt_expr	')'	{ $$ = $2; }
 			;
diff --git a/tests/py/inet/fib.t b/tests/py/inet/fib.t
index f9c03b3ad2be..60b77a4ac00a 100644
--- a/tests/py/inet/fib.t
+++ b/tests/py/inet/fib.t
@@ -17,3 +17,5 @@ fib daddr check missing;ok
 fib daddr oif exists;ok;fib daddr check exists
 
 fib daddr check vmap { missing : drop, exists : accept };ok
+
+meta mark set fib daddr check . ct mark map { exists . 0x00000000 : 0x00000001 };ok
diff --git a/tests/py/inet/fib.t.payload b/tests/py/inet/fib.t.payload
index e09a260cc41e..02d92b57a477 100644
--- a/tests/py/inet/fib.t.payload
+++ b/tests/py/inet/fib.t.payload
@@ -36,3 +36,11 @@ ip test-ip prerouting
 ip test-ip prerouting
   [ fib daddr oif present => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
+
+# meta mark set fib daddr check . ct mark map { exists . 0x00000000 : 0x00000001 }
+        element 00000001 00000000  : 00000001 0 [end]
+ip test-ip prerouting
+  [ fib daddr oif present => reg 1 ]
+  [ ct load mark => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
-- 
2.30.2

