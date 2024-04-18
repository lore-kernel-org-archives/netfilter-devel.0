Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED3F16C6BC;
	Thu, 18 Apr 2024 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454244; cv=none; b=iIFAk8sPJL+f7HcREkqp5xOJpnzFNf8xjfHbVCCYna9h691sMQPIY+Ury69c87HLuIzaL2p8XypQoHc5AvM3qiNe2DlGNDuPjYYT/pVYiFvk7q0Wo2JerrnKphlNlPrd2XfiSxczWhoj7h60C6pGsmko1yK8z9JqNrmfsG9bquk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454244; c=relaxed/simple;
	bh=2tL09bEWXxqleLCSY98tgicFB0nHxUPtRHQ4lToBe/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6b2tqd3yc6YuCE+gA/51TgEr0BdOf8i7Z8czwejAkGchA52G/hGFDrQirCiqesSCrOMMD7oJK1vyzYgWe4vkDPWstxvb9Ty7WP15UC0j4JkCNKDaeV6WierG+feo7YVx0R2AGqrFds9Ql/YlaZFBga3/JRvtw+KiQxLnErMCRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rxTif-0000BH-U1; Thu, 18 Apr 2024 17:30:37 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next v2 11/12] selftests: netfilter: nft_audit.sh: add more skip checks
Date: Thu, 18 Apr 2024 17:27:39 +0200
Message-ID: <20240418152744.15105-12-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240418152744.15105-1-fw@strlen.de>
References: <20240418152744.15105-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This testcase doesn't work if auditd is running, audit_logread will not
receive any data in that case.

Add a nftables feature test for the reset keyword and skip this test
if that fails.

While at it, do a few minor shellcheck cleanups.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_audit.sh      | 30 ++++++++++++++++---
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_audit.sh b/tools/testing/selftests/net/netfilter/nft_audit.sh
index 99ed5bd6e840..b390437696ba 100755
--- a/tools/testing/selftests/net/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/net/netfilter/nft_audit.sh
@@ -6,11 +6,33 @@
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
 }
 
+# nft must be recent enough to support "reset" keyword.
+nft --check -f /dev/stdin >/dev/null 2>&1 <<EOF
+add table t
+add chain t c
+reset rules t c
+EOF
+
+if [ "$?" -ne 0 ];then
+	echo "SKIP: nft reset feature test failed"
+	exit $SKIP_RC
+fi
+
 # Run everything in a separate network namespace
 [ "${1}" != "run" ] && { unshare -n "${0}" run; exit $?; }
 
@@ -73,7 +95,7 @@ done
 
 for ((i = 0; i < 500; i++)); do
 	echo "add rule t2 c3 counter accept comment \"rule $i\""
-done >$rulefile
+done > "$rulefile"
 do_test "nft -f $rulefile" \
 'table=t2 family=2 entries=500 op=nft_register_rule'
 
@@ -101,7 +123,7 @@ do_test 'nft add counter t2 c1; add counter t2 c2' \
 
 for ((i = 3; i <= 500; i++)); do
 	echo "add counter t2 c$i"
-done >$rulefile
+done > "$rulefile"
 do_test "nft -f $rulefile" \
 'table=t2 family=2 entries=498 op=nft_register_obj'
 
@@ -115,7 +137,7 @@ do_test 'nft add quota t2 q1 { 10 bytes }; add quota t2 q2 { 10 bytes }' \
 
 for ((i = 3; i <= 500; i++)); do
 	echo "add quota t2 q$i { 10 bytes }"
-done >$rulefile
+done > "$rulefile"
 do_test "nft -f $rulefile" \
 'table=t2 family=2 entries=498 op=nft_register_obj'
 
@@ -157,7 +179,7 @@ table=t2 family=2 entries=135 op=nft_reset_rule'
 
 # resetting sets and elements
 
-elem=(22 ,80 ,443)
+elem=(22 ",80" ",443")
 relem=""
 for i in {1..3}; do
 	relem+="${elem[((i - 1))]}"
-- 
2.43.2

