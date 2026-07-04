Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBC530D41C
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2026 08:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783154914; cv=none; b=I2sRLcUUPTtrfpkxV+CM2332l7vfGtgxQGqF28XEHphV6S40lp0eUE5E4Xg2tA8ZnnRCuTcLvv2L+/JTtofhBLj4XG54BX0jiIeTLnplZ8cSzmXg62uch81MGv2IZVtVf8csMFcHGXXXdlgnZmNKz4ufqwjyq6fa+p/Fe9L1MBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783154914; c=relaxed/simple;
	bh=1Wmckpmaga1INbzrPGfe+WuRXFuQZEhvABQArQdqen0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCC7FOedFr0gUKJPcpVPaWAw1RAjD5yaYmHAy7/nVzZkrFLobZCfYTZDPRTGWJSfRWtgIyR6J7eYKWX6tvnTFwnZAOAdpmAl7pnmupjqiL82JsXqVCqTecT3H/29rhG53nbZn8OE/wEmDhTXZkNu6kTV/1RUGD4hDSsMj03ag6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4EBB060491; Sat, 04 Jul 2026 10:48:32 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: ebtables: bound num_counters in do_update_counters()
Date: Sat,  4 Jul 2026 10:48:11 +0200
Message-ID: <20260704084811.27355-4-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260704084811.27355-1-fw@strlen.de>
References: <20260704084811.27355-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sashiko says:
 it appears the exact same
 pattern remains unfixed in the sibling function do_update_counters().

Fixes: 43ae85af154b ("netfilter: ebtables: bound num_counters like nentries in do_replace()")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 7238e48d51a1..80008664ebe5 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1390,6 +1390,9 @@ static int do_update_counters(struct net *net, const char *name,
 	if (num_counters == 0)
 		return -EINVAL;
 
+	if (num_counters >= MAX_EBT_ENTRIES)
+		return -ENOMEM;
+
 	tmp = vmalloc_array(num_counters, sizeof(*tmp));
 	if (!tmp)
 		return -ENOMEM;
-- 
2.55.0

