Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7AD1A285
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 02:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769566347; cv=none; b=u7QHA9rAoK+g29JgTMUlElqauQsj2U5wpGYebyeTeuT7/OWvhP5NqzPe3NNWRxcECUfqHxv2ILYoRsw7UvopKSkB5KKWCo/WKGqZT9CeIVSO8OAkkBf+1tKiTG9ttex5WZjW5YOLI7bfnsLFR7KpzIjZs36+7MYGsS8tDyUaWso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769566347; c=relaxed/simple;
	bh=gmIaKFudCBz3V2xaWTt41odFjnjY1IPl8q6ewWB6MB4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jjcq37HemyY2GVM2CW6bj7eLaT9SbMF41GMZ+BNBgntJltFnQBM7GtnrT24VFtWWVj7HpHNXFagTJtaHtdbmdOSCmkxF1Cq3ek4ZkMrlwJtU98KlTxNSvnCEOmlgH5kHZ1PM1Ow9JuWKxP+CATRvJi0icYdWkxcUPjmczt/Wa/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Oma4Dmx9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Oma4Dmx9"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D7FE360180
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 03:12:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1769566344;
	bh=WeRiWP0eTyfByjXyNTw28zmlBKRAwUr4nkLdbj662lA=;
	h=From:To:Subject:Date:From;
	b=Oma4Dmx9ZRDuzTF6wlU72rt4xJEU14aDhHx6nTrC3nnAxSYLlSK248d7dh5aW8kkM
	 KmUBZZA+8qvozgePna15FCldUuE0HVfHqC29kgXrEXfUrEXfA/A2yUNHe8WUEgmDe5
	 CceQsBJNvhjCPr+7cdFOP23f5yxp5cjwK0E9qGQ9P7ChOcea9myrSOjAYK22RY4InM
	 VfZ7F4gdLT0LfeYJ1aWpO9+a0ZFQPd2oMb1/rydWId9ORei4fpWXTZzBXDbyp02TaX
	 lKY9oUXuWKkps7C4qM5AewlgbhgTYC5eNf4E/YVqLl803EBqP8jMiYC2ARV5X3O7Ww
	 C23N9I94GriFA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: add open interval overlap tests
Date: Wed, 28 Jan 2026 03:12:19 +0100
Message-ID: <20260128021219.763391-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend coverage with corner cases with open interval overlaps.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This can be applied as-is.

 .../testcases/maps/open-interval-anonymous_0  | 33 ++++++++++
 tests/shell/testcases/sets/open-interval_0    | 65 +++++++++++++++++++
 2 files changed, 98 insertions(+)
 create mode 100755 tests/shell/testcases/maps/open-interval-anonymous_0
 create mode 100755 tests/shell/testcases/sets/open-interval_0

diff --git a/tests/shell/testcases/maps/open-interval-anonymous_0 b/tests/shell/testcases/maps/open-interval-anonymous_0
new file mode 100755
index 000000000000..0d7972ee9ffa
--- /dev/null
+++ b/tests/shell/testcases/maps/open-interval-anonymous_0
@@ -0,0 +1,33 @@
+#/bin/bash
+
+RULESET="table ip x {
+	chain y {
+		type filter hook output priority 0;
+	}
+}"
+
+$NFT -f - <<< $RULESET
+
+$NFT add rule ip x y meta mark set ip saddr map { 255.255.255.0-255.255.255.255 : 1}
+[ $? -ne 0 ] && echo "failed to add rule with open interval" && exit 1
+$NFT add rule ip x y meta mark set ip saddr map { 255.255.255.0-255.255.255.254 : 2}
+[ $? -ne 0 ] && echo "failed to add rule without open interval" && exit 1
+$NFT add rule ip x y meta mark set ip saddr map { 255.255.255.0-255.255.255.1 : 1, 255.255.255.2-255.255.255.254 : 2}
+[ $? -ne 0 ] && echo "failed to add adjacent intervals" && exit 1
+$NFT add rule ip x y meta mark set ip saddr map { 255.255.255.0-255.255.255.1 : 1, 255.255.255.2-255.255.255.255 : 2}
+[ $? -ne 0 ] && echo "failed to add adjacent intervals with open interval" && exit 1
+$NFT add rule ip x y meta mark set ip saddr map { 255.255.255.2-255.255.255.255 : 1, 255.255.255.0-255.255.255.1 : 2}
+[ $? -ne 0 ] && echo "failed to add adjacent intervals with open interval (different order)" && exit 1
+$NFT add rule ip x y meta mark set ip saddr map { 255.255.255.0-255.255.255.255 : 1, 255.255.255.0-255.255.255.254 : 2}
+[ $? -eq 0 ] && echo "unexpected open interval overlap with multiple intervals" && exit 1
+$NFT add rule ip x y meta mark set ip saddr map { 255.255.255.0-255.255.255.254 : 1, 255.255.255.0-255.255.255.255 : 2}
+[ $? -eq 0 ] && echo "unexpected open interval overlap with multiple intervals (different order)" && exit 1
+$NFT add rule ip x y meta mark set ip saddr map { 255.255.255.0-255.255.255.3 : 1, 255.255.255.0-255.255.255.2 : 2}
+[ $? -eq 0 ] && echo "unexpected overlapping interval on start" && exit 1
+$NFT add rule ip x y meta mark set ip saddr map { 255.255.255.0-255.255.255.3 : 1, 255.255.255.1-255.255.255.3 : 2}
+[ $? -eq 0 ] && echo "unexpected overlapping interval on end" && exit 1
+$NFT add rule ip x y meta mark set ip saddr map { 255.255.255.1-255.255.255.3 : 1, 255.255.255.0-255.255.255.4 : 2}
+[ $? -eq 0 ] && echo "unexpected overlapping interval" && exit 1
+$NFT add rule ip x y meta mark set ip saddr map { 255.255.255.1-255.255.255.5 : 1, 255.255.255.2-255.255.255.3 : 2}
+[ $? -eq 0 ] && echo "unexpected overlapping interval again" && exit 1
+exit 0
diff --git a/tests/shell/testcases/sets/open-interval_0 b/tests/shell/testcases/sets/open-interval_0
new file mode 100755
index 000000000000..1be926ae129c
--- /dev/null
+++ b/tests/shell/testcases/sets/open-interval_0
@@ -0,0 +1,65 @@
+#/bin/bash
+
+RULESET="table ip x {
+	set y {
+		type ipv4_addr
+		flags interval
+		counter
+	}
+
+	chain y {
+		type filter hook output priority 0;
+		ip daddr @y
+	}
+}"
+
+$NFT -f - <<< $RULESET
+
+# validate same interval
+$NFT add element ip x y { 1.1.1.1-2.2.2.2, 3.3.3.3-4.4.4.4 }
+[ $? -ne 0 ] && echo "failed to add simple intervals" && exit 1
+$NFT add element ip x y { 1.1.1.1-4.4.4.4 }
+[ $? -eq 0 ] && echo "unexpected add simple interval" && exit 1
+$NFT delete element ip x y { 1.1.1.1-4.4.4.4 }
+[ $? -eq 0 ] && echo "unexpected delete simple interval" && exit 1
+$NFT add element ip x y { 1.1.1.1-2.2.2.2 }
+[ $? -ne 0 ] && echo "failed to re-add simple interval" && exit 1
+$NFT delete element ip x y { 1.1.1.1-2.2.2.2 }
+[ $? -ne 0 ] && echo "failed to delete simple interval" && exit 1
+$NFT add element ip x y { 1.1.1.1-2.2.2.2 }
+[ $? -ne 0 ] && echo "failed to add simple interval again" && exit 1
+
+# now validate open interval
+$NFT add element ip x y { 255.255.255.0-255.255.255.255 }
+[ $? -ne 0 ] && echo "failed to add open interval" && exit 1
+$NFT add element ip x y { 255.255.255.0-255.255.255.255 }
+[ $? -ne 0 ] && echo "failed to re-add open interval" && exit 1
+# try add overlap on open interval
+$NFT add element ip x y { 255.255.255.0-255.255.255.254 }
+[ $? -eq 0 ] && echo "unexpected open interval overlap" && exit 1
+# try add overlap on open interval in one command
+$NFT add element ip x y { 255.255.255.0-255.255.255.255, 255.255.255.0-255.255.255.254 }
+[ $? -eq 0 ] && echo "unexpected open interval overlap with multiple intervals" && exit 1
+$NFT add element ip x y { 255.255.255.0-255.255.255.254, 255.255.255.0-255.255.255.255 }
+[ $? -eq 0 ] && echo "unexpected open interval overlap with multiple intervals (different order)" && exit 1
+# try more overlaps on existing open interval
+$NFT add element ip x y { 255.255.255.1-255.255.255.255 }
+[ $? -eq 0 ] && echo "unexpected inner open interval overlap" && exit 1
+$NFT add element ip x y { 255.255.255.1-255.255.255.254 }
+[ $? -eq 0 ] && echo "unexpected inner interval overlap" && exit 1
+$NFT flush set ip x y
+$NFT add element ip x y { 255.255.255.0-255.255.255.254 }
+[ $? -ne 0 ] && echo "failed to add interval" && exit 1
+$NFT add element ip x y { 255.255.255.0-255.255.255.254 }
+[ $? -ne 0 ] && echo "failed to re-add interval" && exit 1
+# try open interval overlap on existing interval
+$NFT add element ip x y { 255.255.255.0-255.255.255.255 }
+[ $? -eq 0 ] && echo "unexpected open interval over interval" && exit 1
+# try open interval overlap on existing interval
+$NFT add element ip x y { 255.255.255.1-255.255.255.255 }
+[ $? -eq 0 ] && echo "unexpected inner open interval over interval" && exit 1
+$NFT add element ip x y { 255.255.255.0-255.255.255.254, 255.255.255.0-255.255.255.255 }
+[ $? -eq 0 ] && echo "unexpected inner open interval over with multiple intervals" && exit 1
+$NFT add element ip x y { 255.255.255.0-255.255.255.255, 255.255.255.0-255.255.255.254 }
+[ $? -eq 0 ] && echo "unexpected inner open interval over with multiple intervals (different order)" && exit 1
+exit 0
-- 
2.47.3

