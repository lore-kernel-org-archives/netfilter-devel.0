Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECF12690C0;
	Thu, 26 Mar 2026 12:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774529533; cv=none; b=keH6ihRT5Q4xrrIYaxl5szwfIs1ZYGMmlvdDWgOuZ4n/smfp4vFbg7/pVEmmsALuzFf6jhKdR6PS7UWi8oMTGXT7O5Z2kqacz5uoHwIKemRDaLpTtvUxEMijTaCsRFiae2m8VeMcFZVvXZ2DGUSqYsTiO7v/xwX259L1NjYxiiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774529533; c=relaxed/simple;
	bh=JmL4jT7/pY8p5XAOf8x0E4Bvm5soQhdankRVmIzdmdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvA5VsYRPx/IzQjmXiEUsb4voal2PNGieGDWexZdbArsR31THD80bD1dDuepHobPy4iuQyZXmDVboDov1mstnXh25mt+GL16p/vbIfp5Png1xv5QfPlmSU7feduU4IC7zSfrMMXyA0yR8q+H6LIoehDiqy8BtWKASnbxOwxGuGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SgKKZTeN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SgKKZTeN"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 91E516026C;
	Thu, 26 Mar 2026 13:52:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774529531;
	bh=3hJxK5rllYA2kZvxgaWC+2ejMOnxVCOmuBD7UKfH31w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgKKZTeNqDtH0i8+UYFG4nVzj1KQIQsg25lR+7ffH2JADCSaownvOgTV52shMZl3u
	 b8eVJnM1a6p6e+q4JQ/38+5JBXhmkjx7cXmaqDF2Qxp0DjD+8+ueTx58gL9axzsDlG
	 Hs5XP/FHGAaKF8FLKwxXfWXzlwpY2gyo0IIJfGbmL1mS8m6Rk1khQcKVB7tf2rBl82
	 zLve+7aRMpxzm+eQX9+aYYQ9+5SRETiMwVgIMFatcC5Oige6yS1krPQXJBXvwoEvbX
	 XTl0eyO9KxJF4SBzrc9iAA06xaxilKHBPySxp93WmPJ7igIJ1bStBC0L1DuGWADw3p
	 f21fbbv2l22DA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 11/12] netfilter: nf_conntrack_sip: fix use of uninitialized rtp_addr in process_sdp
Date: Thu, 26 Mar 2026 13:51:52 +0100
Message-ID: <20260326125153.685915-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326125153.685915-1-pablo@netfilter.org>
References: <20260326125153.685915-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Weiming Shi <bestswngs@gmail.com>

process_sdp() declares union nf_inet_addr rtp_addr on the stack and
passes it to the nf_nat_sip sdp_session hook after walking the SDP
media descriptions. However rtp_addr is only initialized inside the
media loop when a recognized media type with a non-zero port is found.

If the SDP body contains no m= lines, only inactive media sections
(m=audio 0 ...) or only unrecognized media types, rtp_addr is never
assigned. Despite that, the function still calls hooks->sdp_session()
with &rtp_addr, causing nf_nat_sdp_session() to format the stale stack
value as an IP address and rewrite the SDP session owner and connection
lines with it.

With CONFIG_INIT_STACK_ALL_ZERO (default on most distributions) this
results in the session-level o= and c= addresses being rewritten to
0.0.0.0 for inactive SDP sessions. Without stack auto-init the
rewritten address is whatever happened to be on the stack.

Fix this by pre-initializing rtp_addr from the session-level connection
address (caddr) when available, and tracking via a have_rtp_addr flag
whether any valid address was established. Skip the sdp_session hook
entirely when no valid address exists.

Fixes: 4ab9e64e5e3c ("[NETFILTER]: nf_nat_sip: split up SDP mangling")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_sip.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 20e57cf5c83a..939502ff7c87 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1040,6 +1040,7 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 	unsigned int port;
 	const struct sdp_media_type *t;
 	int ret = NF_ACCEPT;
+	bool have_rtp_addr = false;
 
 	hooks = rcu_dereference(nf_nat_sip_hooks);
 
@@ -1056,8 +1057,11 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 	caddr_len = 0;
 	if (ct_sip_parse_sdp_addr(ct, *dptr, sdpoff, *datalen,
 				  SDP_HDR_CONNECTION, SDP_HDR_MEDIA,
-				  &matchoff, &matchlen, &caddr) > 0)
+				  &matchoff, &matchlen, &caddr) > 0) {
 		caddr_len = matchlen;
+		memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
+		have_rtp_addr = true;
+	}
 
 	mediaoff = sdpoff;
 	for (i = 0; i < ARRAY_SIZE(sdp_media_types); ) {
@@ -1091,9 +1095,11 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 					  &matchoff, &matchlen, &maddr) > 0) {
 			maddr_len = matchlen;
 			memcpy(&rtp_addr, &maddr, sizeof(rtp_addr));
-		} else if (caddr_len)
+			have_rtp_addr = true;
+		} else if (caddr_len) {
 			memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
-		else {
+			have_rtp_addr = true;
+		} else {
 			nf_ct_helper_log(skb, ct, "cannot parse SDP message");
 			return NF_DROP;
 		}
@@ -1125,7 +1131,7 @@ static int process_sdp(struct sk_buff *skb, unsigned int protoff,
 
 	/* Update session connection and owner addresses */
 	hooks = rcu_dereference(nf_nat_sip_hooks);
-	if (hooks && ct->status & IPS_NAT_MASK)
+	if (hooks && ct->status & IPS_NAT_MASK && have_rtp_addr)
 		ret = hooks->sdp_session(skb, protoff, dataoff,
 					 dptr, datalen, sdpoff,
 					 &rtp_addr);
-- 
2.47.3

