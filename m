Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BEE1CD3F
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Mar 2025 12:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741956163; cv=none; b=MFdw+ddaytqmCIEz/3rjKehrLGHauzVgFCXebQyzz8ZIQj3s4uogpDS4YfUObICb7UZ2d09EefNHGt580yDF05Vh/ja6P17+iKJgC4+RYCf9M+wpYjBcOzFwGiiMbAWiH4jhNI8TgJYrXU0tAF8bP4ZxO8P4N05ragPsMm8vbDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741956163; c=relaxed/simple;
	bh=iD+MgR69CoDyku/9TsJF6tBuNK3jCMEv/I5vWM+HX4U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OlHAwwgjoW8AMxpmRJZkbc0DN/Z+GtrA+ZATMUIBWODgdTLNa20YwbrePjRQ955jWlfFkgSUCr6QMB6i9j8WRGCS6s/nTmdTppeJ9WrrfQ/U0V25QWDyIhK5WBb1TdeEGjAzxHV5Z98HqLB204PRjOWlFbDaeLo8tyy/GvLhhoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tt4N4-0006a2-FX; Fri, 14 Mar 2025 13:42:38 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] netlink: fix stack buffer overrun when emitting ranged expressions
Date: Fri, 14 Mar 2025 13:41:49 +0100
Message-ID: <20250314124159.2131-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Included bogon input generates following Sanitizer splat:

AddressSanitizer: dynamic-stack-buffer-overflow on address 0x7...
WRITE of size 2 at 0x7fffffffcbe4 thread T0
    #0 0x0000003a68b8 in __asan_memset (src/nft+0x3a68b8) (BuildId: 3678ff51a5405c77e3e0492b9a985910efee73b8)
    #1 0x0000004eb603 in __mpz_export_data src/gmputil.c:108:2
    #2 0x0000004eb603 in netlink_export_pad src/netlink.c:256:2
    #3 0x0000004eb603 in netlink_gen_range src/netlink.c:471:2
    #4 0x0000004ea250 in __netlink_gen_data src/netlink.c:523:10
    #5 0x0000004e8ee3 in alloc_nftnl_setelem src/netlink.c:205:3
    #6 0x0000004d4541 in mnl_nft_setelem_batch src/mnl.c:1816:11

Problem is that the range end is emitted to the buffer at the *padded*
location (rounded up to next register size), but buffer sizing is
based of the expression length, not the padded length.

Also extend the test script: Capture stderr and if we see
AddressSanitizer warning, make it fail.

Same bug as the one fixed in 600b84631410 ("netlink: fix stack buffer overflow with sub-reg sized prefixes"),
just in a different function.

Apply same fix: no dynamic array + add a length check.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c                                   | 11 +++++++----
 tests/shell/testcases/bogons/assert_failures    | 17 ++++++++++++++++-
 ...an_stack_buffer_overrun_in_netlink_gen_range |  6 ++++++
 3 files changed, 29 insertions(+), 5 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/asan_stack_buffer_overrun_in_netlink_gen_range

diff --git a/src/netlink.c b/src/netlink.c
index 8e6e2066fe2a..52c2d8009b82 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -462,11 +462,14 @@ static void netlink_gen_verdict(const struct expr *expr,
 static void netlink_gen_range(const struct expr *expr,
 			      struct nft_data_linearize *nld)
 {
-	unsigned int len = div_round_up(expr->left->len, BITS_PER_BYTE) * 2;
-	unsigned char data[len];
-	unsigned int offset = 0;
+	unsigned int len = (netlink_padded_len(expr->left->len) / BITS_PER_BYTE) * 2;
+	unsigned char data[NFT_MAX_EXPR_LEN_BYTES];
+	unsigned int offset;
 
-	memset(data, 0, len);
+	if (len > sizeof(data))
+		BUG("Value export of %u bytes would overflow", len);
+
+	memset(data, 0, sizeof(data));
 	offset = netlink_export_pad(data, expr->left->value, expr->left);
 	netlink_export_pad(data + offset, expr->right->value, expr->right);
 	nft_data_memcpy(nld, data, len);
diff --git a/tests/shell/testcases/bogons/assert_failures b/tests/shell/testcases/bogons/assert_failures
index 79099427c98a..3dee63b3f97b 100755
--- a/tests/shell/testcases/bogons/assert_failures
+++ b/tests/shell/testcases/bogons/assert_failures
@@ -1,12 +1,27 @@
 #!/bin/bash
 
 dir=$(dirname $0)/nft-f/
+tmpfile=$(mktemp)
+
+cleanup()
+{
+	rm -f "$tmpfile"
+}
+
+trap cleanup EXIT
 
 for f in $dir/*; do
-	$NFT --check -f "$f"
+	echo "Check $f"
+	$NFT --check -f "$f" 2> "$tmpfile"
 
 	if [ $? -ne 1 ]; then
 		echo "Bogus input file $f did not cause expected error code" 1>&2
 		exit 111
 	fi
+
+	if grep AddressSanitizer "$tmpfile"; then
+		echo "Address sanitizer splat for $f" 1>&2
+		cat "$tmpfile"
+		exit 111
+	fi
 done
diff --git a/tests/shell/testcases/bogons/nft-f/asan_stack_buffer_overrun_in_netlink_gen_range b/tests/shell/testcases/bogons/nft-f/asan_stack_buffer_overrun_in_netlink_gen_range
new file mode 100644
index 000000000000..2f7872e4accd
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/asan_stack_buffer_overrun_in_netlink_gen_range
@@ -0,0 +1,6 @@
+table ip test {
+        chain y {
+                redirect to :tcp dport map { 83 : 80/3, 84 :4 }
+        }
+}
+
-- 
2.45.3

