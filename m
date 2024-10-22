Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D031B19C547;
	Tue, 22 Oct 2024 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729610639; cv=none; b=XwFsC7XOYBz4jGgBoa11FAA2tGeRs8LISOjgMSdaGckBlR9xiS4kopCBvG5VdHAI5mz3vLf0m2yF8UpZNfdjHlAi/NP6SbYuT0GXZCuBhUGmRWFBpNCHhOYxc7t76r9z7k3NZd6IENvLA35O4+Le6rsLE+h1ZA75JRC1CRPXs8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729610639; c=relaxed/simple;
	bh=OTodVjqQkcoVjtPea+cWFU6tnjAm1M+tQr7XzBI+L+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XTSwpzPk1cwjxEEtnRRmmMJ/pNcNTvy6ylq/PhCvv5TO53JBpt6zrV8qhqIaPa/ARVM4EfgJVbACR7V+8KtIqti56iusgeVLxmvaKGTO35q7sjQ+Hu2FM0LDbL7B9DU1cDnpkWEegsz88KY1BDvTNBBh1RoHsC0Zorr1AuQxc/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t3GjV-0001du-LL; Tue, 22 Oct 2024 17:23:41 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net] selftests: netfilter: nft_flowtable.sh: make first pass deterministic
Date: Tue, 22 Oct 2024 17:23:18 +0200
Message-ID: <20241022152324.13554-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CI occasionaly encounters a failing test run.  Example:
 # PASS: ipsec tunnel mode for ns1/ns2
 # re-run with random mtus: -o 10966 -l 19499 -r 31322
 # PASS: flow offloaded for ns1/ns2
[..]
 # FAIL: ipsec tunnel ... counter 1157059 exceeds expected value 878489

This script will re-exec itself, on the second run, random MTUs are
chosen for the involved links.  This is done so we can cover different
combinations (large mtu on client, small on server, link has lowest
mtu, etc).

Furthermore, file size is random, even for the first run.

Rework this script and always use the same file size on initial run so
that at least the first round can be expected to have reproducible
behavior.

Second round will use random mtu/filesize.

Raise the failure limit to that of the file size, this should avoid all
errneous test errors.  Currently, first fin will remove the offload, so if
one peer is already closing remaining data is handled by classic path,
which result in larger-than-expected counter and a test failure.

Given packet path also counts tcp/ip headers, in case offload is
completely broken this test will still fail (as expected).

The test counter limit could be made more strict again in the future
once flowtable can keep a connection in offloaded state until FINs
in both directions were seen.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 If you prefer you can also apply this to net-next instead.

 .../selftests/net/netfilter/nft_flowtable.sh  | 39 ++++++++++---------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index b3995550856a..a4ee5496f2a1 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -71,6 +71,8 @@ omtu=9000
 lmtu=1500
 rmtu=2000
 
+filesize=$((2 * 1024 * 1024))
+
 usage(){
 	echo "nft_flowtable.sh [OPTIONS]"
 	echo
@@ -81,12 +83,13 @@ usage(){
 	exit 1
 }
 
-while getopts "o:l:r:" o
+while getopts "o:l:r:s:" o
 do
 	case $o in
 		o) omtu=$OPTARG;;
 		l) lmtu=$OPTARG;;
 		r) rmtu=$OPTARG;;
+		s) filesize=$OPTARG;;
 		*) usage;;
 	esac
 done
@@ -217,18 +220,10 @@ ns2out=$(mktemp)
 
 make_file()
 {
-	name=$1
-
-	SIZE=$((RANDOM % (1024 * 128)))
-	SIZE=$((SIZE + (1024 * 8)))
-	TSIZE=$((SIZE * 1024))
-
-	dd if=/dev/urandom of="$name" bs=1024 count=$SIZE 2> /dev/null
+	name="$1"
+	sz="$2"
 
-	SIZE=$((RANDOM % 1024))
-	SIZE=$((SIZE + 128))
-	TSIZE=$((TSIZE + SIZE))
-	dd if=/dev/urandom conf=notrunc of="$name" bs=1 count=$SIZE 2> /dev/null
+	head -c "$sz" < /dev/urandom > "$name"
 }
 
 check_counters()
@@ -246,18 +241,18 @@ check_counters()
 	local fs
 	fs=$(du -sb "$nsin")
 	local max_orig=${fs%%/*}
-	local max_repl=$((max_orig/4))
+	local max_repl=$((max_orig))
 
 	# flowtable fastpath should bypass normal routing one, i.e. the counters in forward hook
 	# should always be lower than the size of the transmitted file (max_orig).
 	if [ "$orig_cnt" -gt "$max_orig" ];then
-		echo "FAIL: $what: original counter $orig_cnt exceeds expected value $max_orig" 1>&2
+		echo "FAIL: $what: original counter $orig_cnt exceeds expected value $max_orig, reply counter $repl_cnt" 1>&2
 		ret=1
 		ok=0
 	fi
 
 	if [ "$repl_cnt" -gt $max_repl ];then
-		echo "FAIL: $what: reply counter $repl_cnt exceeds expected value $max_repl" 1>&2
+		echo "FAIL: $what: reply counter $repl_cnt exceeds expected value $max_repl, original counter $orig_cnt" 1>&2
 		ret=1
 		ok=0
 	fi
@@ -455,7 +450,7 @@ test_tcp_forwarding_nat()
 	return $lret
 }
 
-make_file "$nsin"
+make_file "$nsin" "$filesize"
 
 # First test:
 # No PMTU discovery, nsr1 is expected to fragment packets from ns1 to ns2 as needed.
@@ -664,8 +659,16 @@ if [ "$1" = "" ]; then
 	l=$(((RANDOM%mtu) + low))
 	r=$(((RANDOM%mtu) + low))
 
-	echo "re-run with random mtus: -o $o -l $l -r $r"
-	$0 -o "$o" -l "$l" -r "$r"
+	MINSIZE=$((2 *  1000 * 1000))
+	MAXSIZE=$((64 * 1000 * 1000))
+
+	filesize=$(((RANDOM * RANDOM) % MAXSIZE))
+	if [ "$filesize" -lt "$MINSIZE" ]; then
+		filesize=$((filesize+MINSIZE))
+	fi
+
+	echo "re-run with random mtus and file size: -o $o -l $l -r $r -s $filesize"
+	$0 -o "$o" -l "$l" -r "$r" -s "$filesize"
 fi
 
 exit $ret
-- 
2.45.2

