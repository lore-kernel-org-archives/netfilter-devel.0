Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAF920C03E
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Jun 2025 22:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749162051; cv=none; b=gWSvdJgMzAFsCbuQh755ZZrWptSMTSFbJ2e3+hkq+is7qkSCs/9XXcs+25LfJOTeqFCuRdcjSal4uCjAaLnaICyy+IBjuONEcDgaaaNl6ZQkmGDcWVnQQxiKnWSxm3AHuELelCdGKTTziHsI0izRnLH0rWWdDIBqhi/zBwc7V6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749162051; c=relaxed/simple;
	bh=sl2skgwPHh6gvI2en7PO/+6Zb9VT4NS/Awdo46Dqxww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=asdreuXlx6H9zrKQBtM5P02eFBUSKyayw/ZyJ+wiACYdLOoa6K9VV3bC3/PT+vvlLhMz1STJ84wR61SBsoFasNdjgvvMcYBirQEi2hWQcs8QPyYMyy7p8vFj7wIoXpL48uOA8J8UxfpZeH3xojtPwlnfRK+KrEGdwuciH3wx/a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 275AF60A0A; Fri,  6 Jun 2025 00:20:47 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [nft] mnl: catch bogus expressions before crashing
Date: Fri,  6 Jun 2025 00:20:28 +0200
Message-ID: <20250605222039.31719-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We can't recover from errors here, but we can abort with a more
precise reason than 'segmentation fault', or stack corruptions
that get caught way later, or not at all.

expr->value is going to be read, we can't cope with other expression
types here.

We will copy to stack buffer of IFNAMSIZ size, abort if we would
overflow.

Check there is a NUL byte present too.
This is a preemptive patch, I've seen one crash in this area but
no reproducer yet.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/mnl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index 64b1aaedb84c..6565341fa6e3 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -732,9 +732,20 @@ static void nft_dev_add(struct nft_dev *dev_array, const struct expr *expr, int
 	unsigned int ifname_len;
 	char ifname[IFNAMSIZ];
 
+	if (expr->etype != EXPR_VALUE)
+		BUG("Must be a value, not %s\n", expr_name(expr));
+
 	ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
 	memset(ifname, 0, sizeof(ifname));
+
+	if (ifname_len > sizeof(ifname))
+		BUG("Interface length %u exceeds limit\n", ifname_len);
+
 	mpz_export_data(ifname, expr->value, BYTEORDER_HOST_ENDIAN, ifname_len);
+
+	if (strnlen(ifname, IFNAMSIZ) >= IFNAMSIZ)
+		BUG("Interface length %zu exceeds limit, no NUL byte\n", strnlen(ifname, IFNAMSIZ));
+
 	dev_array[i].ifname = xstrdup(ifname);
 	dev_array[i].location = &expr->location;
 }
-- 
2.49.0

