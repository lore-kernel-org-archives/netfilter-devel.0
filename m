Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F97392803
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2026 07:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783150316; cv=none; b=s8hHRxPrcfqZb2Or7FNu4Fwps6lfAugEf5Vgp5PmpcJUFXkOTur4/MMZdEqktbQN4CbQgoPSTMlMRX38LqaWRBjFssqR0DdD9mleCVUTVoBy5voK9J/9OfQPHbn11r18U44rNtDU63qmEAZvEmTQ0Clvdt8TCPJQzyms7RzGDIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783150316; c=relaxed/simple;
	bh=tnpWBHJv30Ve9MKlJU8KwrVMphgyHktbIvpfeT2PxL0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ou8W5D9UhZ+9rTSYl96SxccPaflPZz7cZa6BmI6Yt8g2FhlQgAHfmNKQi4+DABetBmolLAEkOf1rW/+qORqg25ipLYNAAiTTewEff9PH5+/X84CwfQ/Zccy3/PZP8sg3/puDSpaApNDgHS3L9j0b1v93otAi3vBDkp2DYY7iBCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 45CC4602A9; Sat, 04 Jul 2026 09:31:39 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: xt_tcpmss: extend checkentry to ipv6
Date: Sat,  4 Jul 2026 09:31:33 +0200
Message-ID: <20260704073133.21570-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sashiko reports:
 Is it intentional that the new parameter validation callback is applied only
 to the NFPROTO_IPV4 match?

Fixes: 68fc6c6470d6 ("netfilter: xt_tcpmss: add checkentry for parameter validation")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_tcpmss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index b08b077d7f0a..5f7f97dbace5 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -103,6 +103,7 @@ static struct xt_match tcpmss_mt_reg[] __read_mostly = {
 	{
 		.name		= "tcpmss",
 		.family		= NFPROTO_IPV6,
+		.checkentry	= tcpmss_mt_check,
 		.match		= tcpmss_mt,
 		.matchsize	= sizeof(struct xt_tcpmss_match_info),
 		.proto		= IPPROTO_TCP,
-- 
2.55.0

