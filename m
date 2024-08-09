Received: from mx01.omp.ru (mx01.omp.ru [90.154.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAB017BB13;
	Fri,  9 Aug 2024 07:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.154.21.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723189278; cv=none; b=EWpB5QVhBSvHqo7tXVtF1t6e3nlDVMbjnVEu68gnu6at2bdNCFLyQfD0sg7xGV9P05hCMABu28rwpLjpK+6iq+p7VNUVOtNCh1fjvm85fIR+olDbkVZtxhySbtk40zgsUHC3rOzkMTOwsWnKW1ZCa/1pgwguXKefrpvR8Ru0Ivc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723189278; c=relaxed/simple;
	bh=bMxXANLcXIR0EKqEWjwf6YFOMOM4Qw2kkWArm9aKOX4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cOh3GrPIBKCSS7znlmgTtQmgoL5qSELUa13UbAcbvSinpM87Ac2I5KkoJlUuWH7GpQ9KmA2BWvxpBZIKAy5z+XJAagNnmvjRY+4VJazryxafJ/lj2k8qdq5LOWAi8/2DY0wzGYXel2YVgFvnxJBsoedAePfPzO4wtQePnxjlwwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru; spf=pass smtp.mailfrom=omp.ru; arc=none smtp.client-ip=90.154.21.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=omp.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=omp.ru
Received: from localhost.localdomain (217.23.186.16) by msexch01.omp.ru
 (10.188.4.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Fri, 9 Aug
 2024 10:40:54 +0300
From: Roman Smirnov <r.smirnov@omp.ru>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
CC: Roman Smirnov <r.smirnov@omp.ru>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Sergey Shtylyov <s.shtylyov@omp.ru>, Karina
 Yankevich <k.yankevich@omp.ru>, <lvc-project@linuxtesting.org>
Subject: [PATCH] netfilter: nfnetlink_log: remove unnecessary check in __build_packet_message()
Date: Fri, 9 Aug 2024 10:40:35 +0300
Message-ID: <20240809074035.11078-1-r.smirnov@omp.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: msexch01.omp.ru (10.188.4.12) To msexch01.omp.ru
 (10.188.4.12)
X-KSE-ServerInfo: msexch01.omp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 6.1.0, Database issued on: 08/09/2024 07:24:41
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 19
X-KSE-AntiSpam-Info: Lua profiles 186955 [Aug 09 2024]
X-KSE-AntiSpam-Info: Version: 6.1.0.4
X-KSE-AntiSpam-Info: Envelope from: r.smirnov@omp.ru
X-KSE-AntiSpam-Info: LuaCore: 24 0.3.24
 186c4d603b899ccfd4883d230c53f273b80e467f
X-KSE-AntiSpam-Info: {rep_avail}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {SMTP from is not routable}
X-KSE-AntiSpam-Info: {Found in DNSBL: 217.23.186.16 in (user)
 b.barracudacentral.org}
X-KSE-AntiSpam-Info:
	127.0.0.199:7.1.2;omp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: ApMailHostAddress: 217.23.186.16
X-KSE-AntiSpam-Info: {DNS response errors}
X-KSE-AntiSpam-Info: Rate: 19
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dmarc=temperror header.from=omp.ru;spf=temperror
 smtp.mailfrom=omp.ru;dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/09/2024 07:29:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 8/9/2024 5:00:00 AM
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit

skb->dev is always non-NULL, the check is unnecessary.

Remove it.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
 net/netfilter/nfnetlink_log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 134e05d31061..ee04a52eaf33 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -566,8 +566,7 @@ __build_packet_message(struct nfnl_log_net *log,
 	    nla_put_be32(inst->skb, NFULA_MARK, htonl(skb->mark)))
 		goto nla_put_failure;
 
-	if (indev && skb->dev &&
-	    skb_mac_header_was_set(skb) &&
+	if (indev && skb_mac_header_was_set(skb) &&
 	    skb_mac_header_len(skb) != 0) {
 		struct nfulnl_msg_packet_hw phw;
 		int len;
-- 
2.43.0

