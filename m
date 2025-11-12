Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC422857C1
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2025 07:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762933122; cv=none; b=Hwy16TAW4HSgo4yrKt1Illh4jwyGpsLiFINYL8bod8V75TWQUotl/4ssKjigAC64B3S5SEfV+TvF/K/vT9lP+g5NnYqeNNrEN0Bk3fNhhtg2iY6pHEPNi7jw+50mC5OsXvtif7hrqpW/EEpOjO5xQgFkkMuYAlKTHH2j2QhtVfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762933122; c=relaxed/simple;
	bh=VX9UxJWfqwPGGGSoe/98v/9ZW+723DNfVXAtgkmuHU4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pm36AV9dmYiSRylWVk5ov4MVdHedOWLlxkD64k/qqkYa9//HXFUUIARfCEyz+P3gV4yMjm5OT2l2Pl8WK0ESw/vXoLcHgPikKD31MX2HYMYp7JjeNt+DPsj2LzG/Lo76Y6AP1oTiiLTKDhVLUBLpMoZunN0mJaxQyxK4fgMzWhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZfP8WwQJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZfP8WwQJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762933120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6zo0DYKVOULHcWn+4RYlzYprbUF2jfhDmYn1RXi1H/c=;
	b=ZfP8WwQJx4vZ3Li5t+DGYi/Z/8zB+1veUeLO8efWN5GxLoU/HRg3bbaB/tl8rAFyKwhD8r
	zqIJ/tNP2izNsLBnbWk8B6UtlTYYe9IllIbZ6JvYej+2waknCrGVOuWFgPCgacO4p+ELdU
	qf4B1CULoECb6lNNmYAgOrnYRv92Y+w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-127-EUYfZHgCNcqpAZEemkEz6A-1; Wed,
 12 Nov 2025 02:38:38 -0500
X-MC-Unique: EUYfZHgCNcqpAZEemkEz6A-1
X-Mimecast-MFC-AGG-ID: EUYfZHgCNcqpAZEemkEz6A_1762933117
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2468C195608F;
	Wed, 12 Nov 2025 07:38:37 +0000 (UTC)
Received: from yiche-laptop.redhat.com (unknown [10.72.116.123])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7AB651955F1A;
	Wed, 12 Nov 2025 07:38:34 +0000 (UTC)
From: Yi Chen <yiche@redhat.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH] tests: shell: add packetpath test for meta time expression.
Date: Wed, 12 Nov 2025 15:38:31 +0800
Message-ID: <20251112073831.14720-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Signed-off-by: Yi Chen <yiche@redhat.com>
---
 .../packetpath/dumps/meta_time.nodump         |  0
 tests/shell/testcases/packetpath/meta_time    | 79 +++++++++++++++++++
 2 files changed, 79 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/meta_time.nodump
 create mode 100755 tests/shell/testcases/packetpath/meta_time

diff --git a/tests/shell/testcases/packetpath/dumps/meta_time.nodump b/tests/shell/testcases/packetpath/dumps/meta_time.nodump
new file mode 100644
index 00000000..e69de29b
diff --git a/tests/shell/testcases/packetpath/meta_time b/tests/shell/testcases/packetpath/meta_time
new file mode 100755
index 00000000..a5003fa2
--- /dev/null
+++ b/tests/shell/testcases/packetpath/meta_time
@@ -0,0 +1,79 @@
+#!/bin/sh
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_meta_time)
+
+. $NFT_TEST_LIBRARY_FILE
+
+gen_in_range_minute()
+{
+	echo $(date -d "-5 minutes" +%H:%M)-$(date -d "+5 minutes" +%H:%M)
+}
+
+gen_out_of_range_minute()
+{
+	echo $(date -d "+2 minutes" +%H:%M)-$(date -d "+5 minutes" +%H:%M)
+}
+
+gen_in_range_hour()
+{
+	echo $(date -d "-2 hours" +%H:%M)-$(date -d "+2 hours" +%H:%M)
+}
+
+gen_out_of_range_hour()
+{
+	echo $(date -d "+1 hours" +%H:%M)-$(date -d "+2 hours" +%H:%M)
+}
+gen_in_range_day()
+{
+	#meta day "Sunday"-"Tuesday"
+	echo \"$(date -d "-1 days" +%A)\"-\"$(date -d "+1 days" +%A)\"
+}
+gen_out_of_range_day()
+{
+	echo \"$(date -d "-2 days" +%A)\"-\"$(date -d "-1 days" +%A)\"
+}
+
+gen_in_range_time()
+{
+	echo ">" \"$(date -d "-1 years +10 days" +%G-%m-%d" "%H:%M:%S)\" "meta time <" \"$(date -d "+2 days" +%G-%m-%d" "%H:%M:%S)\"
+}
+
+gen_out_of_range_time()
+{
+	echo ">" \"$(date -d "+10 days" +%G-%m-%d" "%H:%M:%S)\" "meta time <" \"$(date -d "+1 month" +%G-%m-%d" "%H:%M:%S)\"
+}
+
+$NFT -f - <<-EOF
+table ip time_test {
+	counter matched {}
+	counter unmatch {}
+	chain input {
+		type filter hook input priority filter; policy accept;
+		iifname lo icmp type echo-request meta hour $(gen_in_range_hour)       counter name matched
+		iifname lo icmp type echo-request meta hour $(gen_out_of_range_hour)   counter name unmatch
+		iifname lo icmp type echo-request meta hour $(gen_in_range_minute)     counter name matched
+		iifname lo icmp type echo-request meta hour $(gen_out_of_range_minute) counter name unmatch
+		iifname lo icmp type echo-request meta day  $(gen_in_range_day)        counter name matched
+		iifname lo icmp type echo-request meta day  $(gen_out_of_range_day)    counter name unmatch
+		iifname lo icmp type echo-request meta time $(gen_in_range_time)       counter name matched
+		iifname lo icmp type echo-request meta time $(gen_out_of_range_time)   counter name unmatch
+	}
+}
+EOF
+assert_pass "restore meta time ruleset"
+
+nft add rule ip time_test input ip protocol icmp meta hour \"24:00\"-\"4:00\" 2>/dev/null
+assert_fail "Wrong time format input"
+nft add rule ip time_test input ip protocol icmp meta hour \"-2:00\"-\"4:00\" 2>/dev/null
+assert_fail "Wrong time format input"
+
+ip link set lo up
+ping -W 1 127.0.0.1 -c 1
+assert_pass "ping pass"
+
+$NFT list counter ip time_test matched | grep 'packets 4'
+assert_pass "matched check"
+$NFT list counter ip time_test unmatch | grep 'packets 0'
+assert_pass "unmatch check"
+$NFT delete table ip time_test
+assert_pass "delete table"
-- 
2.51.1

