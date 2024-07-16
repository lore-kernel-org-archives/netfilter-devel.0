Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81F3199225
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 12:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721132894; cv=none; b=DbFIBSQCZkVZ5xaJXnFWOYFyCdouGUm/9SQ3ydCQcS3Xf9Rw5vbB9ScaS2sY6Gor5FzaEtsS2p90bSQjiTjBar2CrPzv8EjUKmkV1Pr7CDn8beoyIySziLlZXccFn0gPKN5RFJSQYpwSMqCbT/QeHqHx/3ZvI5lEeOGRiDJrgsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721132894; c=relaxed/simple;
	bh=NPYR50ktjxcEcM2QRMbczNIuiRwdIoMdVrQbeN3i7dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBLur9N01H8U0YnckvbR4P+oL411dFv3I1GD4sJenGzZf6EL5MHa0bCGRv7LOEiR680rvj4fLviNBHkgf+B8ETRJwHFkltuBYbeDZoQDXtxwm/fDRgbLmmZA38w/yielh8qzerEFDofGlrlacYX6Q6RGJVp7Qe1RhBXbV/zgANc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=h9aChjt3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="h9aChjt3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ri/eTvHh+adhepAFA+8mFEdjzF37wtgQKn32pN8lWhA=; b=h9aChjt3/WbkNuGnLafN89XU1U
	nVzY9ojhsRwJQOSEk/sO0VqHHw+v+2tHToVU7ybhH7QBhDGiJv49DWCYzFiZzswVQdLgExgNkVnHf
	7SkJAO2+tWVHmLglPb75t5L3x4Btc974WY1AdORNHPIany3l6t8qT7cbrwIGwE24AfuTJcX2d1wzu
	z2TULXYiWsd0B2Y7IL1xQk8SyFycI6p5cqNB+8tkYGMcxzLeiJp/35/SjUwY1pDqUw4CY8Bqju87m
	QX3XUWLcXhZ8/SiqUkcaoNF8MbmtS4S6xNzLwUV4GF/TgfiI4yAYZUpJOlAXiWp0EXAzRxx1OOKUF
	gu3ZsTiw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sThHu-000000007tE-3UpR;
	Tue, 16 Jul 2024 14:28:10 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 6/8] xtables-monitor: Fix for ebtables rule events
Date: Tue, 16 Jul 2024 14:28:03 +0200
Message-ID: <20240716122805.22331-7-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240716122805.22331-1-phil@nwl.cc>
References: <20240716122805.22331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bridge family wasn't recognized in rule_cb(), so merely an empty
"EVENT:" line was printed for ebtables rule changes. For lack of a
well-known family modifier flag for bridge family, simply prefix rules
by "ebtables".

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/nft-only/0012-xtables-monitor_0     | 15 ++++++---------
 iptables/xtables-monitor.c                        |  3 +++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0 b/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
index 7b028ba7a9ca5..0f0295b05ec52 100755
--- a/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
+++ b/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
@@ -55,7 +55,7 @@ monitorcheck ip6tables -A FORWARD -j ACCEPT
 EXP="\
  EVENT: nft: NEW table: table filter bridge flags 0 use 1 handle 0
  EVENT: nft: NEW chain: bridge filter FORWARD use 1 type filter hook forward prio -200 policy accept packets 0 bytes 0 flags 1
- EVENT: "
+ EVENT: ebtables -t filter -A FORWARD -j ACCEPT"
 monitorcheck ebtables -A FORWARD -j ACCEPT
 
 EXP="\
@@ -73,7 +73,7 @@ monitorcheck ip6tables -N foo
 # FIXME
 EXP="\
  EVENT: nft: NEW chain: bridge filter foo use 1
- EVENT: "
+ EVENT: ebtables -t filter -A foo -j ACCEPT"
 monitorcheck ebtables -N foo
 
 EXP=" EVENT: -0 -t filter -N foo"
@@ -86,8 +86,7 @@ monitorcheck iptables -A FORWARD -i eth1 -o eth2 -p tcp --dport 22 -j ACCEPT
 EXP=" EVENT: -6 -t filter -A FORWARD -i eth1 -o eth2 -p udp -m udp --sport 1337 -j ACCEPT"
 monitorcheck ip6tables -A FORWARD -i eth1 -o eth2 -p udp --sport 1337 -j ACCEPT
 
-# FIXME
-EXP=" EVENT: "
+EXP=" EVENT: ebtables -t filter -A FORWARD -p IPv4 -i eth1 -o eth2 --ip-proto udp --ip-sport 1337 -j ACCEPT"
 monitorcheck ebtables -A FORWARD -i eth1 -o eth2 -p ip --ip-protocol udp --ip-source-port 1337 -j ACCEPT
 
 EXP=" EVENT: -0 -t filter -A INPUT -j ACCEPT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06"
@@ -99,8 +98,7 @@ monitorcheck iptables -D FORWARD -i eth1 -o eth2 -p tcp --dport 22 -j ACCEPT
 EXP=" EVENT: -6 -t filter -D FORWARD -i eth1 -o eth2 -p udp -m udp --sport 1337 -j ACCEPT"
 monitorcheck ip6tables -D FORWARD -i eth1 -o eth2 -p udp --sport 1337 -j ACCEPT
 
-# FIXME
-EXP=" EVENT: "
+EXP=" EVENT: ebtables -t filter -D FORWARD -p IPv4 -i eth1 -o eth2 --ip-proto udp --ip-sport 1337 -j ACCEPT"
 monitorcheck ebtables -D FORWARD -i eth1 -o eth2 -p ip --ip-protocol udp --ip-source-port 1337 -j ACCEPT
 
 EXP=" EVENT: -0 -t filter -D INPUT -j ACCEPT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06"
@@ -114,7 +112,7 @@ monitorcheck ip6tables -X foo
 
 # FIXME
 EXP="\
- EVENT: 
+ EVENT: ebtables -t filter -D foo -j ACCEPT
  EVENT: nft: DEL chain: bridge filter foo use 0"
 monitorcheck ebtables -X foo
 
@@ -127,8 +125,7 @@ monitorcheck iptables -F FORWARD
 EXP=" EVENT: -6 -t filter -D FORWARD -j ACCEPT"
 monitorcheck ip6tables -F FORWARD
 
-# FIXME
-EXP=" EVENT: "
+EXP=" EVENT: ebtables -t filter -D FORWARD -j ACCEPT"
 monitorcheck ebtables -F FORWARD
 
 EXP=" EVENT: -0 -t filter -D INPUT -j ACCEPT"
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 714a2dfd7074a..7079a039fb28b 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -106,6 +106,9 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 	case NFPROTO_ARP:
 		printf("-0 ");
 		break;
+	case NFPROTO_BRIDGE:
+		printf("ebtables ");
+		break;
 	default:
 		puts("");
 		goto err_free;
-- 
2.43.0

