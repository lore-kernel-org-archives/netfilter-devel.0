Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE012147E3
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Jun 2025 10:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750156898; cv=none; b=XfwIdow891H+4QgAWs39VnUea/rDlbqE483PGZcPXyF1wvG3s8b/qosd6rcKnS8x1TpT7ulsF3g23THJeyOw+jfOmW8LN/mnyIgLRg99S1c2FSvTJkbj0ixwN+KBF8N+eK2kDpaCqNJlY6CJw3PY4GP2IT3SZBVo9FRyYY8TgDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750156898; c=relaxed/simple;
	bh=PcDyVnGO3msk4Velz8J4LmxqXo/dxqG110iVO0auaAc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XREzgwJDdy5tRPy3YHJHh8qaTP/Lp6GW7WSpwoXuDro1rXYfkSI+8U6YC9PPPdhhqom0HEdUYk31kOWsetL6bwgx1yTAADK23JYR44IeCAb3Y8PBGETo1DFcMrJlGuyu+CSQ+dThu6z9jlBfBsbyacA5TFIRADU4VErsvl3939o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a2Nw11sW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a2Nw11sW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750156895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mHFjoybK4MX1uVCmbNn4U7fiX4el2OsdSYxnn9p3cP8=;
	b=a2Nw11sWReG+alWaUzo2TJpC0AeTSA4WlIKgYvXgxh5m633+oHWBiufhUM0y0pHBrK+9o9
	OgfLG4wQxZsDGKS+wRA3yuQUNpNJevnAD4kqOzbUXA5S8wirE2E9f11L7hwG1LFysjzOP7
	zrV1FkghTTOK45AT+Ei+QVqP82c5hIo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-ktrrVPT8OTyqxUXTSNYGaw-1; Tue,
 17 Jun 2025 06:41:34 -0400
X-MC-Unique: ktrrVPT8OTyqxUXTSNYGaw-1
X-Mimecast-MFC-AGG-ID: ktrrVPT8OTyqxUXTSNYGaw_1750156893
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02810180136B;
	Tue, 17 Jun 2025 10:41:33 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.116.40])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 43B0D1956094;
	Tue, 17 Jun 2025 10:41:30 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH] tests: shell: Add a test case to verify the limit statement.
Date: Tue, 17 Jun 2025 18:41:28 +0800
Message-ID: <20250617104128.27188-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 tests/shell/features/ncat.sh                |   4 +
 tests/shell/testcases/packetpath/rate_limit | 154 ++++++++++++++++++++
 2 files changed, 158 insertions(+)
 create mode 100755 tests/shell/features/ncat.sh
 create mode 100755 tests/shell/testcases/packetpath/rate_limit

diff --git a/tests/shell/features/ncat.sh b/tests/shell/features/ncat.sh
new file mode 100755
index 00000000..eb1581ce
--- /dev/null
+++ b/tests/shell/features/ncat.sh
@@ -0,0 +1,4 @@
+#!/bin/sh
+
+# check whether ncat is installed
+ncat -h >/dev/null 2>&1
diff --git a/tests/shell/testcases/packetpath/rate_limit b/tests/shell/testcases/packetpath/rate_limit
new file mode 100755
index 00000000..d7556edc
--- /dev/null
+++ b/tests/shell/testcases/packetpath/rate_limit
@@ -0,0 +1,154 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_ncat)
+
+cleanup()
+{
+	for i in $C $S;do
+		kill $(ip netns pid $i) 2>/dev/null
+		ip netns del $i
+	done
+	rm -rf $WORKDIR
+}
+trap cleanup EXIT
+
+assert_pass()
+{
+	local ret=$?
+	if [ $ret != 0 ]; then
+		echo "FAIL: ${@}"
+		exit 1
+	else
+		echo "PASS: ${@}"
+	fi
+}
+assert_fail()
+{
+	local ret=$?
+	if [ $ret == 0 ]; then
+		echo "FAIL: ${@}"
+		exit 1
+	else
+		echo "PASS: ${@}"
+	fi
+}
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
+ip netns exec $S nft -f - <<EOF
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
+ip netns exec $S ncat -lk 80 > /dev/null & sleep 1
+for port in `seq 10000 10004`;do
+        ip netns exec $C ncat ${ip_sc} 80 -p $port -w 1 <<< 'AAA'
+        assert_pass "tcp connection burst 5 accept"
+done
+ip netns exec $C ncat ${ip_sc} 80 -p $port -w 1 <<< 'AAA'
+assert_fail "tcp connection burst 5 up to limit reject"
+
+ip netns exec $S nft flush chain filter in_tcp
+assert_pass result "flush chain"
+
+ip netns exec $S nft flush set filter http1
+assert_pass result "flush set"
+
+ip netns exec $S nft add rule filter in_tcp iifname s_c tcp dport 80 ct state new add @http1 { tcp dport . ip saddr limit rate over 1/second burst 1 packets} counter reject
+assert_pass result "add rule limit rate over 1/second burst 1"
+ip netns exec $S nft add rule filter in_tcp iifname s_c tcp dport 80 counter accept
+
+sleep 1
+ip netns exec $C ncat ${ip_sc} 80 -p 10000 -w 1 <<< 'AAA'
+assert_pass result "tcp connection limit rate 1/sec burst 1 accept"
+
+ip netns exec $C ncat ${ip_sc} 80 -p 10001 -w 1 <<< 'AAA'
+assert_fail result "tcp connection limit rate 1/sec burst 1 reject"
+
+sleep 1
+ip netns exec $C ncat ${ip_sc} 80 -p 10002 -w 1 <<< 'AAA'
+assert_pass result "tcp connection limit rate 1/sec burst 1 accept"
-- 
2.49.0

