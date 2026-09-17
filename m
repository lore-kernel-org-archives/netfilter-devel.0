Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86AC50E592
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 17:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666339; cv=none; b=VzL/wYXcbgFYwCiuCJsZA8jTBPLFmSmOeguO8VW8cFXdQrtrXPgZr/w4nPmtTROqA1vhgiRFIuoPgasZsUiK5uBt25avtSRsPb/jqxxM6n3KYd5b3qxktMCBoI2lB4QD5g2rducZq8IIZn1EbdipbUamlIFrV8yrLwRhFNwQpLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666339; c=relaxed/simple;
	bh=WXEsb3rs86QT/4jItsCmfTJuPabN0nu24ueLVFWBoT8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lRdySoVE8K9DpUWrLuU20zq17cd1dxllf2qFFWkcloLizbPLp8Ms4fCqjAZvrlQ/h9Bm++3aeQjYw8gn5eY4PHmk1Sr6SEpf7F2z6eCx+eMJuiXuexIruM3n9S/CFuT2ILwxHEaYoSgCGadj+aLXqah2pKHYiUB6XiQhTe+mqQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TjsAvJBa; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TjsAvJBa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7GBjrlsFEtmYkq33RxLVXILS4BZODP2ZdXaXokHgMxc=; b=TjsAvJBani7NsbRycUWQtZdE8t
	kXibUDoeSU0mpWPrMQxBXU5Ox+ePZU2AmdU9oRjLPm4nMz72TU+iPUqKIx0VtlCUYlu6RwWyG4gji
	tPusSX6lq8tDotV/nAVvLyyhesRfrAQXnRGIpA3VgoFSw8TYYHIONd4V3ZPQJbImptEninPoUv7PK
	gFbIJ9+BWWBIgughtmmurL8SbDhPB3IU4tSnR+8gmxbgLZps/M1o7sNI0mavm64yOdwq34p7GyTGh
	gP3KMqRlO3kiPG1ytVG7weyNOHs50+Bx/8qaafgB7WKJvmhdPbtIv9RG/bwsqK9sgfjtV9XUuE6K6
	dfy2emWA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1x7Fxx-000000004iU-0JED;
	Thu, 17 Sep 2026 19:32:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] doc: nft.8: Describe nftables transactions and their limitations
Date: Thu, 17 Sep 2026 19:31:58 +0200
Message-ID: <20260917173159.2077268-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Given the exceptions to the rule, describing how nftables handles
batches might clear some confusion.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index 0f37782c23a0b..15e5c0de33f4d 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -1039,6 +1039,57 @@ These are some additional commands included in nft.
 
 include::additional-commands.txt[]
 
+TRANSACTIONAL RULESET UPDATES
+-----------------------------
+The nft tool accepts multiple commands at once, either on command-line
+(separated by semi-colon) or in a file. Even when restoring a dump in nested
+syntax it resolves into individual commands adding the various ruleset elements
+found in there. It collects these commands in a batch.
+
+The kernel treats a batch as a transaction, i.e. if one of the commands fails
+to apply, previous ones are unrolled and the transaction fails. Multiple
+transactions are serialized and thus won't interfere nondeterministically.
+
+.Trying to create a NAT chain
+---------------------
+# nft "add table t; add chain t c { type nat hook input priority 0; }"
+---------------------
+If nft_chain_nat.ko is unavailable, chain creation fails in above example. Due
+to the transactional behaviour the table won't be created, either.
+
+There are a few exceptions to the above rule though: list and reset commands
+are not integrated into the transaction system on kernel-side and "happen" in
+user space during cache population. The latter is a preparation step for other
+commands. For reference, here are the rough command processing steps in nft:
+
+. Parse input into list of commands
+. Gather cache requirements for each command
+. Fetch data from kernel and populate cache
+. Process each command (sanity checks, serialize into batch)
+. Submit batch to kernel
+. Receive response, report errors or echo updated input if requested
+
+Data for list command is fetched in step 3, output is printed in step 4. With
+reset command, the actual data reset happens in step 3 and printing of the old
+values happens in step 4.
+
+.Trying to create a NAT chain and list in between
+---------------------
+# nft "add table t; list table t; add chain t c { type nat hook input priority 0; }"
+---------------------
+The above command will list table t's (empty) contents irrespective of whether
+the transaction fails or not. In fact, it lists the table before even
+attempting to create it: The add table command populates nft's cache while
+being processed (in step 4 above) so following commands find it there.
+
+As a conclusion to the above:
+
+* Don't rely upon list command output alone to verify success of a ruleset
+  modification, at least not if in the same batch. At least make sure the batch
+  succeeds and nft returns zero.
+* Keep in mind that reset command won't unroll. Its effects will persist
+  despite the failing transaction which reverts all other commands.
+
 ERROR REPORTING
 ---------------
 When an error is detected, nft shows the line(s) containing the error, the
-- 
2.54.0

