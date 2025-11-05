Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5662E229C
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361311; cv=none; b=oOuQFr52nWTyo1HZqPHEXsSulSkhP2CTo2iGAqp+OhlwQqheW6NcX1+M36BH9Xum2g7E9YZ/pp8NXtj+htq//rQavZB3uca3RPI3Zux4T9rI3rOp4/NOyVVV9fejtY50B0QVetHCm4jp4Wv3Fio1bkXX+p9xowlwFEwH+ZnwtCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361311; c=relaxed/simple;
	bh=MP7s1HjGxMXGuI4TmEfxtVdahYFmuwiiTnYXEs39Kz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSo6pTRt0NoIzJuGbGVzTLaXw41GcJ9R7bolYUZZLGQGjuxsHJ7ESBW+rE1wif0pK193CJjrPHeK02Z8T6i+fyPCC1XjtWOZPfljP0B8dGahE9l9KY0nXoO8cV6yjZXHaug1rSr5iAM8pOcTmcpZO1nY5WJdFK7nM1pGgyGEkb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0D733603CA; Wed,  5 Nov 2025 17:48:27 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 03/11] tests: netfilter: conntrack_resize: prepare for pernet conntrack table
Date: Wed,  5 Nov 2025 17:47:57 +0100
Message-ID: <20251105164805.3992-4-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105164805.3992-1-fw@strlen.de>
References: <20251105164805.3992-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test_conntrack_max_limit subtest will fail once we have pernet
tables, each netns can set its own limits, not bound by init_net max
setting.

Also, because ct hashtable is allocated on demand,
net.netfilter.nf_conntrack_buckets will be 0 until first user enables
conntrack, so don't try to reset this value to 0 when that was the
original value.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/conntrack_resize.sh         | 26 +++++--------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_resize.sh b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
index 615fe3c6f405..c155de936287 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_resize.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
@@ -35,7 +35,7 @@ cleanup() {
 
 	# restore original sysctl setting
 	sysctl -q net.netfilter.nf_conntrack_max=$init_net_max
-	sysctl -q net.netfilter.nf_conntrack_buckets=$ct_buckets
+	[ "$ct_buckets" -gt 0 ] && sysctl -q net.netfilter.nf_conntrack_buckets=$ct_buckets
 }
 trap cleanup EXIT
 
@@ -90,9 +90,11 @@ ctresize() {
 	local duration="$1"
 	local now=$(date +%s)
 	local end=$((now + duration))
+	local rnd
 
 	while [ $now -lt $end ]; do
-		sysctl -q net.netfilter.nf_conntrack_buckets=$RANDOM
+		rnd=$((RANDOM+1))
+		sysctl -q net.netfilter.nf_conntrack_buckets=$rnd
 		now=$(date +%s)
 	done
 }
@@ -434,18 +436,6 @@ check_sysctl_immutable()
 	return 1
 }
 
-test_conntrack_max_limit()
-{
-	sysctl -q net.netfilter.nf_conntrack_max=100
-	insert_ctnetlink "$nsclient1" 101
-
-	# check netns is clamped by init_net, i.e., either netns follows
-	# init_net value, or a higher pernet limit (compared to init_net) is ignored.
-	check_ctcount "$nsclient1" 100 "netns conntrack_max is init_net bound"
-
-	sysctl -q net.netfilter.nf_conntrack_max=$init_net_max
-}
-
 test_conntrack_disable()
 {
 	local timeout=2
@@ -476,15 +466,12 @@ check_max_alias 262000
 setup_ns nsclient1 nsclient2
 
 # check this only works from init_net
-for n in netfilter.nf_conntrack_buckets netfilter.nf_conntrack_expect_max net.nf_conntrack_max;do
-	check_sysctl_immutable "$nsclient1" "net.$n" 1
-done
+check_sysctl_immutable "$nsclient1" "net.$netfilter.nf_conntrack_expect_max" 1
 
 # won't work on older kernels. If it works, check that the netns obeys the limit
 if check_sysctl_immutable "$nsclient1" net.netfilter.nf_conntrack_max 0;then
 	# subtest: if pernet is changeable, check that reducing it in pernet
-	# limits the pernet entries.  Inverse, pernet clamped by a lower init_net
-	# setting, is already checked by "test_conntrack_max_limit" test.
+	# limits the pernet entries.
 
 	ip netns exec "$nsclient1" sysctl -q net.netfilter.nf_conntrack_max=1
 	insert_ctnetlink "$nsclient1" 2
@@ -507,7 +494,6 @@ done
 tmpfile=$(mktemp)
 tmpfile_proc=$(mktemp)
 tmpfile_uniq=$(mktemp)
-test_conntrack_max_limit
 test_dump_all
 test_floodresize_all
 test_conntrack_disable
-- 
2.51.0

