Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E8E19A854
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 12:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721132896; cv=none; b=TBKcyROzY3qeedjvgfy7Zy8TrKBBLvA6hEF7VQ3Yolsshkry3vWMm9hwkSvVOVTMX6nF6DozYIUCIEFaBc56XixCLlHBlCr/BhuWYurpIRgEZTsIS+tgH6WK/rmWjy1PGrvN2KJhDF2eb0ZJIg2qrLgTI7ktBcBka/N0dLJe3Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721132896; c=relaxed/simple;
	bh=tx7z+EDAD+bfCstFjOCsZhtGPgkuxayz163MvUcJwew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTUdgtzA5rImTvRBroHGKfRxCy+s6yMdQb9cfVR1hWC52kA76H6bSvJF/dbeAIFhhkYz9NaXa9+in4sahec4hRSW+EF4CVlj3KZQ3bL+0m4CuahGHyhuX+CWVjsT5/tuQgqdKa5QFduB4DUkDUz/65z3GpG/dBEHLaJ2KgHER2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=c9/tC1BU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="c9/tC1BU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=d57mw90EoYFOGNEoq/FCSi0/k7Xvij4lyiAEHrZURHo=; b=c9/tC1BUkzs28/eC7cZO7nFQAa
	mvNM6RhGxCF36qHMEWKWFbOUAsgko+Uz4FlRUTZdStaiUtifM3Odh329b7iIj1J6Jo/GCQORDNLbb
	ZVBUXi1G72dFtEW4fi+yLJWkyZ/u2LyZz7I/HCBWzA+pX7Jyh90ZjHrjCkSntF59Ii/PVvu6eAxHq
	srFlN4TXQsYscjui1rW5CwtSMPpOV/K/9NTCADRQiqtNjbUD6x9FUu45aUMfGISqta6SO6/n79dom
	l4uOC6mYJNg3XhRKTWNacnKBqlikjirWRNfef9dddgRyUiILAnrlHICiLQOBzFSR2s8YEP3uoNxzH
	uokM9ZIg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sThHx-000000007tY-17FP;
	Tue, 16 Jul 2024 14:28:13 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC iptables PATCH 8/8] xtables-monitor: Print commands instead of -4/-6/-0 flags
Date: Tue, 16 Jul 2024 14:28:05 +0200
Message-ID: <20240716122805.22331-9-phil@nwl.cc>
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

The '-4' and '-6' flags are a rarely used feature of iptables-restore.
The '-0' flag is purely artificial and not recognized anywhere (at least
not as an arptables rule prefix in this sense). Finally, there is no
such flag for ebtables in the first place. Go with a more intuitively
clear approach and instead print the typical command which added the
rule being printed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../testcases/nft-only/0012-xtables-monitor_0 | 40 +++++------
 iptables/xtables-monitor.c                    | 66 +++++++++----------
 2 files changed, 50 insertions(+), 56 deletions(-)

diff --git a/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0 b/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
index ef1ec3c9446ae..c49b7ccddeb35 100755
--- a/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
+++ b/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
@@ -42,13 +42,13 @@ monitorcheck() { # (cmd ...)
 EXP="\
  EVENT: nft: NEW table: table filter ip flags 0 use 1 handle 0
  EVENT: nft: NEW chain: ip filter FORWARD use 1 type filter hook forward prio 0 policy accept packets 0 bytes 0 flags 1
- EVENT: -4 -t filter -A FORWARD -j ACCEPT"
+ EVENT: iptables -t filter -A FORWARD -j ACCEPT"
 monitorcheck iptables -A FORWARD -j ACCEPT
 
 EXP="\
  EVENT: nft: NEW table: table filter ip6 flags 0 use 1 handle 0
  EVENT: nft: NEW chain: ip6 filter FORWARD use 1 type filter hook forward prio 0 policy accept packets 0 bytes 0 flags 1
- EVENT: -6 -t filter -A FORWARD -j ACCEPT"
+ EVENT: ip6tables -t filter -A FORWARD -j ACCEPT"
 monitorcheck ip6tables -A FORWARD -j ACCEPT
 
 EXP="\
@@ -60,68 +60,68 @@ monitorcheck ebtables -A FORWARD -j ACCEPT
 EXP="\
  EVENT: nft: NEW table: table filter arp flags 0 use 1 handle 0
  EVENT: nft: NEW chain: arp filter INPUT use 1 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1
- EVENT: -0 -t filter -A INPUT -j ACCEPT"
+ EVENT: arptables -t filter -A INPUT -j ACCEPT"
 monitorcheck arptables -A INPUT -j ACCEPT
 
-EXP=" EVENT: -4 -t filter -N foo"
+EXP=" EVENT: iptables -t filter -N foo"
 monitorcheck iptables -N foo
 
-EXP=" EVENT: -6 -t filter -N foo"
+EXP=" EVENT: ip6tables -t filter -N foo"
 monitorcheck ip6tables -N foo
 
-EXP=" EVENT: nft: NEW chain: bridge filter foo use 1"
+EXP=" EVENT: ebtables -t filter -N foo"
 monitorcheck ebtables -N foo
 
-EXP=" EVENT: -0 -t filter -N foo"
+EXP=" EVENT: arptables -t filter -N foo"
 monitorcheck arptables -N foo
 
 # meta l4proto matches require proper nft_handle:family value
-EXP=" EVENT: -4 -t filter -A FORWARD -i eth1 -o eth2 -p tcp -m tcp --dport 22 -j ACCEPT"
+EXP=" EVENT: iptables -t filter -A FORWARD -i eth1 -o eth2 -p tcp -m tcp --dport 22 -j ACCEPT"
 monitorcheck iptables -A FORWARD -i eth1 -o eth2 -p tcp --dport 22 -j ACCEPT
 
-EXP=" EVENT: -6 -t filter -A FORWARD -i eth1 -o eth2 -p udp -m udp --sport 1337 -j ACCEPT"
+EXP=" EVENT: ip6tables -t filter -A FORWARD -i eth1 -o eth2 -p udp -m udp --sport 1337 -j ACCEPT"
 monitorcheck ip6tables -A FORWARD -i eth1 -o eth2 -p udp --sport 1337 -j ACCEPT
 
 EXP=" EVENT: ebtables -t filter -A FORWARD -p IPv4 -i eth1 -o eth2 --ip-proto udp --ip-sport 1337 -j ACCEPT"
 monitorcheck ebtables -A FORWARD -i eth1 -o eth2 -p ip --ip-protocol udp --ip-source-port 1337 -j ACCEPT
 
-EXP=" EVENT: -0 -t filter -A INPUT -j ACCEPT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06"
+EXP=" EVENT: arptables -t filter -A INPUT -j ACCEPT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06"
 monitorcheck arptables -A INPUT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06 -j ACCEPT
 
-EXP=" EVENT: -4 -t filter -D FORWARD -i eth1 -o eth2 -p tcp -m tcp --dport 22 -j ACCEPT"
+EXP=" EVENT: iptables -t filter -D FORWARD -i eth1 -o eth2 -p tcp -m tcp --dport 22 -j ACCEPT"
 monitorcheck iptables -D FORWARD -i eth1 -o eth2 -p tcp --dport 22 -j ACCEPT
 
-EXP=" EVENT: -6 -t filter -D FORWARD -i eth1 -o eth2 -p udp -m udp --sport 1337 -j ACCEPT"
+EXP=" EVENT: ip6tables -t filter -D FORWARD -i eth1 -o eth2 -p udp -m udp --sport 1337 -j ACCEPT"
 monitorcheck ip6tables -D FORWARD -i eth1 -o eth2 -p udp --sport 1337 -j ACCEPT
 
 EXP=" EVENT: ebtables -t filter -D FORWARD -p IPv4 -i eth1 -o eth2 --ip-proto udp --ip-sport 1337 -j ACCEPT"
 monitorcheck ebtables -D FORWARD -i eth1 -o eth2 -p ip --ip-protocol udp --ip-source-port 1337 -j ACCEPT
 
-EXP=" EVENT: -0 -t filter -D INPUT -j ACCEPT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06"
+EXP=" EVENT: arptables -t filter -D INPUT -j ACCEPT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06"
 monitorcheck arptables -D INPUT -i eth1 -s 1.2.3.4 --src-mac 01:02:03:04:05:06 -j ACCEPT
 
-EXP=" EVENT: -4 -t filter -X foo"
+EXP=" EVENT: iptables -t filter -X foo"
 monitorcheck iptables -X foo
 
-EXP=" EVENT: -6 -t filter -X foo"
+EXP=" EVENT: ip6tables -t filter -X foo"
 monitorcheck ip6tables -X foo
 
-EXP=" EVENT: nft: DEL chain: bridge filter foo use 0"
+EXP=" EVENT: ebtables -t filter -X foo"
 monitorcheck ebtables -X foo
 
-EXP=" EVENT: -0 -t filter -X foo"
+EXP=" EVENT: arptables -t filter -X foo"
 monitorcheck arptables -X foo
 
-EXP=" EVENT: -4 -t filter -D FORWARD -j ACCEPT"
+EXP=" EVENT: iptables -t filter -D FORWARD -j ACCEPT"
 monitorcheck iptables -F FORWARD
 
-EXP=" EVENT: -6 -t filter -D FORWARD -j ACCEPT"
+EXP=" EVENT: ip6tables -t filter -D FORWARD -j ACCEPT"
 monitorcheck ip6tables -F FORWARD
 
 EXP=" EVENT: ebtables -t filter -D FORWARD -j ACCEPT"
 monitorcheck ebtables -F FORWARD
 
-EXP=" EVENT: -0 -t filter -D INPUT -j ACCEPT"
+EXP=" EVENT: arptables -t filter -D INPUT -j ACCEPT"
 monitorcheck arptables -F INPUT
 
 EXP=" EVENT: nft: DEL chain: ip filter FORWARD use 0 type filter hook forward prio 0 policy accept packets 0 bytes 0 flags 1"
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index b54a704bb1786..9561bd177dee4 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -70,6 +70,22 @@ static int table_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
+static const char *family_cmd(int family)
+{
+	switch (family) {
+	case NFPROTO_IPV4:
+		return "iptables";
+	case NFPROTO_IPV6:
+		return "ip6tables";
+	case NFPROTO_ARP:
+		return "arptables";
+	case NFPROTO_BRIDGE:
+		return "ebtables";
+	default:
+		return NULL;
+	}
+}
+
 static bool counters;
 static bool trace;
 static bool events;
@@ -103,27 +119,16 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 	    nft_rule_is_policy_rule(r))
 		goto err_free;
 
-	if (arg->is_event)
-		printf(" EVENT: ");
-	switch (family) {
-	case AF_INET:
-	case AF_INET6:
-		printf("-%c ", family == AF_INET ? '4' : '6');
-		break;
-	case NFPROTO_ARP:
-		printf("-0 ");
-		break;
-	case NFPROTO_BRIDGE:
-		printf("ebtables ");
-		break;
-	default:
-		puts("");
+	if (!family_cmd(family))
 		goto err_free;
-	}
 
-	printf("-t %s ", nftnl_rule_get_str(r, NFTNL_RULE_TABLE));
-	nft_rule_print_save(arg->h, r, type == NFT_MSG_NEWRULE ? NFT_RULE_APPEND :
-							   NFT_RULE_DEL,
+	printf("%s%s -t %s ",
+	       arg->is_event ? " EVENT: " : "",
+	       family_cmd(family),
+	       nftnl_rule_get_str(r, NFTNL_RULE_TABLE));
+	nft_rule_print_save(arg->h, r,
+			    type == NFT_MSG_NEWRULE ? NFT_RULE_APPEND
+						    : NFT_RULE_DEL,
 			    counters ? 0 : FMT_NOCOUNTS);
 err_free:
 	nftnl_rule_free(r);
@@ -150,29 +155,18 @@ static int chain_cb(const struct nlmsghdr *nlh, void *data)
 	if (arg->nfproto && arg->nfproto != family)
 		goto err_free;
 
-	if (nftnl_chain_is_set(c, NFTNL_CHAIN_PRIO))
-		family = -1;
-
 	printf(" EVENT: ");
-	switch (family) {
-	case NFPROTO_IPV4:
-		family = 4;
-		break;
-	case NFPROTO_IPV6:
-		family = 6;
-		break;
-	case NFPROTO_ARP:
-		family = 0;
-		break;
-	default:
-		nftnl_chain_snprintf(buf, sizeof(buf), c, NFTNL_OUTPUT_DEFAULT, 0);
+
+	if (nftnl_chain_is_set(c, NFTNL_CHAIN_PRIO) || !family_cmd(family)) {
+		nftnl_chain_snprintf(buf, sizeof(buf),
+				     c, NFTNL_OUTPUT_DEFAULT, 0);
 		printf("nft: %s chain: %s\n",
 		       type == NFT_MSG_NEWCHAIN ? "NEW" : "DEL", buf);
 		goto err_free;
 	}
 
-	printf("-%d -t %s -%c %s\n",
-			family,
+	printf("%s -t %s -%c %s\n",
+			family_cmd(family),
 			nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE),
 			type == NFT_MSG_NEWCHAIN ? 'N' : 'X',
 			nftnl_chain_get_str(c, NFTNL_CHAIN_NAME));
-- 
2.43.0

