Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EEC386573;
	Sun,  7 Jun 2026 09:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780825810; cv=none; b=tzBFJwDjdbQa5lYgPRqxINs2GDnROBJPIfVQLGVwXhr4OxPkjSyALuFthajIOhblkqxVn2gj0f1nJ6y7mCX2wQtZwQcfB0ZaghLh3dbx2fT5clcyslGYu8X9VMa/zjHPODLkw5DjDg49KFrjo9IbDEgntp2epQEEODfY9U8zbH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780825810; c=relaxed/simple;
	bh=umzV0W4njSNtuU49Vf/CM8PPqw/fBrYpFbxdvYxkq7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjCySgZ4Mfxkb3GQeQ1hcusGJoFm/+ziXxIy5iNT2wgPK88mJgP7F0iKLlymU+bGL6GQbe4/dg8gL1nWUalMkOalblnCyOHu4ol0AOJU1PaeurEnm0zu2RsBAUbmYS/28nnY9JsvtZk8l9brFiN/5x2lhRdodm9QZHM/TPbbPSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bzxtbn9P; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bzxtbn9P"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 38CD76019F;
	Sun,  7 Jun 2026 11:50:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780825806;
	bh=0ENKkrFLlUB3IhcSu+diaF6GSvxtSANCQrvHGbtCycs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzxtbn9PHVCq65M/HJXyLSbyA6Sz0fgEBk8EZAWYT5GdYNdK3BUVADD2IDXJeYMxp
	 EXkU29iXCcS2Je4zJVg2v/Fcx8n7wFVXB5JlMSLyFolHKG4vakPl9wLZq9fe8TjxEr
	 Y/8N7tVRoLvf4mn4cKA5kW5HeHPdb54UVl2Bb54h/jHklS3f/0TwLbEflLkK5X9Cig
	 eGjPOGXN6qH7hBviD2kzRIomnjXWodFyg845DJ6eyI+8hzBsqCsbP4aNvpylLWhhY4
	 Es7h6AyOgQH0C6O77Ne+hYfEYCtYxEGNY9uYs1m2f+TEkjHnVeCKooBAGPS/SlQ1BG
	 jIGevhBgsYsKA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 04/15] netfilter: synproxy: drop packets if timestamp adjustment fails
Date: Sun,  7 Jun 2026 11:49:43 +0200
Message-ID: <20260607094954.48892-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260607094954.48892-1-pablo@netfilter.org>
References: <20260607094954.48892-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

If a packet was malformed or if skb_ensure_writable() failed, the
synproxy_tstamp_adjust() function returned 0 indicating an error but it
was ignored on the callers.

Make the function return a boolean instead to clarify the result and
drop the packet if synproxy_tstamp_adjust() failed due to ENOMEM from
skb_ensure_writable(). In addition, if there are malformed options, skip
the tstamp update but do not drop the packet as that should be done by
the policy directly.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_synproxy_core.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index ed00114f65f3..f99c22f57b7e 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -184,7 +184,7 @@ synproxy_check_timestamp_cookie(struct synproxy_options *opts)
 	opts->options |= opts->tsecr & (1 << 5) ? NF_SYNPROXY_OPT_ECN : 0;
 }
 
-static unsigned int
+static bool
 synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 		       struct tcphdr *th, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
@@ -194,13 +194,13 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 	__be32 *ptr, old;
 
 	if (synproxy->tsoff == 0)
-		return 1;
+		return true;
 
 	optoff = protoff + sizeof(struct tcphdr);
 	optend = protoff + th->doff * 4;
 
 	if (skb_ensure_writable(skb, optend))
-		return 0;
+		return false;
 
 	th = (struct tcphdr *)(skb->data + protoff);
 
@@ -209,7 +209,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 
 		switch (op[0]) {
 		case TCPOPT_EOL:
-			return 1;
+			return true;
 		case TCPOPT_NOP:
 			optoff++;
 			continue;
@@ -217,7 +217,7 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 			if (optoff + 1 == optend ||
 			    optoff + op[1] > optend ||
 			    op[1] < 2)
-				return 0;
+				return true;
 			if (op[0] == TCPOPT_TIMESTAMP &&
 			    op[1] == TCPOLEN_TIMESTAMP) {
 				if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
@@ -233,12 +233,12 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 				}
 				inet_proto_csum_replace4(&th->check, skb,
 							 old, *ptr, false);
-				return 1;
+				return true;
 			}
 			optoff += op[1];
 		}
 	}
-	return 1;
+	return true;
 }
 
 #ifdef CONFIG_PROC_FS
@@ -749,7 +749,9 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 		break;
 	}
 
-	synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy);
+	if (!synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy))
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, ENOMEM);
+
 	return NF_ACCEPT;
 }
 EXPORT_SYMBOL_GPL(ipv4_synproxy_hook);
@@ -1177,7 +1179,9 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 		break;
 	}
 
-	synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy);
+	if (!synproxy_tstamp_adjust(skb, thoff, th, ct, ctinfo, synproxy))
+		return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, ENOMEM);
+
 	return NF_ACCEPT;
 }
 EXPORT_SYMBOL_GPL(ipv6_synproxy_hook);
-- 
2.47.3

