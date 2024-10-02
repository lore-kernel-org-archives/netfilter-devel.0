Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6749216A2D;
	Wed,  2 Oct 2024 20:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727900676; cv=none; b=AstlquYIHo6GjXkpAwowHOYb0Fz5HV75zyFOzR7EVDfGCzNRrTPo9dlOAemiu8i5VifEsLO6d5DJVrYxJo0AaY/sZL9+mnTuS6ZIcFWWsbDQwO+D+emCOrqKwORGNoqRE1h6U2Tjmu3c/c3XV8+jbA9dJCzqnQnKadrUyBuQ4EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727900676; c=relaxed/simple;
	bh=nViKH115qa5hIsUmBIx21jNNg9IrP6dieQ65e8twGKo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SgoXgeVK0YO04smz2SBfZIkG1CYw7u5UQmb+QGHQ7eay5Go7ivwS9NKxg1EAX65pMoCvF3XwsN7xxTkKt8gkpzKEg/u6XorSiF4KNRCyqp8c/eFyrQ5KYI/GzCTP24aQb4oHcj6JPngDAxVNYR/AgoioTXMiLAd7bqerFfQPyvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 2/4] selftests: netfilter: Fix nft_audit.sh for newer nft binaries
Date: Wed,  2 Oct 2024 22:24:19 +0200
Message-Id: <20241002202421.1281311-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241002202421.1281311-1-pablo@netfilter.org>
References: <20241002202421.1281311-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

As a side-effect of nftables' commit dbff26bfba833 ("cache: consolidate
reset command"), audit logs changed when more objects were reset than
fit into a single netlink message.

Since the objects' distribution in netlink messages is not relevant,
implement a summarizing function which combines repeated audit logs into
a single one with summed up 'entries=' value.

Fixes: 203bb9d39866 ("selftests: netfilter: Extend nft_audit.sh")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

