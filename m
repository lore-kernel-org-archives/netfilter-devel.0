Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1FB18DB13
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Mar 2025 04:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741234773; cv=none; b=BiZyDXPtUS1Lh+8pVld2LqLK/w1KL7BF9WEp9gPPGzjCvW2kcuZBoxFaJOFTHcRO+0MZEp5VgmA9/2m6ulAId+B5VxIwd6CdbqEMGVoGmCLRfpI7UPxd8E5TinGum4iBlYPHMbgjdKSt0qpoVPDlG3YB2LkV/FX+BRAv+9/AOqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741234773; c=relaxed/simple;
	bh=PNJizwoXOYuRErEmrXewZ+r4I5avrZRNTKwQYr/Yz+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EZSJzoxmk/uA0k7Yn4Mu8LkEm5B7HPNPTWUHIeyEnQG+YxQ/hReKJPBMKwzH2N2eGNvY3FhD919Ln5ek0RIw3Cy/23agqiFYi+sh2lf+zFNWB4uDQy+vh3dLSavwy5+Fd/FN3b8jdLGCnPOBjpwG5BSnGJidni9uLCw66dTsQwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tq2hl-00071a-EZ; Thu, 06 Mar 2025 05:19:29 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] doc: add mptcp to tcp option matching list
Date: Thu,  6 Mar 2025 05:19:15 +0100
Message-ID: <20250306041920.31408-1-fw@strlen.de>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/payload-expression.txt | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index 2a155aa87b6f..ce0c6a237db9 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -729,13 +729,13 @@ nftables currently supports matching (finding) a given ipv6 extension header, TC
 *dst* {*nexthdr* | *hdrlength*}
 *mh* {*nexthdr* | *hdrlength* | *checksum* | *type*}
 *srh* {*flags* | *tag* | *sid* | *seg-left*}
-*tcp option* {*eol* | *nop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*} 'tcp_option_field'
+*tcp option* {*eol* | *nop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp* | *mptcp* } 'tcp_option_field'
 *ip option* { lsrr | ra | rr | ssrr } 'ip_option_field'
 
 The following syntaxes are valid only in a relational expression with boolean type on right-hand side for checking header existence only:
 [verse]
 *exthdr* {*hbh* | *frag* | *rt* | *dst* | *mh*}
-*tcp option* {*eol* | *nop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*}
+*tcp option* {*eol* | *nop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp* | *mptcp* }
 *ip option* { lsrr | ra | rr | ssrr }
 *dccp option* 'dccp_option_type'
 
@@ -794,8 +794,13 @@ length, left, right
 |timestamp|
 TCP Timestamps |
 length, tsval, tsecr
+|mptcp|
+Multipath TCP |
+subtype
 |============================
 
+Data types can be queried with 'nft describe tcp option *keyword* [ *fieldname* ]'.
+
 TCP option matching also supports raw expression syntax to access arbitrary options:
 [verse]
 *tcp option*
-- 
2.48.1

