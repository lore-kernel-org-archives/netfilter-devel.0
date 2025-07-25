Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00982EFD86;
	Fri, 25 Jul 2025 17:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463071; cv=none; b=l0pI0wvBce08xlCtcW0SaojIjRJ8UeXbmJr44x1KRDXOtMaHRKIBYXydvFoPkrwShYB3KzU4EIRML3ohVocoYCwCBPb58QRHVGbwHHpZYef7foXPj1X1q6mVnjBKLZX0uMJNJuHL0YdTXUesj7uNeDuTvLQfNCGJncoTTCm9TFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463071; c=relaxed/simple;
	bh=saTvY1xNV9odBTdpzYotFCX6xkjzZJMxHYHlN0zSC0c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pcRTzVaojVgC3Ha3+n0jUEx/J+T5P3c7qQLDcXblDMXMZCOJUs+S+PIWwgf69mhQSxJzC7Ay1IathjDw2P7fNwzjSUqy8+F+OGrPPs1qCjZ/33EeQccVzXo71s9XfpuxP/8psm8hgSRWZFBDlikBsXXSYpAisKrJePd/sbIOU14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Iz7HYyd5; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=j9Ni0yOj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Iz7HYyd5";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="j9Ni0yOj"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id AB02A60287; Fri, 25 Jul 2025 19:04:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463068;
	bh=2nSk3/XWL9Gu8qwfao7/VodiDG0CLkG0nflCVUDCe8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iz7HYyd5th4k5q8L2d1veF/O1Z+4tsa6+ufkJNsgB98rzATftiavY+0hRkB4zNJKi
	 tmro32dYiqTJBb3cW8/rEJwLkmJqz0mgjdnCY3zHVyvO+jIVHfNMXE+6S9IU9J0TGk
	 F7faFeMuG/oBDOR/TnEN9DHWP7PvexhHMhQQBq0qNo1RlOUAe60H4PB7bghg//LX5a
	 CDA5IPXitviAxKz1huNPMM0BHw1jHvX6aJy3Zjo7ssyjZJ98XBMD5jpXzbQOly2kDN
	 cmCI8NRktsO/EaJuHPgBQDpcYleeCa6W1sZtDEP98S5GXd00xxwH1A998Pe8uIgii2
	 Lh//+slZvbs3g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2FD5860273;
	Fri, 25 Jul 2025 19:04:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463063;
	bh=2nSk3/XWL9Gu8qwfao7/VodiDG0CLkG0nflCVUDCe8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9Ni0yOjnVYi2l39HeXaD3KOzAYCR8CLFC5FIxsFUG9yW3uUysMMs4NbrEaGuzedO
	 kd/8i2/03Jw89/TnaVKUOOINYA4hbWnDh+FGiLKk0OpZIud2mYvRyyiCusTgff/mK2
	 LoJNkGfSlw7e7D4G6Z2nzEoM2/lncitpASjDM2CXRFu+V0pykS97YefWL0agGP8IG4
	 EcMYl+kSpf8J6TGyCnoYZqGJa68wgPNOCZMAxE/ZIMfLsXyubdlqv+aHeJqxTayrUK
	 P/I7PULhyWkQVPm7fAhIKNuukYKg7JD9c393ww9V5fXMECiyvqf8+gLfI92hoivhcT
	 R3ENoArPavZYg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 19/19] selftests: netfilter: ipvs.sh: Explicity disable rp_filter on interface tunl0
Date: Fri, 25 Jul 2025 19:03:40 +0200
Message-Id: <20250725170340.21327-20-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yi Chen <yiche@redhat.com>

Although setup_ns() set net.ipv4.conf.default.rp_filter=0,
loading certain module such as ipip will automatically create a tunl0 interface
in all netns including new created ones. In the script, this is before than
default.rp_filter=0 applied, as a result tunl0.rp_filter remains set to 1
which causes the test report FAIL when ipip module is preloaded.

Before fix:
Testing DR mode...
Testing NAT mode...
Testing Tunnel mode...
ipvs.sh: FAIL

After fix:
Testing DR mode...
Testing NAT mode...
Testing Tunnel mode...
ipvs.sh: PASS

Fixes: 7c8b89ec506e ("selftests: netfilter: remove rp_filter configuration")
Signed-off-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/netfilter/ipvs.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/ipvs.sh b/tools/testing/selftests/net/netfilter/ipvs.sh
index 6af2ea3ad6b8..9c9d5b38ab71 100755
--- a/tools/testing/selftests/net/netfilter/ipvs.sh
+++ b/tools/testing/selftests/net/netfilter/ipvs.sh
@@ -151,7 +151,7 @@ test_nat() {
 test_tun() {
 	ip netns exec "${ns0}" ip route add "${vip_v4}" via "${gip_v4}" dev br0
 
-	ip netns exec "${ns1}" modprobe -q ipip
+	modprobe -q ipip
 	ip netns exec "${ns1}" ip link set tunl0 up
 	ip netns exec "${ns1}" sysctl -qw net.ipv4.ip_forward=0
 	ip netns exec "${ns1}" sysctl -qw net.ipv4.conf.all.send_redirects=0
@@ -160,10 +160,10 @@ test_tun() {
 	ip netns exec "${ns1}" ipvsadm -a -i -t "${vip_v4}:${port}" -r ${rip_v4}:${port}
 	ip netns exec "${ns1}" ip addr add ${vip_v4}/32 dev lo:1
 
-	ip netns exec "${ns2}" modprobe -q ipip
 	ip netns exec "${ns2}" ip link set tunl0 up
 	ip netns exec "${ns2}" sysctl -qw net.ipv4.conf.all.arp_ignore=1
 	ip netns exec "${ns2}" sysctl -qw net.ipv4.conf.all.arp_announce=2
+	ip netns exec "${ns2}" sysctl -qw net.ipv4.conf.tunl0.rp_filter=0
 	ip netns exec "${ns2}" ip addr add "${vip_v4}/32" dev lo:1
 
 	test_service
-- 
2.30.2

