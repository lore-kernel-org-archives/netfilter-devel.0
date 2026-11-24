Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795505708;
	b=bhWYxkEHxpaSSdgT+eKrt/h6LBLSJ/ZeFWyFutT/EqfUSxE66cC4NEvTL7gOJex6C02g
	 zcmPnxQdBj1wv19UN/yOSGzquDzRlR2jLOkuqRTonBvpIWRZG2dg+giBMq3q2YQOrG0Gc
	 /CVsbSHRYFMHPgczkRWWZeMbmQrXknDgNmIppyz2HmBVDQnXJkczhhTL4LsoBGfEA9jcm
	 rgoTQHxT/bmsttxYQaG4DyMg1U4U9bN20OXjgAqIpUMWRnT2ieL7J2ejls1z9pL7bhFvb
	 fsO2WLw/mj+514MdUkR4uz0tSUffpFQ+esDXof42PJKyZlUWiZ6MzL+bSzIsmykH6JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795505708;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Zg3OYvyYgIIQt0yqgvnkicFlZsIbXlhS6WotBdiihcc=;
	b=ep1/DcPUHApFqR26vWfWFpeRVp/qlTYA+VpUBrN3Y1+yJR/xH3or7gAWU26BDlIcxSI9
	 IBOOiCB3f7t5Gd+tHAl/27hq88rFAYhvnewKi10oapF1B+U7v3daXwe4C3jZyalAjtxRA
	 XQiQyHNg5YdZLOPh8wCwmvmnTHkjs9CYkrC8I2ugyGJwOkwHcWBWCbRvxpQBdrdsu/qMJ
	 TA9q6ha79fzp0xLwKkhgnqBYlxvPHuwF8fbNBHOWZ5bYbfbn7oVw3V5288B0cfDX/aJc7
	 iaReVMHnHWKXukcMdc5svMXUFxIjjG0TLk32yKGJFkR0v+QwME9tNIzMTTZfh8GhDDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b="Abq5Tj/g";
	arc=none smtp.remote-ip=162.62.57.210
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E4D606A339
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 07:35:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2E4D606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=Abq5Tj/g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795505697; bh=Zg3OYvyYgIIQt0yqgvnkicFlZsIbXlhS6WotBdiihcc=;
	h=From:To:Cc:Subject:Date;
	b=Abq5Tj/gHhGrQP9rW1g3wVFG8iy+wncNficy5EBoHfORWV/flzfoyepC6g6R+WRMC
	 JHiwcWmec8/rmSGUaCnuMRNv6lsSVewlgmew0PyM5G2hJ4/G4r47+ICYaXFuwRKjwt
	 WVWiqG4/uzFC26pljEQAk6q7w6jm9gpv8LHqJDBI=
Received: from localhost.localdomain ([182.239.88.62])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 8B681640; Tue, 24 Nov 2026 15:34:54 +0800
X-QQ-mid: xmsmtpt1795505694t8uifanfa
Message-ID: <tencent_3705C873E3E6E120BF70664ED16960967905@qq.com>
X-QQ-XMAILINFO: M/M2SMd6THQP8lYbjORLt4kWwubd5WeO2Q9nGUSEZh9Vjqay01LMTCfujUMxI0
	 loLF2/kanA8p+q50ej2clp9p34Qi//ezc05ug3MkUt4LjKJhKSdx/IuxvQu8adsXtSzA8Gt07ibJ
	 Mjim6NLyXXRf8rCwLU3QHZDpKgl0vYOrLcNOya4nGsSq3N31rBvrTLO+wY1LaCs7RWSzQcgswjtZ
	 dMFK0NSNjaaIvhmLoQkBc8nTUMlqRmK/M91HwjL9tUEY1flG6UkRuDBQZAhSIyfmY0NEXsE5MMYv
	 5KEl2/WcJph48GwB+jQGBWy8nQP+7B0Afk49ot5bqt1PLyyU0sKD11yBIMhsXHSPmoWIs7HNY5xn
	 4BF8ZzBQSIjl2rt7OZVRNA7vyCF0iLKNlZOA3AiqSpKc082e2FhYVLOwFHhtjTtjDZ5RwSnuHIUM
	 5K/9lZaGWaNz5EP3Plm+u3cCOCWRmeq7bExfiZH/p5iLxGralsFlhTJ3eLfthjawxcrC2noiMJ40
	 x1xEGzXJkggMg9HNp+SonDwnw5EF/ptMJ7EjR1xYIgMC8gIPz2z86TrtU2Wr8DJwRhB6py4cqq0h
	 4EKdJ5jp0pxFpEex/51U9N99oy/3nX9vKD8pR4hqu6uruDYL3wDFD0aL3uX2JD7TJxsb4cxAaKQv
	 +lndMrOyvS5G6A3scPiNrVHPbs32z0Bx8uH4iO/KM9fqAVSAthvCp3ua7j/UvM++tPb7eD9xSSbK
	 nN7X43RCp4svu+3qea2lbTgB2Y4nq/JZL6GgnYEFqPQbYQ+ljAJ1K4TaGU2Yuaf5ONCt8bl01nX4
	 P2MCDWM9+t2MN59GmQhcLsS6Jx0Udx1KGNmm94ATacMq2hpCdYg/pMuCN8ZrEuBlYg2BugEv0xtz
	 GoxRi0hbDd6wbAw3SMNm+8tvLcRjQvgABsdmSy1cDXJQWDTAW74na1CcEhQ1YQblTyVO0KMDBB9D
	 R7C0t62/ZY4rGFMwTckx9B5vTZqpW1vcwYfodAfi2s3f30ddPGNevENUj0LOQhpYJyWY4LBkSW4H
	 FjfriAS8WXlda7+4NBWe8n4YwhBry8oMgNx6wK3P4wpdrnlbt9HP+jDcs2nbChOGrLtSn1gy22sz
	 ZQ74pmaq978v57arIOkQQKcw7DtQ==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Ma Xinmeng <1564938642@qq.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] tests: shell: add dormant table adoption regression test
Date: Tue, 24 Nov 2026 15:34:29 +0800
X-OQ-MSGID: <20261124073437.1906-1-1564938642@qq.com>
X-Mailer: git-send-email 2.49.0.windows.1
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

Add a regression test for re-owning an already dormant PERSIST table.
The test creates a dormant PERSIST OWNER table, lets the owning nft
process exit so the table becomes an orphan, adds a basechain while the
table is still dormant, and re-owns the orphan.

This exercises the kernel path fixed by "netfilter: nf_tables: only
disable tables on a dormant transition". The test only issues the three
nft commands; run-tests.sh already checks whether the kernel was tainted.

Signed-off-by: Ma Xinmeng <1564938642@qq.com>
---
 .../shell/testcases/transactions/0052dormant_table_adopt_0 | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/0052dormant_table_adopt_0

diff --git a/tests/shell/testcases/transactions/0052dormant_table_adopt_0 b/tests/shell/testcases/transactions/0052dormant_table_adopt_0
new file mode 100755
index 0000000..73ae4f2
--- /dev/null
+++ b/tests/shell/testcases/transactions/0052dormant_table_adopt_0
@@ -0,0 +1,7 @@
+#!/bin/bash
+
+set -e
+
+$NFT add table ip t '{ flags dormant,persist,owner; }'
+$NFT add chain ip t c '{ type filter hook output priority 0; }'
+$NFT add table ip t '{ flags dormant,persist,owner; }'
-- 
2.56.0.windows.4.niugit

