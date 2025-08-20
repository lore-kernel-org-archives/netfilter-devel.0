Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D55C304BD8
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 12:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755692785; cv=none; b=So2qVj8VLqoC95zA291qZBmAbxGsrBrPKGcWlc/AIooNbJj5hufT8IfOcwaJcH12wMOV0AAPUYg4lW83Vau3AGh8DYHVOHdIPfKk0UbrFsHu7rsd908VvQJdCnhlSxKJXDYhF2UXjc41hPs+R4DDqqbGWDlIgFMgedGW4vaO4M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755692785; c=relaxed/simple;
	bh=aCAwcWBNfeS9AY5lWI7DnShbRb+QKlak3PiZWvEkUzQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lYhQL4F7YO8khgyMfPEj7wOXglLnwGIqSF1sjTh1SLKnKPTZ+hgGHODliBK4iDXLFuN/DB/Hu1Vrvsw+niMtx26StPHQbiZcOZFpcTKtf8udg2WxrZ111W3bdYces9NKzREnRFRa/sRRWXVLv9yu58wfKIj+zpaLYWiaI0Crugc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Luy1bpcy; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=I+ShEclG; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Luy1bpcy";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="I+ShEclG"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5678A605E5; Wed, 20 Aug 2025 14:26:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755692775;
	bh=NzbtKPOzhv2Wq9pdfaAzqlbEEXc06OcV8MgBIPQKwLM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Luy1bpcymgz1M4qnVnnQ3sd8h5Vu3wmGhSQXHaTXvMl3sLEa8ETZalpCKghXYC2tB
	 Ilk1YAYF/zJZ2ZwyRAWmWVMlIOzaltrRQTtUIFNvR2MD6lnp8qWOzTm5cS4LqmbT/+
	 fBrDHVM6KFYVr7kzE6e0DFJNtN0bK2ODYYwOQV5E9AgI5+yNc5PcOOSs2b2Qw2Dw/t
	 fXcHdvwtSTL1wTwcz+L5VT7/rwWtXS1aKoU88Atk4mE+fnkEvSNjEUBUmPG/0IaDN+
	 rDoxxFhl3M+FuBYktDSegveJH3hsiq6RR8zbkdmlUlAU3uI1OLeZygaU6oWfMd0xO/
	 W0jKTQhSWk+xA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AFBF1605E2
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 14:26:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755692774;
	bh=NzbtKPOzhv2Wq9pdfaAzqlbEEXc06OcV8MgBIPQKwLM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=I+ShEclGo+Bz0FmqN2x9bagyidg4fkPAGFDH+M6zCL8cL7U4xaU6Rlq1HyxUoZ8u4
	 95sEXXCDT3EMy08KkbJlUs4IT4zIykwpJZnsUr+3uFxA7WnhB/MkrRFOusjj9GHQMQ
	 NYadjUsGBYxMI6KJazEy3yliCW2zP3nAwejiK6UTC5mEBOGDfkKF492CNS/KOYFuIi
	 uPUUxKjn9khiqzrTHL1zqwsE0EsVUtgy3OA7SwqLM7Q37RQCwsAdlp/Xr1FDIaumeH
	 dwPlD6g2G6i3cwWbGLC6dRPE72zDyc9zJbHr2zjSUEs/92c7yFZku7GW/cSVcr3t7M
	 0eDKTHqBZzvFA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] tests: shell: coverage for simple verdict map merger
Date: Wed, 20 Aug 2025 14:26:09 +0200
Message-Id: <20250820122609.1790954-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250820122609.1790954-1-pablo@netfilter.org>
References: <20250820122609.1790954-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a testcase to cover for merging two rules into verdict map, added by

  345d9260f7fe ("optimize: merge several selectors with different verdict into verdict map").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testcases/optimizations/dumps/merge_vmap.nft    |  5 +++++
 tests/shell/testcases/optimizations/merge_vmap      | 13 +++++++++++++
 2 files changed, 18 insertions(+)
 create mode 100644 tests/shell/testcases/optimizations/dumps/merge_vmap.nft
 create mode 100644 tests/shell/testcases/optimizations/merge_vmap

diff --git a/tests/shell/testcases/optimizations/dumps/merge_vmap.nft b/tests/shell/testcases/optimizations/dumps/merge_vmap.nft
new file mode 100644
index 000000000000..2c2535264135
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/merge_vmap.nft
@@ -0,0 +1,5 @@
+table ip x {
+	chain y {
+		ip saddr . ip daddr vmap { 1.1.1.1 . 2.2.2.2 : accept, 2.2.2.2 . 3.3.3.3 : drop }
+	}
+}
diff --git a/tests/shell/testcases/optimizations/merge_vmap b/tests/shell/testcases/optimizations/merge_vmap
new file mode 100644
index 000000000000..5d4454cd7e2a
--- /dev/null
+++ b/tests/shell/testcases/optimizations/merge_vmap
@@ -0,0 +1,13 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip x {
+	chain y {
+		ip saddr 1.1.1.1 ip daddr 2.2.2.2 accept
+		ip saddr 2.2.2.2 ip daddr 3.3.3.3 drop
+	}
+}"
+
+# check that optimizer output displays vmap in the listing
+$NFT -o -f - <<< $RULESET 2>&1 | grep vmap
-- 
2.30.2

