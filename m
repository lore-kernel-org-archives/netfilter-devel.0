Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D20815E20C
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2024 11:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713438566; cv=none; b=pk1380WuYSLMmsjlgCLelqsMl8VHRjInJK1tbyqEL90WJNKtxuYwST/u8ED3KqKtqz5BnWx7c7xEFWe7EfbiM2d0bH9rz060kJC6LTXCbl75xRzeFR4U4/2hWNmsL3mX314qCXRFsko5WQuMwbfr5kuLaWxROa5SQd9brayCpK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713438566; c=relaxed/simple;
	bh=F/TmGD6P/eBNZve0CmXoI/nVfjo5Bnc9S/wABpwztCg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MKCUUjwaGHh0G10ehphq1GhM1VPGd4a+W92SVREjFFe8j4CR+iaTANziN4toZjAbVskBkGLheOwCdcQxBRmDaYBYn7kJIad3grdiVykS9W7VoradXT++LPGl8f9Cj+gdxosXofzXoYnS9LvEn1zNU4Bs3hd1yHPbA/UzGBCIa8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=Zj8lifKr; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="Zj8lifKr"
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 50FBA3F2EA
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2024 11:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1713438125;
	bh=AOGV+CBOV8eiaEz1GoNMtohBk1/aB8bFkBW7cPKL6oU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=Zj8lifKroqtWPZeSBTFG4xaigDMSFk61lNN+TOQ0/qFH3z1Oj/URB1PrWQMhPXRtB
	 zcfP4aqo+MUK9qcRCaGsOATOPQq9Blkui7OGy0VZQjSHxFwyZlEADMaL7al0Vct/is
	 KWIdz2OAJdoXhagsJh8l9zto6OipzSxaUGE+eoHJFmufUaKprT9FHR5e33toSvOhE0
	 0k/ZXV8hBfBhyWMfl/ZkNI5yqxJ5Cor/c1swZI08G3Fpo77xeToW0f39Ea7TcJdfPS
	 8Z5oK0MKV5yfvSbKF5HGZ14U9TXhqEJAkITI2JkFNkml9QVs3uviNM+G7E+iqHl2Qv
	 HsEmItHmaeaOA==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a5217f85620so31964666b.2
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Apr 2024 04:02:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713438124; x=1714042924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AOGV+CBOV8eiaEz1GoNMtohBk1/aB8bFkBW7cPKL6oU=;
        b=cGanMPQzMSBSfnwtHCuh/Y0sqdezUkF2c2etoZsyjKu7B7l/0r469sPyAfkRI7g9z5
         aByk+CKpJVjku7kswuvwmZpNwMfKz1mgtvemHQzKj2Eur8LraxiB4ROrz4mLqo/uALo/
         1O42Qpvh6X358Iz7eB/cuVDOXS1q+RKbvUm/6hAbuck9KPopp+fYPJvSfmL4t82u9iHv
         P8PcFZL8d0F9PiHNccKRwwdP8pq210DrvKdNDxSnXNK0XSKFDim29qIMH/smC7pNXyNM
         9G0P7oNNsqhXi7b0V6FQ5MvQ03irBZoIg4CjULFIqxUKu3KBBrH3CZuU7F7kMK+7cLCp
         lAHw==
X-Forwarded-Encrypted: i=1; AJvYcCWNmWi4Npv2bko53B0CTZHmNIMRNPT9E5YClO2hJGoaqGj3QnHLqTOeN/wDVQ2y5VtdhG7Z/Ezyfq0eyKlGcc/TuCkn76pAyc4qHA1m2pC/
X-Gm-Message-State: AOJu0YyUFgLxOSr5ov1zHnPpSMIIPpuKnYrR/Y2h9OFKrlc+RampUmMI
	KJcurV1Rfz2AtHKUlKo54Oz4H/R9SnakRoZ8DrPB/50cuJLQKJuqZqb2ODgoQKd8O83DckzBXqC
	oWbyjCuG1/gfjE4i22cyVhQPTScw7xG3cg9bMkg1oxH+heSB1iPA29KqgigtXkBV8ga9g1Ufu2T
	tCAinUkw==
X-Received: by 2002:a17:906:5a8c:b0:a52:5a02:2432 with SMTP id l12-20020a1709065a8c00b00a525a022432mr1500553ejq.50.1713438124766;
        Thu, 18 Apr 2024 04:02:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFK0FFwqxygVS/MakVnyy4i3LBAXhMuv1GAxCYpN0cDVcZFrxU5v8w8WwAoL/TOLrTzl1iuHA==
X-Received: by 2002:a17:906:5a8c:b0:a52:5a02:2432 with SMTP id l12-20020a1709065a8c00b00a525a022432mr1500533ejq.50.1713438124401;
        Thu, 18 Apr 2024 04:02:04 -0700 (PDT)
Received: from amikhalitsyn.lan ([2001:470:6d:781:320c:9c91:fb97:fbfc])
        by smtp.gmail.com with ESMTPSA id yk18-20020a17090770d200b00a51983e6190sm728594ejb.205.2024.04.18.04.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 04:02:04 -0700 (PDT)
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To: horms@verge.net.au
Cc: netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next v2 1/2] ipvs: add READ_ONCE barrier for ipvs->sysctl_amemthresh
Date: Thu, 18 Apr 2024 13:01:52 +0200
Message-Id: <20240418110153.102781-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Julian Anastasov <ja@ssi.bg>
Cc: Simon Horman <horms@verge.net.au>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 143a341bbc0a..daa62b8b2dd1 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -94,6 +94,7 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 {
 	struct sysinfo i;
 	int availmem;
+	int amemthresh;
 	int nomem;
 	int to_change = -1;
 
@@ -105,7 +106,8 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 	/* si_swapinfo(&i); */
 	/* availmem = availmem - (i.totalswap - i.freeswap); */
 
-	nomem = (availmem < ipvs->sysctl_amemthresh);
+	amemthresh = max(READ_ONCE(ipvs->sysctl_amemthresh), 0);
+	nomem = (availmem < amemthresh);
 
 	local_bh_disable();
 
@@ -146,8 +148,8 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 	case 1:
 		if (nomem) {
 			ipvs->drop_rate = ipvs->drop_counter
-				= ipvs->sysctl_amemthresh /
-				(ipvs->sysctl_amemthresh-availmem);
+				= amemthresh /
+				(amemthresh-availmem);
 			ipvs->sysctl_drop_packet = 2;
 		} else {
 			ipvs->drop_rate = 0;
@@ -156,8 +158,8 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 	case 2:
 		if (nomem) {
 			ipvs->drop_rate = ipvs->drop_counter
-				= ipvs->sysctl_amemthresh /
-				(ipvs->sysctl_amemthresh-availmem);
+				= amemthresh /
+				(amemthresh-availmem);
 		} else {
 			ipvs->drop_rate = 0;
 			ipvs->sysctl_drop_packet = 1;
-- 
2.34.1

