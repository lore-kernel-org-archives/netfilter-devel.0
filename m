Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116E726AD9
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2025 12:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750596974; cv=none; b=cQel/ckZRBja4CD1SwRRPmte9b1TywERn5u244bNnHh+8nUyGYTQyK0I0GWAARp0FrbHoqlCeINm6rUmjV0GGvApO4vJfM2UEbcei8et1AVwQK3DrqhGvaoxXp5+s32cXsnQdWuC7SUvXQZzwieNb/ePk3G7j2+56kcBgggUAb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750596974; c=relaxed/simple;
	bh=HVdmzDMknbvAsc8QTWQIV32+voJyLRS2uGkuJLO7TfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b47949732y3BLiS7Cb25kNxjy4oYtev+UZoDW3gSKk/B505nB/ZDJ2jEOwQBD8BBqAUp03S/mfacP2/S6vXG0mDYgjegwdFO2h4LSiPkPxHOWnYYNUinRpJgk9QWq9ytl/vC+/JSKdGYNh7OhqSlV/OfKSjN8yAgkePJM2U5bwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PEK14nxB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PEK14nxB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750596970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qsVa1etaVGdKltqX4pCbQOJza6EH/KxbwTi3fC2zigQ=;
	b=PEK14nxBezdORdPoue9utg6DzZvy9/A7pqRXmC6dQMqlV/dLAuDsFN9ZrJswlo51k30+IJ
	/A//2sAoITSnU5Cy9vbPCHqPV0iWZzyuK5WsiTNklFkpRnbEOgN3Qr7Z705YrgUqNH1fnc
	JplOibFUs3ZqkeE/v5XSEOg3prc0eq4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-410-AamCfS_wNAedhEfCC0rXaw-1; Sun,
 22 Jun 2025 08:56:08 -0400
X-MC-Unique: AamCfS_wNAedhEfCC0rXaw-1
X-Mimecast-MFC-AGG-ID: AamCfS_wNAedhEfCC0rXaw_1750596967
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0BD11956087;
	Sun, 22 Jun 2025 12:56:07 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.116.39])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E0B75180035C;
	Sun, 22 Jun 2025 12:56:05 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 4/4] test: shell: Add rate_limit test case for 'limit statement'.
Date: Sun, 22 Jun 2025 20:55:54 +0800
Message-ID: <20250622125554.4960-4-yiche@redhat.com>
In-Reply-To: <20250622125554.4960-3-yiche@redhat.com>
References: <20250622125554.4960-1-yiche@redhat.com>
 <20250622125554.4960-2-yiche@redhat.com>
 <20250622125554.4960-3-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 .../packetpath/dumps/rate_limit.nodump        |   0
 tests/shell/testcases/packetpath/rate_limit   | 136 ++++++++++++++++++
 2 files changed, 136 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/rate_limit.nodump
 create mode 100755 tests/shell/testcases/packetpath/rate_limit

diff --git a/tests/shell/testcases/packetpath/dumps/rate_limit.nodump b/tests/shell/testcases/packetpath/dumps/rate_limit.nodump
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/shell/testcases/packetpath/rate_limit b/tests/shell/testcases/packetpath/rate_limit
new file mode 100755
index 00000000..10cb8f42
--- /dev/null
+++ b/tests/shell/testcases/packetpath/rate_limit
@@ -0,0 +1,136 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+
+. $NFT_TEST_LIBRARY_FILE
+
+cleanup()
+{
+	for i in $C $S;do
+		kill $(ip netns pid $i) 2>/dev/null
+		ip netns del $i
+	done
+}
+trap cleanup EXIT
+
+rnd=$(mktemp -u XXXXXXXX)
+C="ratelimit-client-$rnd"
+S="ratelimit-server-$rnd"
+
+ip_sc=10.167.1.1
+ip_cs=10.167.1.2
+ip1_cs=10.167.1.3
+
+ip netns add $S
+ip netns add $C
+
+ip link add s_c netns $S type veth peer name c_s netns $C
+ip -net $S link set s_c up
+ip -net $C link set c_s up
+ip -net $S link set lo up
+ip -net $C link set lo up
+ip -net $S addr add ${ip_sc}/24  dev s_c
+ip -net $C addr add ${ip_cs}/24  dev c_s
+ip -net $C addr add ${ip1_cs}/24 dev c_s
+ip netns exec $C ping ${ip_sc} -c1
+assert_pass "topo initialization"
+
+ip netns exec $S $NFT -f - <<EOF
+table ip filter {
+	set icmp1 {
+		type ipv4_addr
+		size 65535
+		flags dynamic,timeout
+	}
+
+	set http1 {
+		type inet_service . ipv4_addr
+		size 65535
+		flags dynamic
+	}
+
+	chain input {
+		type filter hook input priority filter; policy accept;
+		ip protocol icmp counter jump in_icmp
+		ip protocol tcp  counter jump in_tcp
+	}
+	chain in_tcp {
+		iifname "s_c" tcp dport 80 ct state new add @http1 { tcp dport . ip saddr limit rate over 1/minute burst 5 packets } counter reject
+		iifname "s_c" tcp dport 80 counter accept
+	}
+
+	chain in_icmp {
+		iifname "s_c" ip protocol icmp counter update @icmp1 { ip saddr timeout 3s limit rate 1/second burst 5 packets } counter accept
+		iifname "s_c" ip protocol icmp counter reject
+	}
+
+}
+EOF
+assert_pass "Apply ruleset"
+
+# icmp test
+ip netns exec $C ping -W 1 ${ip_sc} -c 5 -f -I ${ip_cs} | grep -q '5 received'
+assert_pass "saddr1, burst 5 accept"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 5 -f -I ${ip1_cs} | grep -q '5 received'
+assert_pass "saddr2, burst 5 accept"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 1 -f -I ${ip_cs} | grep -q '1 received'
+assert_fail "saddr1, burst 5 up to limit, reject"
+
+sleep 3
+ip netns exec $C ping -W 1 ${ip_sc} -c 5 -f -I ${ip_cs} | grep -q '5 received'
+assert_pass "saddr1, element timeout,burst 5 pass again"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 1 -f -I ${ip_cs} | grep -q '1 received'
+assert_fail "saddr1, burst 5 up to limit"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 6 -i 1 -I ${ip1_cs} | grep -q '6 received'
+assert_pass "saddr2, 6s test, limit rate 1/second accept"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 4 -f -I ${ip1_cs} | grep -q '4 received'
+assert_pass "saddr2, burst 4 accept"
+
+sleep 2
+ip netns exec $C ping -W 1 ${ip_sc} -c 2 -f -I ${ip1_cs} | grep -q '2 received'
+assert_pass "saddr2, burst 2 sleep 2, accept"
+
+sleep 2
+ip netns exec $C ping -W 1 ${ip_sc} -c 2 -f -I ${ip1_cs} | grep -q '2 received'
+assert_pass "saddr2, burst 2 sleep 2, accept"
+
+ip netns exec $C ping -W 1 ${ip_sc} -c 1 -f -I ${ip1_cs} | grep -q '1 received'
+assert_fail "saddr2, limit rate 1/second up to limit, reject"
+
+
+# tcp test
+ip netns exec $S socat TCP-LISTEN:80,reuseaddr,fork - > /dev/null &
+wait_local_port_listen $S 80 tcp
+
+for port in {1..5};do
+	ip netns exec $C socat -u - TCP:${ip_sc}:80,connect-timeout=1 <<< 'AAA'
+	assert_pass "tcp connection burst 5 accept"
+done
+ip netns exec $C socat -u - TCP:${ip_sc}:80,reuseport,connect-timeout=1 <<< 'AAA'
+assert_fail "tcp connection burst 5 up to limit reject"
+
+ip netns exec $S $NFT flush chain filter in_tcp
+assert_pass result "flush chain"
+
+ip netns exec $S $NFT flush set filter http1
+assert_pass result "flush set"
+
+ip netns exec $S $NFT add rule filter in_tcp iifname s_c tcp dport 80 ct state new add @http1 { tcp dport . ip saddr limit rate over 1/second burst 1 packets} counter reject
+assert_pass result "add rule limit rate over 1/second burst 1"
+ip netns exec $S $NFT add rule filter in_tcp iifname s_c tcp dport 80 counter accept
+
+sleep 1
+ip netns exec $C socat -u - TCP:${ip_sc}:80,reuseport,connect-timeout=1 <<< 'AAA'
+assert_pass result "tcp connection limit rate 1/sec burst 1 accept"
+
+ip netns exec $C socat -u - TCP:${ip_sc}:80,reuseport,connect-timeout=1 <<< 'AAA'
+assert_fail result "tcp connection limit rate 1/sec burst 1 reject"
+
+sleep 1
+ip netns exec $C socat -u - TCP:${ip_sc}:80,reuseport,connect-timeout=1 <<< 'AAA'
+assert_pass result "tcp connection limit rate 1/sec burst 1 accept"
-- 
2.49.0

