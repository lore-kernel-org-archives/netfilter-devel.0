Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF2E15FCF5
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2024 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718378210; cv=none; b=ZQ8etTBTA3u/78GCVK7kd+1ISmM2U/Y25f6TAfKpzWtNOGGP8F0AdeV/cEoKGWt1A+2i6tZjOiICkSgPZ2pUq7NBUuDBs6ZS0ZtCA/+m2PYAo8q8TKeqgnjIXKzDWr0dyGf3f/1W5XdT+dyXOTYJjVv+pAmyGhqhuhARSrmD39o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718378210; c=relaxed/simple;
	bh=p+HoCpRxH1Kf/i84CW5y0nYqjOF6hkQofzduAIyM88g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCwVjkn1RDaLMXanHS3YiP7458a4PvqYaYhLoaHuCKHn+RQnRm+wHF6ta0OU04DgsJNWywc6NQqEId6QUeDYfQDo/KKBN/2EIQB6EyF+Qzz0rc0elSTtQbUw6ysHaqM0uNAj2+VoE2wcHK6XneMru0bwtPTKgNynAXH7a9WzXws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PZ/5bdB9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PZ/5bdB9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kbq78l3vrRkBTzF92H9WS7PV/crd5Alh63ZJWaJcIpQ=; b=PZ/5bdB9wSfhGfFZpfZE2LOcwR
	wB2EJolmH1pfVv42YW0BhCfcFLxGY6XEqWN4fs5a2Kv2ANPwarx6B8mqj2etrDAs/7MDFCw/gmeJ4
	rIeJqsqU45orRyyKmBD3Jsp8MiJCGf9GtyLrhVQY1PcCgjNNcJfYvkQlbt7GLyIUhSniKec4MOcMp
	xQJwZGZHaFAR6ERCfH5qJAPmZeZUEBmmVdbJCtLadG2FVQNqiPpXyo3zx0JOthHLv3U0/vkLPys0j
	RZnIr4TJrjtBLIkgPddUebMxo006pmL4L1dJ+ybnFHjVWxBGtb7hD00MrAkur2DUKGH0jScspgch4
	cWYRWRBg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sI8fO-000000007Kd-1ROs;
	Fri, 14 Jun 2024 17:16:38 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: [nf-next PATCH v2 1/2] netfilter: xt_recent: Reduce size of struct recent_entry::nstamps
Date: Fri, 14 Jun 2024 17:16:40 +0200
Message-ID: <20240614151641.28885-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240614151641.28885-1-phil@nwl.cc>
References: <20240614151641.28885-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no point in this change besides presenting its possibility
separate from a follow-up patch extending the size of both 'index' and
'nstamps' fields.

The value of 'nstamps' is initialized to 1 in recent_entry_init() and
adjusted in recent_entry_update() to match that of 'index' if it becomes
larger after being incremented. Since 'index' is of type u8, it will at
max become 255 (and wrap to 0 afterwards). Therefore, 'nstamps' will
also never exceed the value 255.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/xt_recent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index ef93e0d3bee0..60259280b2d5 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -70,7 +70,7 @@ struct recent_entry {
 	u_int16_t		family;
 	u_int8_t		ttl;
 	u_int8_t		index;
-	u_int16_t		nstamps;
+	u_int8_t		nstamps;
 	unsigned long		stamps[];
 };
 
-- 
2.43.0

