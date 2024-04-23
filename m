Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D857E101;
	Tue, 23 Apr 2024 11:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713870677; cv=none; b=OGbmCmm9ApnalX6vWShfQUzGPdSp4XO0wDlxFk1eV4o6CEBnuoKCzNRdT0MToUJzPvsDQHai0EUsyiOZDFquFBLmidnFfJuZSHtDjKYGuNH29xoBRS6nWQr0LDRchkHKxIeYflH8OFUEEWasrP5oxpBak09v5aBO6bxZ9NRp9X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713870677; c=relaxed/simple;
	bh=1ToGxX5smLuzy0eBhos4Q8wXruXszNCaI66tNz9rn+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vu1uBxR0xg9U8EyKtUYGQkQWHMMy4FNF1/oNA9yr9j2i4yt3zdr99/gfPWxSzPuU302nmXfpsa3kPdSQj2d1OJNs730Pvv4QkJm6S8UIJogS5WlhgQFHl/eN9mUkvrk0ZIJcYS6zscDiKWKRs+aoBnvYu0I2FLo16fhKsSXJQZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzE3G-0006vX-RV; Tue, 23 Apr 2024 13:11:06 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 2/7] selftests: netfilter: nft_concat_range.sh: drop netcat support
Date: Tue, 23 Apr 2024 15:05:45 +0200
Message-ID: <20240423130604.7013-3-fw@strlen.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240423130604.7013-1-fw@strlen.de>
References: <20240423130604.7013-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tests fail on my workstation with netcat 110, instead of debugging+more
workarounds just remove this.

Tests will fall back to bash or socat.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../net/netfilter/nft_concat_range.sh         | 74 ++++---------------
 1 file changed, 13 insertions(+), 61 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
index 877c9d3777d2..2160de014525 100755
--- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
@@ -66,7 +66,7 @@ src
 start		1
 count		5
 src_delta	2000
-tools		sendip nc bash
+tools		sendip bash
 proto		udp
 
 race_repeat	3
@@ -91,7 +91,7 @@ src
 start		1
 count		5
 src_delta	2000
-tools		sendip socat nc bash
+tools		sendip socat bash
 proto		udp
 
 race_repeat	3
@@ -116,7 +116,7 @@ src
 start		10
 count		5
 src_delta	2000
-tools		sendip socat nc bash
+tools		sendip socat bash
 proto		udp6
 
 race_repeat	3
@@ -141,7 +141,7 @@ src
 start		1
 count		5
 src_delta	2000
-tools		sendip socat nc bash
+tools		sendip socat bash
 proto		udp
 
 race_repeat	0
@@ -163,7 +163,7 @@ src		mac
 start		10
 count		5
 src_delta	2000
-tools		sendip socat nc bash
+tools		sendip socat bash
 proto		udp6
 
 race_repeat	0
@@ -185,7 +185,7 @@ src		mac proto
 start		10
 count		5
 src_delta	2000
-tools		sendip socat nc bash
+tools		sendip socat bash
 proto		udp6
 
 race_repeat	0
@@ -207,7 +207,7 @@ src		addr4
 start		1
 count		5
 src_delta	2000
-tools		sendip socat nc bash
+tools		sendip socat bash
 proto		udp
 
 race_repeat	3
@@ -227,7 +227,7 @@ src		addr6 port
 start		10
 count		5
 src_delta	2000
-tools		sendip socat nc
+tools		sendip socat
 proto		udp6
 
 race_repeat	3
@@ -247,7 +247,7 @@ src		mac proto addr4
 start		1
 count		5
 src_delta	2000
-tools		sendip socat nc bash
+tools		sendip socat bash
 proto		udp
 
 race_repeat	0
@@ -264,7 +264,7 @@ src		mac
 start		1
 count		5
 src_delta	2000
-tools		sendip socat nc bash
+tools		sendip socat bash
 proto		udp
 
 race_repeat	0
@@ -286,7 +286,7 @@ src		mac addr4
 start		1
 count		5
 src_delta	2000
-tools		sendip socat nc bash
+tools		sendip socat bash
 proto		udp
 
 race_repeat	0
@@ -337,7 +337,7 @@ src		addr4
 start		1
 count		5
 src_delta	2000
-tools		sendip socat nc
+tools		sendip socat
 proto		udp
 
 race_repeat	3
@@ -363,7 +363,7 @@ src		mac
 start		1
 count		1
 src_delta	2000
-tools		sendip socat nc bash
+tools		sendip socat bash
 proto		udp
 
 race_repeat	0
@@ -486,12 +486,6 @@ check_tools() {
 
 	__tools=
 	for tool in ${tools}; do
-		if [ "${tool}" = "nc" ] && [ "${proto}" = "udp6" ] && \
-		   ! nc -u -w0 1.1.1.1 1 2>/dev/null; then
-			# Some GNU netcat builds might not support IPv6
-			__tools="${__tools} netcat-openbsd"
-			continue
-		fi
 		__tools="${__tools} ${tool}"
 
 		command -v "${tool}" >/dev/null && return 0
@@ -554,29 +548,6 @@ setup_send_udp() {
 
 			echo "test4" | B socat -t 0.01 STDIN UDP4-DATAGRAM:${dst_addr4}:${dst_port}"${__socatbind}"
 
-			src_addr4=
-			src_port=
-		}
-	elif command -v nc >/dev/null; then
-		if nc -u -w0 1.1.1.1 1 2>/dev/null; then
-			# OpenBSD netcat
-			nc_opt="-w0"
-		else
-			# GNU netcat
-			nc_opt="-q0"
-		fi
-
-		send_udp() {
-			if [ -n "${src_addr4}" ]; then
-				B ip addr add "${src_addr4}" dev veth_b
-				__src_addr4="-s ${src_addr4}"
-			fi
-			ip addr add "${dst_addr4}" dev veth_a 2>/dev/null
-			[ -n "${src_port}" ] && src_port="-p ${src_port}"
-
-			echo "" | B nc -u "${nc_opt}" "${__src_addr4}" \
-				  "${src_port}" "${dst_addr4}" "${dst_port}"
-
 			src_addr4=
 			src_port=
 		}
@@ -645,25 +616,6 @@ setup_send_udp6() {
 
 			echo "test6" | B socat -t 0.01 STDIN UDP6-DATAGRAM:[${dst_addr6}]:${dst_port}"${__socatbind6}"
 		}
-	elif command -v nc >/dev/null && nc -u -w0 1.1.1.1 1 2>/dev/null; then
-		# GNU netcat might not work with IPv6, try next tool
-		send_udp6() {
-			ip -6 addr add "${dst_addr6}" dev veth_a nodad \
-				2>/dev/null
-			if [ -n "${src_addr6}" ]; then
-				B ip addr add "${src_addr6}" dev veth_b nodad
-			else
-				src_addr6="2001:db8::2"
-			fi
-			[ -n "${src_port}" ] && src_port="-p ${src_port}"
-
-			# shellcheck disable=SC2086 # this needs split options
-			echo "" | B nc -u w0 "-s${src_addr6}" ${src_port} \
-					       ${dst_addr6} ${dst_port}
-
-			src_addr6=
-			src_port=
-		}
 	elif [ -z "$(bash -c 'type -p')" ]; then
 		send_udp6() {
 			ip -6 addr add "${dst_addr6}" dev veth_a nodad \
-- 
2.43.2

