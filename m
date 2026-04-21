Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5B63AE6FA
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 10:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776768269; cv=none; b=FtiDV8H4VWfE1rTf1mqHgOqiN1nd2D+6iaro4u789puayrnmrEvLrvXWuc0RVIn6EvzMTiYPYYKqlEoTW+p+ND0JEWpKM1I5lxYnTijD8eJAnMYKA4EYbTQkIz4B6iS6a0c9aRh4JcELE+hNi/m30iAIwKRvrnSV+Hqtayvnh1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776768269; c=relaxed/simple;
	bh=vSjP9BHlGkRs3WlDd+eYwg/rEtDZNLcDyRaYoJdCyhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BquHQPv9WcMvMm57RS8UoQrNITTEJBZUWucqRsd6VFq/lASSaQI1zt3c3aNJ+jdIIABAWJmAhYXzu6GCjtpfvQIqdEZNGuNKE1C4m019TdSshlUd8oU2+W+Xg+rCvgde0ueRprzjR/bZlsFRIEXvBlwua+DfLXin3DTnilESR9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8B7EA5BD61;
	Tue, 21 Apr 2026 10:44:23 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 15E74593B0;
	Tue, 21 Apr 2026 10:44:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OFhFAgdV52ljagAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 21 Apr 2026 10:44:23 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	ecklm94@gmail.com,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH 2/3 nf v3] netfilter: nf_tables: skip L4 header parsing for non-first fragments
Date: Tue, 21 Apr 2026 12:44:08 +0200
Message-ID: <20260421104409.5452-2-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260421104409.5452-1-fmancera@suse.de>
References: <20260421104409.5452-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 8B7EA5BD61
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

The tproxy, osf and exthdr (SCTP) expressions rely on the presence of
transport layer headers to perform socket lookups, fingerprint matching,
or chunk extraction. For fragmented packets, while the IP protocol
remains constant across all fragments, only the first fragment contains
the actual L4 header.

The expressions could be attached to a chain with a priority lower than
-400, bypassing defragmentation. Or could be used in stateless
environments where defragmentation is not happening at all.  This could
result in garbage data being used for the matching.

Add a check for pkt->fragoff so only unfragmented packets or the first
fragment is processed.

Fixes: 133dc203d77d ("netfilter: nft_exthdr: Support SCTP chunks")
Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: handled fragmented packets for socket expression too,
squashed nftables expression commits into this one.
v3: removed changes to nft_socket and created a generic solution for
xt/nft
---
 net/netfilter/nft_exthdr.c | 2 +-
 net/netfilter/nft_osf.c    | 2 +-
 net/netfilter/nft_tproxy.c | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 0407d6f708ae..e6a07c0df207 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -376,7 +376,7 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
 	const struct sctp_chunkhdr *sch;
 	struct sctp_chunkhdr _sch;
 
-	if (pkt->tprot != IPPROTO_SCTP)
+	if (pkt->tprot != IPPROTO_SCTP || pkt->fragoff)
 		goto err;
 
 	do {
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 18003433476c..966c7745c423 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -28,7 +28,7 @@ static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	struct nf_osf_data data;
 	struct tcphdr _tcph;
 
-	if (pkt->tprot != IPPROTO_TCP) {
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index f2101af8c867..89be443734f6 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -30,8 +30,8 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 	__be16 tport = 0;
 	struct sock *sk;
 
-	if (pkt->tprot != IPPROTO_TCP &&
-	    pkt->tprot != IPPROTO_UDP) {
+	if ((pkt->tprot != IPPROTO_TCP &&
+	     pkt->tprot != IPPROTO_UDP) || pkt->fragoff) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
@@ -97,8 +97,8 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 
 	memset(&taddr, 0, sizeof(taddr));
 
-	if (pkt->tprot != IPPROTO_TCP &&
-	    pkt->tprot != IPPROTO_UDP) {
+	if ((pkt->tprot != IPPROTO_TCP &&
+	     pkt->tprot != IPPROTO_UDP) || pkt->fragoff) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-- 
2.53.0

