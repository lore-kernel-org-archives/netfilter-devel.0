Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D5814B950
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2025 12:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750596974; cv=none; b=vB7IyYBmxfKPowXTDcW21IdIBs3mgAAUnFw2zfz0k2GlJR36gWxI70pb3Hk0GViPpifxCiVOLayKqDRrrrxLUrT7gPv5Y80/OHIcisAG7qszBJCLU3hXtdVkeTR3eThR3UUmMqhl+w6d7Ob3C3jOW9q3BIinBKp845PoWiPAYPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750596974; c=relaxed/simple;
	bh=q+CPv97Q4ZY7pIz4muN2FDtAY1OteNIEVdaoLGgNT0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n98du+hLJ4w9tMW8Itnu/inFShl4Y09zFDVl4taNWcwzFX8GxvK6SPqSjlX40JLpuF9Ln+JRNHChZtprzv/tySAvhJfw37o5YVJMUu1amwkETi2v+keASMRv65zpYRcDD/QGgMSYJBc+2NPengYPlHHwsxWLCtVBMohRGqAu3o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M0PrQuVR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M0PrQuVR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750596971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HTYi6ngwGg9HzMnrel+suaxyv/Je/5ge71XI6Q36e/0=;
	b=M0PrQuVRA9v5ZGzEdEMyzbjHNxAh3y/XjMKwSz5uQRJx5kkavDXhnQsptrwQc/krrq9T14
	Q9UAUY4323E2ZZQou6C+rgn7OY6VAye46P0vVpJAuCZQjbcJ0IAsfWLborFfy8wlrVQb3R
	wSmCM6CJI0DE05pqjgSLXiNIDZBCank=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-314-eZNXP9jQMU2H8rWcgyobyg-1; Sun,
 22 Jun 2025 08:56:06 -0400
X-MC-Unique: eZNXP9jQMU2H8rWcgyobyg-1
X-Mimecast-MFC-AGG-ID: eZNXP9jQMU2H8rWcgyobyg_1750596965
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 134771800368;
	Sun, 22 Jun 2025 12:56:05 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.116.39])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2BD1B180045B;
	Sun, 22 Jun 2025 12:56:02 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 3/4] test: shell: Add wait_local_port_listen() helper to lib.sh
Date: Sun, 22 Jun 2025 20:55:53 +0800
Message-ID: <20250622125554.4960-3-yiche@redhat.com>
In-Reply-To: <20250622125554.4960-2-yiche@redhat.com>
References: <20250622125554.4960-1-yiche@redhat.com>
 <20250622125554.4960-2-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Introduce a new helper function wait_local_port_listen() in helpers/lib.sh.
Update the flowtables and nat_ftp test cases to use this helper.

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 tests/shell/helpers/lib.sh                  | 21 +++++++++++++++++++++
 tests/shell/testcases/packetpath/flowtables |  3 ++-
 tests/shell/testcases/packetpath/nat_ftp    |  6 ++++--
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/tests/shell/helpers/lib.sh b/tests/shell/helpers/lib.sh
index d2d20984..ce27aac3 100755
--- a/tests/shell/helpers/lib.sh
+++ b/tests/shell/helpers/lib.sh
@@ -28,3 +28,24 @@ assert_fail()
 		echo "PASS: ${@}"
 	fi
 }
+
+wait_local_port_listen()
+{
+	local listener_ns="${1}"
+	local port="${2}"
+	local protocol="${3}"
+	local pattern
+	local i
+
+	pattern=":$(printf "%04X" "${port}") "
+
+	# for tcp protocol additionally check the socket state
+	[ ${protocol} = "tcp" ] && pattern="${pattern}0A"
+	for i in $(seq 10); do
+		if ip netns exec "${listener_ns}" awk '{print $2" "$4}' \
+		   /proc/net/"${protocol}"* | grep -q "${pattern}"; then
+			break
+		fi
+		sleep 0.1
+	done
+}
diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
index f3580a5f..dbe470a8 100755
--- a/tests/shell/testcases/packetpath/flowtables
+++ b/tests/shell/testcases/packetpath/flowtables
@@ -83,7 +83,8 @@ assert_pass "set net.netfilter.nf_conntrack_tcp_timeout_established=86400"
 
 # A trick to control the timing to send a packet
 ip netns exec $S socat TCP6-LISTEN:10001 GOPEN:/tmp/socat-$rnd,ignoreeof &
-sleep 1
+wait_local_port_listen $S 10001 tcp
+
 ip netns exec $C socat -b 2048 PIPE:/tmp/pipefile-$rnd 'TCP:[2001:db8:ffff:22::1]:10001' &
 sleep 1
 ip netns exec $C echo "send sth" >> /tmp/pipefile-$rnd        ; assert_pass "send a packet"
diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
index 37ef14a3..3ba4029d 100755
--- a/tests/shell/testcases/packetpath/nat_ftp
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -132,7 +132,8 @@ pam_service_name=vsftpd
 background=YES
 EOF
 ip netns exec $S vsftpd ${FTPCONF}
-sleep 1
+wait_local_port_listen $S 21 tcp
+
 ip netns exec $S ss -6ltnp | grep -q '*:21'
 assert_pass "start vsftpd server"
 
@@ -141,7 +142,7 @@ assert_pass "start vsftpd server"
 reload_ruleset
 ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
 pid=$!
-sleep 1
+sleep 0.5
 ip netns exec $C curl --no-progress-meter --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
 assert_pass "curl ftp passive mode "
 
@@ -158,6 +159,7 @@ reload_ruleset
 
 ip netns exec $S tcpdump -q --immediate-mode -Ui s_r -w ${PCAP} 2> /dev/null &
 pid=$!
+sleep 0.5
 ip netns exec $C curl --no-progress-meter -P - --connect-timeout 5 ftp://[${ip_rc}]:2121/$(basename $INFILE) -o $OUTFILE
 assert_pass "curl ftp active mode "
 
-- 
2.49.0

