Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F124158A13
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 16:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727369799; cv=none; b=jQJfN818HuEiT2OBw2Ag10KFMerSSNParjEG4SnGXJtQoV02QrNvEhS3XUiwEZCJ1INEZ2rcC2KQ7d2u8OkOSeuZmWHF/2gMdLxzPP/sfBd3JU3oZE3l0MEi1OzKyA/VlD3TzN6Ym71tUPT+lfpQ5xL75iUn6ZvCs24Y46GRwFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727369799; c=relaxed/simple;
	bh=snjTAr5CuPRVdXEdi5Ht82y1bshoseIxOBfsZ6zsmjA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RI5yebIMuFdlIIkdMpGakcFtGimpFBm6/2KAm8KwIvgcxnnccPSyTgC2iMWTjhWmf7FdbsY7b29JyDne9FyZC4kFNPgVjFJGQUimZ05G4VtKZL3o0srX7tZGr2TQHyCVmeAIKDYO50AL6tI2H/nlj4TqUvkbzFV/4gfQgfTZ+VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=AL1gL4eo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="AL1gL4eo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=h29pfhENhwbBOKQdbU853CQy8jDc/ZnHCoFprtexOTI=; b=AL1gL4eoucKB8j6XAp3O4IKhsn
	Yw0Jed2pT4YW59BaPWHSxI4WcO1hqlphJkuoguBAPiDWW/0PtmgSM+BYFOkhB0JmW870mR3v/JnNt
	n25caQVkyx5XcxOTeeYW26iPVXw1xMh009LJumG8bP6ToanKKwDNaJFkfPhnBDJNH/dGcuQjyKRK1
	QJb7JGhmn4o7a1zmy83s6lmKdQ+M1wnbjI4ThwSL3iYn+uDxbQvnfBHSb1A9pLtFIlEebpUdeK7bm
	eVFY8Qi1ge3Jkpg3gObG+orHakISR2bw00NHBiT3TIrkmwrVvd6bGmYnxZ0r3oEnebHbdr5Dx+E3V
	tS+RoNJA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1strn8-000000003gU-2iSp;
	Thu, 26 Sep 2024 18:56:34 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf PATCH] selftests: netfilter: Fix nft_audit.sh for newer nft binaries
Date: Thu, 26 Sep 2024 18:56:31 +0200
Message-ID: <20240926165631.28107-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As a side-effect of nftables' commit dbff26bfba833 ("cache: consolidate
reset command"), audit logs changed when more objects were reset than
fit into a single netlink message.

Since the objects' distribution in netlink messages is not relevant,
implement a summarizing function which combines repeated audit logs into
a single one with summed up 'entries=' value.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../selftests/net/netfilter/nft_audit.sh      | 57 ++++++++++---------
 1 file changed, 29 insertions(+), 28 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_audit.sh b/tools/testing/selftests/net/netfilter/nft_audit.sh
index 902f8114bc80..87f2b4c725aa 100755
--- a/tools/testing/selftests/net/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/net/netfilter/nft_audit.sh
@@ -48,12 +48,31 @@ logread_pid=$!
 trap 'kill $logread_pid; rm -f $logfile $rulefile' EXIT
 exec 3<"$logfile"
 
+lsplit='s/^\(.*\) entries=\([^ ]*\) \(.*\)$/pfx="\1"\nval="\2"\nsfx="\3"/'
+summarize_logs() {
+	sum=0
+	while read line; do
+		eval $(sed "$lsplit" <<< "$line")
+		[[ $sum -gt 0 ]] && {
+			[[ "$pfx $sfx" == "$tpfx $tsfx" ]] && {
+				let "sum += val"
+				continue
+			}
+			echo "$tpfx entries=$sum $tsfx"
+		}
+		tpfx="$pfx"
+		tsfx="$sfx"
+		sum=$val
+	done
+	echo "$tpfx entries=$sum $tsfx"
+}
+
 do_test() { # (cmd, log)
 	echo -n "testing for cmd: $1 ... "
 	cat <&3 >/dev/null
 	$1 >/dev/null || exit 1
 	sleep 0.1
-	res=$(diff -a -u <(echo "$2") - <&3)
+	res=$(diff -a -u <(echo "$2") <(summarize_logs <&3))
 	[ $? -eq 0 ] && { echo "OK"; return; }
 	echo "FAIL"
 	grep -v '^\(---\|+++\|@@\)' <<< "$res"
@@ -152,31 +171,17 @@ do_test 'nft reset rules t1 c2' \
 'table=t1 family=2 entries=3 op=nft_reset_rule'
 
 do_test 'nft reset rules table t1' \
-'table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule'
+'table=t1 family=2 entries=9 op=nft_reset_rule'
 
 do_test 'nft reset rules t2 c3' \
-'table=t2 family=2 entries=189 op=nft_reset_rule
-table=t2 family=2 entries=188 op=nft_reset_rule
-table=t2 family=2 entries=126 op=nft_reset_rule'
+'table=t2 family=2 entries=503 op=nft_reset_rule'
 
 do_test 'nft reset rules t2' \
-'table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=186 op=nft_reset_rule
-table=t2 family=2 entries=188 op=nft_reset_rule
-table=t2 family=2 entries=129 op=nft_reset_rule'
+'table=t2 family=2 entries=509 op=nft_reset_rule'
 
 do_test 'nft reset rules' \
-'table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule
-table=t1 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=3 op=nft_reset_rule
-table=t2 family=2 entries=180 op=nft_reset_rule
-table=t2 family=2 entries=188 op=nft_reset_rule
-table=t2 family=2 entries=135 op=nft_reset_rule'
+'table=t1 family=2 entries=9 op=nft_reset_rule
+table=t2 family=2 entries=509 op=nft_reset_rule'
 
 # resetting sets and elements
 
@@ -200,13 +205,11 @@ do_test 'nft reset counters t1' \
 'table=t1 family=2 entries=1 op=nft_reset_obj'
 
 do_test 'nft reset counters t2' \
-'table=t2 family=2 entries=342 op=nft_reset_obj
-table=t2 family=2 entries=158 op=nft_reset_obj'
+'table=t2 family=2 entries=500 op=nft_reset_obj'
 
 do_test 'nft reset counters' \
 'table=t1 family=2 entries=1 op=nft_reset_obj
-table=t2 family=2 entries=341 op=nft_reset_obj
-table=t2 family=2 entries=159 op=nft_reset_obj'
+table=t2 family=2 entries=500 op=nft_reset_obj'
 
 # resetting quotas
 
@@ -217,13 +220,11 @@ do_test 'nft reset quotas t1' \
 'table=t1 family=2 entries=1 op=nft_reset_obj'
 
 do_test 'nft reset quotas t2' \
-'table=t2 family=2 entries=315 op=nft_reset_obj
-table=t2 family=2 entries=185 op=nft_reset_obj'
+'table=t2 family=2 entries=500 op=nft_reset_obj'
 
 do_test 'nft reset quotas' \
 'table=t1 family=2 entries=1 op=nft_reset_obj
-table=t2 family=2 entries=314 op=nft_reset_obj
-table=t2 family=2 entries=186 op=nft_reset_obj'
+table=t2 family=2 entries=500 op=nft_reset_obj'
 
 # deleting rules
 
-- 
2.43.0

