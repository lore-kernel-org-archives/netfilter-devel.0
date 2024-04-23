Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8468E81722;
	Tue, 23 Apr 2024 11:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713870683; cv=none; b=XkQv/tdD0wWMv9hINhxQZLiHvjAQ3M9vnKuycmH4KxvVIdCI3npgjACbHYow/WjOlFC1Rmou6pxi4gF8G32CoxNm3XuqG7zGhupphJ/qAameaUe3oL3FpPBBXIK74S3qapm7j1/V+u11ElMbgKc9rwmgzu3tq+d8lUotlVlAxb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713870683; c=relaxed/simple;
	bh=RYyxTVmCpSCsoTayCNb5gNQVXpth9U6AtoMSwwJQX1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ac2WTqswuyb22Q/ZWzq9gbOyzHWWy7hCNcqKf/F++Pmd9QPlxjK3DRtUQqNUH+sr9Nw9tY9yu6vLdA8Jbffp7vfKvKwQSLXgD6vs1oDBVsjWWomRqgjGEdNXMdlm2oXs4vB1IOBz9Yrs/bADlwGb/ZdQtFkrkux8wYWfo9aX9Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzE3R-0006wp-4Y; Tue, 23 Apr 2024 13:11:17 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 6/7] selftests: netfilter: skip tests on early errors
Date: Tue, 23 Apr 2024 15:05:49 +0200
Message-ID: <20240423130604.7013-7-fw@strlen.de>
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

br_netfilter: If we can't add the needed initial nftables ruleset skip the
test, kernel doesn't support a required feature.

rpath: run a subset of the tests if possible, but make sure we return
the skip return value so they are marked appropriately by the kselftest
framework.

nft_audit.sh: provide version information when skipping, this should
help catching kernel problem (feature not available in kernel) vs.
userspace issue (parser doesn't support keyword).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/br_netfilter.sh |  4 ++++
 tools/testing/selftests/net/netfilter/nft_audit.sh    |  3 ++-
 tools/testing/selftests/net/netfilter/rpath.sh        | 10 ++++++++--
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/br_netfilter.sh b/tools/testing/selftests/net/netfilter/br_netfilter.sh
index 1084faf88f0b..d7806753f5de 100755
--- a/tools/testing/selftests/net/netfilter/br_netfilter.sh
+++ b/tools/testing/selftests/net/netfilter/br_netfilter.sh
@@ -124,6 +124,10 @@ table bridge filter {
 	}
 }
 EOF
+if [ "$?" -ne 0 ];then
+	echo "SKIP: could not add nftables ruleset"
+	exit $ksft_skip
+fi
 
 # place 1, 2 & 3 in same subnet, connected via ns0:br0.
 # ns4 is placed in same subnet as well, but its not
diff --git a/tools/testing/selftests/net/netfilter/nft_audit.sh b/tools/testing/selftests/net/netfilter/nft_audit.sh
index b390437696ba..902f8114bc80 100755
--- a/tools/testing/selftests/net/netfilter/nft_audit.sh
+++ b/tools/testing/selftests/net/netfilter/nft_audit.sh
@@ -29,7 +29,8 @@ reset rules t c
 EOF
 
 if [ "$?" -ne 0 ];then
-	echo "SKIP: nft reset feature test failed"
+	echo -n "SKIP: nft reset feature test failed: "
+	nft --version
 	exit $SKIP_RC
 fi
 
diff --git a/tools/testing/selftests/net/netfilter/rpath.sh b/tools/testing/selftests/net/netfilter/rpath.sh
index 5289c8447a41..4485fd7675ed 100755
--- a/tools/testing/selftests/net/netfilter/rpath.sh
+++ b/tools/testing/selftests/net/netfilter/rpath.sh
@@ -64,12 +64,18 @@ ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 # firewall matches to test
 [ -n "$iptables" ] && {
 	common='-t raw -A PREROUTING -s 192.168.0.0/16'
-	ip netns exec "$ns2" "$iptables" $common -m rpfilter
+	if ! ip netns exec "$ns2" "$iptables" $common -m rpfilter;then
+		echo "Cannot add rpfilter rule"
+		exit $ksft_skip
+	fi
 	ip netns exec "$ns2" "$iptables" $common -m rpfilter --invert
 }
 [ -n "$ip6tables" ] && {
 	common='-t raw -A PREROUTING -s fec0::/16'
-	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter
+	if ! ip netns exec "$ns2" "$ip6tables" $common -m rpfilter;then
+		echo "Cannot add rpfilter rule"
+		exit $ksft_skip
+	fi
 	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter --invert
 }
 [ -n "$nft" ] && ip netns exec "$ns2" $nft -f - <<EOF
-- 
2.43.2

