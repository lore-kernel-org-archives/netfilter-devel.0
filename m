Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0168B2E859
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2024 14:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733494130; cv=none; b=oilovzaTnfoiyCW0imafJ/susrcU3yVQQF9Kdqiemw8bt62OeFT7lrATOM6tyc5YpnkYW2nvwiA51bpAEhnqCZ4wMARPwWkiW4B2BH2eyJyl6M+tjDmQ8AUOOdq+KRlCvhHHSwnOzy5czECWDpULfg2EhFkndBHoTHQNUZIJt1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733494130; c=relaxed/simple;
	bh=qRlDdzVHX8FMj7dFOrKMTHD7MUZMM5TwCrqIKzy4hfM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PlXN7oL+WXArj+QjnQuJyHt2/DFFGMDqSSd1M3lFlK99UKsttJduvD4RaQQS7kM65v65ilfk9kqN/Qxz5ei4sJ31eggZQnzWJ1W0lLCe3ONw3dH3RC/1SQ6lF3SCN7E14UKFh50bg1OzHrAoHVXebu7oVkapp/dPtPtFM2ipNEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=AYq43XI5; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="AYq43XI5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=s8xICMyKR3JVNIqC8wk8B15bxzBfuyHb6NG/JYxlADI=; b=AYq43XI5RjPMacaTXPmpCyObdQ
	VXr41G4K8qvnQf3svCl9BC2VGzjDo2MvXnFPMoYW199dNhrnmpZq9WVU3qXbIDanPW9CueP39vm+j
	GZVTzD8KjvEyZgO5kuvkhCEduUp3ZSGF3tOXcYjHKmoFw0L3keyY37KFinwHn+QtGKAgb7QI8sDwd
	EhjbuFAAaeiSl//cpawyG1ludW/Oh9xxlZnjMVBfLn/KGTX8huIoLPlIjyn5eTjZhQjtv3Kcfb5cy
	z0knZMmLthj93r9/OznAwKsSyyoKuIYNlfKx3M2CsButRmBheZyR5PJ/uR99cINhMjXZx7XIDiB2h
	AvtXX6wA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tJZ0Y-00000000698-1ynO;
	Fri, 06 Dec 2024 15:08:38 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf PATCH] selftests: netfilter: Stabilize rpath.sh
Date: Fri,  6 Dec 2024 15:08:40 +0100
Message-ID: <20241206140840.26801-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On some systems, neighbor discoveries from ns1 for fec0:42::1 (i.e., the
martian trap address) would happen at the wrong time and cause
false-negative test result.

Problem analysis also discovered that IPv6 martian ping test was broken
in that sent neighbor discoveries, not echo requests were inadvertently
trapped

Avoid the race condition by introducing the neighbors to each other
upfront. Also pin down the firewall rules to matching on echo requests
only.

Fixes: efb056e5f1f0 ("netfilter: ip6t_rpfilter: Fix regression with VRF interfaces")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tools/testing/selftests/net/netfilter/rpath.sh | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/rpath.sh b/tools/testing/selftests/net/netfilter/rpath.sh
index 4485fd7675ed..86ec4e68594d 100755
--- a/tools/testing/selftests/net/netfilter/rpath.sh
+++ b/tools/testing/selftests/net/netfilter/rpath.sh
@@ -61,9 +61,20 @@ ip -net "$ns2" a a 192.168.42.1/24 dev d0
 ip -net "$ns1" a a fec0:42::2/64 dev v0 nodad
 ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 
+# avoid neighbor lookups and enable martian IPv6 pings
+ns2_hwaddr=$(ip -net "$ns2" link show dev v0 | \
+	     sed -n 's, *link/ether \([^ ]*\) .*,\1,p')
+ns1_hwaddr=$(ip -net "$ns1" link show dev v0 | \
+	     sed -n 's, *link/ether \([^ ]*\) .*,\1,p')
+ip -net "$ns1" neigh add fec0:42::1 lladdr "$ns2_hwaddr" nud permanent dev v0
+ip -net "$ns1" neigh add fec0:23::1 lladdr "$ns2_hwaddr" nud permanent dev v0
+ip -net "$ns2" neigh add fec0:42::2 lladdr "$ns1_hwaddr" nud permanent dev d0
+ip -net "$ns2" neigh add fec0:23::2 lladdr "$ns1_hwaddr" nud permanent dev v0
+
 # firewall matches to test
 [ -n "$iptables" ] && {
 	common='-t raw -A PREROUTING -s 192.168.0.0/16'
+	common+=' -p icmp --icmp-type echo-request'
 	if ! ip netns exec "$ns2" "$iptables" $common -m rpfilter;then
 		echo "Cannot add rpfilter rule"
 		exit $ksft_skip
@@ -72,6 +83,7 @@ ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 }
 [ -n "$ip6tables" ] && {
 	common='-t raw -A PREROUTING -s fec0::/16'
+	common+=' -p icmpv6 --icmpv6-type echo-request'
 	if ! ip netns exec "$ns2" "$ip6tables" $common -m rpfilter;then
 		echo "Cannot add rpfilter rule"
 		exit $ksft_skip
@@ -82,8 +94,10 @@ ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 table inet t {
 	chain c {
 		type filter hook prerouting priority raw;
-		ip saddr 192.168.0.0/16 fib saddr . iif oif exists counter
-		ip6 saddr fec0::/16 fib saddr . iif oif exists counter
+		ip saddr 192.168.0.0/16 icmp type echo-request \
+			fib saddr . iif oif exists counter
+		ip6 saddr fec0::/16 icmpv6 type echo-request \
+			fib saddr . iif oif exists counter
 	}
 }
 EOF
-- 
2.47.0

