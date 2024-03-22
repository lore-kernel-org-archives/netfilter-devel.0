Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD0E59B56
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Mar 2024 16:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711123612; cv=none; b=pmxMgKUE8r3ZCBqLkAF9jBn+gomQTxrRQKbe79tXRH63LGs/cshtb3jMZS5vBSBRAnT4dGfqs2TLTk02TS9lLX84qbsI8Zr6E0Oj97Z2iji4BUVgapJduT1e3iJEIYn2c966qw00ykle23m/g+TDGfZRsW/eQafBCWamd7JtJUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711123612; c=relaxed/simple;
	bh=pT7rc3q+qRGjvQeV+PjNK3ihPjmhA4pFtTWupzebl1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kK21kLRS7lFP6pPD7JGoPEDo9j9SfSP8t5a60SMO52hINSfgGvpjmKywXGRT9SDOPz3E4hdXWt4UXJPVY79KWUYwBKVNc3b8WJ7HcZG8AVS5ufgCuBjXLWCUzPHK/mGziKApUV6nOEFxkehCT7O22UtT4fwBxEzVUn0SZ9/3KQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bt4WwrJu; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bt4WwrJu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uy8LfBUyzk3Ua1vQKS67g+tPmeOECpP4jqCgJIT1O3w=; b=bt4WwrJunNs/pbhcrAALLNbrGr
	I8l1UwFccRUSJ1y4ZanyFTDf+sPU5mr0vpYR0Qo9EU9IrN9lzwuACAcZnyiuzc+ZnZbGHrPJ57YXp
	HqcJGo/J96FYcuL0CwhIVoBG63IS3sb0V8OXKTbVLERB6JOPIYG8R5FLxPON7ijw2pwrtzoGM00kN
	VSwY4KnIj79cbSskjjqaZoLHTi6lnBHptTKMyXRWNuFyqGl3z5biv+udQtG+gLKQdGJPL+wEyFePh
	Ec46QEMTeXU6cb+fZjrLf/4CghUl10tzMJz/2m3jcNfCFT9yKe+OauK0z8QLlupbP3uWr0Ry6jRvv
	2vTcmhbA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rnhPs-000000000yC-2kCK;
	Fri, 22 Mar 2024 17:06:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 2/5] mergesort: Avoid accidental set element reordering
Date: Fri, 22 Mar 2024 17:06:42 +0100
Message-ID: <20240322160645.18331-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240322160645.18331-1-phil@nwl.cc>
References: <20240322160645.18331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In corner cases, expr_msort_cmp() may return 0 for two non-identical
elements. An example are ORed tcp flags: 'syn' and 'syn | ack' are
considered the same value since expr_msort_value() reduces the latter to
its LHS.

Keeping the above in mind and looking at how list_expr_sort() works: The
list in 'head' is cut in half, the first half put into the temporary
list 'list' and finally 'list' is merged back into 'head' considering
each element's position. Shall expr_msort_cmp() return 0 for two
elements, the one from 'list' ends up after the one in 'head', thus
reverting their previous ordering.

The practical implication is that output never matches input for the
sample set '{ syn, syn | ack }' as the sorting after delinearization in
netlink_list_setelems() keeps swapping the elements. Out of coincidence,
the commit this fixes itself illustrates the use-case this breaks,
namely tracking a ruleset in git: Each ruleset reload will trigger an
update to the stored dump.

This change breaks interval set element deletion because __set_delete()
implicitly relies upon this reordering of duplicate entries by inserting
a clone of the one to delete into the start (via list_move()) and after
sorting assumes the clone will end up right behind the original. Fix
this by calling list_move_tail() instead.

Fixes: 14ee0a979b622 ("src: sort set elements in netlink_get_setelems()")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/intervals.c                               |  2 +-
 src/mergesort.c                               |  2 +-
 .../sets/dumps/0055tcpflags_0.json-nft        | 32 +++++++++----------
 .../testcases/sets/dumps/0055tcpflags_0.nft   |  8 ++---
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 68728349e999c..6c3f36fec02aa 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -466,7 +466,7 @@ static int __set_delete(struct list_head *msgs, struct expr *i,	struct set *set,
 			unsigned int debug_mask)
 {
 	i->flags |= EXPR_F_REMOVE;
-	list_move(&i->list, &existing_set->init->expressions);
+	list_move_tail(&i->list, &existing_set->init->expressions);
 	list_expr_sort(&existing_set->init->expressions);
 
 	return setelem_delete(msgs, set, init, existing_set->init, debug_mask);
diff --git a/src/mergesort.c b/src/mergesort.c
index 4d0e280fdc5e2..5e676be16369b 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -78,7 +78,7 @@ void list_splice_sorted(struct list_head *list, struct list_head *head)
 	while (l != list) {
 		if (h == head ||
 		    expr_msort_cmp(list_entry(l, typeof(struct expr), list),
-				   list_entry(h, typeof(struct expr), list)) < 0) {
+				   list_entry(h, typeof(struct expr), list)) <= 0) {
 			l = l->next;
 			list_add_tail(l->prev, h);
 			continue;
diff --git a/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft b/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
index 6a3511515f785..e37139f334466 100644
--- a/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
@@ -28,15 +28,6 @@
           {
             "|": [
               "fin",
-              "psh",
-              "ack",
-              "urg"
-            ]
-          },
-          {
-            "|": [
-              "fin",
-              "psh",
               "ack"
             ]
           },
@@ -50,21 +41,22 @@
           {
             "|": [
               "fin",
+              "psh",
               "ack"
             ]
           },
           {
             "|": [
-              "syn",
+              "fin",
               "psh",
               "ack",
               "urg"
             ]
           },
+          "syn",
           {
             "|": [
               "syn",
-              "psh",
               "ack"
             ]
           },
@@ -78,22 +70,22 @@
           {
             "|": [
               "syn",
+              "psh",
               "ack"
             ]
           },
-          "syn",
           {
             "|": [
-              "rst",
+              "syn",
               "psh",
               "ack",
               "urg"
             ]
           },
+          "rst",
           {
             "|": [
               "rst",
-              "psh",
               "ack"
             ]
           },
@@ -107,12 +99,13 @@
           {
             "|": [
               "rst",
+              "psh",
               "ack"
             ]
           },
-          "rst",
           {
             "|": [
+              "rst",
               "psh",
               "ack",
               "urg"
@@ -126,11 +119,18 @@
           },
           {
             "|": [
+              "psh",
               "ack",
               "urg"
             ]
           },
-          "ack"
+          "ack",
+          {
+            "|": [
+              "ack",
+              "urg"
+            ]
+          }
         ]
       }
     }
diff --git a/tests/shell/testcases/sets/dumps/0055tcpflags_0.nft b/tests/shell/testcases/sets/dumps/0055tcpflags_0.nft
index ffed5426577e4..22bf5c461b877 100644
--- a/tests/shell/testcases/sets/dumps/0055tcpflags_0.nft
+++ b/tests/shell/testcases/sets/dumps/0055tcpflags_0.nft
@@ -2,9 +2,9 @@ table ip test {
 	set tcp_good_flags {
 		type tcp_flag
 		flags constant
-		elements = { fin | psh | ack | urg, fin | psh | ack, fin | ack | urg, fin | ack, syn | psh | ack | urg,
-			     syn | psh | ack, syn | ack | urg, syn | ack, syn, rst | psh | ack | urg,
-			     rst | psh | ack, rst | ack | urg, rst | ack, rst, psh | ack | urg,
-			     psh | ack, ack | urg, ack }
+		elements = { fin | ack, fin | ack | urg, fin | psh | ack, fin | psh | ack | urg, syn,
+			     syn | ack, syn | ack | urg, syn | psh | ack, syn | psh | ack | urg, rst,
+			     rst | ack, rst | ack | urg, rst | psh | ack, rst | psh | ack | urg, psh | ack,
+			     psh | ack | urg, ack, ack | urg }
 	}
 }
-- 
2.43.0

