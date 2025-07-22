Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74B02E3B1C
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 14:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753195742; cv=none; b=AGX+17bN9UyqHJa/HDtSiCMfXWDWIwsdVrXdqqe4WAfRxXlRx+YaC75xeFsLjZ3C2IPpNdSuDGQXX3gxVifHbsC3GEyXroM5lEPMt4rkmb213Qb9ce0wNV3buMlcvx5o1i8jikeVT6fb+DGIslcJ8jG8fk3WG3/V3o0ziHw+0h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753195742; c=relaxed/simple;
	bh=btd7O9gR3DRYqYAJoMfI+Tj7Ey9WrZ4062oGvZ1mo/Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOhoE39MIGUN0/w+13PGWrsS8L+vDlIpdaFsbIyf8Yd6MQlHm04NR7N/xDNGox1qI/DYy+KXub68tQ1AmhapiGHEdi5UmQZxw86bkiqzwCjWK/vDd8RXu6LjYjLJFar2LrPb+eXu3qCs5e002XYjm3LoAwOfBfa44deFxuZVrLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=JBj9Rx6S; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="JBj9Rx6S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Iavx5wYdeh0ZKibtQC8lk7I9895ZcL1Du2+6pukeQkI=; b=JBj9Rx6S/NJ/8h6idYS1z904ni
	0K1uwOMFNHVONvQbzuhArSLSxIRowByRqFWnM7+lbvf9vfRByxpPjCSDr7skOz3dxFwn2rUKx9IJl
	BWSSIPY2ORO4Ie6wLorLITjDwftbVuT2rXF2C9BBXHDlHFf6U+NqWJ3VqqxcSNh+uQ9wj0HDOd3M/
	L2ewXsd6oSzVuqwRkMO9SdN0IviWVrWtZeQUUsp8dvC2CVMrTqvAdzjfKku4ZKJC3cwTwPwQfj/UH
	4IPtIxQOgYJVEdWTuuKfB260/pdnF640gK9rZsGrx9P87GDh+7iNN/FW+xw3JPo5t2n3gy7qrlw3U
	4yckoYUQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ueEIc-0000000044X-46gU
	for netfilter-devel@vger.kernel.org;
	Tue, 22 Jul 2025 16:48:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] xtables-monitor: Print -X command for base chains, too
Date: Tue, 22 Jul 2025 16:48:53 +0200
Message-ID: <20250722144853.21022-2-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250722144853.21022-1-phil@nwl.cc>
References: <20250722144853.21022-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 61e85e3192dea ("iptables-nft: allow removal of empty
builtin chains"), the command may be applied to "builtin" chains as
well, so the output is basically valid.

Apart from that, since kernel commit a1050dd07168 ("netfilter:
nf_tables: Reintroduce shortened deletion notifications") the base chain
deletion notification does not contain NFTNL_CHAIN_PRIO (actually:
NFTA_HOOK_PRIORITY) attribute anymore so this implicitly fixes for
changed kernel behaviour.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../tests/shell/testcases/nft-only/0012-xtables-monitor_0 | 8 ++++----
 iptables/xtables-monitor.c                                | 4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0 b/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
index c49b7ccddeb35..10d9547ae8f44 100755
--- a/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
+++ b/iptables/tests/shell/testcases/nft-only/0012-xtables-monitor_0
@@ -124,16 +124,16 @@ monitorcheck ebtables -F FORWARD
 EXP=" EVENT: arptables -t filter -D INPUT -j ACCEPT"
 monitorcheck arptables -F INPUT
 
-EXP=" EVENT: nft: DEL chain: ip filter FORWARD use 0 type filter hook forward prio 0 policy accept packets 0 bytes 0 flags 1"
+EXP=" EVENT: iptables -t filter -X FORWARD"
 monitorcheck iptables -X FORWARD
 
-EXP=" EVENT: nft: DEL chain: ip6 filter FORWARD use 0 type filter hook forward prio 0 policy accept packets 0 bytes 0 flags 1"
+EXP=" EVENT: ip6tables -t filter -X FORWARD"
 monitorcheck ip6tables -X FORWARD
 
-EXP=" EVENT: nft: DEL chain: bridge filter FORWARD use 0 type filter hook forward prio -200 policy accept packets 0 bytes 0 flags 1"
+EXP=" EVENT: ebtables -t filter -X FORWARD"
 monitorcheck ebtables -X FORWARD
 
-EXP=" EVENT: nft: DEL chain: arp filter INPUT use 0 type filter hook input prio 0 policy accept packets 0 bytes 0 flags 1"
+EXP=" EVENT: arptables -t filter -X INPUT"
 monitorcheck arptables -X INPUT
 
 exit $rc
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index 9561bd177dee4..950aac17a2411 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -157,7 +157,9 @@ static int chain_cb(const struct nlmsghdr *nlh, void *data)
 
 	printf(" EVENT: ");
 
-	if (nftnl_chain_is_set(c, NFTNL_CHAIN_PRIO) || !family_cmd(family)) {
+	if (!family_cmd(family) ||
+	    (type == NFT_MSG_NEWCHAIN &&
+	     nftnl_chain_is_set(c, NFTNL_CHAIN_PRIO))) {
 		nftnl_chain_snprintf(buf, sizeof(buf),
 				     c, NFTNL_OUTPUT_DEFAULT, 0);
 		printf("nft: %s chain: %s\n",
-- 
2.49.0

