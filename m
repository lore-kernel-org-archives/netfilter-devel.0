Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBAB3C6A39;
	Thu,  9 Apr 2026 13:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740059; cv=none; b=EasXYTomy1U5NbXYWBvSK0VNi1Vhio5XzXbzjK3XEZv7nbF/6xi1+Tq93p+rmVj6VheY1HdOAMsICD0ozfYtPMZRC0s6CZQtmGjdUfgcehJmYW2+2G5rBwsVoKitpxuE4d/ORRUPr48GjH6tgqHk/dACMtWzl4n/JBuJLn4XsQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740059; c=relaxed/simple;
	bh=dls/Wpp1Eq0cIYONF2jW98TENqkjUWDdoHaOOiHpl34=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DopUIG2jcoNO1jHz4dSMc2r9h8l51B6yDAn6YnYzINZBMjq3JojAfdHwmFFmBQ/J4b0Z1p3WvOixzjeXDD9+UfkhNL4wHSIf1BSt28NnYz0+ZSGMxfkjBtfI0h96evXmTActWWnG+gB/IqjUzvgf8gykZLvTbxWurGhvB/kL4xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	 (Exim 4.99)
	(envelope-from <daniel@makrotopia.org>)
	id 1wAp6a-000000001k4-1gBy;
	Thu, 09 Apr 2026 13:07:32 +0000
Date: Thu, 9 Apr 2026 14:07:29 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH RFC net-next 1/4] net: flow_offload: let drivers report byte
 counter semantics
Message-ID: <15636456e2bb94a565d139333e586ce5b63bc8c2.1775739840.git.daniel@makrotopia.org>
References: <cover.1775739840.git.daniel@makrotopia.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1775739840.git.daniel@makrotopia.org>

Hardware flow offload engines count bytes at different points --
some report ingress L2 frame bytes, others egress L2, others L3.
Add an enum so drivers can declare what their counters represent.
The framework can then convert to L3 as needed for conntrack.

Default is FLOW_STATS_BYTES_L3 (zero), preserving existing
behaviour for all current drivers.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 include/net/flow_offload.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 70a02ee143080..7f5ef29b3abce 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -541,12 +541,19 @@ static inline bool flow_rule_match_has_control_flags(const struct flow_rule *rul
 	return flow_rule_has_control_flags(match.mask->flags, extack);
 }
 
+enum flow_stats_byte_type {
+	FLOW_STATS_BYTES_L3 = 0,	/* L3 (inner IP) bytes */
+	FLOW_STATS_BYTES_INGRESS_L2,	/* full ingress L2 frame bytes */
+	FLOW_STATS_BYTES_EGRESS_L2,	/* full egress L2 frame bytes */
+};
+
 struct flow_stats {
 	u64	pkts;
 	u64	bytes;
 	u64	drops;
 	u64	lastused;
 	enum flow_action_hw_stats used_hw_stats;
+	enum flow_stats_byte_type byte_type;
 	bool used_hw_stats_valid;
 };
 
-- 
2.53.0
