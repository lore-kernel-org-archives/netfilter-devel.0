Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121243914F0
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Apr 2026 11:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165449; cv=none; b=inCKZ92vvOc+j4BtzJY47hTCOsgDxFgEAzYV8+j5b5hmzPs/9nMkls3MTzYbB+sc/FBWezKF9Jy19gLa78Ar4OSVzYTIqIu/BQpN3LAEF4kbuPdVUFFlMURtyLVCna13y6k9CeUBe7heBUOABX2REOCBatfeX5bRWh4G38RW+qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165449; c=relaxed/simple;
	bh=vCdfaW9akuSEUpT3dkrjHG7m4BNmGyZtjh6I7q+cFOA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LpjAhUjjDGOTDZVI6YRE8Urckyn4bjDn6FH1d3INr/OXP4088acJtjkTRv27vCth3liof2fwMzETUGPiX/QvhzL5lS7driBPRp5WFNToSQuVgtEWoJIPZ3jCIEuLEsyXPF+LDmaE1jC/iT1U66MOm7sdjQuio1pYXcz/HWf50v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QHjVXbzk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QHjVXbzk"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1D13360278;
	Tue, 14 Apr 2026 13:17:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776165446;
	bh=TW/05Cad82CW+FmpDAPNt1XPirSEQeexMK7TY5O/ukE=;
	h=From:To:Cc:Subject:Date:From;
	b=QHjVXbzklRRFXZMYmRiCl1n8mKTHH2zywSxgb/RqFp+6W+fZHskLRDqEoI5Z6/HT/
	 vTQbldSgKA8z2jizGR4sBcCuM+JLRchLnIvlgRoJ9frhYYaueXbQpDqEGyBWaNHsXS
	 jztgegea5kHtS4A1l/PX0sRXqg4p9+VbC8NacZB7nb0FH0kqHCbywgV2jNsJxHbzGh
	 hYwV6fnecNMIbs/zMah5FqYY0fbANIZkwPR5K8D2JVhIuk8gM/kugP7llUrgryCsFB
	 Vm/gx3frqrpT3jTdVodAXuXYMepCfUIK1sbVPCe+4b6UTewDo9WOlxVF9ZGnhLS4J1
	 z9+EgP4UvxQFA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: xmei5@asu.edu,
	fw@strlen.de
Subject: [PATCH nf] netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO
Date: Tue, 14 Apr 2026 13:17:22 +0200
Message-ID: <20260414111722.6944-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Xiang Mei says:

The OSF_WSS_MODULO branch in nf_osf_match_one() performs:

  ctx->window % f->wss.val

without guarding against f->wss.val == 0.  A user with CAP_NET_ADMIN
can add an OSF fingerprint with wss.wc = OSF_WSS_MODULO and wss.val = 0
via nfnetlink.  When a matching TCP SYN packet arrives, the kernel
executes a division by zero and panics.

The OSF_WSS_PLAIN case already treats val == 0 as a wildcard (match
everything).  Apply the same semantics to OSF_WSS_MODULO: if val is 0,
any window value matches rather than dividing by zero.

Crash:
 Oops: divide error: 0000 [#1] SMP KASAN NOPTI
 RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
 Call Trace:
 <IRQ>
  nf_osf_match (net/netfilter/nfnetlink_osf.c:220 (discriminator 6))
  xt_osf_match_packet (net/netfilter/xt_osf.c:32)
  ipt_do_table (net/ipv4/netfilter/ip_tables.c:348)
  nf_hook_slow (net/netfilter/core.c:622 (discriminator 1))
  ip_local_deliver (net/ipv4/ip_input.c:265)
  ip_rcv (include/linux/skbuff.h:1162)
  __netif_receive_skb_one_core (net/core/dev.c:6181)
  process_backlog (.include/linux/skbuff.h:2502 net/core/dev.c:6642)
  __napi_poll (net/core/dev.c:7710)
  net_rx_action (net/core/dev.c:7945)
  handle_softirqs (kernel/softirq.c:622

Fix this from control plane, reject f->wss.val == 0 if wss.ws is
OSF_WSS_MODULO.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Apologies, I don't mean to step on your feet with this patch.
This just expedites scrutiny before PR submission.

 net/netfilter/nfnetlink_osf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 5d15651c74f0..bf47a3812910 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -329,6 +329,15 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
 		if (f->opt[i].kind == OSFOPT_MSS && f->opt[i].length < 4)
 			return -EINVAL;
 
+		switch (f->wss.wc) {
+		case OSF_WSS_MODULO:
+			if (f->wss.val == 0)
+				return -EINVAL;
+			break;
+		default:
+			break;
+		}
+
 		tot_opt_len += f->opt[i].length;
 		if (tot_opt_len > MAX_IPOPTLEN)
 			return -EINVAL;
-- 
2.47.3

