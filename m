Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE00A2116F6
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 12:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759925910; cv=none; b=HNBxRkD6a5O8DwOTlP/yEmfCT9UOjPprgbHrp7Y3a6k0dfxOHF8Oz76gdVGqYkwQbGbpP6fPZtMUec0jBq3UdUW6+EPT3ZdO05PwxdDvFWjTeHwWfDZE4dEz5qUy/nXM1ID10rcpU+WFUrZvYmFBqSSC0yGZazqelXI0+/yADnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759925910; c=relaxed/simple;
	bh=9oX4IIj7Em8OwdbTcr7bohiRHJGmilbEh2Zs0P/MygM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kNpTpMUBfMCWW7F1NPBDlSmnqXd7E/sZmLhb+ObW1L520N04S+KhBEOnO+cwxElOhDzd1EcvHqkUaOkylpx5tDzxTMiGJCnlGIG5FMFemohVX4MxpZ2Goxx94FTVMP2YHQSg1nBsVpBl3MLoR5fSRDC9nn9iWOh778k3/rQ7XLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CD723602B1; Wed,  8 Oct 2025 14:18:25 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools] conntrack: --id argument is mandatory
Date: Wed,  8 Oct 2025 14:18:15 +0200
Message-ID: <20251008121820.28391-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

conntrack -i
conntrack v1.4.8 (conntrack-tools): option `-i' requires an argument
conntrack --id
Segmentation fault (core dumped)

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index b7d260f8e55d..940469ddcf74 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -331,7 +331,7 @@ static struct option original_opts[] = {
 	{"nat-range", 1, 0, 'a'},	/* deprecated */
 	{"mark", 1, 0, 'm'},
 	{"secmark", 1, 0, 'c'},
-	{"id", 2, 0, 'i'},		/* deprecated */
+	{"id", 1, 0, 'i'},		/* deprecated */
 	{"family", 1, 0, 'f'},
 	{"src-nat", 2, 0, 'n'},
 	{"dst-nat", 2, 0, 'g'},
-- 
2.49.1

