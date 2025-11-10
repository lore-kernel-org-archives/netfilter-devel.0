Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56382EDD63
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 20:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762806613; cv=none; b=fm9TUrN0iSy4PdmKe/ntnqr8OHs0N4OJ2UN/5BF9zBBt9jaGFxmvmJ0Md00E+iemXYkO7Xh9ps+jZbGmjoHeL8Hil6GbI08P31o7E9qN25m4086x8qYuy688Rw+CkaNXqjnDmqQd21YpkTJjvvf/S7Rfqdu85Q2jsVFruTDRieg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762806613; c=relaxed/simple;
	bh=UmjRi3hXBSKF6ZzNALfHfpstRXNI9ZW8jJVzyV9IZk8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pQPqP2Qb5bng8YYHg3fuWvtea+nJi1SlBH63/DFmBYyPbHFOJw4TkzbaDN+28t03XhgT1PhQTfQ6IdsY1TjOdhYA6G7QdaeNRWNwZSqgDA266EwKlkVYucbdWs4BG4ZwMhD94OjAOlbEiIEP7LbnCI2TbulSPL6IhdOVYiJZkP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=THhrr4fy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="THhrr4fy"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F35B96034A
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 21:30:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1762806602;
	bh=6AYOpKwKi5EIoLq7wm+BMAK9hbzjy/tX+leXV6FUms0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=THhrr4fylQ9+BT+zcWwL1c1IPH21YR8WamFWELcrvpBR20TVsqtoECoqJrrvqzH+u
	 MoKUzV5bUOMXIJn5GsGYsKuvkWL99KfBuu5d29tY+QuQCkx2oXmf+bk2nxMr4FRaMc
	 8GgJoiLQrD1iUt0qjYRu4HbCC5HoGPdA5FUtemKvIrHTuzh+dgSyjRnIHQ80JiES63
	 sDkLaov3Mn9WSdZr0G5kyFcguxOFUWExYSFD1zWKDtuJKD/EMQ9NdtDXvffIQ2VNOa
	 XKTE7BnB16HpGaqYlmF4yawTymIkAYMK4seiaxBfO3o09ka6d+4hZjRTG3KDqp3C1g
	 pX+CswBOhiOWA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools,v2 3/3] conntrackd: update netns test to support IPv6
Date: Mon, 10 Nov 2025 21:29:56 +0100
Message-Id: <20251110202956.22523-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20251110202956.22523-1-pablo@netfilter.org>
References: <20251110202956.22523-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend test to support for IPv6:

- Add IPv6 address and route.
- Use inet instead of ip table for masquerading.
- Annotate the IPv6 multicast address for IPv6_address in
  conntrackd.conf files.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: new in this series.

 tests/conntrackd/netns/conntrackd-netns-test.sh | 10 ++++++++++
 tests/conntrackd/netns/conntrackd-nsr1.conf     |  1 +
 tests/conntrackd/netns/conntrackd-nsr2.conf     |  1 +
 tests/conntrackd/netns/ruleset-nsr1.nft         |  2 +-
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tests/conntrackd/netns/conntrackd-netns-test.sh b/tests/conntrackd/netns/conntrackd-netns-test.sh
index 6f165879040f..f6b11e26dcf7 100755
--- a/tests/conntrackd/netns/conntrackd-netns-test.sh
+++ b/tests/conntrackd/netns/conntrackd-netns-test.sh
@@ -17,24 +17,34 @@ start () {
 	ip link add veth2 netns nsr1 type veth peer name veth0 netns nsr2
 
 	ip -net ns1 addr add 192.168.10.2/24 dev veth0
+	ip -6 -net ns1 addr add bbbb::2/64 dev veth0
 	ip -net ns1 link set up dev veth0
 	ip -net ns1 ro add 10.0.1.0/24 via 192.168.10.1 dev veth0
+	ip -6 -net ns1 ro add aaaa::/64 via bbbb::1 dev veth0
 
 	ip -net nsr1 addr add 10.0.1.1/24 dev veth0
 	ip -net nsr1 addr add 192.168.10.1/24 dev veth1
+	ip -6 -net nsr1 addr add aaaa::1/64 dev veth0
+	ip -6 -net nsr1 addr add bbbb::1/64 dev veth1
 	ip -net nsr1 link set up dev veth0
 	ip -net nsr1 link set up dev veth1
 	ip -net nsr1 route add default via 192.168.10.2
+	ip -6 -net nsr1 route add default via bbbb::2
 	ip netns exec nsr1 sysctl net.ipv4.ip_forward=1
+	ip netns exec nsr1 sysctl net.ipv6.conf.all.forwarding=1
 
 	ip -net nsr1 addr add 192.168.100.2/24 dev veth2
+	ip -6 -net nsr1 addr add cccc::2/96 dev veth2
 	ip -net nsr1 link set up dev veth2
 	ip -net nsr2 addr add 192.168.100.3/24 dev veth0
+	ip -6 -net nsr2 addr add cccc::3/96 dev veth0
 	ip -net nsr2 link set up dev veth0
 
 	ip -net ns2 addr add 10.0.1.2/24 dev veth0
+	ip -6 -net ns2 addr add aaaa::2/64 dev veth0
 	ip -net ns2 link set up dev veth0
 	ip -net ns2 route add default via 10.0.1.1
+	ip -6 -net ns2 route add default via aaaa::1
 
 	echo 1 > /proc/sys/net/netfilter/nf_log_all_netns
 
diff --git a/tests/conntrackd/netns/conntrackd-nsr1.conf b/tests/conntrackd/netns/conntrackd-nsr1.conf
index c79eff5f6bab..d37e102e86d1 100644
--- a/tests/conntrackd/netns/conntrackd-nsr1.conf
+++ b/tests/conntrackd/netns/conntrackd-nsr1.conf
@@ -3,6 +3,7 @@ Sync {
 	}
 	Multicast {
 		IPv4_address 225.0.0.50
+		#IPv6_address ff08::123
 		Group 3780
 		IPv4_interface 192.168.100.2
 		Interface veth2
diff --git a/tests/conntrackd/netns/conntrackd-nsr2.conf b/tests/conntrackd/netns/conntrackd-nsr2.conf
index 65fa0d6a4a1a..aab60839750b 100644
--- a/tests/conntrackd/netns/conntrackd-nsr2.conf
+++ b/tests/conntrackd/netns/conntrackd-nsr2.conf
@@ -3,6 +3,7 @@ Sync {
 	}
 	Multicast {
 		IPv4_address 225.0.0.50
+		#IPv6_address ff08::123
 		Group 3780
 		IPv4_interface 192.168.100.3
 		Interface veth0
diff --git a/tests/conntrackd/netns/ruleset-nsr1.nft b/tests/conntrackd/netns/ruleset-nsr1.nft
index bd6f1b4df6dd..5ba6d6faa5fb 100644
--- a/tests/conntrackd/netns/ruleset-nsr1.nft
+++ b/tests/conntrackd/netns/ruleset-nsr1.nft
@@ -1,4 +1,4 @@
-table ip filter {
+table inet filter {
 	chain postrouting {
 		type nat hook postrouting priority srcnat; policy accept;
 		oif veth0 masquerade
-- 
2.30.2

