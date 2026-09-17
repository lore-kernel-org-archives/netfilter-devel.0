Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AE84D178D
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666336; cv=none; b=tC9jASuwCrI1m4vxyqTM/fmF//SOZaPlGy9/pUqKFyU9Ix6vW1PVa8qiCEIJAfobF7sZ1dvHiHW97soJcV/W3ZCHGCftHkLkiflxC4lTxM5Vcu1M30xa1nl87FWU8HhTuvYWNFVgJ/GmDdfeInrCnbZpgPuErMc7hqpYBv89txA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666336; c=relaxed/simple;
	bh=j2N2CKr0J4KruUbXkro6efkPLMGLbrhKT58v2HZGN3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1KenXXDHSFxhDy80Lw9mqmCp33ICFPkg2B4uJZ86M3wmsTp1g7o0ZsBLYlU1YH0ohsdeteFipGdML6Dnz4srk8Scl32Kox5tzkP8l6mPaLHLefZ8BzwcmAogizAsH02dqtac4oiFItj8b7V3fpYI/BUuu96PhexecrSkQ8rlS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZRfcNzBD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZRfcNzBD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=h4FFokQirexjcHgmJcn44s3BFwNd7eX6NPvq9Sw6Kiw=; b=ZRfcNzBDeKgGs4R3rEpDMMCnmx
	qSzkIMVGyEoPEQHaOh5Wz84U183gnP25N1q/Sk8abIR5dXA6+1Yc9RKJAzRi5htps52G8lzrfvsVW
	eCTEtJCAgUgmyIbHOUCJmZOo2cojL0CUqdjZnBugBNzWTe2issLvQ1BV8zdAMzTW+jBdO0hHRRmO/
	O1XUBNpGGcpg5fXsZo6NFkPV8D14/BmXYpwlTkspot0wMFdBAibXExwwFCElcoDrn7H8rwJveY6KD
	T2ZOWOcZyRg/fFxpKgtgZ9WE7v5BXwgzyKDCpocvlruzR9CUQtGLaaJ+s7aL91k3jAqLgOwpiSlnZ
	LFwOmWJw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x7Fxs-000000004iP-2Ber;
	Thu, 17 Sep 2026 19:32:04 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/2] doc: nft.8: Document caveats when mixing clients
Date: Thu, 17 Sep 2026 19:31:59 +0200
Message-ID: <20260917173159.2077268-2-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260917173159.2077268-1-phil@nwl.cc>
References: <20260917173159.2077268-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The "do not touch" warning message nft emits for tables with rules using
compat expressions has been complained about for being confusing.
Replace it with a reference to nft.8 and describe the implications there.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 src/rule.c  |  4 ++--
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 15e5c0de33f4d..a7ef9a7183b5b 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -1090,6 +1090,52 @@ being processed (in step 4 above) so following commands find it there.
 * Keep in mind that reset command won't unroll. Its effects will persist
   despite the failing transaction which reverts all other commands.
 
+MIXED USE
+---------
+A kernel ruleset created by nft may be read and modified by any other program.
+This practicaly constitutes a form of inter-process communication with the
+kernel as data channel. Nftables' flexible ruleset specification makes
+compatibility issues likely.
+
+WITH IPTABLES-NFT
+~~~~~~~~~~~~~~~~~
+In general, mixed use of iptables-nft and nft within the same host/netns is not
+advisable and may lead to obscure bugs in both tools. A ruleset created by
+iptables-nft should not be modified using nft and vice-versa.
+
+In order to replicate legacy behaviour, iptables-nft makes use of compat
+expressions in kernel. These allow nftables to call xtables kernel extensions.
+Content of compat expressions is extension-specific, nft requires libxtables to
+interpret the data. If available, it will use its xlate callbacks to print
+equivalent nftables statements, just like iptables-translate does.
+
+If a ruleset dump containing such (translated) compat expressions is restored
+again using nft, the resulting ruleset will not contain any compat expressions
+anymore. This may cause subtle changes in behaviour but will almost certainly
+break ruleset parsing in iptables-nft.
+
+If a translation is not possible, nft prints the well-known compat expression
+fields (type and name) in a format the parser will detect and reject with a
+verbose message. This is to make sure such an incomplete ruleset dump is not
+restored by accident.
+
+WITH OTHER VERSIONS OF NFT
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+While nft is supposed to be backwards-compatible, i.e. Rulesets created by any
+older version must parse correctly, the other direction is hard to even handle
+sanely. The result of parsing a ruleset "from the future" may vary from success
+to crash and from obviously broken rulesets to subtle bugs or minimal changes
+in behaviour.
+
+If a ruleset should remain readable by all involved versions, only the oldest
+version should make modifications and all others should limit themselves to
+read-only access.
+
+Starting with version 1.1.6, nft annotates created tables with its own version
+and warns if tables fetched from kernel are annotated with a newer version.
+While its absence is not a guarantee, its presence clearly indicates a
+problematic setup.
+
 ERROR REPORTING
 ---------------
 When an error is detected, nft shows the line(s) containing the error, the
diff --git a/src/rule.c b/src/rule.c
index 0ffe2ca1955da..552c17df05f83 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1284,11 +1284,11 @@ static void table_print(const struct table *table, struct output_ctx *octx)
 
 	if (table->has_xt_stmts)
 		fprintf(octx->error_fp,
-			"# Warning: table %s %s is managed by iptables-nft, do not touch!\n",
+			"# Warning: Table %s %s is managed by iptables-nft, see MIXED USE in nft(8).\n",
 			family, table->handle.table.name);
 	if (table->is_from_future)
 		fprintf(octx->error_fp,
-			"# Warning: table %s %s was created by a newer version of nftables? Content may be incomplete!\n",
+			"# Warning: Table %s %s was created by a newer version of nft, see MIXED USE in nft(8).\n",
 			family, table->handle.table.name);
 
 	nft_print(octx, "table %s %s {", family, table->handle.table.name);
-- 
2.54.0

