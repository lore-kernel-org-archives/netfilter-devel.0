Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE63C47F58;
	Thu, 11 Apr 2024 23:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712878991; cv=none; b=i97i0CDlL940xMI0vQ5eL4lPJ/dyxi04IWmabkgDQp2NvCg4JKfL4ZoN4CeKt9xM7VKGsMEax6bNsNPVPlUGzD7YY8yQ8xMFAVs/kskNesoTmoezUxTcuJiWi8Jjluej9DziF9/GHaKKKN7dsE0XVUeIMNqBdMr/nEovLI6ZgSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712878991; c=relaxed/simple;
	bh=MX8uDJx4isHSYs5Cv9ylLKucX9rcXh9h53YYVatxS3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM3/U1Yk91MxJwlfbyAehWzl976+L2r3pgaSjSd6iE/IDEkxDW83/I61GoDsVp7CHEzWBXaRLYdCGw5eog4iuB9eNW6Ikekg4lF3+1D423pLR39AH+0c9jbrV1Tw9MaEru4t8GV2s/J1DdCxufZpUcDIdcSkubSAwyOhsXJuMmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rv44S-0000xm-IL; Fri, 12 Apr 2024 01:43:08 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 12/15] selftests: netfilter: nft_conntrack_helper.sh: test to lib.sh infra
Date: Fri, 12 Apr 2024 01:36:17 +0200
Message-ID: <20240411233624.8129-13-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240411233624.8129-1-fw@strlen.de>
References: <20240411233624.8129-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

prefer socat over nc, nc has too many incompatible versions around.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_conntrack_helper.sh     | 132 +++++++-----------
 1 file changed, 53 insertions(+), 79 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_conntrack_helper.sh b/tools/testing/selftests/net/netfilter/nft_conntrack_helper.sh
index faa7778d7bd1..abcaa7337197 100755
--- a/tools/testing/selftests/net/netfilter/nft_conntrack_helper.sh
+++ b/tools/testing/selftests/net/netfilter/nft_conntrack_helper.sh
@@ -5,72 +5,48 @@
 # 2. auto-assign still works.
 #
 # Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+
+source lib.sh
+
 ret=0
 
-sfx=$(mktemp -u "XXXXXXXX")
-ns1="ns1-$sfx"
-ns2="ns2-$sfx"
 testipv6=1
 
+checktool "socat -h" "run test without socat"
+checktool "conntrack --version" "run test without conntrack"
+checktool "nft --version" "run test without nft"
+
 cleanup()
 {
-	ip netns del ${ns1}
-	ip netns del ${ns2}
-}
-
-nft --version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without nft tool"
-	exit $ksft_skip
-fi
-
-ip -Version > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without ip tool"
-	exit $ksft_skip
-fi
-
-conntrack -V > /dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without conntrack tool"
-	exit $ksft_skip
-fi
+	ip netns pids "$ns1" | xargs kill 2>/dev/null
 
-which nc >/dev/null 2>&1
-if [ $? -ne 0 ];then
-	echo "SKIP: Could not run test without netcat tool"
-	exit $ksft_skip
-fi
+	ip netns del "$ns1"
+	ip netns del "$ns2"
+}
 
 trap cleanup EXIT
 
-ip netns add ${ns1}
-ip netns add ${ns2}
+setup_ns ns1 ns2
 
-ip link add veth0 netns ${ns1} type veth peer name veth0 netns ${ns2} > /dev/null 2>&1
-if [ $? -ne 0 ];then
+if ! ip link add veth0 netns "$ns1" type veth peer name veth0 netns "$ns2" > /dev/null 2>&1;then
     echo "SKIP: No virtual ethernet pair device support in kernel"
     exit $ksft_skip
 fi
 
-ip -net ${ns1} link set lo up
-ip -net ${ns1} link set veth0 up
+ip -net "$ns1" link set veth0 up
+ip -net "$ns2" link set veth0 up
 
-ip -net ${ns2} link set lo up
-ip -net ${ns2} link set veth0 up
+ip -net "$ns1" addr add 10.0.1.1/24 dev veth0
+ip -net "$ns1" addr add dead:1::1/64 dev veth0 nodad
 
-ip -net ${ns1} addr add 10.0.1.1/24 dev veth0
-ip -net ${ns1} addr add dead:1::1/64 dev veth0
-
-ip -net ${ns2} addr add 10.0.1.2/24 dev veth0
-ip -net ${ns2} addr add dead:1::2/64 dev veth0
+ip -net "$ns2" addr add 10.0.1.2/24 dev veth0
+ip -net "$ns2" addr add dead:1::2/64 dev veth0 nodad
 
 load_ruleset_family() {
 	local family=$1
 	local ns=$2
 
-ip netns exec ${ns} nft -f - <<EOF
+ip netns exec "$ns" nft -f - <<EOF
 table $family raw {
 	ct helper ftp {
              type "ftp" protocol tcp
@@ -94,22 +70,21 @@ check_for_helper()
 	local message=$2
 	local port=$3
 
-	if echo $message |grep -q 'ipv6';then
+	if echo "$message" |grep -q 'ipv6';then
 		local family="ipv6"
 	else
 		local family="ipv4"
 	fi
 
-	ip netns exec ${netns} conntrack -L -f $family -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
-	if [ $? -ne 0 ] ; then
-		if [ $autoassign -eq 0 ] ;then
+	if ! ip netns exec "$netns" conntrack -L -f $family -p tcp --dport "$port" 2> /dev/null |grep -q 'helper=ftp';then
+		if [ "$autoassign" -eq 0 ] ;then
 			echo "FAIL: ${netns} did not show attached helper $message" 1>&2
 			ret=1
 		else
 			echo "PASS: ${netns} did not show attached helper $message" 1>&2
 		fi
 	else
-		if [ $autoassign -eq 0 ] ;then
+		if [ "$autoassign" -eq 0 ] ;then
 			echo "PASS: ${netns} connection on port $port has ftp helper attached" 1>&2
 		else
 			echo "FAIL: ${netns} connection on port $port has ftp helper attached" 1>&2
@@ -120,69 +95,68 @@ check_for_helper()
 	return 0
 }
 
+listener_ready()
+{
+	ns="$1"
+	port="$2"
+	proto="$3"
+	ss -N "$ns" -lnt -o "sport = :$port" | grep -q "$port"
+}
+
 test_helper()
 {
 	local port=$1
 	local autoassign=$2
 
-	if [ $autoassign -eq 0 ] ;then
+	if [ "$autoassign" -eq 0 ] ;then
 		msg="set via ruleset"
 	else
 		msg="auto-assign"
 	fi
 
-	sleep 3 | ip netns exec ${ns2} nc -w 2 -l -p $port > /dev/null &
+	ip netns exec "$ns2" socat -t 3 -u -4 TCP-LISTEN:"$port",reuseaddr STDOUT > /dev/null &
+	busywait "$BUSYWAIT_TIMEOUT" listener_ready "$ns2" "$port" "-4"
 
-	sleep 1 | ip netns exec ${ns1} nc -w 2 10.0.1.2 $port > /dev/null &
-	sleep 1
+	ip netns exec "$ns1" socat -u -4 STDIN TCP:10.0.1.2:"$port" < /dev/null > /dev/null
 
-	check_for_helper "$ns1" "ip $msg" $port $autoassign
-	check_for_helper "$ns2" "ip $msg" $port $autoassign
-
-	wait
+	check_for_helper "$ns1" "ip $msg" "$port" "$autoassign"
+	check_for_helper "$ns2" "ip $msg" "$port" "$autoassign"
 
 	if [ $testipv6 -eq 0 ] ;then
 		return 0
 	fi
 
-	ip netns exec ${ns1} conntrack -F 2> /dev/null
-	ip netns exec ${ns2} conntrack -F 2> /dev/null
-
-	sleep 3 | ip netns exec ${ns2} nc -w 2 -6 -l -p $port > /dev/null &
+	ip netns exec "$ns1" conntrack -F 2> /dev/null
+	ip netns exec "$ns2" conntrack -F 2> /dev/null
 
-	sleep 1 | ip netns exec ${ns1} nc -w 2 -6 dead:1::2 $port > /dev/null &
-	sleep 1
+	ip netns exec "$ns2" socat -t 3 -u -6 TCP-LISTEN:"$port",reuseaddr STDOUT > /dev/null &
+	busywait $BUSYWAIT_TIMEOUT listener_ready "$ns2" "$port" "-6"
 
-	check_for_helper "$ns1" "ipv6 $msg" $port
-	check_for_helper "$ns2" "ipv6 $msg" $port
+	ip netns exec "$ns1" socat -t 3 -u -6 STDIN TCP:"[dead:1::2]":"$port" < /dev/null > /dev/null
 
-	wait
+	check_for_helper "$ns1" "ipv6 $msg" "$port"
+	check_for_helper "$ns2" "ipv6 $msg" "$port"
 }
 
-load_ruleset_family ip ${ns1}
-if [ $? -ne 0 ];then
+if ! load_ruleset_family ip "$ns1"; then
 	echo "FAIL: ${ns1} cannot load ip ruleset" 1>&2
 	exit 1
 fi
 
-load_ruleset_family ip6 ${ns1}
-if [ $? -ne 0 ];then
+if ! load_ruleset_family ip6 "$ns1"; then
 	echo "SKIP: ${ns1} cannot load ip6 ruleset" 1>&2
 	testipv6=0
 fi
 
-load_ruleset_family inet ${ns2}
-if [ $? -ne 0 ];then
+if ! load_ruleset_family inet "${ns2}"; then
 	echo "SKIP: ${ns1} cannot load inet ruleset" 1>&2
-	load_ruleset_family ip ${ns2}
-	if [ $? -ne 0 ];then
+	if ! load_ruleset_family ip "${ns2}"; then
 		echo "FAIL: ${ns2} cannot load ip ruleset" 1>&2
 		exit 1
 	fi
 
-	if [ $testipv6 -eq 1 ] ;then
-		load_ruleset_family ip6 ${ns2}
-		if [ $? -ne 0 ];then
+	if [ "$testipv6" -eq 1 ] ;then
+		if ! load_ruleset_family ip6 "$ns2"; then
 			echo "FAIL: ${ns2} cannot load ip6 ruleset" 1>&2
 			exit 1
 		fi
@@ -190,8 +164,8 @@ if [ $? -ne 0 ];then
 fi
 
 test_helper 2121 0
-ip netns exec ${ns1} sysctl -qe 'net.netfilter.nf_conntrack_helper=1'
-ip netns exec ${ns2} sysctl -qe 'net.netfilter.nf_conntrack_helper=1'
+ip netns exec "$ns1" sysctl -qe 'net.netfilter.nf_conntrack_helper=1'
+ip netns exec "$ns2" sysctl -qe 'net.netfilter.nf_conntrack_helper=1'
 test_helper 21 1
 
 exit $ret
-- 
2.43.2

