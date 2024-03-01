Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5110240872
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 13:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709298289; cv=none; b=JSO4NBVn9UGCKxkKlXrcP26RfHWVQFcRUeoh3gTZVBSXW7ivAVhVymbiwatK3YxgssF38mbZFTg+1SOFb1iUzTgHyg73DOQR+mXmb9+B/pAgHt0e+eY33+u6slAQMnxp/4vUXZEyzTatkjs0/+Te+g0MsuNCbvFP/Qf5HminyxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709298289; c=relaxed/simple;
	bh=jAAnIxlFh7Wm45xEJ5jZQYvkbJrYuCK1uLkUVbxk2qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C99r+N3g2zwLhOtbUSNr2t8FMoj7fYp5TjpMM0nHv9ZNzWoKSPIT7B9MXCxXncTJJN+agsYICYFL35LKguwYoEakgehdDKsy8/9W5mNIxHM2+UUVl3WXGIjadzWJlhhwvW44CACnbtUkoA4n+QnsA2mSXeSdStoRrNZS+tisZuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rg2ZB-0002NH-L6; Fri, 01 Mar 2024 14:04:45 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] tests: add test case for named ct objects
Date: Fri,  1 Mar 2024 13:59:38 +0100
Message-ID: <20240301125942.20170-4-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240301125942.20170-1-fw@strlen.de>
References: <20240301125942.20170-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a dedicated test for named conntrack objects:
timeouts, helpers and expectations.

A json dump file is not added because the json input
code does not support "typeof" declarations for sets/maps.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/maps/dumps/named_ct_objects.nft | 71 ++++++++++++++
 tests/shell/testcases/maps/named_ct_objects   | 94 +++++++++++++++++++
 2 files changed, 165 insertions(+)
 create mode 100644 tests/shell/testcases/maps/dumps/named_ct_objects.nft
 create mode 100755 tests/shell/testcases/maps/named_ct_objects

diff --git a/tests/shell/testcases/maps/dumps/named_ct_objects.nft b/tests/shell/testcases/maps/dumps/named_ct_objects.nft
new file mode 100644
index 000000000000..59f18932b28a
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/named_ct_objects.nft
@@ -0,0 +1,71 @@
+table inet t {
+	ct expectation exp1 {
+		protocol tcp
+		dport 9876
+		timeout 1m
+		size 12
+		l3proto ip
+	}
+
+	ct expectation exp2 {
+		protocol tcp
+		dport 9876
+		timeout 3s
+		size 13
+		l3proto ip6
+	}
+
+	ct helper myftp {
+		type "ftp" protocol tcp
+		l3proto inet
+	}
+
+	ct timeout dns {
+		protocol tcp
+		l3proto ip
+		policy = { established : 3s, close : 1s }
+	}
+
+	map exp {
+		typeof ip saddr : ct expectation
+		elements = { 192.168.2.2 : "exp1" }
+	}
+
+	map exp6 {
+		typeof ip6 saddr : ct expectation
+		flags interval
+		elements = { dead:beef::/64 : "exp2" }
+	}
+
+	map helpobj {
+		typeof ip6 saddr : ct helper
+		flags interval
+		elements = { dead:beef::/64 : "myftp" }
+	}
+
+	map timeoutmap {
+		typeof ip daddr : ct timeout
+		elements = { 192.168.0.1 : "dns" }
+	}
+
+	set helpname {
+		typeof ct helper
+		elements = { "sip",
+			     "ftp" }
+	}
+
+	chain y {
+		ct expectation set ip saddr map @exp
+		ct expectation set ip6 saddr map { dead::beef : "exp2" }
+		ct expectation set ip6 daddr map { dead::beef : "exp2", feed::17 : "exp2" }
+		ct expectation set ip6 daddr . tcp dport map { feed::17 . 512 : "exp2", dead::beef . 123 : "exp2" }
+		ct helper set ip6 saddr map { 1c3::c01d : "myftp", dead::beef : "myftp" }
+		ct helper set ip6 saddr map @helpobj
+		ct timeout set ip daddr map @timeoutmap
+		ct timeout set ip daddr map { 1.2.3.4 : "dns", 5.6.7.8 : "dns", 192.168.8.0/24 : "dns" }
+		ct timeout set ip daddr map { 1.2.3.4-1.2.3.8 : "dns" }
+		ct timeout set ip6 daddr map { 1ce::/64 : "dns", dead::beef : "dns" }
+		ct helper @helpname accept
+		ip saddr 192.168.1.1 ct timeout set "dns"
+	}
+}
diff --git a/tests/shell/testcases/maps/named_ct_objects b/tests/shell/testcases/maps/named_ct_objects
new file mode 100755
index 000000000000..61b87c1ab14a
--- /dev/null
+++ b/tests/shell/testcases/maps/named_ct_objects
@@ -0,0 +1,94 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_cttimeout)
+
+$NFT -f /dev/stdin <<EOF || exit 1
+table inet t {
+	ct expectation exp1 {
+		protocol tcp
+		dport 9876
+		timeout 1m
+		size 12
+		l3proto ip
+	}
+
+	ct expectation exp2 {
+		protocol tcp
+		dport 9876
+		timeout 3s
+		size 13
+		l3proto ip6
+	}
+
+	ct helper myftp {
+		type "ftp" protocol tcp
+	}
+
+	ct timeout dns {
+		protocol tcp
+		l3proto ip
+		policy = { established : 3, close : 1 }
+	}
+
+	map exp {
+		typeof ip saddr : ct expectation
+		elements = { 192.168.2.2 : "exp1" }
+	}
+
+	map exp6 {
+		typeof ip6 saddr : ct expectation
+		flags interval
+		elements = { dead:beef::/64 : "exp2" }
+	}
+
+	map helpobj {
+		typeof ip6 saddr : ct helper
+		flags interval
+		elements = { dead:beef::/64 : "myftp" }
+	}
+
+	map timeoutmap {
+		typeof ip daddr : ct timeout
+		elements = { 192.168.0.1 : "dns" }
+	}
+
+	set helpname {
+		typeof ct helper
+		elements = { "ftp", "sip" }
+	}
+
+	chain y {
+		ct expectation set ip saddr map @exp
+		ct expectation set ip6 saddr map { dead::beef : "exp2" }
+		ct expectation set ip6 daddr map { dead::beef : "exp2", feed::17 : "exp2" }
+		ct expectation set ip6 daddr . tcp dport map { dead::beef . 123 : "exp2", feed::17 . 512 : "exp2" }
+		ct helper set ip6 saddr map { dead::beef : "myftp", 1c3::c01d : "myftp" }
+		ct helper set ip6 saddr map @helpobj
+		ct timeout set ip daddr map @timeoutmap
+		ct timeout set ip daddr map { 1.2.3.4 : "dns", 5.6.7.8 : "dns", 192.168.8.0/24 : "dns" }
+		ct timeout set ip daddr map { 1.2.3.4-1.2.3.8 : "dns" }
+		ct timeout set ip6 daddr map { dead::beef : "dns", 1ce::/64 : "dns" }
+		ct helper @helpname accept
+	}
+}
+EOF
+
+must_fail()
+{
+	echo "Command should have failed: $1"
+	exit 111
+}
+
+
+must_work()
+{
+	echo "Command should have succeeded: $1"
+	exit 111
+}
+
+$NFT 'add rule inet t y ip saddr 192.168.1.1 ct timeout set "dns"' || must_work "dns timeout"
+
+$NFT 'add rule inet t y ct helper set ip saddr map @helpobj' && must_fail "helper assignment, map key is ipv6_addr"
+$NFT 'add rule inet t y ct helper set ip6 saddr map @helpname' && must_fail "helper assignment, not a map with objects"
+
+exit 0
-- 
2.43.0

