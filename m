Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A201369BF;
	Sun, 14 Apr 2024 23:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713135896; cv=none; b=Pan9PES96+G0UL7ES0jA/u+43nR5r5nYhAOBclWy1A5Ee8ym9v8A0ixkJVm/pQNKER4QsRWKr5hm9K++QF3x26pdgk1geAX/PvoxKYOmUnr6xgK9iSby4IyUBylsc2CnVX4sK3wU7Nc8kldkV+y4u6e2emsRR+RiuBNQLXGGbMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713135896; c=relaxed/simple;
	bh=CYMECbFjAP6fMd+pxWOaX4ssSIUxkUnXd0x+d9YNe5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPH0SqCUOYgIMLSSho2jx/IE9x14ddTOamfAjEg3z9FqnZn/Aq+IdpiC1ULQ+6VpKUMwkXoUmcWzrKo/2OXTkRuvKP5s9OucDrFcFuCwRrch1dhfshpyjyulNw2Fxc+KSc6B+P+ttn0Dfo11mcRqndkZX8OOCeeaXsURGdLS+PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rw8u4-0002Yb-5s; Mon, 15 Apr 2024 01:04:52 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 11/12] selftests: netfilter: nft_audit.sh: skip if auditd is running
Date: Mon, 15 Apr 2024 00:57:23 +0200
Message-ID: <20240414225729.18451-12-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240414225729.18451-1-fw@strlen.de>
References: <20240414225729.18451-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This testcase doesn't work if auditd is running, audit_logread will not
receive any data in that case.

Skip if auditd is already running.  While at it, do a few minor
shellcheck cleanups.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_audit.sh       | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_audit.sh b/tools/testing/selftests/net/netfilter/nft_audit.sh
index 99ed5bd6e840..80936d70fcf6 100755
--- a/tools/testing/selftests/net/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/net/netfilter/nft_audit.sh
@@ -6,6 +6,16 @@
 SKIP_RC=4
 RC=0
 
+if [ -r /var/run/auditd.pid ];then
+	read pid < /var/run/auditd.pid
+	p=$(pgrep ^auditd$)
+
+	if [ "$pid" -eq "$p" ]; then
+		echo "SKIP: auditd is running"
+		exit $SKIP_RC
+	fi
+fi
+
 nft --version >/dev/null 2>&1 || {
 	echo "SKIP: missing nft tool"
 	exit $SKIP_RC
@@ -73,7 +83,7 @@ done
 
 for ((i = 0; i < 500; i++)); do
 	echo "add rule t2 c3 counter accept comment \"rule $i\""
-done >$rulefile
+done > "$rulefile"
 do_test "nft -f $rulefile" \
 'table=t2 family=2 entries=500 op=nft_register_rule'
 
@@ -101,7 +111,7 @@ do_test 'nft add counter t2 c1; add counter t2 c2' \
 
 for ((i = 3; i <= 500; i++)); do
 	echo "add counter t2 c$i"
-done >$rulefile
+done > "$rulefile"
 do_test "nft -f $rulefile" \
 'table=t2 family=2 entries=498 op=nft_register_obj'
 
@@ -115,7 +125,7 @@ do_test 'nft add quota t2 q1 { 10 bytes }; add quota t2 q2 { 10 bytes }' \
 
 for ((i = 3; i <= 500; i++)); do
 	echo "add quota t2 q$i { 10 bytes }"
-done >$rulefile
+done > "$rulefile"
 do_test "nft -f $rulefile" \
 'table=t2 family=2 entries=498 op=nft_register_obj'
 
@@ -157,7 +167,7 @@ table=t2 family=2 entries=135 op=nft_reset_rule'
 
 # resetting sets and elements
 
-elem=(22 ,80 ,443)
+elem=(22 ",80" ",443")
 relem=""
 for i in {1..3}; do
 	relem+="${elem[((i - 1))]}"
-- 
2.43.2

