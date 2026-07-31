Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C05143BDA0;
	Fri, 31 Jul 2026 15:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785511106; cv=none; b=KblIu7jkmMfDEXR4ZS3SV4i74RIDGeoKJj+3CGYvoPpg+DRL2F6+ggTqvtfsuArwOKD2457QJFhDHZgkD+JTPPxSba+I0li5qc/rI2uFnVAT3iH5Y/M746uYottgPB79wLjHn7LmcMSpxTS7mex2+A9kmnN41q6AHgusTDfYJRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785511106; c=relaxed/simple;
	bh=RkWR4p7MuTLgm5nIMryXo7GuA8d2gsmO+SCcCkrcAWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egawRFuUv+fPHiaIJm3+5wsu3lP7itSTVSLK2VNyryN7yvCdhu/vDhZ03NDlFo0Tjgk8YU7b0UJOp6FsTaKV/6hD1LyFWACuj+GRhwzLv3UQxB0KDOEysrxD010JOKONndpe/X9QjmBUYogXgGrrBSkQiPRnz6VeJpS380sOgAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pVGnWom9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pVGnWom9"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5E355601A7;
	Fri, 31 Jul 2026 17:18:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785511103;
	bh=0ZAxE5vnQVDEGsADIz2FPoDzOkd9SbXEy0QlavXZO7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVGnWom9DluVAsUKH9hpLEfyspVeOKcBU1L2sbvFk7kN/7bdJw4dNK/0AN9+16kMG
	 SGC8swMvBwQt1NE/t1Uq9Vj8bVzRpP45fIab9PXKoi9W60ls7SWcvD2aKrb0yA270O
	 vFa8wanhhmaGu4hjBmwrLoVfHFo8XQVEyZ98uylFx282KCWUVH6SEJX5viUHZ8b6hB
	 +nOydsuxkgMZmrNj85fwtCxscRmDl3a5/EU7tIeWKFD9C+dX5sqXf2u5MWK1BfjoDK
	 DsoaeE/qspHe8GFx5PZxd4xt1t/8Lst+02bQoK1zbkrPkcoPhii9iqzUwcHl/iZY/6
	 JokK6WxQtJKVg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 09/10] ipvs: return the csum validation for forward hook
Date: Fri, 31 Jul 2026 17:18:05 +0200
Message-ID: <20260731151806.849724-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731151806.849724-1-pablo@netfilter.org>
References: <20260731151806.849724-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Sashiko notes that playing games with the skb dst and rt
flags instead of providing hooknum is not a good idea
when validating the checksums.

Also, skipping checksum validation for FORWARD packets
risk silent data corruption, even if the only user is
the FTP-CMD packets coming from the real server.

Sashiko also noticed that by using common checksum
helper in the previous commit we actually fixed old bug
where the TCP/UDP checksum for IPv6 on CHECKSUM_COMPLETE
was not validated correctly.

Fixes: e876b75b9020 ("ipvs: fix the checksum validations")
Link: https://sashiko.dev/#/patchset/20260722211420.153933-1-pablo%40netfilter.org
Link: https://sashiko.dev/#/patchset/20260727185024.67534-1-ja%40ssi.bg
Link: https://sashiko.dev/#/patchset/20260728202520.59179-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h                   | 19 +++++--------------
 net/netfilter/ipvs/ip_vs_proto_sctp.c |  2 +-
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 1235f1934e94..d2813eb795be 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -25,9 +25,7 @@
 #include <linux/netfilter.h>		/* for union nf_inet_addr */
 #include <linux/ip.h>
 #include <linux/ipv6.h>			/* for struct ipv6hdr */
-#include <net/route.h>
 #include <net/ipv6.h>
-#include <net/ip6_fib.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack.h>
 #endif
@@ -2095,30 +2093,23 @@ static inline __wsum ip_vs_check_diff2(__be16 old, __be16 new, __wsum oldsum)
 	return csum_partial(diff, sizeof(diff), oldsum);
 }
 
-static inline bool ip_vs_checksum_needed(struct sk_buff *skb, int af)
+static inline bool ip_vs_checksum_needed(struct sk_buff *skb)
 {
 	/* Checksum unnecessary or already validated? */
 	if (skb_csum_unnecessary(skb))
 		return false;
-	/* LOCAL_OUT ? */
-	if (!skb->dev || skb->dev->flags & IFF_LOOPBACK)
+	/* Locally generated ? */
+	if (!skb->dev)
 		return false;
-	/* !LOCAL_IN (FORWARD) ? */
-	if (af == AF_INET6) {
-		if (!(dst_rt6_info(skb_dst(skb))->rt6i_flags & RTF_LOCAL))
-			return false;
-	} else {
-		if (!(skb_rtable(skb)->rt_flags & RTCF_LOCAL))
-			return false;
-	}
 	return true;
 }
 
 static inline bool ip_vs_checksum_common_check(struct sk_buff *skb,
 					       int offset, int proto, int af)
 {
-	if (!ip_vs_checksum_needed(skb, af))
+	if (!ip_vs_checksum_needed(skb))
 		return true;
+	/* Validate csum even for FORWARD */
 	return !nf_checksum(skb, NF_INET_LOCAL_IN, offset, proto, af);
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index 3dbd3096e163..c80567c73469 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -193,7 +193,7 @@ sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
 	struct sctphdr *sh;
 	__le32 cmp, val;
 
-	if (!ip_vs_checksum_needed(skb, af))
+	if (!ip_vs_checksum_needed(skb))
 		return 1;
 	sh = (struct sctphdr *)(skb->data + sctphoff);
 	cmp = sh->checksum;
-- 
2.47.3

