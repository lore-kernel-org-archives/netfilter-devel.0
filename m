Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8356221703
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jul 2025 08:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753344432; cv=none; b=MS43INg8ueNy19c4aoLsl6MxKsChV6hjd1DV30PsyQeyMyy7SjJL+53O4nZZb3aGQoc115eCrBbPsENg6KQu/YFtW7jpzjW8VD7ov86LnfDBaQ/jtOnMNs0LxwsmGmmthOkXHo5OZpNH6gPixFyLuluneuNH1ZnGn1zHYrekilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753344432; c=relaxed/simple;
	bh=3GfbGSqWVEhIf20dNOMc0fp14qcTv6XZ5FmBTnLwA+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=idqcEc7pYV7ljemSycgvhF/1fcPuq02JFV/kErIOs5BM9BW3aSr8cPppIhZl/+e9W5nD2yvZ3cYrDhOb32Apqzns+Z2gbideMTOPGuHliC35TumNkuyHrLeCfVi2FKpKowSo6zTEH7V1kR2MPdwiJ/QgYl5gNBp78uYWaCtzK4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XiE/NPua; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XiE/NPua"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753344429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yds5vhOzn4LpdsxnEOz220TpuASpaZwH3IpQhzpEW5I=;
	b=XiE/NPuaue4/X8ln3Xf4oWGKlNrNbPR6DcvXVlfY+yDD5N/+jMOVDM43pUTKbeGeYJbkpm
	Jpt4GbcF4sZFGjbX8dQ2eKoeF0FpvnKc++n+0mrSkupv5zvh03EMJdigmpgOhKCM9sEE7c
	5GqLLA8WPJFfh9uryx7KWol/HYyhHuw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-l7vBBadIMIenRZy1RjtSJA-1; Thu,
 24 Jul 2025 04:07:05 -0400
X-MC-Unique: l7vBBadIMIenRZy1RjtSJA-1
X-Mimecast-MFC-AGG-ID: l7vBBadIMIenRZy1RjtSJA_1753344423
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17E8318002B6;
	Thu, 24 Jul 2025 08:07:03 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.112.178])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E176218002AF;
	Thu, 24 Jul 2025 08:06:55 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	horms@kernel.org,
	coreteam@netfilter.org,
	fw@strlen.de
Subject: [PATCH net v2] selftests: netfilter: ipvs.sh: Explicity disable rp_filter on interface tunl0
Date: Thu, 24 Jul 2025 16:06:53 +0800
Message-ID: <20250724080653.20723-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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

v2: Fixed the format of Fixes tag.
Signed-off-by: Yi Chen <yiche@redhat.com>
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
2.50.1

