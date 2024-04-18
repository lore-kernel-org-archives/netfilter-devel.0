Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308D116C697;
	Thu, 18 Apr 2024 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713454223; cv=none; b=sBeKnL57gEhWmbedWC428nILFkpFJ8opweiZU1qXsdunuhlNYCM3DdEpFOVDpeE7UvAuhlxDIy0mL9GB090s4LADUTFVeufveUgKlztmiBkSmD0KUaxlDInYXJMJKA8zCMOAjbSvpThPv9KVrhwjfuFvIoj5iuJS3YlXhTA7Fr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713454223; c=relaxed/simple;
	bh=ir5dmaOLullcI+hF+BiwqizY4fgPBd0YBRDRRsM0OwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfaQ+Gwp25cABy6Xxt/kdp2dgpkWG3+fj/Mg0QbHsq9jb6+pn0Rb7xNLYLXQxBa7O6HfW46cCtYRLnDymhzeJXYgIEbtQArttCYtE5TsmQB1Tg8mM6iZe8i3On+vic3SpcG3kvObyzGyLE2Ghdd8e1tdmL7uBD9YGKnYjKs1C5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rxTiL-000090-GC; Thu, 18 Apr 2024 17:30:17 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next v2 06/12] selftests: netfilter: xt_string.sh: shellcheck cleanups
Date: Thu, 18 Apr 2024 17:27:34 +0200
Message-ID: <20240418152744.15105-7-fw@strlen.de>
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

no functional change intended.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/xt_string.sh      | 34 +++++++++----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/xt_string.sh b/tools/testing/selftests/net/netfilter/xt_string.sh
index ec7042b502e4..8d401c69e317 100755
--- a/tools/testing/selftests/net/netfilter/xt_string.sh
+++ b/tools/testing/selftests/net/netfilter/xt_string.sh
@@ -37,7 +37,7 @@ hdrlen=$((20 + 8)) # IPv4 + UDP
 add_rule() { # (alg, from, to)
 	ip netns exec "$netns" \
 		iptables -A OUTPUT -o d0 -m string \
-			--string "$pattern" --algo $1 --from $2 --to $3
+			--string "$pattern" --algo "$1" --from "$2" --to "$3"
 }
 showrules() { # ()
 	ip netns exec "$netns" iptables -v -S OUTPUT | grep '^-A'
@@ -49,10 +49,10 @@ countrule() { # (pattern)
 	showrules | grep -c -- "$*"
 }
 send() { # (offset)
-	( for ((i = 0; i < $1 - $hdrlen; i++)); do
-		printf " "
+	( for ((i = 0; i < $1 - hdrlen; i++)); do
+		echo -n " "
 	  done
-	  printf "$pattern"
+	  echo -n "$pattern"
 	) > "$infile"
 
 	ip netns exec "$netns" socat -t 1 -u STDIN UDP-SENDTO:10.1.2.2:27374 < "$infile"
@@ -65,8 +65,8 @@ add_rule kmp 1400 1600
 
 zerorules
 send 0
-send $((1000 - $patlen))
-if [ $(countrule -c 0 0) -ne 4 ]; then
+send $((1000 - patlen))
+if [ "$(countrule -c 0 0)" -ne 4 ]; then
 	echo "FAIL: rules match data before --from"
 	showrules
 	((rc--))
@@ -74,16 +74,16 @@ fi
 
 zerorules
 send 1000
-send $((1400 - $patlen))
-if [ $(countrule -c 2) -ne 2 ]; then
+send $((1400 - patlen))
+if [ "$(countrule -c 2)" -ne 2 ]; then
 	echo "FAIL: only two rules should match at low offset"
 	showrules
 	((rc--))
 fi
 
 zerorules
-send $((1500 - $patlen))
-if [ $(countrule -c 1) -ne 4 ]; then
+send $((1500 - patlen))
+if [ "$(countrule -c 1)" -ne 4 ]; then
 	echo "FAIL: all rules should match at end of packet"
 	showrules
 	((rc--))
@@ -91,7 +91,7 @@ fi
 
 zerorules
 send 1495
-if [ $(countrule -c 1) -ne 1 ]; then
+if [ "$(countrule -c 1)" -ne 1 ]; then
 	echo "FAIL: only kmp with proper --to should match pattern spanning fragments"
 	showrules
 	((rc--))
@@ -99,23 +99,23 @@ fi
 
 zerorules
 send 1500
-if [ $(countrule -c 1) -ne 2 ]; then
+if [ "$(countrule -c 1)" -ne 2 ]; then
 	echo "FAIL: two rules should match pattern at start of second fragment"
 	showrules
 	((rc--))
 fi
 
 zerorules
-send $((1600 - $patlen))
-if [ $(countrule -c 1) -ne 2 ]; then
+send $((1600 - patlen))
+if [ "$(countrule -c 1)" -ne 2 ]; then
 	echo "FAIL: two rules should match pattern at end of largest --to"
 	showrules
 	((rc--))
 fi
 
 zerorules
-send $((1600 - $patlen + 1))
-if [ $(countrule -c 1) -ne 0 ]; then
+send $((1600 - patlen + 1))
+if [ "$(countrule -c 1)" -ne 0 ]; then
 	echo "FAIL: no rules should match pattern extending largest --to"
 	showrules
 	((rc--))
@@ -123,7 +123,7 @@ fi
 
 zerorules
 send 1600
-if [ $(countrule -c 1) -ne 0 ]; then
+if [ "$(countrule -c 1)" -ne 0 ]; then
 	echo "FAIL: no rule should match pattern past largest --to"
 	showrules
 	((rc--))
-- 
2.43.2

