Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539589;
	b=dnBYYWmRCoQlbysjyQ20juUagWa+su+Wn3Psl/1haOwgXue3wZ1lc3J292DPE45gC+oQ
	 YcfH6jqSpt7W/KxelP8WwtHI+BA5GGVyi7jDXL8l2yNRpBm9sDH87JpAxz/g4X/CoR7Za
	 GzW1U5iZwMYQRSD+80uM/jnztZBWnmknohi/iO9/nagI/XIRiMnu6S3E9bFiqBQTBYXlH
	 Nl2LalRfn90SWQKVUEVuM4lp+EVhuZW0IAqH+gc39NJuCmvYDlm004D8IH9exgqgSBB58
	 I4P3BPCocgv0C6v87TD5FRL8EF0yUBd54XkkE6DIwe0ZmWQcAXFqVVJsv/GtYaBAR+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539589;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=2Z/RPSCZzGOwx32PFiUP+tr0MR11Y1QNpYHw9wZIm+0=;
	b=3mOFleC+jlxtmggeHc0IloFNII5OLYgADi2swQCfEg6sHaxPE2Wd1+3IpxBAI4DWC0yy
	 B2IfEShBk9mL9gUsSemcNoAIrj1pe2UXEedtszpywAsSf1L3SwqENC6oBTpBRQhKwBANs
	 8LX8Ll825BkGIyWvQ+J3d/BHk1SqSw0B4JZNcEJjAmbD9VS4mtin1djOAp0DNudgem4QD
	 ZV/l5J3pgHQPfaE5yxNI1rewU7TxoE6LIFwPUGBocZqEpXmtrIk/AWDm3PoxjUT7luJDB
	 pl5S0Uo1YuNwmjSPRZAD0TidjARAc+uCs9uCV61kjkSZuLUMHyz8VIoMiA2PihEMBNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dCTIqUkD;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9961760A2611;
	Fri, 13 Nov 2026 03:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9961760A2611
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dCTIqUkD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539587;
	bh=2Z/RPSCZzGOwx32PFiUP+tr0MR11Y1QNpYHw9wZIm+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCTIqUkD2S/ffilVbG1gaSb0FEJXTZn0zKJ3NgWxROg493fsflHCf7gpGc0uXwZg5
	 IVSDeNPgyqq8jaKXLbrNUlB+vrzYVbGE/H5iDi04Lmy0KfclmFFhYnf2yIuMJ48qjq
	 HhT1vJ92uKQjbpNbaROolUSskccr8QgctJ3VEio19lEvOXtkUuJktZhL37th15NSDZ
	 LMv3HRy/s9x0jEN3NFK4Fb+Le1OBMPARDCOV0wsJtJnblrFmtRcoAdLCng8wzdmkYs
	 GtzTf97t8ARwiv0jHWyQ9xy3Hy13P4YuEKJUN0e3NKY0oJGGsyTm9N0lqXH/Gg4GO2
	 eB1F219NUd2VQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9437F602A6;
	Fri, 13 Nov 2026 04:13:06 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 08/15] netfilter: lwtunnel: expose read-only sysctl nf_hooks_lwtunnel for non init-netns
Date: Fri, 13 Nov 2026 04:12:44 +0100
Message-ID: <20261113031251.2437074-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose nf_hooks_lwtunnel sysctl with 0444 mode from non init-netns
instead of 0644, sashiko reports this is exposing a global static branch
to modification by unprivileged users.

Fixes: 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_hooks_lwtunnel.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
index 40c6fce14a63..7e2ee8677f1f 100644
--- a/net/netfilter/nf_hooks_lwtunnel.c
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -68,14 +68,18 @@ static int __net_init nf_lwtunnel_net_init(struct net *net)
 {
 	const struct ctl_table *table;
 	struct ctl_table_header *hdr;
+	struct ctl_table *dup;
 
 	table = nf_lwtunnel_sysctl_table;
 	if (!net_eq(net, &init_net)) {
-		table = kmemdup(nf_lwtunnel_sysctl_table,
-				sizeof(nf_lwtunnel_sysctl_table),
-				GFP_KERNEL_ACCOUNT);
-		if (!table)
+		dup = kmemdup(nf_lwtunnel_sysctl_table,
+			      sizeof(nf_lwtunnel_sysctl_table),
+			      GFP_KERNEL_ACCOUNT);
+		if (!dup)
 			goto err_alloc;
+
+		dup->mode = 0444;
+		table = dup;
 	}
 
 	hdr = register_net_sysctl_sz(net, "net/netfilter", table,
-- 
2.47.3

