Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6B420ADD6
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 22:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730240800; cv=none; b=uRxJJYJFpox3Eb6REjvET1Y8Y7tjSpzYWYmhso7n67lkkTQ413/oCGDgF3UdPZI+/6dpjWsOdt8NM/8KaFQH8xDpkytPO+VW/vp1gkEGpJmrN7/PAWKFMaUiVkOaeuICm+Su6ojoRd0IJXbOGzxf9CvDg9WhYIHzvdnGi4bQX20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730240800; c=relaxed/simple;
	bh=2ykjBgHvpOgf4SQa4HNEZ3mRIn/W+6Hc0mnbY8aK2S8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JIEq6EAZZ3q69WWLCEL59PqonisWG5RRbeBAroKCGTIfh8ho1H93hpeex+VGyJZtS7j/NWnwTQBj1ec0gYL1OB1VIAGeECibqqhIZl4Ewhtrel4YqpjJLY2p+Iid0Q6bcXC1+RjvKZOdBCc5+A2RNqD8mSZcUo6cDE+kmXAdmC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pm4igUfO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pm4igUfO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UROeXIFptdNZ0pfsP7GPdJUSzBBkVRS8iHsBGmwrkwE=; b=pm4igUfObB/KwguiO6YYLDQuXU
	YzBYJr+LFemEyAqiDusz8DhPCQZsbKHkZ0THuL3x9MyD3TQleVG9kVRtbciQqD/apkXprdAP1ZWlT
	Eneios5s1ambgkjiUwj2eo2/fKe5GWxEldRtrBTrWAzCofc/J8lVIlCa4QzP8ZIBSDaMDlU61HO5b
	x4oA8ukjQ02ohIPXhemO2YFAiV6nd9FMZ7mgZ8eg113fuZj6lR6oXMsmfFbhJUSrmzPEqwsUvmwKh
	plD5qwEMfqSjK7bFtlI+a8NlJp/aG1QeLxzfddCxHHhaakzykDepz04UUz7El6abKiryhKVGxtwIb
	q4Sa34tw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t5ufR-000000008Ia-2HAC;
	Tue, 29 Oct 2024 23:26:25 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <ej@inai.de>
Subject: [libnftnl PATCH v2] Use SPDX License Identifiers in headers
Date: Tue, 29 Oct 2024 23:23:04 +0100
Message-ID: <20241029222622.25798-1-phil@nwl.cc>
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
SPDX-License-Identifier string as separate comment in line 1. Drop
resulting empty lines if duplicate or at the bottom of the comment.
Leave any other header comment content in place.

This also fixes for an incomplete notice in examples/nft-ruleset-get.c
since commit c335442eefcca ("src: incorrect header refers to GPLv2
only").

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Put the label into its own comment in line 1, as suggested by Pablo.
---
 examples/nft-chain-add.c               | 6 +-----
 examples/nft-chain-del.c               | 6 +-----
 examples/nft-chain-get.c               | 6 +-----
 examples/nft-compat-get.c              | 6 +-----
 examples/nft-ct-expectation-add.c      | 6 +-----
 examples/nft-ct-expectation-del.c      | 6 +-----
 examples/nft-ct-expectation-get.c      | 6 +-----
 examples/nft-ct-helper-add.c           | 6 +-----
 examples/nft-ct-helper-del.c           | 6 +-----
 examples/nft-ct-helper-get.c           | 6 +-----
 examples/nft-ct-timeout-add.c          | 6 +-----
 examples/nft-ct-timeout-del.c          | 6 +-----
 examples/nft-ct-timeout-get.c          | 6 +-----
 examples/nft-events.c                  | 6 +-----
 examples/nft-map-add.c                 | 6 +-----
 examples/nft-obj-add.c                 | 6 +-----
 examples/nft-obj-del.c                 | 6 +-----
 examples/nft-obj-get.c                 | 6 +-----
 examples/nft-rule-add.c                | 6 +-----
 examples/nft-rule-ct-expectation-add.c | 6 +-----
 examples/nft-rule-ct-helper-add.c      | 6 +-----
 examples/nft-rule-ct-timeout-add.c     | 6 +-----
 examples/nft-rule-del.c                | 6 +-----
 examples/nft-rule-get.c                | 6 +-----
 examples/nft-ruleset-get.c             | 6 +-----
 examples/nft-set-add.c                 | 6 +-----
 examples/nft-set-del.c                 | 6 +-----
 examples/nft-set-elem-add.c            | 6 +-----
 examples/nft-set-elem-del.c            | 6 +-----
 examples/nft-set-elem-get.c            | 6 +-----
 examples/nft-set-get.c                 | 6 +-----
 examples/nft-table-add.c               | 6 +-----
 examples/nft-table-del.c               | 6 +-----
 examples/nft-table-get.c               | 6 +-----
 examples/nft-table-upd.c               | 6 +-----
 src/batch.c                            | 6 +-----
 src/chain.c                            | 6 +-----
 src/common.c                           | 6 +-----
 src/expr.c                             | 6 +-----
 src/expr/bitwise.c                     | 6 +-----
 src/expr/byteorder.c                   | 6 +-----
 src/expr/cmp.c                         | 6 +-----
 src/expr/connlimit.c                   | 6 +-----
 src/expr/counter.c                     | 6 +-----
 src/expr/ct.c                          | 6 +-----
 src/expr/data_reg.c                    | 6 +-----
 src/expr/dup.c                         | 6 +-----
 src/expr/dynset.c                      | 6 +-----
 src/expr/exthdr.c                      | 6 +-----
 src/expr/fib.c                         | 6 +-----
 src/expr/fwd.c                         | 6 +-----
 src/expr/hash.c                        | 7 +------
 src/expr/immediate.c                   | 6 +-----
 src/expr/inner.c                       | 6 +-----
 src/expr/last.c                        | 6 +-----
 src/expr/limit.c                       | 6 +-----
 src/expr/log.c                         | 6 +-----
 src/expr/lookup.c                      | 6 +-----
 src/expr/masq.c                        | 6 +-----
 src/expr/match.c                       | 6 +-----
 src/expr/meta.c                        | 6 +-----
 src/expr/nat.c                         | 6 +-----
 src/expr/numgen.c                      | 7 +------
 src/expr/objref.c                      | 6 +-----
 src/expr/payload.c                     | 6 +-----
 src/expr/queue.c                       | 7 +------
 src/expr/quota.c                       | 6 +-----
 src/expr/range.c                       | 6 +-----
 src/expr/redir.c                       | 6 +-----
 src/expr/reject.c                      | 6 +-----
 src/expr/rt.c                          | 6 +-----
 src/expr/socket.c                      | 6 +-----
 src/expr/target.c                      | 6 +-----
 src/expr/tproxy.c                      | 6 +-----
 src/expr/tunnel.c                      | 6 +-----
 src/expr/xfrm.c                        | 7 +------
 src/gen.c                              | 6 +-----
 src/obj/counter.c                      | 6 +-----
 src/obj/ct_expect.c                    | 6 +-----
 src/obj/ct_helper.c                    | 6 +-----
 src/obj/ct_timeout.c                   | 6 +-----
 src/obj/limit.c                        | 6 +-----
 src/obj/quota.c                        | 6 +-----
 src/obj/secmark.c                      | 6 +-----
 src/obj/tunnel.c                       | 6 +-----
 src/object.c                           | 6 +-----
 src/rule.c                             | 6 +-----
 src/ruleset.c                          | 6 +-----
 src/set.c                              | 6 +-----
 src/set_elem.c                         | 6 +-----
 src/str_array.c                        | 3 +--
 src/table.c                            | 6 +-----
 src/trace.c                            | 6 +-----
 src/udata.c                            | 6 +-----
 src/utils.c                            | 6 +-----
 tests/nft-chain-test.c                 | 7 +------
 tests/nft-expr_bitwise-test.c          | 7 +------
 tests/nft-expr_byteorder-test.c        | 7 +------
 tests/nft-expr_cmp-test.c              | 7 +------
 tests/nft-expr_counter-test.c          | 7 +------
 tests/nft-expr_ct-test.c               | 7 +------
 tests/nft-expr_dup-test.c              | 7 +------
 tests/nft-expr_exthdr-test.c           | 7 +------
 tests/nft-expr_fwd-test.c              | 7 +------
 tests/nft-expr_hash-test.c             | 7 +------
 tests/nft-expr_immediate-test.c        | 7 +------
 tests/nft-expr_limit-test.c            | 7 +------
 tests/nft-expr_log-test.c              | 7 +------
 tests/nft-expr_lookup-test.c           | 7 +------
 tests/nft-expr_masq-test.c             | 7 +------
 tests/nft-expr_match-test.c            | 7 +------
 tests/nft-expr_meta-test.c             | 7 +------
 tests/nft-expr_nat-test.c              | 7 +------
 tests/nft-expr_numgen-test.c           | 7 +------
 tests/nft-expr_objref-test.c           | 7 +------
 tests/nft-expr_payload-test.c          | 7 +------
 tests/nft-expr_queue-test.c            | 7 +------
 tests/nft-expr_quota-test.c            | 7 +------
 tests/nft-expr_range-test.c            | 7 +------
 tests/nft-expr_redir-test.c            | 7 +------
 tests/nft-expr_reject-test.c           | 7 +------
 tests/nft-expr_target-test.c           | 7 +------
 tests/nft-object-test.c                | 7 +------
 tests/nft-rule-test.c                  | 7 +------
 tests/nft-set-test.c                   | 7 +------
 tests/nft-table-test.c                 | 7 +------
 126 files changed, 126 insertions(+), 662 deletions(-)

diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
index 13be982324180..29a5b08245527 100644
--- a/examples/nft-chain-add.c
+++ b/examples/nft-chain-add.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-chain-del.c b/examples/nft-chain-del.c
index 3cd483ea6c027..3d333b777dfe1 100644
--- a/examples/nft-chain-del.c
+++ b/examples/nft-chain-del.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-chain-get.c b/examples/nft-chain-get.c
index 612f58be7553c..764ffc35718c8 100644
--- a/examples/nft-chain-get.c
+++ b/examples/nft-chain-get.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-compat-get.c b/examples/nft-compat-get.c
index 8f00cbf5b8242..fd308db9c4600 100644
--- a/examples/nft-compat-get.c
+++ b/examples/nft-compat-get.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-ct-expectation-add.c b/examples/nft-ct-expectation-add.c
index d9b9cdb2f68b8..8608a6bf322e7 100644
--- a/examples/nft-ct-expectation-add.c
+++ b/examples/nft-ct-expectation-add.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <time.h>
diff --git a/examples/nft-ct-expectation-del.c b/examples/nft-ct-expectation-del.c
index 67dbd4777ed03..54b6ab6d1686d 100644
--- a/examples/nft-ct-expectation-del.c
+++ b/examples/nft-ct-expectation-del.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-ct-expectation-get.c b/examples/nft-ct-expectation-get.c
index 12c1350024c6a..2ae6003a3047c 100644
--- a/examples/nft-ct-expectation-get.c
+++ b/examples/nft-ct-expectation-get.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-ct-helper-add.c b/examples/nft-ct-helper-add.c
index 397443ba74db3..4d182798f00f9 100644
--- a/examples/nft-ct-helper-add.c
+++ b/examples/nft-ct-helper-add.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-ct-helper-del.c b/examples/nft-ct-helper-del.c
index fda3026cd69b9..ce8a2a06ba11e 100644
--- a/examples/nft-ct-helper-del.c
+++ b/examples/nft-ct-helper-del.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-ct-helper-get.c b/examples/nft-ct-helper-get.c
index 34134af196a83..84b2faccdb7bc 100644
--- a/examples/nft-ct-helper-get.c
+++ b/examples/nft-ct-helper-get.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-ct-timeout-add.c b/examples/nft-ct-timeout-add.c
index 4c2052ea75cc6..e0e10ee3df8c3 100644
--- a/examples/nft-ct-timeout-add.c
+++ b/examples/nft-ct-timeout-add.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-ct-timeout-del.c b/examples/nft-ct-timeout-del.c
index 4581c3986fda7..9b31d58150aa5 100644
--- a/examples/nft-ct-timeout-del.c
+++ b/examples/nft-ct-timeout-del.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-ct-timeout-get.c b/examples/nft-ct-timeout-get.c
index 18aed52e987e4..f87efac7f84ee 100644
--- a/examples/nft-ct-timeout-get.c
+++ b/examples/nft-ct-timeout-get.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-events.c b/examples/nft-events.c
index 8aab90a118242..bd4618da1487e 100644
--- a/examples/nft-events.c
+++ b/examples/nft-events.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-map-add.c b/examples/nft-map-add.c
index e5ce664af6b5b..6caf42f2a375b 100644
--- a/examples/nft-map-add.c
+++ b/examples/nft-map-add.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-obj-add.c b/examples/nft-obj-add.c
index f526b3c085772..9b123b9dd6b96 100644
--- a/examples/nft-obj-add.c
+++ b/examples/nft-obj-add.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-obj-del.c b/examples/nft-obj-del.c
index ae4f703146180..a23d5224a14fb 100644
--- a/examples/nft-obj-del.c
+++ b/examples/nft-obj-del.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-obj-get.c b/examples/nft-obj-get.c
index e560ed008f848..c0ddbed0efcab 100644
--- a/examples/nft-obj-get.c
+++ b/examples/nft-obj-get.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 7d13b92f6ef55..937b4366a29b8 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-rule-ct-expectation-add.c b/examples/nft-rule-ct-expectation-add.c
index 07c8306d9154c..31f674a9d3956 100644
--- a/examples/nft-rule-ct-expectation-add.c
+++ b/examples/nft-rule-ct-expectation-add.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-rule-ct-helper-add.c b/examples/nft-rule-ct-helper-add.c
index 594e6ba8e6ddc..eceb1cbf5be70 100644
--- a/examples/nft-rule-ct-helper-add.c
+++ b/examples/nft-rule-ct-helper-add.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-rule-ct-timeout-add.c b/examples/nft-rule-ct-timeout-add.c
index 0953cb4a396f1..4fb4be80535ec 100644
--- a/examples/nft-rule-ct-timeout-add.c
+++ b/examples/nft-rule-ct-timeout-add.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-rule-del.c b/examples/nft-rule-del.c
index cb085ff10b3bb..f0e594834f90e 100644
--- a/examples/nft-rule-del.c
+++ b/examples/nft-rule-del.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-rule-get.c b/examples/nft-rule-get.c
index 8da5b59ae372c..865bad5789c1f 100644
--- a/examples/nft-rule-get.c
+++ b/examples/nft-rule-get.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-ruleset-get.c b/examples/nft-ruleset-get.c
index 34ebe1fb6155c..c53084704e481 100644
--- a/examples/nft-ruleset-get.c
+++ b/examples/nft-ruleset-get.c
@@ -1,14 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (c) 2013 Arturo Borrero Gonzalez <arturo@debian.org>
  *
  * based on previous code from:
  *
  * Copyright (c) 2013 Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdlib.h>
diff --git a/examples/nft-set-add.c b/examples/nft-set-add.c
index 109e33a75ac0e..7447b4088d2ed 100644
--- a/examples/nft-set-add.c
+++ b/examples/nft-set-add.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-set-del.c b/examples/nft-set-del.c
index 5e8dea975a739..4ff9e040f6df2 100644
--- a/examples/nft-set-del.c
+++ b/examples/nft-set-del.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-set-elem-add.c b/examples/nft-set-elem-add.c
index 4b8b37c086a43..09b8f02ec97f6 100644
--- a/examples/nft-set-elem-add.c
+++ b/examples/nft-set-elem-add.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-set-elem-del.c b/examples/nft-set-elem-del.c
index 1e6c90df81687..2382f4fb0653c 100644
--- a/examples/nft-set-elem-del.c
+++ b/examples/nft-set-elem-del.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-set-elem-get.c b/examples/nft-set-elem-get.c
index 7f99a602b0317..1863f72c3ca1d 100644
--- a/examples/nft-set-elem-get.c
+++ b/examples/nft-set-elem-get.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-set-get.c b/examples/nft-set-get.c
index 48a0699cad2ba..5848165d77eb4 100644
--- a/examples/nft-set-get.c
+++ b/examples/nft-set-get.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-table-add.c b/examples/nft-table-add.c
index 3d54e0e5d5097..0079e095e52d1 100644
--- a/examples/nft-table-add.c
+++ b/examples/nft-table-add.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-table-del.c b/examples/nft-table-del.c
index 44f0b1f0e0902..b04bd750d1dd5 100644
--- a/examples/nft-table-del.c
+++ b/examples/nft-table-del.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-table-get.c b/examples/nft-table-get.c
index 58eca9c1f32e2..3e76747a0fbea 100644
--- a/examples/nft-table-get.c
+++ b/examples/nft-table-get.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/examples/nft-table-upd.c b/examples/nft-table-upd.c
index 7346636d5d47b..247af5d986eff 100644
--- a/examples/nft-table-upd.c
+++ b/examples/nft-table-upd.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This software has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/batch.c b/src/batch.c
index 8a9c6f910f1d5..2fca5fc698d7f 100644
--- a/src/batch.c
+++ b/src/batch.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (c) 2013-2015 Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include "internal.h"
diff --git a/src/chain.c b/src/chain.c
index c9fbc3a87314b..7287dcd98e898 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 #include "internal.h"
diff --git a/src/common.c b/src/common.c
index ec84fa0db541f..e661227c6d43f 100644
--- a/src/common.c
+++ b/src/common.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdlib.h>
diff --git a/src/expr.c b/src/expr.c
index 4e32189c6e8d0..65180d6849cd8 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 #include "internal.h"
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index e99131a090ed7..1a945e9167c61 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 383e80d57b442..903c775bf1963 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index d1f0f64a56b3b..f55a8c0299e13 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/connlimit.c b/src/expr/connlimit.c
index fcac8bf170ac4..02b9ecc87d258 100644
--- a/src/expr/connlimit.c
+++ b/src/expr/connlimit.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2018 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/counter.c b/src/expr/counter.c
index cef911908981c..80f21d7a177ea 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/ct.c b/src/expr/ct.c
index bea0522d89372..b01fbc58bd285 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index d2ccf2e8dc682..fd5e0d6e749e1 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 28d686b1351b8..d49cdb77c1081 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 9d2bfe5e206b1..40f9136ab73a2 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (c) 2014, 2015 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include "internal.h"
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 453902c230173..339527dcd193c 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/fib.c b/src/expr/fib.c
index 20bc125aa3adf..c378f4f51bb11 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2016 Red Hat GmbH
  * Author: Florian Westphal <fw@strlen.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 04cb089a7146e..d543e2239af20 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/hash.c b/src/expr/hash.c
index eb44b2ea9bb69..050e4b9b1c599 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2016 by Laura Garcia <nevola@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index ab1276a1772cc..f0e0a78d6b794 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/inner.c b/src/expr/inner.c
index 4f66e944ec91a..8a56bb336cff5 100644
--- a/src/expr/inner.c
+++ b/src/expr/inner.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2022 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include "internal.h"
diff --git a/src/expr/last.c b/src/expr/last.c
index 8e5b88ebb96be..427d4b52a1aec 100644
--- a/src/expr/last.c
+++ b/src/expr/last.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 5b821081eb20d..b77b27e024acb 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/log.c b/src/expr/log.c
index 18ec2b64a5b93..d4b53e6c744de 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 21a7fcef40413..7f85ecca008f5 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/masq.c b/src/expr/masq.c
index e0565db66fe16..da4f437f136c0 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2014 by Arturo Borrero Gonzalez <arturo@debian.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/match.c b/src/expr/match.c
index 8c1bc74a1ce19..2c5bd6bb74d19 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 136a450b6e976..56d3ddaffa226 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 1235ba45b694d..3ce1aafda55e4 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -1,12 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2014 Pablo Neira Ayuso <pablo@netfilter.org>
  * (C) 2012 Intel Corporation
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * Authors:
  * 	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
  */
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index c015b8847aa48..e3af372410720 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2016 by Laura Garcia <nevola@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 00538057222b5..5fe09c242ef48 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 35cd10c31b98a..c3ac0c345aec6 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/queue.c b/src/expr/queue.c
index 09220c4a1138c..0160d5e25f836 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Eric Leblond <eric@regit.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/src/expr/quota.c b/src/expr/quota.c
index ddf232f9f3acd..108c87c04530d 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/range.c b/src/expr/range.c
index 96bb140119b66..b05724fc5fa4f 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include "internal.h"
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 9971306130fb0..be38f6257a8f1 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2014 by Arturo Borrero Gonzalez <arturo@debian.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 9090db3f697a7..5d8763ebb5ef0 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/rt.c b/src/expr/rt.c
index ff4fd03c8f1b1..633031e1427c3 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (c) 2016 Anders K. Pedersen <akp@cohaesio.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/socket.c b/src/expr/socket.c
index 7a25cdf806d12..822ee8b9b832e 100644
--- a/src/expr/socket.c
+++ b/src/expr/socket.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (c) 2018 Máté Eckl <ecklm94@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/target.c b/src/expr/target.c
index 8259a20a66cb5..3549456b430ff 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/expr/tproxy.c b/src/expr/tproxy.c
index 9391ce880cd3b..4cc9125f1de65 100644
--- a/src/expr/tproxy.c
+++ b/src/expr/tproxy.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (c) 2018 Máté Eckl <ecklm94@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include "internal.h"
diff --git a/src/expr/tunnel.c b/src/expr/tunnel.c
index 861e56dd64c27..b51b6c7513086 100644
--- a/src/expr/tunnel.c
+++ b/src/expr/tunnel.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2018 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/expr/xfrm.c b/src/expr/xfrm.c
index 2585579c3b549..ba2107d63c082 100644
--- a/src/expr/xfrm.c
+++ b/src/expr/xfrm.c
@@ -1,9 +1,4 @@
-/*
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 
 #include <stdio.h>
 #include <string.h>
diff --git a/src/gen.c b/src/gen.c
index 88efbaaba9acc..45349bc8fedcf 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2014 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 #include "internal.h"
 
diff --git a/src/obj/counter.c b/src/obj/counter.c
index 19e09ed41a94a..c9462cd3225c6 100644
--- a/src/obj/counter.c
+++ b/src/obj/counter.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/obj/ct_expect.c b/src/obj/ct_expect.c
index b4d6faa810eab..65c6d08623df4 100644
--- a/src/obj/ct_expect.c
+++ b/src/obj/ct_expect.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2019 by Stéphane Veyret <sveyret@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <arpa/inet.h>
diff --git a/src/obj/ct_helper.c b/src/obj/ct_helper.c
index 1feccf20b01b2..6e16f083f2f2b 100644
--- a/src/obj/ct_helper.c
+++ b/src/obj/ct_helper.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2017 Red Hat GmbH
  * Author: Florian Westphal <fw@strlen.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index b9b688ec7c4bc..22ce9181a2e30 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2018 by Harsha Sharma <harshasharmaiitr@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/obj/limit.c b/src/obj/limit.c
index cbf30b480b8fa..fe1a88f07d0bf 100644
--- a/src/obj/limit.c
+++ b/src/obj/limit.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (c) 2017 Pablo M. Bermudo Garay <pablombg@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/obj/quota.c b/src/obj/quota.c
index 526db8e42caa8..0eda0a5063228 100644
--- a/src/obj/quota.c
+++ b/src/obj/quota.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/obj/secmark.c b/src/obj/secmark.c
index eea96647cff72..25b04e206eef0 100644
--- a/src/obj/secmark.c
+++ b/src/obj/secmark.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 03094109db442..980bffdb91916 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2018 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <stdio.h>
diff --git a/src/object.c b/src/object.c
index 9d150315d487d..bfcceb9df5e15 100644
--- a/src/object.c
+++ b/src/object.c
@@ -1,10 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 #include "internal.h"
 
diff --git a/src/rule.c b/src/rule.c
index c22918a8f3527..3948a74098fe7 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 #include "internal.h"
diff --git a/src/ruleset.c b/src/ruleset.c
index 185aa48737e50..ac50aa604f985 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -1,13 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  * (C) 2013 by Arturo Borrero Gonzalez <arturo@debian.org>
  * (C) 2013 by Alvaro Neira Ayuso <alvaroneay@gmail.com>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
diff --git a/src/set.c b/src/set.c
index 75ad64e038502..d2f6a944c6841 100644
--- a/src/set.c
+++ b/src/set.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 #include "internal.h"
diff --git a/src/set_elem.c b/src/set_elem.c
index 9207a0dbd6899..848adf1d179bf 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 #include "internal.h"
diff --git a/src/str_array.c b/src/str_array.c
index 63471bd08aaca..5669c6154d394 100644
--- a/src/str_array.c
+++ b/src/str_array.c
@@ -1,8 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2024 Red Hat GmbH
  * Author: Phil Sutter <phil@nwl.cc>
- *
- * SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nf_tables.h>
diff --git a/src/table.c b/src/table.c
index b1b164cbbcedc..9870dcafb4ef6 100644
--- a/src/table.c
+++ b/src/table.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 #include "internal.h"
diff --git a/src/trace.c b/src/trace.c
index f4264377508e8..f7eb45ed6704d 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2015 Red Hat GmbH
  * Author: Florian Westphal <fw@strlen.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 #include "internal.h"
 
diff --git a/src/udata.c b/src/udata.c
index e9bfc35e624c6..a1956571ef5fd 100644
--- a/src/udata.c
+++ b/src/udata.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2016 by Pablo Neira Ayuso <pablo@netfilter.org>
  * (C) 2016 by Carlos Falgueras García <carlosfg@riseup.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <libnftnl/udata.h>
diff --git a/src/utils.c b/src/utils.c
index 2f1ffd6227583..5f2c5bff7c650 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2012-2013 by Pablo Neira Ayuso <pablo@netfilter.org>
  * (C) 2013 by Arturo Borrero Gonzalez <arturo@debian.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published
- * by the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  */
 
 #include <internal.h>
diff --git a/tests/nft-chain-test.c b/tests/nft-chain-test.c
index 64c506eb62a15..0d0544a8173a9 100644
--- a/tests/nft-chain-test.c
+++ b/tests/nft-chain-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 44c4bf06f0410..d98569ce4a8fd 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_byteorder-test.c b/tests/nft-expr_byteorder-test.c
index 30e64c0eb6100..dfd697321652d 100644
--- a/tests/nft-expr_byteorder-test.c
+++ b/tests/nft-expr_byteorder-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_cmp-test.c b/tests/nft-expr_cmp-test.c
index 0bab67b851a81..e5f5c9bcdd084 100644
--- a/tests/nft-expr_cmp-test.c
+++ b/tests/nft-expr_cmp-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_counter-test.c b/tests/nft-expr_counter-test.c
index 81c3fe10d74b3..b9b5501202f83 100644
--- a/tests/nft-expr_counter-test.c
+++ b/tests/nft-expr_counter-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_ct-test.c b/tests/nft-expr_ct-test.c
index 548a426dd8464..b6b192e6057a0 100644
--- a/tests/nft-expr_ct-test.c
+++ b/tests/nft-expr_ct-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_dup-test.c b/tests/nft-expr_dup-test.c
index 0c5df9a9b7d44..1865d499b0ba6 100644
--- a/tests/nft-expr_dup-test.c
+++ b/tests/nft-expr_dup-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_exthdr-test.c b/tests/nft-expr_exthdr-test.c
index b2c72b7357c6a..514eebeba705d 100644
--- a/tests/nft-expr_exthdr-test.c
+++ b/tests/nft-expr_exthdr-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_fwd-test.c b/tests/nft-expr_fwd-test.c
index 825dad3a456bd..a52caa9f1ef1a 100644
--- a/tests/nft-expr_fwd-test.c
+++ b/tests/nft-expr_fwd-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_hash-test.c b/tests/nft-expr_hash-test.c
index 6644bb7f3ac0d..e2e59e958cc8d 100644
--- a/tests/nft-expr_hash-test.c
+++ b/tests/nft-expr_hash-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2016 by Laura Garcia <nevola@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_immediate-test.c b/tests/nft-expr_immediate-test.c
index 5027813626b1d..e054c23bc6007 100644
--- a/tests/nft-expr_immediate-test.c
+++ b/tests/nft-expr_immediate-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_limit-test.c b/tests/nft-expr_limit-test.c
index 38aaf56551e97..4347f9c79dccd 100644
--- a/tests/nft-expr_limit-test.c
+++ b/tests/nft-expr_limit-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_log-test.c b/tests/nft-expr_log-test.c
index 275ffaefc3772..2fc5ad6050aa5 100644
--- a/tests/nft-expr_log-test.c
+++ b/tests/nft-expr_log-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_lookup-test.c b/tests/nft-expr_lookup-test.c
index 9b7052565d6e9..de84ea8c04a6c 100644
--- a/tests/nft-expr_lookup-test.c
+++ b/tests/nft-expr_lookup-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_masq-test.c b/tests/nft-expr_masq-test.c
index 09179149421e2..1705dc02ccc5a 100644
--- a/tests/nft-expr_masq-test.c
+++ b/tests/nft-expr_masq-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
index fdeacc488e288..53a8b849c4847 100644
--- a/tests/nft-expr_match-test.c
+++ b/tests/nft-expr_match-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_meta-test.c b/tests/nft-expr_meta-test.c
index 2f03fb16f7b80..43c665f0325ed 100644
--- a/tests/nft-expr_meta-test.c
+++ b/tests/nft-expr_meta-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_nat-test.c b/tests/nft-expr_nat-test.c
index 3a365dd307c26..983e1afc8ce9c 100644
--- a/tests/nft-expr_nat-test.c
+++ b/tests/nft-expr_nat-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_numgen-test.c b/tests/nft-expr_numgen-test.c
index 94df50f6e40c5..666043e0732e5 100644
--- a/tests/nft-expr_numgen-test.c
+++ b/tests/nft-expr_numgen-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2016 by Laura Garcia <nevola@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_objref-test.c b/tests/nft-expr_objref-test.c
index 9e698df38e255..36c869eb281b7 100644
--- a/tests/nft-expr_objref-test.c
+++ b/tests/nft-expr_objref-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_payload-test.c b/tests/nft-expr_payload-test.c
index aec17106ef0fa..8c41bab71b287 100644
--- a/tests/nft-expr_payload-test.c
+++ b/tests/nft-expr_payload-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_queue-test.c b/tests/nft-expr_queue-test.c
index d007b98a71391..b114cea066cb3 100644
--- a/tests/nft-expr_queue-test.c
+++ b/tests/nft-expr_queue-test.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Eric Leblond <eric@regit.org>
  *
  * Based on test framework by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_quota-test.c b/tests/nft-expr_quota-test.c
index a3eb2e3c45f3c..193afc8b8d6df 100644
--- a/tests/nft-expr_quota-test.c
+++ b/tests/nft-expr_quota-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2016 by Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_range-test.c b/tests/nft-expr_range-test.c
index 6ef896beb08a8..c441a2eb5df80 100644
--- a/tests/nft-expr_range-test.c
+++ b/tests/nft-expr_range-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_redir-test.c b/tests/nft-expr_redir-test.c
index 8e1f30c433325..d2de222427e76 100644
--- a/tests/nft-expr_redir-test.c
+++ b/tests/nft-expr_redir-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_reject-test.c b/tests/nft-expr_reject-test.c
index 049401da1565c..cadd322d2a5e2 100644
--- a/tests/nft-expr_reject-test.c
+++ b/tests/nft-expr_reject-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index a5172064c13b2..89de945e58348 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-object-test.c b/tests/nft-object-test.c
index d2ca444153419..77300e62ae47e 100644
--- a/tests/nft-object-test.c
+++ b/tests/nft-object-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-rule-test.c b/tests/nft-rule-test.c
index 3a92223f0e910..d865d267366e3 100644
--- a/tests/nft-rule-test.c
+++ b/tests/nft-rule-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-set-test.c b/tests/nft-set-test.c
index 66916fe0d5238..e264c735a2de6 100644
--- a/tests/nft-set-test.c
+++ b/tests/nft-set-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
diff --git a/tests/nft-table-test.c b/tests/nft-table-test.c
index 53cf3d198a16a..79e10ef81a730 100644
--- a/tests/nft-table-test.c
+++ b/tests/nft-table-test.c
@@ -1,11 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * (C) 2013 by Ana Rey Botello <anarey@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #include <stdio.h>
-- 
2.47.0

