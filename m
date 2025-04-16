Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B4F1DED77
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Apr 2025 15:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744818812; cv=none; b=Bb7oLT6YpVb94vmDhTw9wGmtSNyIrZDupD6CAMeUY7q3rl4sqhMpuY2OqApIqN0tO6WUpFNGJs/fp8JIzEdCA9CwhqXqEIGCnBz/LlB/WbY0DleALvx/ac355jg5VGoxKQ9pmKiD2IdnZn4obBHMF1qNBIWDGTRaHdPr0PA8Yc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744818812; c=relaxed/simple;
	bh=UEZx/l4ZzU95JhsSIcNTUKgjjg+USykIIj/3wAMm9i4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PWjcSd23pBIwt6+2Y2fLzCb2uGkXXoPXuVFpQevwm32wiEeC9niA5r7GB9w+zrqLZUgrlRIR8+TlDD+hbk60j5R66EETd/kc5BoeJKA1VF8/bssTTvsoMfpSYPzLjlJsh5OeGmpm1grj5yT+dG2Cnu8A/hPxI8umo6A/ZFUwnhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N6NafiTO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N6NafiTO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744818809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5wAEIksNTMhftEI9ksYATaXuBQvBfVXYVSLa7gcAGIc=;
	b=N6NafiTOurrZXjZYkc8EWSWy9RPO41FUVeXvDS4PFNaArWsObu2d2DTsztrxOuDqcV27yS
	4rvPM/8tDO1l//rNii2YOsrCYmXC285K1+mSxWKA1wblLeXrLdIri0NIdXY4AjgaFrKCcn
	LzFv+H8mCxJ+PKH1N+l/21Jp55XN1ns=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-393-CPCqf0RINqKtm-qXrethUQ-1; Wed,
 16 Apr 2025 11:53:26 -0400
X-MC-Unique: CPCqf0RINqKtm-qXrethUQ-1
X-Mimecast-MFC-AGG-ID: CPCqf0RINqKtm-qXrethUQ_1744818805
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54F94180087F;
	Wed, 16 Apr 2025 15:53:25 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.112.8])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 76EF41956095;
	Wed, 16 Apr 2025 15:53:23 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH] tests: shell: Update packetpath/flowtables
Date: Wed, 16 Apr 2025 23:53:20 +0800
Message-ID: <20250416155320.16390-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

1. The socat receiver should not use the pipfile as output where the sender
   reads data from, this could create an infinite data loop.
2. Sending a packet right after establishing the connection helped uncover
   a new bug.
3. Optimize test log output

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 tests/shell/testcases/packetpath/flowtables | 77 +++++++++++++--------
 1 file changed, 50 insertions(+), 27 deletions(-)

diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
index d4e0a5bd..b68c5dd4 100755
--- a/tests/shell/testcases/packetpath/flowtables
+++ b/tests/shell/testcases/packetpath/flowtables
@@ -3,8 +3,6 @@
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
 # NFT_TEST_SKIP(NFT_TEST_SKIP_slow)
 
-set -x
-
 rnd=$(mktemp -u XXXXXXXX)
 R="flowtable-router-$rnd"
 C="flowtable-client-$rnd"
@@ -17,9 +15,33 @@ cleanup()
 		ip netns del $i
 	done
 }
-
 trap cleanup EXIT
 
+assert_pass()
+{
+	local ret=$?
+	if [ $ret != 0 ]
+	then
+		echo "FAIL: ${@}"
+		ip netns exec $R cat /proc/net/nf_conntrack
+		exit 1
+	else
+		echo "PASS: ${@}"
+	fi
+}
+assert_fail()
+{
+	local ret=$?
+	if [ $ret == 0 ]
+	then
+		echo "FAIL: ${@}"
+		ip netns exec $R cat /proc/net/nf_conntrack
+		exit 1
+	else
+		echo "PASS: ${@}"
+	fi
+}
+
 ip netns add $R
 ip netns add $S
 ip netns add $C
@@ -35,14 +57,15 @@ ip netns exec $S ip -6 addr add 2001:db8:ffff:22::1/64 dev s_r
 ip netns exec $C ip -6 addr add 2001:db8:ffff:21::2/64 dev c_r
 ip netns exec $R ip -6 addr add 2001:db8:ffff:22::fffe/64 dev r_s
 ip netns exec $R ip -6 addr add 2001:db8:ffff:21::fffe/64 dev r_c
-ip netns exec $R sysctl -w net.ipv6.conf.all.forwarding=1
+ip netns exec $R sysctl -wq net.ipv6.conf.all.forwarding=1
 ip netns exec $C ip route add 2001:db8:ffff:22::/64 via 2001:db8:ffff:21::fffe dev c_r
 ip netns exec $S ip route add 2001:db8:ffff:21::/64 via 2001:db8:ffff:22::fffe dev s_r
 ip netns exec $S ethtool -K s_r tso off
 ip netns exec $C ethtool -K c_r tso off
-
 sleep 3
-ip netns exec $C ping -6 2001:db8:ffff:22::1 -c1 || exit 1
+
+ip netns exec $C ping -q -6 2001:db8:ffff:22::1 -c1
+assert_pass "topo initialization"
 
 ip netns exec $R nft -f - <<EOF
 table ip6 filter {
@@ -61,6 +84,7 @@ table ip6 filter {
         }
 }
 EOF
+assert_pass "apply nft ruleset"
 
 if [ ! -r /proc/net/nf_conntrack ]
 then
@@ -68,32 +92,31 @@ then
 	exit 77
 fi
 
-ip netns exec $R nft list ruleset
-ip netns exec $R sysctl -w net.netfilter.nf_flowtable_tcp_timeout=5 || {
-	echo "E: set net.netfilter.nf_flowtable_tcp_timeout fail, skipping" >&2
-        exit 77
-}
-ip netns exec $R sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=86400 || {
-        echo "E: set net.netfilter.nf_conntrack_tcp_timeout_established fail, skipping" >&2
-        exit 77
+ip netns exec $R sysctl -wq net.netfilter.nf_flowtable_tcp_timeout=5
+assert_pass "set net.netfilter.nf_flowtable_tcp_timeout=5"
 
-}
+ip netns exec $R sysctl -wq net.netfilter.nf_conntrack_tcp_timeout_established=86400
+assert_pass "set net.netfilter.nf_conntrack_tcp_timeout_established=86400"
 
 # A trick to control the timing to send a packet
-ip netns exec $S socat TCP6-LISTEN:10001 GOPEN:/tmp/pipefile-$rnd,ignoreeof &
+ip netns exec $S socat TCP6-LISTEN:10001 GOPEN:/tmp/socat-$rnd,ignoreeof &
 sleep 1
 ip netns exec $C socat -b 2048 PIPE:/tmp/pipefile-$rnd 'TCP:[2001:db8:ffff:22::1]:10001' &
 sleep 1
-ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "check [OFFLOAD] tag (failed)"; exit 1; }
-ip netns exec $R cat /proc/net/nf_conntrack
+ip netns exec $C echo "send sth" >> /tmp/pipefile-$rnd        ; assert_pass "send a packet"
+ip netns exec $R grep -q 'OFFLOAD' /proc/net/nf_conntrack     ; assert_pass "check [OFFLOAD] tag"
 sleep 6
-ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   && { echo "CT OFFLOAD timeout, fail back to classical path (failed)"; exit 1; }
-ip netns exec $R grep '8639[0-9]' /proc/net/nf_conntrack || { echo "check nf_conntrack_tcp_timeout_established (failed)"; exit 1; }
-ip netns exec $C echo "send sth" >> /tmp/pipefile-$rnd
-ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "traffic seen, back to OFFLOAD path (failed)"; exit 1; }
-ip netns exec $C sleep 3
-ip netns exec $C echo "send sth" >> /tmp/pipefile-$rnd
-ip netns exec $C sleep 3
-ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "Traffic seen in 5s (nf_flowtable_tcp_timeout), so stay in OFFLOAD (failed)"; exit 1; }
-
+ip netns exec $R grep -q 'OFFLOAD' /proc/net/nf_conntrack     ; assert_fail "CT OFFLOAD timeout, back to the classical path"
+ip netns exec $R grep -q '863[89][0-9]' /proc/net/nf_conntrack; assert_pass "check timeout adopt nf_conntrack_tcp_timeout_established"
+ip netns exec $C echo "send sth" >> /tmp/pipefile-$rnd        ; assert_pass "send a packet"
+ip netns exec $R grep -q 'OFFLOAD' /proc/net/nf_conntrack     ; assert_pass "packet detected, back to the OFFLOAD path"
+
+i=3; while ((i--))
+do
+	sleep 3
+	ip netns exec $C echo "send sth" >> /tmp/pipefile-$rnd; assert_pass "send a packet"
+	sleep 3
+	ip netns exec $R grep -q 'OFFLOAD' /proc/net/nf_conntrack
+	assert_pass "Traffic seen in 5s (nf_flowtable_tcp_timeout), should stay in OFFLOAD"
+done
 exit 0
-- 
2.49.0

