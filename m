Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6196484039
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2026 09:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783157357; cv=none; b=SkpKbASSR2KOux8g9sxH1sMVUD4OmzveqejQFjFwIEzMepEw+ce/JM4JhVb4v26g3gmJY410P6f8aVg9vHk8vTqhyyChXZdebwtI4GSKfC4Vn9CElDIb8htymNaq+xPSFmUQfpcDQvOQ4MiBoJ567wz1lrQxjnXZngnhMgxOSnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783157357; c=relaxed/simple;
	bh=wtMnY4VbxzRTE1niUsDxGDKIcPplprhENE1zdVNuFoI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L5Ad5sz89099n3068SWSycolDPwdMGYWn0Jh/oOuR6IBBl5ORmm+V1JAE4Z3RQLkJexxO9ZgRuRyrdPbued1KofCz9oWXGYBs4wba21OS9Wo2PqBpLG7KpVMsDZcnZYTuWnRWXroX7obcFsGuz0yLzb4FmxdigDXxmgs6vOa5ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9C34260491; Sat, 04 Jul 2026 11:29:14 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: ebtables: must null-terminate name
Date: Sat,  4 Jul 2026 11:29:02 +0200
Message-ID: <20260704092905.29642-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sashiko says:
 hlp struct is copied from userspace without forcing null-termination of
 hlp.name [..} is passed to request_module().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Many more reported issues, will go through this next week.

 net/bridge/netfilter/ebtables.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 2a3ac58d5529..d5640a57a2eb 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1440,6 +1440,8 @@ static int update_counters(struct net *net, sockptr_t arg, unsigned int len)
 	if (len != sizeof(hlp) + hlp.num_counters * sizeof(struct ebt_counter))
 		return -EINVAL;
 
+	hlp.name[sizeof(hlp.name) - 1] = 0;
+
 	return do_update_counters(net, hlp.name, hlp.counters,
 				  hlp.num_counters, len);
 }
@@ -2401,6 +2403,8 @@ static int compat_update_counters(struct net *net, sockptr_t arg,
 	if (len != sizeof(hlp) + hlp.num_counters * sizeof(struct ebt_counter))
 		return update_counters(net, arg, len);
 
+	hlp.name[sizeof(hlp.name) - 1] = 0;
+
 	return do_update_counters(net, hlp.name, compat_ptr(hlp.counters),
 				  hlp.num_counters, len);
 }
-- 
2.55.0

