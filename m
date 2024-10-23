Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E888A1E51D
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 20:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729714028; cv=none; b=TVleR/8X8PZ4q6X2d9BB4QRS+lIWh/72byucm8xz1QDAmHFFBDwTnBKnT2IE5AN0mngZXl/a+rWBpOidUoVElck7JykFtNf9Uvv+qmfFJ+RKcBnY8QTgy71v2gsHWQIeKursMaVyTlE9MkCdldic5kWrn2tzgM0az8R08kwM3co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729714028; c=relaxed/simple;
	bh=NUebTff7U3dr/2ftbs8iGVGVAID8Lpp3NTKa/9VaC6k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rLKSewNdfVhoWY6MJH6OlNJQdsrUPNVt1MwwyqS+8AdZwh4Pif+xRh2WYsLbk7jlZe3fEimn/pveq4puWQluhLeCfCemVwWQTdi7jNiGEqOuVsMtIn7LLcGf/nD1ysb/POxYnAhcP0qwdeA/teX/5X2QhtusTggzFSg9PvXZ1B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XNWsZh3C; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XNWsZh3C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jUC0PIKUZ2BmwQgWUoTcWlyVPN7KHEgX436NHB4qFes=; b=XNWsZh3Com/il/XDDz/kxIi+v2
	salSWqr2/idDkgmqmenWklfrEyEnof6PRw1ttrgVbGrGxHZbKScsCITfJ24fAhguzaNoQdYe4E5UC
	BYN6oGZS8SZ1C009ssx6TM8qy660AbeaMr6EVwAwpH1g5h4MLruDcjwGpyteDP5FB50p96PXA5Lup
	Sw2SUaIjfxvW1CUlgPHfNJJzStZBKKqvYsUtnx0ygnxZOO9cg9PeCwRODB6mPiymEmhx/Dk/kkKxs
	6LTBR1NmM4L0F1Pb++LtFDN3n5Psk4YbUmKegSLFbetVm21ab1J/pknOQVaKkS9gttGTvjDZcwHTb
	3C9dYJjg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3hdE-000000000h6-37ho;
	Wed, 23 Oct 2024 22:07:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <ej@inai.de>
Subject: [libnftnl PATCH] Use SPDX License Identifiers in headers
Date: Wed, 23 Oct 2024 22:06:57 +0200
Message-ID: <20241023200658.24205-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Replace the copyright notice in header comments by an equivalent
SPDX-License-Identifier string. Drop a following empty line if at the
bottom of the comment. Leave any other header comment content in place.

This also fixes for an incomplete notice in examples/nft-ruleset-get.c
since commit c335442eefcca ("src: incorrect header refers to GPLv2
only").

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 examples/nft-chain-add.c               | 5 +----
 examples/nft-chain-del.c               | 5 +----
 examples/nft-chain-get.c               | 5 +----
 examples/nft-compat-get.c              | 5 +----
 examples/nft-ct-expectation-add.c      | 5 +----
 examples/nft-ct-expectation-del.c      | 5 +----
 examples/nft-ct-expectation-get.c      | 5 +----
 examples/nft-ct-helper-add.c           | 5 +----
 examples/nft-ct-helper-del.c           | 5 +----
 examples/nft-ct-helper-get.c           | 5 +----
 examples/nft-ct-timeout-add.c          | 5 +----
 examples/nft-ct-timeout-del.c          | 5 +----
 examples/nft-ct-timeout-get.c          | 5 +----
 examples/nft-events.c                  | 5 +----
 examples/nft-map-add.c                 | 5 +----
 examples/nft-obj-add.c                 | 5 +----
 examples/nft-obj-del.c                 | 5 +----
 examples/nft-obj-get.c                 | 5 +----
 examples/nft-rule-add.c                | 5 +----
 examples/nft-rule-ct-expectation-add.c | 5 +----
 examples/nft-rule-ct-helper-add.c      | 5 +----
 examples/nft-rule-ct-timeout-add.c     | 5 +----
 examples/nft-rule-del.c                | 5 +----
 examples/nft-rule-get.c                | 5 +----
 examples/nft-ruleset-get.c             | 5 +----
 examples/nft-set-add.c                 | 5 +----
 examples/nft-set-del.c                 | 5 +----
 examples/nft-set-elem-add.c            | 5 +----
 examples/nft-set-elem-del.c            | 5 +----
 examples/nft-set-elem-get.c            | 5 +----
 examples/nft-set-get.c                 | 5 +----
 examples/nft-table-add.c               | 5 +----
 examples/nft-table-del.c               | 5 +----
 examples/nft-table-get.c               | 5 +----
 examples/nft-table-upd.c               | 5 +----
 src/batch.c                            | 5 +----
 src/chain.c                            | 5 +----
 src/common.c                           | 5 +----
 src/expr.c                             | 5 +----
 src/expr/bitwise.c                     | 5 +----
 src/expr/byteorder.c                   | 5 +----
 src/expr/cmp.c                         | 5 +----
 src/expr/connlimit.c                   | 5 +----
 src/expr/counter.c                     | 5 +----
 src/expr/ct.c                          | 5 +----
 src/expr/data_reg.c                    | 5 +----
 src/expr/dup.c                         | 5 +----
 src/expr/dynset.c                      | 5 +----
 src/expr/exthdr.c                      | 5 +----
 src/expr/fib.c                         | 5 +----
 src/expr/fwd.c                         | 5 +----
 src/expr/hash.c                        | 6 +-----
 src/expr/immediate.c                   | 5 +----
 src/expr/inner.c                       | 5 +----
 src/expr/last.c                        | 5 +----
 src/expr/limit.c                       | 5 +----
 src/expr/log.c                         | 5 +----
 src/expr/lookup.c                      | 5 +----
 src/expr/masq.c                        | 5 +----
 src/expr/match.c                       | 5 +----
 src/expr/meta.c                        | 5 +----
 src/expr/nat.c                         | 5 +----
 src/expr/numgen.c                      | 6 +-----
 src/expr/objref.c                      | 5 +----
 src/expr/payload.c                     | 5 +----
 src/expr/queue.c                       | 6 +-----
 src/expr/quota.c                       | 5 +----
 src/expr/range.c                       | 5 +----
 src/expr/redir.c                       | 5 +----
 src/expr/reject.c                      | 5 +----
 src/expr/rt.c                          | 5 +----
 src/expr/socket.c                      | 5 +----
 src/expr/target.c                      | 5 +----
 src/expr/tproxy.c                      | 5 +----
 src/expr/tunnel.c                      | 5 +----
 src/expr/xfrm.c                        | 5 +----
 src/gen.c                              | 5 +----
 src/obj/counter.c                      | 5 +----
 src/obj/ct_expect.c                    | 5 +----
 src/obj/ct_helper.c                    | 5 +----
 src/obj/ct_timeout.c                   | 5 +----
 src/obj/limit.c                        | 5 +----
 src/obj/quota.c                        | 5 +----
 src/obj/secmark.c                      | 5 +----
 src/obj/tunnel.c                       | 5 +----
 src/object.c                           | 5 +----
 src/rule.c                             | 5 +----
 src/ruleset.c                          | 5 +----
 src/set.c                              | 5 +----
 src/set_elem.c                         | 5 +----
 src/table.c                            | 5 +----
 src/trace.c                            | 5 +----
 src/udata.c                            | 5 +----
 src/utils.c                            | 5 +----
 tests/nft-chain-test.c                 | 6 +-----
 tests/nft-expr_bitwise-test.c          | 5 +----
 tests/nft-expr_byteorder-test.c        | 6 +-----
 tests/nft-expr_cmp-test.c              | 6 +-----
 tests/nft-expr_counter-test.c          | 6 +-----
 tests/nft-expr_ct-test.c               | 6 +-----
 tests/nft-expr_dup-test.c              | 6 +-----
 tests/nft-expr_exthdr-test.c           | 6 +-----
 tests/nft-expr_fwd-test.c              | 6 +-----
 tests/nft-expr_hash-test.c             | 6 +-----
 tests/nft-expr_immediate-test.c        | 6 +-----
 tests/nft-expr_limit-test.c            | 6 +-----
 tests/nft-expr_log-test.c              | 6 +-----
 tests/nft-expr_lookup-test.c           | 6 +-----
 tests/nft-expr_masq-test.c             | 6 +-----
 tests/nft-expr_match-test.c            | 6 +-----
 tests/nft-expr_meta-test.c             | 6 +-----
 tests/nft-expr_nat-test.c              | 6 +-----
 tests/nft-expr_numgen-test.c           | 6 +-----
 tests/nft-expr_objref-test.c           | 6 +-----
 tests/nft-expr_payload-test.c          | 6 +-----
 tests/nft-expr_queue-test.c            | 6 +-----
 tests/nft-expr_quota-test.c            | 6 +-----
 tests/nft-expr_range-test.c            | 6 +-----
 tests/nft-expr_redir-test.c            | 6 +-----
 tests/nft-expr_reject-test.c           | 6 +-----
 tests/nft-expr_target-test.c           | 6 +-----
 tests/nft-object-test.c                | 6 +-----
 tests/nft-rule-test.c                  | 6 +-----
 tests/nft-set-test.c                   | 6 +-----
 tests/nft-table-test.c                 | 6 +-----
 125 files changed, 125 insertions(+), 533 deletions(-)

diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
index 13be982324180..fc2e939dae8b4 100644
--- a/examples/nft-chain-add.c
+++ b/examples/nft-chain-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-chain-del.c b/examples/nft-chain-del.c
index 3cd483ea6c027..ea10a8aed97c3 100644
--- a/examples/nft-chain-del.c
+++ b/examples/nft-chain-del.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-chain-get.c b/examples/nft-chain-get.c
index 612f58be7553c..57835e55d393c 100644
--- a/examples/nft-chain-get.c
+++ b/examples/nft-chain-get.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-compat-get.c b/examples/nft-compat-get.c
index 8f00cbf5b8242..657cf1b30f50a 100644
--- a/examples/nft-compat-get.c
+++ b/examples/nft-compat-get.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-ct-expectation-add.c b/examples/nft-ct-expectation-add.c
index d9b9cdb2f68b8..34a80670e3b58 100644
--- a/examples/nft-ct-expectation-add.c
+++ b/examples/nft-ct-expectation-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <time.h>
diff --git a/examples/nft-ct-expectation-del.c b/examples/nft-ct-expectation-del.c
index 67dbd4777ed03..802b5680dcd67 100644
--- a/examples/nft-ct-expectation-del.c
+++ b/examples/nft-ct-expectation-del.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-ct-expectation-get.c b/examples/nft-ct-expectation-get.c
index 12c1350024c6a..653eaf435728c 100644
--- a/examples/nft-ct-expectation-get.c
+++ b/examples/nft-ct-expectation-get.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-ct-helper-add.c b/examples/nft-ct-helper-add.c
index 397443ba74db3..ae5c8109c82b3 100644
--- a/examples/nft-ct-helper-add.c
+++ b/examples/nft-ct-helper-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-ct-helper-del.c b/examples/nft-ct-helper-del.c
index fda3026cd69b9..30c3269a086c4 100644
--- a/examples/nft-ct-helper-del.c
+++ b/examples/nft-ct-helper-del.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-ct-helper-get.c b/examples/nft-ct-helper-get.c
index 34134af196a83..33a3bf557801f 100644
--- a/examples/nft-ct-helper-get.c
+++ b/examples/nft-ct-helper-get.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-ct-timeout-add.c b/examples/nft-ct-timeout-add.c
index 4c2052ea75cc6..6ee2827de6ec7 100644
--- a/examples/nft-ct-timeout-add.c
+++ b/examples/nft-ct-timeout-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-ct-timeout-del.c b/examples/nft-ct-timeout-del.c
index 4581c3986fda7..def48c8045fcb 100644
--- a/examples/nft-ct-timeout-del.c
+++ b/examples/nft-ct-timeout-del.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-ct-timeout-get.c b/examples/nft-ct-timeout-get.c
index 18aed52e987e4..1c85c217645b2 100644
--- a/examples/nft-ct-timeout-get.c
+++ b/examples/nft-ct-timeout-get.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-events.c b/examples/nft-events.c
index 8aab90a118242..ee2b7709fc236 100644
--- a/examples/nft-events.c
+++ b/examples/nft-events.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-map-add.c b/examples/nft-map-add.c
index e5ce664af6b5b..8c38085e18808 100644
--- a/examples/nft-map-add.c
+++ b/examples/nft-map-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-obj-add.c b/examples/nft-obj-add.c
index f526b3c085772..1cb6769e549cc 100644
--- a/examples/nft-obj-add.c
+++ b/examples/nft-obj-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-obj-del.c b/examples/nft-obj-del.c
index ae4f703146180..b582240e7355b 100644
--- a/examples/nft-obj-del.c
+++ b/examples/nft-obj-del.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-obj-get.c b/examples/nft-obj-get.c
index e560ed008f848..385208e019ede 100644
--- a/examples/nft-obj-get.c
+++ b/examples/nft-obj-get.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 7d13b92f6ef55..19915544554fe 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-rule-ct-expectation-add.c b/examples/nft-rule-ct-expectation-add.c
index 07c8306d9154c..377eb68a6de14 100644
--- a/examples/nft-rule-ct-expectation-add.c
+++ b/examples/nft-rule-ct-expectation-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-rule-ct-helper-add.c b/examples/nft-rule-ct-helper-add.c
index 594e6ba8e6ddc..a9d92bb93d215 100644
--- a/examples/nft-rule-ct-helper-add.c
+++ b/examples/nft-rule-ct-helper-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-rule-ct-timeout-add.c b/examples/nft-rule-ct-timeout-add.c
index 0953cb4a396f1..b89918aa84316 100644
--- a/examples/nft-rule-ct-timeout-add.c
+++ b/examples/nft-rule-ct-timeout-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-rule-del.c b/examples/nft-rule-del.c
index cb085ff10b3bb..15bfaaaf22223 100644
--- a/examples/nft-rule-del.c
+++ b/examples/nft-rule-del.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-rule-get.c b/examples/nft-rule-get.c
index 8da5b59ae372c..be85639fea5db 100644
--- a/examples/nft-rule-get.c
+++ b/examples/nft-rule-get.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-ruleset-get.c b/examples/nft-ruleset-get.c
index 34ebe1fb6155c..269f469734b1d 100644
--- a/examples/nft-ruleset-get.c
+++ b/examples/nft-ruleset-get.c
@@ -5,10 +5,7 @@
  *
  * Copyright (c) 2013 Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-set-add.c b/examples/nft-set-add.c
index 109e33a75ac0e..821a85c2878f1 100644
--- a/examples/nft-set-add.c
+++ b/examples/nft-set-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-set-del.c b/examples/nft-set-del.c
index 5e8dea975a739..dfee6ba4402b2 100644
--- a/examples/nft-set-del.c
+++ b/examples/nft-set-del.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-set-elem-add.c b/examples/nft-set-elem-add.c
index 4b8b37c086a43..4df8d3ff0ca4a 100644
--- a/examples/nft-set-elem-add.c
+++ b/examples/nft-set-elem-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-set-elem-del.c b/examples/nft-set-elem-del.c
index 1e6c90df81687..aeb1efc19514b 100644
--- a/examples/nft-set-elem-del.c
+++ b/examples/nft-set-elem-del.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-set-elem-get.c b/examples/nft-set-elem-get.c
index 7f99a602b0317..97d47708c4bc2 100644
--- a/examples/nft-set-elem-get.c
+++ b/examples/nft-set-elem-get.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-set-get.c b/examples/nft-set-get.c
index 48a0699cad2ba..ac9b3faf40b2a 100644
--- a/examples/nft-set-get.c
+++ b/examples/nft-set-get.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-table-add.c b/examples/nft-table-add.c
index 3d54e0e5d5097..0b4433a82a51f 100644
--- a/examples/nft-table-add.c
+++ b/examples/nft-table-add.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-table-del.c b/examples/nft-table-del.c
index 44f0b1f0e0902..0f8589e926dbc 100644
--- a/examples/nft-table-del.c
+++ b/examples/nft-table-del.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-table-get.c b/examples/nft-table-get.c
index 58eca9c1f32e2..82f50ffa6be8e 100644
--- a/examples/nft-table-get.c
+++ b/examples/nft-table-get.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/examples/nft-table-upd.c b/examples/nft-table-upd.c
index 7346636d5d47b..36bb470c95c7f 100644
--- a/examples/nft-table-upd.c
+++ b/examples/nft-table-upd.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/batch.c b/src/batch.c
index 8a9c6f910f1d5..e26af42a4761b 100644
--- a/src/batch.c
+++ b/src/batch.c
@@ -1,10 +1,7 @@
 /*
  * Copyright (c) 2013-2015 Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include "internal.h"
diff --git a/src/chain.c b/src/chain.c
index c9fbc3a87314b..b772968d5a43c 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/common.c b/src/common.c
index ec84fa0db541f..0a20bcab51c94 100644
--- a/src/common.c
+++ b/src/common.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdlib.h>
diff --git a/src/expr.c b/src/expr.c
index 4e32189c6e8d0..cf9dbebdc3993 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index e99131a090ed7..11146e0f5ad98 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 383e80d57b442..9f4e0fa9cdeca 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index d1f0f64a56b3b..4a5e2867124e7 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/connlimit.c b/src/expr/connlimit.c
index fcac8bf170ac4..e514fc4e58cf6 100644
--- a/src/expr/connlimit.c
+++ b/src/expr/connlimit.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2018 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/counter.c b/src/expr/counter.c
index cef911908981c..314d66ba3f0ab 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/ct.c b/src/expr/ct.c
index bea0522d89372..12bed80369988 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index d2ccf2e8dc682..2abee599594b6 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 28d686b1351b8..0dacdce4f54b1 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 9d2bfe5e206b1..485f34c0fb598 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -1,10 +1,7 @@
 /*
  * Copyright (c) 2014, 2015 Patrick McHardy <kaber@trash.net>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include "internal.h"
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 453902c230173..3711566ab9b81 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/fib.c b/src/expr/fib.c
index 20bc125aa3adf..aceaa261fde4d 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -2,10 +2,7 @@
  * (C) 2016 Red Hat GmbH
  * Author: Florian Westphal <fw@strlen.de>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 04cb089a7146e..df09ffcbdd338 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/hash.c b/src/expr/hash.c
index eb44b2ea9bb69..ddfdef760e624 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2016 by Laura Garcia <nevola@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index ab1276a1772cc..216230ce51b6d 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/inner.c b/src/expr/inner.c
index 4f66e944ec91a..920e68cfdd342 100644
--- a/src/expr/inner.c
+++ b/src/expr/inner.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2022 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include "internal.h"
diff --git a/src/expr/last.c b/src/expr/last.c
index 8e5b88ebb96be..ab9f117986bd4 100644
--- a/src/expr/last.c
+++ b/src/expr/last.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 5b821081eb20d..a5277be220839 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/log.c b/src/expr/log.c
index 18ec2b64a5b93..c0c4649ac9ced 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 21a7fcef40413..52003b202d728 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/masq.c b/src/expr/masq.c
index e0565db66fe16..f5ba72b532f6d 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2014 by Arturo Borrero Gonzalez <arturo@debian.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/match.c b/src/expr/match.c
index 8c1bc74a1ce19..c6d67c342ab70 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 136a450b6e976..dcba17df1e8ff 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 1235ba45b694d..7809cd42a69ac 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -2,10 +2,7 @@
  * (C) 2012-2014 Pablo Neira Ayuso <pablo@netfilter.org>
  * (C) 2012 Intel Corporation
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * Authors:
  * 	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index c015b8847aa48..ffab04f392e6a 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2016 by Laura Garcia <nevola@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 00538057222b5..7da351d8029b1 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 35cd10c31b98a..fab2506d8b0d9 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 09220c4a1138c..ce5959b2bf3d1 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Eric Leblond <eric@regit.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/quota.c b/src/expr/quota.c
index ddf232f9f3acd..2fc987199886d 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/range.c b/src/expr/range.c
index 96bb140119b66..e57298057b581 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include "internal.h"
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 9971306130fb0..3adc7b6965461 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2014 by Arturo Borrero Gonzalez <arturo@debian.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 9090db3f697a7..582841183d4f3 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/rt.c b/src/expr/rt.c
index ff4fd03c8f1b1..92a2f190be471 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -1,10 +1,7 @@
 /*
  * Copyright (c) 2016 Anders K. Pedersen <akp@cohaesio.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/socket.c b/src/expr/socket.c
index 7a25cdf806d12..ef27dd90ad65d 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -1,10 +1,7 @@
 /*
  * Copyright (c) 2018 Máté Eckl <ecklm94@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/target.c b/src/expr/target.c
index 8259a20a66cb5..eeea588205e81 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
index 9391ce880cd3b..742a9b7050497 100644
--- a/src/expr/tproxy.c
+++ b/src/expr/tproxy.c
@@ -1,10 +1,7 @@
 /*
  * Copyright (c) 2018 Máté Eckl <ecklm94@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include "internal.h"
diff --git a/src/expr/tunnel.c b/src/expr/tunnel.c
index 861e56dd64c27..2d6a0606a8860 100644
--- a/src/expr/tunnel.c
+++ b/src/expr/tunnel.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2018 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
index 2585579c3b549..a47d3316139ab 100644
--- a/src/expr/xfrm.c
+++ b/src/expr/xfrm.c
@@ -1,8 +1,5 @@
 /*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/gen.c b/src/gen.c
index 88efbaaba9acc..b8323611c5a7b 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2014 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include "internal.h"
 
diff --git a/src/obj/counter.c b/src/obj/counter.c
index 19e09ed41a94a..ec3ce32423abf 100644
--- a/src/obj/counter.c
+++ b/src/obj/counter.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/obj/ct_expect.c b/src/obj/ct_expect.c
index b4d6faa810eab..0c465e65daa25 100644
--- a/src/obj/ct_expect.c
+++ b/src/obj/ct_expect.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <arpa/inet.h>
diff --git a/src/obj/ct_helper.c b/src/obj/ct_helper.c
index 1feccf20b01b2..8b9a3d0176c53 100644
--- a/src/obj/ct_helper.c
+++ b/src/obj/ct_helper.c
@@ -2,10 +2,7 @@
  * (C) 2017 Red Hat GmbH
  * Author: Florian Westphal <fw@strlen.de>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index b9b688ec7c4bc..1aa7d1dc0d5ea 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2018 by Harsha Sharma <harshasharmaiitr@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/obj/limit.c b/src/obj/limit.c
index cbf30b480b8fa..227100efd6c33 100644
--- a/src/obj/limit.c
+++ b/src/obj/limit.c
@@ -1,10 +1,7 @@
 /*
  * Copyright (c) 2017 Pablo M. Bermudo Garay <pablombg@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/obj/quota.c b/src/obj/quota.c
index 526db8e42caa8..a6499eabaa717 100644
--- a/src/obj/quota.c
+++ b/src/obj/quota.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/obj/secmark.c b/src/obj/secmark.c
index eea96647cff72..9241d7ea8ac1c 100644
--- a/src/obj/secmark.c
+++ b/src/obj/secmark.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 03094109db442..af26b96f7003c 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2018 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/src/object.c b/src/object.c
index 9d150315d487d..3d386a7791d82 100644
--- a/src/object.c
+++ b/src/object.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include "internal.h"
 
diff --git a/src/rule.c b/src/rule.c
index c22918a8f3527..b4124bc66edcd 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/ruleset.c b/src/ruleset.c
index 185aa48737e50..af7ce433c6136 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -3,10 +3,7 @@
  * (C) 2013 by Arturo Borrero Gonzalez <arturo@debian.org>
  * (C) 2013 by Alvaro Neira Ayuso <alvaroneay@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/set.c b/src/set.c
index 75ad64e038502..0da11eeaf7b55 100644
--- a/src/set.c
+++ b/src/set.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/set_elem.c b/src/set_elem.c
index 9207a0dbd6899..3b5dcc1c74686 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/table.c b/src/table.c
index b1b164cbbcedc..10c513c4f9f0f 100644
--- a/src/table.c
+++ b/src/table.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
diff --git a/src/trace.c b/src/trace.c
index f4264377508e8..b299599ee91de 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -2,10 +2,7 @@
  * (C) 2015 Red Hat GmbH
  * Author: Florian Westphal <fw@strlen.de>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include "internal.h"
 
diff --git a/src/udata.c b/src/udata.c
index e9bfc35e624c6..1e801d53e6e52 100644
--- a/src/udata.c
+++ b/src/udata.c
@@ -2,10 +2,7 @@
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  * (C) 2016 by Carlos Falgueras García <carlosfg@riseup.net>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <libnftnl/udata.h>
diff --git a/src/utils.c b/src/utils.c
index 157b15f7afe8d..9c947b3b18607 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -2,10 +2,7 @@
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  * (C) 2013 by Arturo Borrero Gonzalez <arturo@debian.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <internal.h>
diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
index 64c506eb62a15..12ebd9ffa8b3f 100644
--- a/tests/nft-chain-test.c
+++ b/tests/nft-chain-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 44c4bf06f0410..46e5e6d3b2475 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -1,10 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
+ * SPDX-License-Identifier: GPL-2.0-or-later
  *
  */
 
diff --git a/tests/nft-expr_byteorder-test.c b/tests/nft-expr_byteorder-test.c
index 30e64c0eb6100..209384ee27c26 100644
--- a/tests/nft-expr_byteorder-test.c
+++ b/tests/nft-expr_byteorder-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_cmp-test.c b/tests/nft-expr_cmp-test.c
index 0bab67b851a81..9d0a4a419da2a 100644
--- a/tests/nft-expr_cmp-test.c
+++ b/tests/nft-expr_cmp-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_counter-test.c b/tests/nft-expr_counter-test.c
index 81c3fe10d74b3..03fdc6f5ff2cd 100644
--- a/tests/nft-expr_counter-test.c
+++ b/tests/nft-expr_counter-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_ct-test.c b/tests/nft-expr_ct-test.c
index 548a426dd8464..f0df609593932 100644
--- a/tests/nft-expr_ct-test.c
+++ b/tests/nft-expr_ct-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_dup-test.c b/tests/nft-expr_dup-test.c
index 0c5df9a9b7d44..12dcf7f8a95be 100644
--- a/tests/nft-expr_dup-test.c
+++ b/tests/nft-expr_dup-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_exthdr-test.c b/tests/nft-expr_exthdr-test.c
index b2c72b7357c6a..46e1fda5d178c 100644
--- a/tests/nft-expr_exthdr-test.c
+++ b/tests/nft-expr_exthdr-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_fwd-test.c b/tests/nft-expr_fwd-test.c
index 825dad3a456bd..7b6c7ebe054cd 100644
--- a/tests/nft-expr_fwd-test.c
+++ b/tests/nft-expr_fwd-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_hash-test.c b/tests/nft-expr_hash-test.c
index 6644bb7f3ac0d..ba60d3f5862f5 100644
--- a/tests/nft-expr_hash-test.c
+++ b/tests/nft-expr_hash-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2016 by Laura Garcia <nevola@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate-test.c
index 5027813626b1d..b4f8663905aec 100644
--- a/tests/nft-expr_immediate-test.c
+++ b/tests/nft-expr_immediate-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
index 38aaf56551e97..07049f734f89f 100644
--- a/tests/nft-expr_limit-test.c
+++ b/tests/nft-expr_limit-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_log-test.c b/tests/nft-expr_log-test.c
index 275ffaefc3772..9f0f33be28c48 100644
--- a/tests/nft-expr_log-test.c
+++ b/tests/nft-expr_log-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
index 9b7052565d6e9..8ec77e6c1b8b2 100644
--- a/tests/nft-expr_lookup-test.c
+++ b/tests/nft-expr_lookup-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_masq-test.c b/tests/nft-expr_masq-test.c
index 09179149421e2..be78de0583637 100644
--- a/tests/nft-expr_masq-test.c
+++ b/tests/nft-expr_masq-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
index fdeacc488e288..67defffd0cb50 100644
--- a/tests/nft-expr_match-test.c
+++ b/tests/nft-expr_match-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_meta-test.c b/tests/nft-expr_meta-test.c
index 2f03fb16f7b80..564bff8aa7e52 100644
--- a/tests/nft-expr_meta-test.c
+++ b/tests/nft-expr_meta-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
index 3a365dd307c26..f67423d71cad1 100644
--- a/tests/nft-expr_nat-test.c
+++ b/tests/nft-expr_nat-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_numgen-test.c b/tests/nft-expr_numgen-test.c
index 94df50f6e40c5..f3041d96981dd 100644
--- a/tests/nft-expr_numgen-test.c
+++ b/tests/nft-expr_numgen-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2016 by Laura Garcia <nevola@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_objref-test.c b/tests/nft-expr_objref-test.c
index 9e698df38e255..b0fa3eee910a9 100644
--- a/tests/nft-expr_objref-test.c
+++ b/tests/nft-expr_objref-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_payload-test.c b/tests/nft-expr_payload-test.c
index aec17106ef0fa..c17894b315ca2 100644
--- a/tests/nft-expr_payload-test.c
+++ b/tests/nft-expr_payload-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_queue-test.c b/tests/nft-expr_queue-test.c
index d007b98a71391..463d2ff5673c9 100644
--- a/tests/nft-expr_queue-test.c
+++ b/tests/nft-expr_queue-test.c
@@ -3,11 +3,7 @@
  *
  * Based on test framework by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_quota-test.c b/tests/nft-expr_quota-test.c
index a3eb2e3c45f3c..a94659704ad90 100644
--- a/tests/nft-expr_quota-test.c
+++ b/tests/nft-expr_quota-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_range-test.c b/tests/nft-expr_range-test.c
index 6ef896beb08a8..dd3bfda1dbb3d 100644
--- a/tests/nft-expr_range-test.c
+++ b/tests/nft-expr_range-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_redir-test.c b/tests/nft-expr_redir-test.c
index 8e1f30c433325..9b9cd6c823ef9 100644
--- a/tests/nft-expr_redir-test.c
+++ b/tests/nft-expr_redir-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_reject-test.c b/tests/nft-expr_reject-test.c
index 049401da1565c..e7df2100e34bd 100644
--- a/tests/nft-expr_reject-test.c
+++ b/tests/nft-expr_reject-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index a5172064c13b2..601021bea378f 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-object-test.c b/tests/nft-object-test.c
index d2ca444153419..2bb445f2ee484 100644
--- a/tests/nft-object-test.c
+++ b/tests/nft-object-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
index 3a92223f0e910..9df2097895e01 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-set-test.c b/tests/nft-set-test.c
index 66916fe0d5238..fedf0f3e17b77 100644
--- a/tests/nft-set-test.c
+++ b/tests/nft-set-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
index 53cf3d198a16a..82f9da2b4ec1a 100644
--- a/tests/nft-table-test.c
+++ b/tests/nft-table-test.c
@@ -1,11 +1,7 @@
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
+ * SPDX-License-Identifier: GPL-2.0-or-later
  */
 
 #include <stdio.h>
-- 
2.47.0

