Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768593DA7E3;
	Wed, 25 Mar 2026 13:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444352; cv=none; b=KT1Of02ZddlrdposC1VXq8RRyr5rZrn+eSGSc+vmw88YqmoX/fBLF7nhIayKpcBQM8OC6XiROvbgUa2UUzczGbRhyHokh6rJZL+QUUm+4CEFTYU/304CLPa+KeLsTIQmhEvHWNfUfn4oIZ2+1LlyaYq1A4iwqSbdJOp9tlLrRAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444352; c=relaxed/simple;
	bh=UiqHFT0kt119Q4NorbM1nwW//HNGPA2WXqHtJiZSuUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAC3DvN9AGBeDkaoKx8OSSj6Z8hsanHpQJlUhsphtnpf3vLl9HA3RQCdno1taEXox+aO44Rz7bXDh7SOmgLwZnLxlEmCY2PzdGmtV0uFJqnuuCi+zaUcTB9XkIyQWHRNH/yd7jnPsd5mpJ5S14pmBNMYJ6a2TvMcl6jQ+MQMuMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 133FC60AF9; Wed, 25 Mar 2026 14:12:30 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 13/14] netfilter: nf_conntrack_sip: fix use of uninitialized rtp_addr in process_sdp
Date: Wed, 25 Mar 2026 14:11:07 +0100
Message-ID: <20260325131108.23045-14-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325131108.23045-1-fw@strlen.de>
References: <20260325131108.23045-1-fw@strlen.de>
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
2.52.0

