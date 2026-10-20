Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792505058;
	b=a68scZ1TiPqXkrZQ8aza7J+0y00lsOhF8MMURoJufn/HkI4R/EODIEMad3udrrIfUq3F
	 4jPMzcDzT16gisuTTJKg14IqEnPnFmXLqx1Ru3lSV/HQcZSmUA0AHSCe6q2lMr86Mowdp
	 L2idhqXEHMjsZennHPdV7eGkZ0Q1/W53xOcGRynKyYtOLC0cABy+/s/BK5xl/O8Uzpitx
	 udRCXGejX7HPJmZcKItUjQzA6eOkY52bOh/ie82OTzysylh9Ss2qqlJGteswEcAhmtE/T
	 jjuy9pHxCBLmFxBBOL4kwp6NvJFDL9Z4Du0r6jA0CYwXkCIWslyTx1wc8hn4kVJ+u8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792505058;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=KAkAzhVfdah/eGN8MKEHeCbnM6XIl8KY+CV/hTm0D08=;
	b=HKEk7JrcOo7BT7nHze2N7bfOzBg5lyPeT537ODvq/ZofpmSGhzbhz7LA54MbcR5VtIHk
	 WO7ETf+CT46UifMZPgXR+TfSueCn7AV7F1oAFrIEg6B6H8kU7uNpCPK6w2qpjC923UdkR
	 ADqytvhYd9Po6oF9xpSW0Okd4s9cCExbfL9zeFgDS+v+uwUZAg+fmNFraW1mhmIwScSdP
	 A+tBO3RLhOn1jeHdDSo1LUQpZH6feOYYQZiApzOP6Y1Vz2W8VlV/odSQMQYWqJQUgVP++
	 Acj8qyv6PTGESanO8u/VB4a8NZx+QgKUFO9irnPgBinM5XNHqCFkvWQVu/PYexF7mTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=PoIWnzPu;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82B1606A319
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 14:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A82B1606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=PoIWnzPu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KAkAzhVfdah/eGN8MKEHeCbnM6XIl8KY+CV/hTm0D08=; b=PoIWnzPuO5FfRgwYpZZ3FEScwv
	qqQ7oaquyV80z8SRB7iZgzP+ykhM0STBmJ4Yhla8K8CMFLFSLtQ5UWgBVFFxYpO3UWZEPJP+qjehs
	jSIuhzpfESDqaS1TGeZFDOBN3g+U4HoEFNWMl0XO3jFemuYzcyMxAxjZlWlacOT7klkvi0zXqiMvL
	zDupV4L8Hs1rowQMp1RwXKlrEgoGR01e0N3IsTC/9+1jjnTuxp44aihxckHDqNcAbEL4AqxVwSHaj
	fEpPfezRDYzT+gKgjYt1XqByaqtOwGH6RBysFyJWLrvrvJr2klS1yYCTVwCgvQah8JWjl/bopGCsC
	tiYZUrUw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xJARk-000000003fn-2ypI
	for netfilter-devel@vger.kernel.org;
	Tue, 20 Oct 2026 16:04:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Add missing feature tests to packetpath tests
Date: Tue, 20 Oct 2026 16:04:03 +0200
Message-ID: <20261020140403.75708-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test system may lack conntrack-tools, add a feature test covering it.
Also add missing socat requirement where needed.

Fixes: e1c4f734eae7c ("tests: shell: add packetpath test for nft ct expectation support")
Fixes: cbb928d3307c4 ("tests: shell: add packetpath test for timeout policy overrides")
Fixes: fcef13a358a07 ("tests: shell: add 'nft ct set zone' test case")
Fixes: 3d4ed753c1231 ("tests: shell: Add a test case for FTP helper combined with NAT.")
Fixes: 9d8c7bbe82504 ("tests: shell: add packetpath test for nat on loopback")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/shell/features/conntrack.sh                  | 4 ++++
 tests/shell/testcases/packetpath/ct_expect         | 1 +
 tests/shell/testcases/packetpath/ct_timeout_policy | 3 +++
 tests/shell/testcases/packetpath/ct_zone_template  | 2 ++
 tests/shell/testcases/packetpath/nat_ftp           | 1 +
 tests/shell/testcases/packetpath/nat_lo            | 2 ++
 6 files changed, 13 insertions(+)
 create mode 100644 tests/shell/features/conntrack.sh

diff --git a/tests/shell/features/conntrack.sh b/tests/shell/features/conntrack.sh
new file mode 100644
index 0000000000000..5454c6b0cf0aa
--- /dev/null
+++ b/tests/shell/features/conntrack.sh
@@ -0,0 +1,4 @@
+#!/bin/sh
+
+# check whether conntrack command is available
+conntrack --help >/dev/null 2>&1
diff --git a/tests/shell/testcases/packetpath/ct_expect b/tests/shell/testcases/packetpath/ct_expect
index cc8f52678cc5f..8b8981bb0b9fe 100755
--- a/tests/shell/testcases/packetpath/ct_expect
+++ b/tests/shell/testcases/packetpath/ct_expect
@@ -1,6 +1,7 @@
 #!/bin/bash
 
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_conntrack)
 
 . $NFT_TEST_LIBRARY_FILE
 
diff --git a/tests/shell/testcases/packetpath/ct_timeout_policy b/tests/shell/testcases/packetpath/ct_timeout_policy
index 1fefcb52d6c38..13b790bfa5051 100755
--- a/tests/shell/testcases/packetpath/ct_timeout_policy
+++ b/tests/shell/testcases/packetpath/ct_timeout_policy
@@ -3,6 +3,9 @@
 # Defines ct timeout policies (1s) and verifies they expire for matching flows
 # while non matching flow stay alive >2s
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_conntrack)
+
 . "$NFT_TEST_LIBRARY_FILE"
 
 ip link set lo up
diff --git a/tests/shell/testcases/packetpath/ct_zone_template b/tests/shell/testcases/packetpath/ct_zone_template
index c851e8f3280e7..0c8f92ba32e15 100755
--- a/tests/shell/testcases/packetpath/ct_zone_template
+++ b/tests/shell/testcases/packetpath/ct_zone_template
@@ -3,6 +3,8 @@
 # Check 'ct zone set 1' actually works, i.e. conntrack is created in
 # the assigned zone.
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_conntrack)
+
 . $NFT_TEST_LIBRARY_FILE
 
 set -e
diff --git a/tests/shell/testcases/packetpath/nat_ftp b/tests/shell/testcases/packetpath/nat_ftp
index bc44ed866125a..cfadd4a6b006e 100755
--- a/tests/shell/testcases/packetpath/nat_ftp
+++ b/tests/shell/testcases/packetpath/nat_ftp
@@ -3,6 +3,7 @@
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_tcpdump)
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_curl)
 # NFT_TEST_REQUIRES(NFT_TEST_HAVE_vsftpd)
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_conntrack)
 
 # modprobe does not work in fake root env
 [ "$NFT_TEST_HAS_REALROOT" != y ] && exit 77
diff --git a/tests/shell/testcases/packetpath/nat_lo b/tests/shell/testcases/packetpath/nat_lo
index 862aadc82ef13..761c4433afd54 100755
--- a/tests/shell/testcases/packetpath/nat_lo
+++ b/tests/shell/testcases/packetpath/nat_lo
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_socat)
+
 set -e
 
 $NFT -f - <<EOF
-- 
2.54.0

