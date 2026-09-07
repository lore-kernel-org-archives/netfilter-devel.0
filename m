Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB4D51D522;
	Mon,  7 Sep 2026 17:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801464; cv=none; b=IxAlzri+rGB9N4NjuXq7qQENnv8LJ1065ulMu9Etiw0e7mnWDLyMiRltn0j5RbfUQQ8myFGP/XiUWiO0IdPwKUEcP0jzE2RG0CTUK7QT2ap89gn0QUDITHyu9rMddxn8JhqtDv0NUFoYWmlS10zAy9HyDHeoGpJwZRFX/kiTFnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801464; c=relaxed/simple;
	bh=ogxmNEYh8SWXfPRe313HfZDaNF1W8nAeDl81/4R28GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faU5A7M14KIeSO7wK5nrZBwK/2wK7QDFkpmEcaEp6MztQ0rX2+toxkUmAJ4azevE59C0fvs0WL7v3fnpjnUcfWPwyafzUbQYWtMu7Uu0rsrsr30b17HKemkkQLtSt617pJ64snLvuunplvEk+DpGewwm0cOwWnDyopMpNT58w1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=O4rO3GDX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="O4rO3GDX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788801459;
	bh=1yXqIV58sXy9JBDXSxnDUpCcuIJfw+yd+mIzGJkNuA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4rO3GDXLcJ2NQoyao9qowxuHvrFh0VCgwRNjk40OWxxCJEPyXc9xv1jaCWOnHjXV
	 RiPGOEKbzScH0+ia0tDamgY8eg+2AMsmcAaLfYz6zcUCc+ehKZq5XyEvToQxyyslIx
	 9Mg4jYixolF+2I8MBLIxRAUweEZ8kUrlyfv6DZSrzsdZQXJa31TIBHsA3mh1WfzM3u
	 D8nrEagI1PIGNLmLhzJL044Mei+MG5FNsv+dYxjLK7Rh1Dg2fyHb0zVGYbU3yYihqU
	 BgcvrwaPm45L+5YuhE+6fgWVKy6yrrp+fQZy5QgjDTQZzW5qo14p7xGK04Q40fGzyN
	 USwmJI9l4lmrA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3A553607D1;
	Mon,  7 Sep 2026 19:17:39 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 2/9] ipvs: fix reversed sequence option serialization
Date: Mon,  7 Sep 2026 19:17:25 +0200
Message-ID: <20260907171732.1407739-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171732.1407739-1-pablo@netfilter.org>
References: <20260907171732.1407739-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kyle Zeng <kylebot@openai.com>

hton_seq() expects the host-order source first and the unaligned
network-order destination second. The version 1 sync sender passes these
arguments in reverse for both sequence blocks. This leaves 24 bytes of the
kmalloc-backed message unwritten. It may disclose stale heap data and
replace the live connection sequence state with values read from the
buffer.

Pass the connection sequence state as the source and the message payload as
the destination for both blocks.

Fixes: 986a07579533 ("IPVS: Backup, Change sending to Version 1 format")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 1deb063cd72c..5383aeafb0ae 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -747,9 +747,9 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
 		*(p++) = IPVS_OPT_SEQ_DATA;
 		*(p++) = sizeof(struct ip_vs_sync_conn_options);
-		hton_seq((struct ip_vs_seq *)p, &cp->in_seq);
+		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
 		p += sizeof(struct ip_vs_seq);
-		hton_seq((struct ip_vs_seq *)p, &cp->out_seq);
+		hton_seq(&cp->out_seq, (struct ip_vs_seq *)p);
 		p += sizeof(struct ip_vs_seq);
 	}
 	/* Handle pe data */
-- 
2.47.3

