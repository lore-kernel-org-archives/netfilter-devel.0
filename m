Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A3F35F8AA
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769552966; cv=none; b=YSG+J5JQGjZj1UmEIRX2Jt7qpg+KCXxOw6pgrUTi06x1OvWaijbSA7dbzqcIf5G/HkgClMYLBROWxDK7Iuh28hxd7GtmM2KVk5iUzjEpNK89Qz4Gs0lbZIoVYkL7aK1fvjJd5IobIMwytD/KCns3NLc/sLfzE0KMHtdG0uxZ5Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769552966; c=relaxed/simple;
	bh=hEZfB0eMK62WqCECgpVGy+kUL6wFaojjRZruurneuH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIDslcsjKUunhBlXEJQG7sMW9eQy05+iTA5nKHSs+AzZYZyoTqWDtowk2jdKYY8b+qP7ku2Fngwf3sUQ1mK6F3OyuwO6jKMa5BgGtgJK8W6oc/eUy4K5gghv0BWS/61heMJ5t0vj0ZnuhB2kx86MMU8h22g89RzjGrfzIZcbfvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=IiVvKkw1; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="IiVvKkw1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vy9HwoabaTUxu2Jl5dog95U5Tuj808ysoz1zVG94wSI=; b=IiVvKkw1xZz/r54S8m3rniT7eS
	K5gOme910lRy7p/7RCYPQUNyn97zk6dCaVoF9fJs47+L3NfIaoduLCfaQDInZVHsJZIVDFwG1kpEE
	wnztaUdcGP9qP/ZewXmWnrrgvLbNRqxwtCdiOLtGPrAl+4iehddgoIMdibx5k/Lv8rW2sVN2DOMDp
	Bkandmc3XUUTWpzADNzepYbEk/2/Z8yZDP2i9xUL4O1u7gFXlbocgLfxBzSVHZdA4QOfhqEiGKHpq
	z7IYoeatVL+muKqvNcUr8TmD46JEQ87Wmx91AFYqh2VxFosuiThqwrt3Mh57KN79AmzfwZO7viBas
	e8d5Pqjw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vkrYo-000000002lh-49OU;
	Tue, 27 Jan 2026 23:29:23 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/4] tests: shell: Add a basic test for src/xt.c
Date: Tue, 27 Jan 2026 23:29:16 +0100
Message-ID: <20260127222916.31806-5-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127222916.31806-1-phil@nwl.cc>
References: <20260127222916.31806-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The feature test introduced in this patch checks iptables-nft presence
and usability as well as translation support presence in nft (as it may
not be compiled in).

The actual test case will optionally call ip6tables-nft and ebtables-nft
as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/features/xtables_xlate.sh      |  21 ++++
 tests/shell/testcases/parsing/compat_xlate | 135 +++++++++++++++++++++
 2 files changed, 156 insertions(+)
 create mode 100755 tests/shell/features/xtables_xlate.sh
 create mode 100755 tests/shell/testcases/parsing/compat_xlate

diff --git a/tests/shell/features/xtables_xlate.sh b/tests/shell/features/xtables_xlate.sh
new file mode 100755
index 0000000000000..9c1f7d84c7640
--- /dev/null
+++ b/tests/shell/features/xtables_xlate.sh
@@ -0,0 +1,21 @@
+#!/bin/bash
+
+# Does nft support translating compat extensions using libxtables?
+# Answer a related question first: Do we have a usable iptables-nft available?
+
+iptables-nft --version | grep -q nf_tables || {
+	echo "iptables-nft not available or not nft-variant"
+	exit 1
+}
+
+ns=$(mktemp -u ns-XXXXXX)
+trap "ip netns del $ns" EXIT
+ip netns add $ns || exit 1
+
+ext_arg="-m comment --comment foobar"
+ip netns exec $ns iptables-nft -vv -A FORWARD $ext_arg | \
+		grep -q "match name comment" || {
+	echo "comment match does not use compat extension?!"
+	exit 1
+}
+ip netns exec $ns $NFT list chain ip filter FORWARD 2>/dev/null | grep -q "foobar"
diff --git a/tests/shell/testcases/parsing/compat_xlate b/tests/shell/testcases/parsing/compat_xlate
new file mode 100755
index 0000000000000..bc774311ffdc2
--- /dev/null
+++ b/tests/shell/testcases/parsing/compat_xlate
@@ -0,0 +1,135 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_xtables_xlate)
+
+set -e
+
+IPTABLES_RULESET='*filter
+-A FORWARD -m comment --comment "this is a comment"
+-A FORWARD -m iprange --src-range 10.0.0.1-10.0.0.23 --dst-range 10.1.0.5-10.2.0.1
+-A FORWARD -p tcp -j TCPMSS --clamp-mss-to-pmtu
+-A FORWARD -p udp --dport 1
+-A FORWARD -p sctp --dport 3
+-A FORWARD -p dccp --dport 4
+-A FORWARD -p esp
+-A FORWARD -p ah
+COMMIT'
+IPTABLES_EXPECT='# Warning: table ip filter is managed by iptables-nft, do not touch!
+table ip filter {
+	chain FORWARD {
+		type filter hook forward priority filter; policy accept;
+		comment "this is a comment" counter packets 0 bytes 0
+		ip saddr 10.0.0.1-10.0.0.23 ip daddr 10.1.0.5-10.2.0.1 counter packets 0 bytes 0
+		ip protocol tcp counter packets 0 bytes 0 tcp option maxseg size set rt mtu
+		udp dport 1 counter packets 0 bytes 0
+		ip protocol sctp sctp dport 3 counter packets 0 bytes 0
+		ip protocol dccp dccp dport 4 counter packets 0 bytes 0
+		ip protocol esp counter packets 0 bytes 0
+		ip protocol ah counter packets 0 bytes 0
+	}
+}'
+
+IP6TABLES_RULESET='*filter
+-A FORWARD -m comment --comment "this is a comment"
+-A FORWARD -m iprange --src-range fec0::1-fec0::23 --dst-range fec0:1::5-fec0:2::1
+-A FORWARD -p tcp -j TCPMSS --clamp-mss-to-pmtu
+COMMIT'
+IP6TABLES_EXPECT='
+# Warning: table ip6 filter is managed by iptables-nft, do not touch!
+table ip6 filter {
+	chain FORWARD {
+		type filter hook forward priority filter; policy accept;
+		comment "this is a comment" counter packets 0 bytes 0
+		ip6 saddr fec0::1-fec0::23 ip6 daddr fec0:1::5-fec0:2::1 counter packets 0 bytes 0
+		meta l4proto tcp counter packets 0 bytes 0 tcp option maxseg size set rt mtu
+	}
+}'
+
+ARPTABLES_RULESET='*filter
+-A INPUT -s 10.0.0.0/8 -j ACCEPT
+-A INPUT -d 192.168.123.1 -j ACCEPT
+-A INPUT --source-mac fe:ed:ba:be:00:01 -j ACCEPT
+-A INPUT --destination-mac fe:ed:ba:be:00:01 -j ACCEPT
+-N foo
+-A foo -i lo -j ACCEPT
+-A foo -l 6 -j ACCEPT
+-A foo -j MARK --set-mark 12345
+-A foo --opcode Request -j ACCEPT
+-A foo --h-type 1 --proto-type 0x800 -j ACCEPT
+-A foo -l 6 --h-type 1 --proto-type 0x800 -i lo --opcode Request -j ACCEPT
+-A INPUT -j foo
+-A INPUT
+-A OUTPUT -o lo -j ACCEPT
+-A OUTPUT -o eth134 -j mangle --mangle-ip-s 10.0.0.1
+-A OUTPUT -o eth432 -j CLASSIFY --set-class feed:babe
+-A OUTPUT -o eth432 --opcode Request -j CLASSIFY --set-class feed:babe
+-P OUTPUT DROP
+COMMIT'
+ARPTABLES_EXPECT='
+# Warning: table arp filter is managed by iptables-nft, do not touch!
+table arp filter {
+	chain INPUT {
+		type filter hook input priority filter; policy accept;
+		arp htype 1 arp hlen 6 arp plen 4 arp saddr ip 10.0.0.0/8 counter packets 0 bytes 0 accept
+		arp htype 1 arp hlen 6 arp plen 4 arp daddr ip 192.168.123.1 counter packets 0 bytes 0 accept
+		arp htype 1 arp hlen 6 arp plen 4 arp saddr ether fe:ed:ba:be:00:01 counter packets 0 bytes 0 accept
+		arp htype 1 arp hlen 6 arp plen 4 arp daddr ether fe:ed:ba:be:00:01 counter packets 0 bytes 0 accept
+		arp htype 1 arp hlen 6 arp plen 4 counter packets 0 bytes 0 jump foo
+		arp htype 1 arp hlen 6 arp plen 4 counter packets 0 bytes 0
+	}
+
+	chain foo {
+		iifname "lo" arp htype 1 arp hlen 6 arp plen 4 counter packets 0 bytes 0 accept
+		arp htype 1 arp hlen 6 arp plen 4 counter packets 0 bytes 0 accept
+		arp htype 1 arp hlen 6 arp plen 4 counter packets 0 bytes 0 meta mark set 0x12345
+		arp htype 1 arp hlen 6 arp plen 4 arp operation request counter packets 0 bytes 0 accept
+		arp htype 1 arp ptype ip arp hlen 6 arp plen 4 counter packets 0 bytes 0 accept
+		iifname "lo" arp htype 1 arp ptype ip arp hlen 6 arp plen 4 arp operation request counter packets 0 bytes 0 accept
+	}
+
+	chain OUTPUT {
+		type filter hook output priority filter; policy drop;
+		oifname "lo" arp htype 1 arp hlen 6 arp plen 4 counter packets 0 bytes 0 accept
+		oifname "eth134" arp htype 1 arp hlen 6 arp plen 4 counter packets 0 bytes 0 arp saddr ip set 10.0.0.1 accept
+		oifname "eth432" arp htype 1 arp hlen 6 arp plen 4 counter packets 0 bytes 0 meta priority set feed:babe
+		oifname "eth432" arp htype 1 arp hlen 6 arp plen 4 arp operation request counter packets 0 bytes 0 meta priority set feed:babe
+	}
+}'
+
+EBTABLES_RULESET='*filter
+-A FORWARD -p IPv4 -j mark --mark-set 1
+-A FORWARD -p IPv6 -j mark --mark-set 2
+COMMIT'
+EBTABLES_EXPECT='
+# Warning: table bridge filter is managed by iptables-nft, do not touch!
+table bridge filter {
+	chain FORWARD {
+		type filter hook forward priority filter; policy accept;
+		ether type ip counter packets 0 bytes 0 meta mark set 0x1 accept
+		ether type ip6 counter packets 0 bytes 0 meta mark set 0x2 accept
+	}
+}'
+
+iptables-nft-restore <<< "$IPTABLES_RULESET"
+EXPECT="$IPTABLES_EXPECT"
+
+if ip6tables-nft --version | grep -q 'nf_tables'; then
+	echo "testing ip6tables, too"
+	ip6tables-nft-restore <<< "$IP6TABLES_RULESET"
+	EXPECT+="$IP6TABLES_EXPECT"
+fi
+if arptables-nft --version | grep -q 'nf_tables'; then
+	echo "testing arptables, too"
+	arptables-nft-restore <<< "$ARPTABLES_RULESET"
+	EXPECT+="$ARPTABLES_EXPECT"
+fi
+if ebtables-nft --version | grep -q 'nf_tables'; then
+	echo "testing ebtables, too"
+	ebtables-nft-restore <<< "$EBTABLES_RULESET"
+	EXPECT+="$EBTABLES_EXPECT"
+fi
+
+$DIFF -u <(echo "$EXPECT") <($NFT list ruleset 2>&1)
+
+# avoid attempts at replaying the ruleset
+$NFT flush ruleset
-- 
2.51.0

