Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F21C86250
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Jan 2026 06:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769408702; cv=none; b=fYLYJxWfn1kpvsE01Q7YdCJnNAKzjBjK1jeQspcV3oN5gcE294Q5+fOMs7hL8TVbbA5fmYAzf9kGwpFZM0D90XKDT5Teo+3Qe+b3ngjv2HoGqhkiGDJ8wyYo8BHKS6/x0tyAKtxEr7obcQ/pQ9zJdVhibsfaPP7YVKe5s/3DD8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769408702; c=relaxed/simple;
	bh=+OHzu5SMxqiLn3umwg6MCM6Ry7psPy1W/fhr/kNjdhQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Ip005agBJDzinsZXNMP/Fc5dPqw18ESEBDKqKzsTHw82+dwlFbQcmXJoGkKRCUnCYB5QGqY4uMIo56bZFdPR963WtNeolzKuyiahaxfjKOY0gSZVHy8BWBeu86FfCWa+QrcRXxmjB4HLq+SVztMQXjUAdlWbIJEcxUlxFDI0cuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=eGpjeUj+; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="eGpjeUj+"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id 09839491F
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Jan 2026 07:18:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769408284;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=35H1aW4/kxcpDlP3sgQYzzATJKNb8/Xo3oljl5vQBuo=;
	b=eGpjeUj+//LtC3ItGRiA9xKUx83K2zMiMd+J+bmA7eMNxZIt7+Dzdppb9WOamzZE
	xTZl1WqKi5N1IIoyqeVk0uI1+Thlp7iC/ZJQpR1CcgtVK3jyyXKFnrp9Bz0nEaK+CiK
	mDrn1nWO/3UR5VWcE6aFDi9hOogKaPY2zzFZ/BIMgR3PERieUDIVr7KsFOlCClYnl7A
	gXkVZKT0Gm7UzZcJ2aleNSyl3C2qF2NI/BpmvtRycktHugDJcT7arF6DXKuePzMAVrm
	TLnuCZlhMTVyE0UDrpuumIWt6v/vafvWEo8dg8/YT9K7wVnQoqO17gJ6iQGP3Sw36XI
	G0tJYlc3kw==
Received: by smtp.mailfence.com with ESMTPSA
          for <netfilter-devel@vger.kernel.org> ; Mon, 26 Jan 2026 07:18:01 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] datatype: fix ether address parsing of integer values
Date: Mon, 26 Jan 2026 00:17:41 -0600
Message-ID: <20260126061746.368011-1-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

When parsing "ether daddr 0x64", integer_expr converts the hex value
to decimal string "100". lladdr_type_parse then interprets this as
hex, yielding 0x100 = 256 which exceeds the single-byte limit.

Values below 0x64 (100) worked because their decimal representation
happens to be valid hex under 256.

Fix by detecting integer strings (no colons, known size) and parsing
as base-0 to handle both decimal and hex input correctly.

Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1824
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
---
 src/datatype.c                                | 17 ++++++++
 .../testcases/nft-f/0033ether_addr_hex_0      | 42 +++++++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100755 tests/shell/testcases/nft-f/0033ether_addr_hex_0

diff --git a/src/datatype.c b/src/datatype.c
index 18973851..d7817ef2 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -581,6 +581,23 @@ static struct error_record *lladdr_type_parse(struct parse_ctx *ctx,
 	const char *s = sym->identifier;
 	unsigned int len, n;
 
+	if (sym->dtype->size && !strchr(s, ':')) {
+		unsigned int size = sym->dtype->size / BITS_PER_BYTE;
+		uint64_t val;
+
+		errno = 0;
+		val = strtoull(s, &p, 0);
+		if (!errno && !*p && !(val >> (size * 8))) {
+			for (n = 0; n < size; n++)
+				buf[size - n - 1] = (val >> (n * 8)) & 0xff;
+
+			*res = constant_expr_alloc(&sym->location, sym->dtype,
+						   BYTEORDER_BIG_ENDIAN,
+						   sym->dtype->size, buf);
+			return NULL;
+		}
+	}
+
 	for (len = 0;;) {
 		n = strtoul(s, &p, 16);
 		if (s == p || n > 0xff)
diff --git a/tests/shell/testcases/nft-f/0033ether_addr_hex_0 b/tests/shell/testcases/nft-f/0033ether_addr_hex_0
new file mode 100755
index 00000000..149b8f52
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0033ether_addr_hex_0
@@ -0,0 +1,42 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table inet t {
+	chain c {
+		ether daddr 0x0 accept
+		ether daddr 0x64 accept
+		ether daddr 0xff accept
+		ether daddr 0x100 accept
+		ether daddr 0xffffffffffff accept
+		ether daddr aa accept
+		ether saddr de:ad:be:ef:00:01 accept
+	}
+}"
+
+EXPECTED="table inet t {
+	chain c {
+		ether daddr 00:00:00:00:00:00 accept
+		ether daddr 00:00:00:00:00:64 accept
+		ether daddr 00:00:00:00:00:ff accept
+		ether daddr 00:00:00:00:01:00 accept
+		ether daddr ff:ff:ff:ff:ff:ff accept
+		ether daddr 00:00:00:00:00:aa accept
+		ether saddr de:ad:be:ef:00:01 accept
+	}
+}"
+
+$NFT -f - <<< "$RULESET"
+
+GET="$($NFT list ruleset)"
+
+if [ "$EXPECTED" != "$GET" ] ; then
+	$DIFF -u <(echo "$EXPECTED") <(echo "$GET")
+	exit 1
+fi
+
+# overflow must fail
+if $NFT add rule inet t c ether daddr 0x1000000000000 accept 2>/dev/null; then
+	echo "FAIL: overflow not rejected" >&2
+	exit 1
+fi
-- 
2.47.3

