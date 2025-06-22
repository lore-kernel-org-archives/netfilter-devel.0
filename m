Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B3226AD9
	for <netfilter-devel@vger.kernel.org>; Sun, 22 Jun 2025 12:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750596968; cv=none; b=VOdZAhL+IL0jLCoyb04dxJN2Fxy0U3MB9aqRP6I21rjDGAwDMKLElK+js+2B1E9tN+VCZTfaPB/WesNtTzeG/Xt2EOWFPF1C4rAa37jNY9eUtj4DHkmdlIU7oaZHYUusQfymFBFFHYXFUqDPUlpVo08nVK+PkiQ1W5zecupZ/WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750596968; c=relaxed/simple;
	bh=7FcX4aps5uAN65ZCqxJ5znbPt6GBG+VCVC/7fC29+7E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DvZbqd84rIAUqdvzPBUouKqmuhCGwXj7DbLvCKJo7FfEfVLQFFF8/ifa05Hcou9sB4YTZAZYgvv8byM86S2tdA+/KNepCfIzVXcVEhliPFDBIGFq+NO0bJDqP+10H71un7XmOPDEQP1m6Jvh8Xx9nV1/5rRTWYtwIucs7V7Dzw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QHTBhlbZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QHTBhlbZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750596964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wkPhzmhO3fimjSYFiRDSk35riXhRcOJkbZJR2iv3G5o=;
	b=QHTBhlbZ4aMFxIefVrqxqmcAEh0CjGVb3rLBPookItVjgseENvsipf5nRLl+fBydvZf+us
	D2n/wyDmhWeV/G6zhi/TFz9RTnjxWhzlWdhYog+P1F/vUGzOckClO2bsb5fau4wF8IqY/D
	cwx5AVstIqfxXVXqYnuOfkfmqbhvrpw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-43-U_yIzDWeNEWaTksIjxlEwQ-1; Sun,
 22 Jun 2025 08:56:00 -0400
X-MC-Unique: U_yIzDWeNEWaTksIjxlEwQ-1
X-Mimecast-MFC-AGG-ID: U_yIzDWeNEWaTksIjxlEwQ_1750596960
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEFBA1956088;
	Sun, 22 Jun 2025 12:55:59 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.116.39])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 04A63180035C;
	Sun, 22 Jun 2025 12:55:57 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 1/4] test: shell: Don't use system nft binary
Date: Sun, 22 Jun 2025 20:55:51 +0800
Message-ID: <20250622125554.4960-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Use the defined $NFT variable instead of calling the system nft binary directly.
Add a nat_ftp.nodump file to avoid the following check-tree.sh error:
ERR: "tests/shell/testcases/packetpath/nat_ftp" has no "tests/shell/testcases/packetpath/dumps/nat_ftp.{nft,nodump}" file.

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 tests/shell/testcases/packetpath/dumps/nat_ftp.nodump | 0
 tests/shell/testcases/packetpath/flowtables           | 4 ++--
 tests/shell/testcases/packetpath/nat_ftp              | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)
 create mode 100644 tests/shell/testcases/packetpath/dumps/nat_ftp.nodump

diff --git a/tests/shell/testcases/packetpath/dumps/nat_ftp.nodump b/tests/shell/testcases/packetpath/dumps/nat_ftp.nodump
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
index b68c5dd4..ab11431f 100755
--- a/tests/shell/testcases/packetpath/flowtables
+++ b/tests/shell/testcases/packetpath/flowtables
@@ -67,7 +67,7 @@ sleep 3
 ip netns exec $C ping -q -6 2001:db8:ffff:22::1 -c1
 assert_pass "topo initialization"
 
-ip netns exec $R nft -f - <<EOF
+ip netns exec $R $NFT -f - <<EOF
 table ip6 filter {
         flowtable f1 {
                 hook ingress priority -100
@@ -88,7 +88,7 @@ assert_pass "apply nft ruleset"
 
 if [ ! -r /proc/net/nf_conntrack ]
 then
-	echo "E: nf_conntrack unreadable, skipping" >&2	
+	echo "E: nf_conntrack unreadable, skipping" >&2
 	exit 77
 fi
 
diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
index 327047b8..738bcb98 100755
--- a/tests/shell/testcases/packetpath/nat_ftp
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -20,7 +20,7 @@ assert_pass()
 	if [ $ret != 0 ]
 	then
 		echo "FAIL: ${@}"
-		ip netns exec $R nft list ruleset
+		ip netns exec $R $NFT list ruleset
 		tcpdump -nnr ${PCAP}
 		test -r /proc/net/nf_conntrack && ip netns exec $R cat /proc/net/nf_conntrack
 		ip netns exec $R conntrack -S
@@ -82,7 +82,7 @@ assert_pass "topo initialization"
 reload_ruleset()
 {
 	ip netns exec $R conntrack -F 2> /dev/null
-	ip netns exec $R nft -f - <<-EOF
+	ip netns exec $R $NFT -f - <<-EOF
 	flush ruleset
 	table ip6 ftp_helper_nat_test {
 		ct helper ftp-standard {
-- 
2.49.0

