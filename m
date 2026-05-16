Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EC13D8113;
	Sat, 16 May 2026 11:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932604; cv=none; b=AegdWGTp13Cm5bt5+RHi1SRnWIrCtaW8q4kONcAnf5N39/8rLOuCNjIS1RYcu5P7ntKFT/jgzLsB6WuI8LyoenaXvhY3EPV3wv9nwvuIzlkFoBXkolQYRA8UTAMlrVPBF0Aleqvwh/DO1nA6Zd56hvpOhddbDMDe5sAK01lTtIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932604; c=relaxed/simple;
	bh=fV2CDfwH+z19oDaiviB/aF9MeqM3/P70LFB+h2zmB/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/JZM9/W+PHJU3xQL8TPsQfEomIyC4i3WrOHTvDz4ycfuHu89Q2+0/hHTbWZ1ZZecrnuMSy+C/RPXZAmIhhLKPxPIoVnBeOf3ngMzZZEwG55bk2OTXnmwVMHYJCC1QVZ9Nohr9eEDzfoN+dwVR/B4zr1jSvyPKxYu9cc9KkAJz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BY1F4QFt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BY1F4QFt"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E74BC601AA;
	Sat, 16 May 2026 13:56:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778932598;
	bh=fwTyBk3ughoK4Jc4LSjyVgxtPRZRV5JVnEb+wikaKi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BY1F4QFtb5GoxUE4qj71gPyTcJNJSFJj9io9ZE8KUPmeClvjXq8TpXHYY8j0aIK5f
	 HoDk/rtz43B07+sOyCFVyPSfWNpcwFkiN4zdk1piEYy2lkZUl0PqdUUDq+0LwNHYmC
	 ho18bCs8hgIBFR7uWNIHVTgGXVyfXP2gipmM2k65W0/HobXboQF5gdLDRY5mA69RRY
	 +5oMnSCcdSAp4mjJQbiSIKhiM2g1/jzb5e57XIC1X2aORG8y6bL04vYoNW66LpTMUK
	 flpqFKU+XJLvghu0RyRPhjcotLUF/SweBP1SXMPMHKvUuRjz7uq8TdnVGQRlfkrzTC
	 jd1GP4H9u5j/w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 05/12] netfilter: ipset: stop hash:* range iteration at end
Date: Sat, 16 May 2026 13:56:20 +0200
Message-ID: <20260516115627.967773-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516115627.967773-1-pablo@netfilter.org>
References: <20260516115627.967773-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nan Li <tonanli66@gmail.com>

The following hash set variants:

hash:ip,mark
hash:ip,port
hash:ip,port,ip
hash:ip,port,net

iterate IPv4 ranges with a 32-bit iterator.

The iterator must stop once the last address in the requested range has
been processed. Advancing it once more can move the traversal state past
the end of the request, so a later retry may continue from an unintended
position.

Handle the iterator increment explicitly at the end of the loop and stop
once the upper bound has been processed. This keeps the existing retry
behaviour intact for valid ranges while preventing traversal from
continuing past the original boundary.

Fixes: 48596a8ddc46 ("netfilter: ipset: Fix adding an IPv4 range containing more than 2^31 addresses")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Nan Li <tonanli66@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_ipmark.c    | 6 +++++-
 net/netfilter/ipset/ip_set_hash_ipport.c    | 5 ++++-
 net/netfilter/ipset/ip_set_hash_ipportip.c  | 5 ++++-
 net/netfilter/ipset/ip_set_hash_ipportnet.c | 5 ++++-
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index a22ec1a6f6ec..e26ca2a370e3 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -150,7 +150,7 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++, i++) {
+	for (; ip <= ip_to; i++) {
 		e.ip = htonl(ip);
 		if (i > IPSET_MAX_RANGE) {
 			hash_ipmark4_data_next(&h->next, &e);
@@ -162,6 +162,10 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 			return ret;
 
 		ret = 0;
+
+		if (ip == ip_to)
+			break;
+		ip++;
 	}
 	return ret;
 }
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index e977b5a9c48d..41ca24a22a02 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -186,7 +186,7 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
 		for (; p <= port_to; p++, i++) {
@@ -203,6 +203,9 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 			ret = 0;
 		}
+		if (ip == ip_to)
+			break;
+		ip++;
 	}
 	return ret;
 }
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 39a01934b153..b9ac2efaa15c 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -182,7 +182,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
 		for (; p <= port_to; p++, i++) {
@@ -199,6 +199,9 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 			ret = 0;
 		}
+		if (ip == ip_to)
+			break;
+		ip++;
 	}
 	return ret;
 }
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 5c6de605a9fb..2d6652d43199 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -274,7 +274,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		p = port;
 		ip2 = ip2_from;
 	}
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		e.ip = htonl(ip);
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
@@ -298,6 +298,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			ip2 = ip2_from;
 		}
 		p = port;
+		if (ip == ip_to)
+			break;
+		ip++;
 	}
 	return ret;
 }
-- 
2.47.3

