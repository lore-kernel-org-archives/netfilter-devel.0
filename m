Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FCB282F10
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 20:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783627457; cv=none; b=eMKVoXNfMymyaWsPESWgfmsBTbZROcqtbAXnmaIwIPYdizH6FWynZJLQZ7Ur+dNJpwQswh0sRIXs+1LqoHxH318jJA+IDbcejwQVLZxMJQW2MnzWP4QHX1NqK9ugZ84rHoVXAOBua0ujcAV/JVD4rcpTDRP3J9xRIN+qMWhNbzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783627457; c=relaxed/simple;
	bh=U1lUeTWKw8J0XtuRgnXxIq9cbl9mEoo+dDoMmHvxKEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gy6op9P9hd/XW4bPYYMinCZN4udaGwfLmJQ/LQ0Qwtgzxn7FJwv33UdClHqeAr1j6MGK6eXQgib4LSzQZ0G1tnPYkPVub7WgdzgOMKWvSzWFwp2vkGlY+UJFZPzEtj8TBAD6ewUKxOCaFNEaikoPMOT0Y78G5M/WlMffHKmM19I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 43D7F602A9; Thu, 09 Jul 2026 22:04:14 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: kadlec@netfilter.org,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset 2/7] tests: runtest.sh: run inside namespace
Date: Thu,  9 Jul 2026 22:03:53 +0200
Message-ID: <20260709200358.15504-3-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709200358.15504-1-fw@strlen.de>
References: <20260709200358.15504-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

re-exec the script in case IPSET_UNSHARED environment
variable isn't set yet.

Add a dummy device named 'eth0' as thats what tests expect
to be present.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/runtest.sh | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/tests/runtest.sh b/tests/runtest.sh
index d102305fff5f..766335fda768 100755
--- a/tests/runtest.sh
+++ b/tests/runtest.sh
@@ -18,13 +18,32 @@ tests="$tests hash:net,port,net hash:net6,port,net6"
 tests="$tests hash:net,iface.t hash:mac.t"
 tests="$tests comment setlist restore"
 # tests="$tests iptree iptreemap"
+
+if [ "$IPSET_UNSHARED" = "" ]; then
+	# Re-execute in new network namespace
+	export IPSET_UNSHARED="yes"
+	sysctl net.netfilter.nf_log_all_netns=1
+	exec unshare -n -- "$0" "$@"
+fi
+
+sysctl net.ipv4.conf.all.rp_filter=0
+
 cleanup() {
 	rm -f "$tmpdir"/.foo*
 	rm -f "$tmpdir/.loglines"
 	rmdir "$tmpdir"
+	ip link del eth0
 }
 trap cleanup EXIT
-tmpdir=$(mktemp -t -d ipset-XXXXXXXX)
+tmpdir=$(mktemp -t -d ip-set-XXXXXXXX)
+
+ip link set lo up
+
+# test cases send and expect packets on eth0.
+ip link add dev eth0 type dummy
+ip link set eth0 up
+ip addr add 10.255.255.64/8 dev eth0
+sysctl net.ipv4.conf.eth0.rp_filter=0
 
 # For correct sorting:
 LC_ALL=C
-- 
2.54.0

