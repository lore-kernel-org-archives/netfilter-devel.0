Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FB0611E
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Oct 2025 08:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761468896; cv=none; b=WVLi+wGAiXEJD5K4O9Y8oXzQcwJHBKspW4yOiw16Ppus+S1i+TaVxDtsnHKgkihG9396qlvGUc/qHquOABJa/5F1G/GkqJVl5Dwr2Uk+hQjOFyk53eO9E+xkhQxOig/7rGRnFZsdJ3qmxjUzYATB6gzxoUGfZAEC659OaXeIpXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761468896; c=relaxed/simple;
	bh=igPDWezEG6IxtWWL/IukYezBG0+XwIMCNo8zYVKaOdU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L8RWbZ6PCLh7hbQknEGMAu6kdFIrfOb1A3I+OgZdCbvP72U2loyH5yuqWw+GKQYUjyUzw/fygtNZQcLlYbS2VIVFqQtzodKabTRwy8bZksO0BIbXWDAosmlm9oEmoPc2OiaUwJ42dn9zpD/vcWB4LvJh7tNfXakPVKbz1bpWDVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 56288603CA; Sun, 26 Oct 2025 09:54:45 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] doc: remove queue from verdict list
Date: Sun, 26 Oct 2025 09:54:36 +0100
Message-ID: <20251026085439.12336-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While its correct that the queue statement is internally implemented
via the queue verdict, this is an implementation detail.
We don't list "stolen" as a verdict either.

nft ... queue will always use the nft_queue statement, so move the
reinject detail from statements to queue statement and remove this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/statements.txt | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/doc/statements.txt b/doc/statements.txt
index e275ee39dc4e..0633d023f2c0 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -4,7 +4,7 @@ The verdict statement alters control flow in the ruleset and issues policy decis
 
 [verse]
 ____
-{*accept* | *drop* | *queue* | *continue* | *return*}
+{*accept* | *drop* | *continue* | *return*}
 {*jump* | *goto*} 'CHAIN'
 
 'CHAIN' := 'chain_name' | *{* 'statement' ... *}*
@@ -22,11 +22,6 @@ afterwards in the processing pipeline.
 The drop occurs instantly, no further chains or hooks are evaluated.
 It is not possible to accept the packet in a later chain again, as those
 are not evaluated anymore for the packet.
-*queue*:: Terminate ruleset evaluation and queue the packet to userspace.
-Userspace must provide a drop or accept verdict.  In case of accept, processing
-resumes with the next base chain hook, not the rule following the queue verdict.
-*continue*:: Continue evaluation with the next rule. This
- is the default behaviour in case a rule issues no verdict.
 *return*:: Return from the current chain and continue evaluation at the
  next rule in the last chain. If issued in a base chain, it is equivalent to the
  base chain policy.
@@ -741,9 +736,10 @@ QUEUE STATEMENT
 ~~~~~~~~~~~~~~~
 This statement passes the packet to userspace using the nfnetlink_queue handler.
 The packet is put into the queue identified by its 16-bit queue number.
-Userspace can inspect and modify the packet if desired. Userspace must then drop
-or re-inject the packet into the kernel. See libnetfilter_queue documentation
-for details.
+Userspace can inspect and optionally modify the packet if desired.
+Userspace must provide a drop or accept verdict.  In case of accept, processing
+resumes with the next base chain hook, not the rule following the queue verdict.
+See libnetfilter_queue documentation for details.
 
 [verse]
 ____
-- 
2.51.0

