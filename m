Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC8544AB73
	for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 13:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786455789; cv=none; b=HpOzGuX1bBn5xng5av060KokRPYTEya5nUuvd/UOIq11UkAsZQHNdf1KcH6bTPW7wba8cn8lRaEjbf8Rw/hpZIAnNUqy3kX3yz4kx4Fnqg9iBn8ObolNjZU841uvUCiQfwXun09KUgIRLbAZ+eiipAmIIbUX3oxA91nh1DhX7yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786455789; c=relaxed/simple;
	bh=e6heA08X0ytkdiuoH2Plwk3ClgkeljZX7jPtRVo6rbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ef4M2h78xO6fClQw+PLCDNBfqX9kXmiwRm94VRxRSLLU0JUY/TdfXLGqNazon9w9vvIAMW3WFEdDcCRHvu3faPVVrg9aKWO6sbJMdwLXehu3EdrJTnvrU6G87Smk1qndbBcYfmC8jhjIXsyAO2dG7rhb+9v/7j3bcPM+7/KVhZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b9+KJmcC; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b9+KJmcC"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-493b966dd74so19750035e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2026 06:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786455774; x=1787060574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nUHipzEJf9sROju1qmkImc9TeZ7+625oV9FDL1Wt7jc=;
        b=b9+KJmcCxtdpPKOjTXZnr1GMg+dW6ioNhpxlMj9LIX00ixKd/PCzBgspoD6JRtplqw
         qIgkAkXkqT1GhU4McW6VRlwAkew8BrKict4Q2DkpIKufcVwkpP3jfau1sQaTt+C7AsYf
         SWuWWzwfwa0fe09oa0Q9LzlW+gWxk3v21d73T22BIfVd0WBnvLYx9+79FZCF8jmq8Zd3
         GjejDV2b226PJp5Ro6I6sWRpTF0mulc29PCPIXSKBGw7a8nuQxamM3N8kFV41Sdsoplm
         CZKaxIbasXKE/PIe8X/Xt029+0mHOwjiRedHB+7qUUmKKIkLLd9ihOfZRf/gE1wjOxzy
         gc8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786455774; x=1787060574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nUHipzEJf9sROju1qmkImc9TeZ7+625oV9FDL1Wt7jc=;
        b=GXnpGsrRNE95UFlfkkOrnT2Hy10XEJcUiROEYZOiZTpOuygHoAaBKFJaZ+fYilIoO4
         4Gc0iisUvxTbe1oalOQghJXxTonEpVAD1+rPYaEBvdClN6Hu7zEH6GZ1Le/B0tdiDNRU
         VlfFhBjU0E/UMtDxGcfrWwLVI+B4n3S+gwLwcbkDPmTAn8Y5kQp8O0oiUlOllPbqKaUF
         a1uLhXUahSQ2j6h+yhNFpM9NEeuoll8I/5i28LCY4f5nlwq/S+fgCgjzFfFx9OQ+uJcy
         dvyTwiAsMA4O36RPyW+sIr/0YJRdTXpmDiwaAM47Vk4hJUJ4N55caAd03oKjIv4INzyZ
         XYqg==
X-Gm-Message-State: AOJu0YxtBSSF2t27YdScKaObIiBYo6fQZaQfcSCt3J//mP7b2dNZhfBi
	0yCn16vmggtpeElecTUid8oLtnatDlngjDyjlCnTNweWsG84Lphwlm0LRsd0y7rK
X-Gm-Gg: AR+sD12fZAr7uuUDK+j+SNEmv9yO0Tgmyvlad25p0xsw9ZWT/n/Kfdc1c/BthIv+HLz
	+TriAihvgRT0k3Z40YlgE3hmrT6+BcsDoYGb8VlL0H7Kufe5nI5/kaiHmwD7ouekj6RBEPKsJcL
	DrTbrNrFgk1IOjvNePbyi2PaspUva4BFDO2NrKkxGkVCi1ERIhuXcs0HBNcMNBYxBwwfn4RNczz
	wPGJdbKqapWL70vskB4+Ssa+/ZQmAqBWlcQVWvS6yBhuekw9BjDxgDboLwnKic69E37Gl7PBIi2
	vVuletrcFCLHjFCpZIgjixRKWbFJ7FM4HQ3fG31+D5zBfgDOE6dPySD46jq/SfvVSbOFQOHHUeI
	yGiPtNegpGvtof0T6hqc4HwHyWwFf5HOcuxz678w3s7wWtIAFYYONBU8p9z+GT94QILnLeCw0PJ
	dR/PF+2Yp9ft87EijjrKy99D4caRUl4BobJzvLolgATLik2g6lHtW91abWPwPOlyndy2qsPDrw8
	jTsCM48OuwqcQ==
X-Received: by 2002:a05:600c:8b78:b0:496:bbcb:b0bb with SMTP id 5b1f17b1804b1-49978475987mr60871095e9.18.1786455774446;
        Tue, 11 Aug 2026 06:42:54 -0700 (PDT)
Received: from DINA5CG53728ZV.evosoft.com ([136.226.199.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49974146933sm80558755e9.10.2026.08.11.06.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 06:42:53 -0700 (PDT)
From: Gergely Palotas <palotasgergely@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Gergely Palotas <palotasgergely@gmail.com>
Subject: [nft PATCH 2/2] tests: shell: add JSON delete test for ct stateful objects
Date: Tue, 11 Aug 2026 15:43:26 +0200
Message-ID: <20260811134326.300827-3-palotasgergely@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811134326.300827-1-palotasgergely@gmail.com>
References: <20260811134326.300827-1-palotasgergely@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Verify that JSON delete commands work correctly for ct timeout, ct
expectation and tunnel stateful objects. These were broken before the
previous fix due to a CMD_OBJ/NFT_OBJECT mismatch in the delete path
of json_parse_cmd_add_object().

Signed-off-by: Gergely Palotas <palotasgergely@gmail.com>
---
 .../json/0009json_delete_ct_objects_0         | 140 ++++++++++++++++++
 1 file changed, 140 insertions(+)
 create mode 100755 tests/shell/testcases/json/0009json_delete_ct_objects_0

diff --git a/tests/shell/testcases/json/0009json_delete_ct_objects_0 b/tests/shell/testcases/json/0009json_delete_ct_objects_0
new file mode 100755
index 00000000..78a68be4
--- /dev/null
+++ b/tests/shell/testcases/json/0009json_delete_ct_objects_0
@@ -0,0 +1,140 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+#
+# Regression test for JSON delete of ct timeout, ct expectation and tunnel
+# objects.  Prior to the fix, json_parse_cmd_add_object() passed the raw
+# NFT_OBJECT_* kernel constant to cmd_alloc() on the delete/list/destroy
+# early-return path instead of the correct CMD_OBJ_* userspace enum value.
+# For ct timeout NFT_OBJECT_CT_TIMEOUT=7 aliased to CMD_OBJ_CHAIN=7, causing
+# the kernel to return EINVAL.
+
+set -e
+
+$NFT flush ruleset
+
+$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"table": {"family": "inet", "name": "t"}}}]}
+EOF
+
+# ===== ct timeout =====
+
+if [ "$NFT_TEST_HAVE_cttimeout" != n ]; then
+
+	echo "Test 1: JSON add ct timeout"
+	$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"ct timeout": {"family": "inet", "table": "t", "name": "ctto", "protocol": "udp", "policy": {"unreplied": 30, "replied": 60}}}}]}
+EOF
+
+	if ! $NFT list ct timeout inet t ctto > /dev/null 2>&1; then
+		echo "Test 1 failed: ct timeout not created"
+		exit 1
+	fi
+
+	echo "Test 2: JSON delete ct timeout by name"
+	$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"ct timeout": {"family": "inet", "table": "t", "name": "ctto"}}}]}
+EOF
+
+	if $NFT list ct timeout inet t ctto > /dev/null 2>&1; then
+		echo "Test 2 failed: ct timeout not deleted"
+		exit 1
+	fi
+
+	echo "Test 3: JSON add + delete ct timeout by handle"
+	$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"ct timeout": {"family": "inet", "table": "t", "name": "ctto2", "protocol": "tcp", "policy": {"established": 120}}}}]}
+EOF
+
+	HANDLE=$($NFT -a list ct timeout inet t ctto2 | sed -n 's/.*# handle \([0-9]\+\).*/\1/p')
+	if [ -z "$HANDLE" ]; then
+		echo "Test 3 failed: could not get ct timeout handle"
+		exit 1
+	fi
+
+	$NFT -j -f - << EOF
+{"nftables": [{"delete": {"ct timeout": {"family": "inet", "table": "t", "handle": $HANDLE}}}]}
+EOF
+
+	if $NFT list ct timeout inet t ctto2 > /dev/null 2>&1; then
+		echo "Test 3 failed: ct timeout not deleted by handle"
+		exit 1
+	fi
+
+fi
+
+# ===== ct expectation =====
+
+if [ "$NFT_TEST_HAVE_ctexpect" != n ]; then
+
+	$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"table": {"family": "ip", "name": "t"}}}]}
+EOF
+
+	echo "Test 4: JSON add ct expectation"
+	$NFT -j -f - << 'EOF'
+{"nftables": [{"add": {"ct expectation": {"family": "ip", "table": "t", "name": "ctex", "protocol": "tcp", "dport": 2121, "timeout": 300000, "size": 12}}}]}
+EOF
+
+	if ! $NFT list ct expectation ip t ctex > /dev/null 2>&1; then
+		echo "Test 4 failed: ct expectation not created"
+		exit 1
+	fi
+
+	echo "Test 5: JSON delete ct expectation by name"
+	$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"ct expectation": {"family": "ip", "table": "t", "name": "ctex"}}}]}
+EOF
+
+	if $NFT list ct expectation ip t ctex > /dev/null 2>&1; then
+		echo "Test 5 failed: ct expectation not deleted"
+		exit 1
+	fi
+
+	$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"table": {"family": "ip", "name": "t"}}}]}
+EOF
+
+fi
+
+# ===== tunnel =====
+#
+# Tunnel objects must be created and deleted in the same batch as the table
+# when using JSON (kernel lookup limitation with separate add commands).
+
+if [ "$NFT_TEST_HAVE_tunnel" != n ]; then
+
+	echo "Test 6: JSON add+delete tunnel object in batch"
+	$NFT -j -f - << 'EOF'
+{"nftables": [
+  {"add": {"table": {"family": "netdev", "name": "t"}}},
+  {"add": {"tunnel": {"family": "netdev", "table": "t", "name": "tun0", "id": 20, "src-ipv4": "192.168.2.20", "dst-ipv4": "192.168.2.21", "sport": 0, "dport": 4789, "tos": 0, "ttl": 255}}}
+]}
+EOF
+
+	if ! $NFT list tunnel netdev t tun0 > /dev/null 2>&1; then
+		echo "Test 6 failed: tunnel not created"
+		exit 1
+	fi
+
+	echo "Test 7: JSON delete tunnel by name"
+	$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"tunnel": {"family": "netdev", "table": "t", "name": "tun0"}}}]}
+EOF
+
+	if $NFT list tunnel netdev t tun0 > /dev/null 2>&1; then
+		echo "Test 7 failed: tunnel not deleted"
+		exit 1
+	fi
+
+	$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"table": {"family": "netdev", "name": "t"}}}]}
+EOF
+
+fi
+
+$NFT -j -f - << 'EOF'
+{"nftables": [{"delete": {"table": {"family": "inet", "name": "t"}}}]}
+EOF
+
+echo "All tests passed!"
-- 
2.47.3

