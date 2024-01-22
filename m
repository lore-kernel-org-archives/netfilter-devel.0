Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D886454F88
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jan 2024 16:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705940813; cv=none; b=Iiri8d9asR5U/UMGPHTBIbQ9Bs78aGrHp/aLeBLnv3Id5yDUt0GZBFsIgx4oEgFjHGrqOPHNFefXh8pHtogiNmbZiV47w1fS8mXAQeYlLXBUNm6acNuz+zGRnyE9fkpmaKw7NvVZT3zaqjBtj9U/afqPGumWoaUfyqyJzNm+1cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705940813; c=relaxed/simple;
	bh=S23Tt8lHyMqXvlhEPBHM37V0UKxYXzIgKejWLA1wtHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aiZ5N/oxlT2YyEJznHYyfmA11JiIOXQ69Qc/anR4NMRuQIg+r49bzuc5hObWQM14iDrWXEa1jr8k/H3dJZSn4ugVgVpesKWATiigt2csHWS/Jp4EEatmTHd2fzxJmqmzE5qehy7n8Zd6KRBmQyvgMB4XGeebHN6gZLaoZKLaLDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T3W1r+Vv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T3W1r+Vv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705940810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mP3PClk3Wc0WBB7LpRk+hDu6qYm7lcrjakd9rWwlLxw=;
	b=T3W1r+VvQyIidheQMpH/3+jz6wZjYPW6Lj7Y6sh/YYBupVHg7YPSBN796hxucA+5B+rC3N
	quE/+6xH8Xc5gjlmGubneETL503pUeZc7MeO8NNV0h+d/dEMH+S2GgsEz3UKy2eXlKisyV
	lJa1fnlw6O03ieLB4xybJMcFiZvqBe8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-ztwcF0SyNx6LCWP9_0ie6Q-1; Mon, 22 Jan 2024 11:26:46 -0500
X-MC-Unique: ztwcF0SyNx6LCWP9_0ie6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 097BD185A781;
	Mon, 22 Jan 2024 16:26:45 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.112.24])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 133171C060B1;
	Mon, 22 Jan 2024 16:26:42 +0000 (UTC)
From: yiche@redhat.com
To: netfilter-devel@vger.kernel.org
Cc: fw@netfilter.org,
	Yi Chen <yiche@redhat.com>
Subject: [PATCH] tests: shell: add test to cover ct offload by using nft flowtables To cover kernel patch ("netfilter: nf_tables: set transport offset from mac header for netdev/egress").
Date: Tue, 23 Jan 2024 00:26:40 +0800
Message-ID: <20240122162640.6374-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Yi Chen <yiche@redhat.com>

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 tests/shell/testcases/packetpath/flowtables | 96 +++++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100755 tests/shell/testcases/packetpath/flowtables

diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
new file mode 100755
index 00000000..852a05c6
--- /dev/null
+++ b/tests/shell/testcases/packetpath/flowtables
@@ -0,0 +1,96 @@
+#! /bin/bash -x
+
+# NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
+
+rnd=$(mktemp -u XXXXXXXX)
+R="flowtable-router-$rnd"
+C="flowtable-client-$rnd"
+S="flowtbale-server-$rnd"
+
+cleanup()
+{
+	for i in $R $C $S;do
+		kill $(ip netns pid $i) 2>/dev/null
+		ip netns del $i
+	done
+}
+
+trap cleanup EXIT
+
+ip netns add $R
+ip netns add $S
+ip netns add $C
+
+ip link add s_r netns $S type veth peer name r_s netns $R
+ip netns exec $S ip link set s_r up
+ip netns exec $R ip link set r_s up
+ip link add c_r netns $C type veth peer name r_c netns $R
+ip netns exec $R ip link set r_c up
+ip netns exec $C ip link set c_r up
+
+ip netns exec $S ip -6 addr add 2001:db8:ffff:22::1/64 dev s_r
+ip netns exec $C ip -6 addr add 2001:db8:ffff:21::2/64 dev c_r
+ip netns exec $R ip -6 addr add 2001:db8:ffff:22::fffe/64 dev r_s
+ip netns exec $R ip -6 addr add 2001:db8:ffff:21::fffe/64 dev r_c
+ip netns exec $R sysctl -w net.ipv6.conf.all.forwarding=1
+ip netns exec $C ip route add 2001:db8:ffff:22::/64 via 2001:db8:ffff:21::fffe dev c_r
+ip netns exec $S ip route add 2001:db8:ffff:21::/64 via 2001:db8:ffff:22::fffe dev s_r
+ip netns exec $S ethtool -K s_r tso off
+ip netns exec $C ethtool -K c_r tso off
+
+sleep 3
+ip netns exec $C ping -6 2001:db8:ffff:22::1 -c1 || exit 1
+
+ip netns exec $R nft -f - <<EOF
+table ip6 filter {
+        flowtable f1 {
+                hook ingress priority -100
+                devices = { r_c, r_s }
+        }
+
+        chain forward {
+                type filter hook forward priority filter; policy accept;
+                ip6 nexthdr tcp ct state established,related counter packets 0 bytes 0 flow add @f1 counter packets 0 bytes 0
+                ip6 nexthdr tcp ct state invalid counter packets 0 bytes 0 drop
+                tcp flags fin,rst counter packets 0 bytes 0 accept
+                meta l4proto tcp meta length < 100 counter packets 0 bytes 0 accept
+                ip6 nexthdr tcp counter packets 0 bytes 0 log drop
+        }
+}
+EOF
+
+if [ ! -r /proc/net/nf_conntrack ]
+then
+	echo "E: nf_conntrack unreadable, skipping" >&2	
+	exit 77
+fi
+
+ip netns exec $R nft list ruleset
+ip netns exec $R sysctl -w net.netfilter.nf_flowtable_tcp_timeout=5 || {
+	echo "E: set net.netfilter.nf_flowtable_tcp_timeout fail, skipping" >&2
+        exit 77
+}
+ip netns exec $R sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=86400 || {
+        echo "E: set net.netfilter.nf_conntrack_tcp_timeout_established fail, skipping" >&2
+        exit 77
+
+}
+
+# A trick to control the timing to send a packet
+ip netns exec $S socat TCP6-LISTEN:10001 GOPEN:pipefile,ignoreeof &
+sleep 1
+ip netns exec $C socat -b 2048 PIPE:pipefile TCP:[2001:db8:ffff:22::1]:10001 &
+sleep 1
+ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "check [OFFLOAD] tag (failed)"; exit 1; }
+ip netns exec $R cat /proc/net/nf_conntrack
+sleep 6
+ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   && { echo "CT OFFLOAD timeout, fail back to classical path (failed)"; exit 1; }
+ip netns exec $R grep '8639[0-9]' /proc/net/nf_conntrack || { echo "check nf_conntrack_tcp_timeout_established (failed)"; exit 1; }
+ip netns exec $C echo "send sth" >> pipefile
+ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "traffic seen, back to OFFLOAD path (failed)"; exit 1; }
+ip netns exec $C sleep 3
+ip netns exec $C echo "send sth" >> pipefile
+ip netns exec $C sleep 3
+ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "Traffic seen in 5s (nf_flowtable_tcp_timeout), so stay in OFFLOAD (failed)"; exit 1; }
+
+exit 0
-- 
2.43.0

