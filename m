Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B203A1D4
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2024 20:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710879715; cv=none; b=JJtozq7PXbxNJcBgxDVJuPMSAp1kDrieuaIs0TPY0jl6X1YQmh+t+1scKz8+5Dx77CXVNGD6d/w/+l7AmVoPnpn06Ey0tr8ZQ4INA8yfXEoEeu/evYCbbBbrbrzNssz2PIs5qK3sFjeIkMmIcsbuijLe7O8vw1ohZGnP04hmszk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710879715; c=relaxed/simple;
	bh=EbvKVrQe+OsmzEUzLMZZoqqDyVJlbaPmCXrR/20ZeME=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=oytdwKwViNKeeryUFZxJ6+BufDWyGlrRNhrXtujpuQlxWk3Wfazk4v8krjiUTRWiqsh+4rCq5brwRnc8UPu/8OrZjCKV/kro2d3GZLSWTNao9Ak8pDyEhpQ0evM5rErgjm1g5KO+lMPZhX8cNTAEKkDx62qA/7wZesiivCEmiw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: shell: update packetpath/flowtables after flow teardown changes
Date: Tue, 19 Mar 2024 21:21:46 +0100
Message-Id: <20240319202146.422650-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update timeout according to:

  ("netfilter: flowtable: infer TCP state and timeout before flow teardown")

which sets TCP state to established and it uses unack timeout as
specified by nf_conntrack_tcp_timeout_unacknowledged.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
to be applied once kernel patch:

  ("netfilter: flowtable: infer TCP state and timeout before flow teardown")

reaches upstream.

 tests/shell/testcases/packetpath/flowtables | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/packetpath/flowtables b/tests/shell/testcases/packetpath/flowtables
index 852a05c6d0ab..9c885d152fb6 100755
--- a/tests/shell/testcases/packetpath/flowtables
+++ b/tests/shell/testcases/packetpath/flowtables
@@ -70,7 +70,7 @@ ip netns exec $R sysctl -w net.netfilter.nf_flowtable_tcp_timeout=5 || {
 	echo "E: set net.netfilter.nf_flowtable_tcp_timeout fail, skipping" >&2
         exit 77
 }
-ip netns exec $R sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=86400 || {
+ip netns exec $R sysctl -w net.netfilter.nf_conntrack_tcp_timeout_unacknowledged=250 || {
         echo "E: set net.netfilter.nf_conntrack_tcp_timeout_established fail, skipping" >&2
         exit 77
 
@@ -85,7 +85,7 @@ ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "check [OFFLO
 ip netns exec $R cat /proc/net/nf_conntrack
 sleep 6
 ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   && { echo "CT OFFLOAD timeout, fail back to classical path (failed)"; exit 1; }
-ip netns exec $R grep '8639[0-9]' /proc/net/nf_conntrack || { echo "check nf_conntrack_tcp_timeout_established (failed)"; exit 1; }
+ip netns exec $R grep '24[0-9].*ESTABLISHED' /proc/net/nf_conntrack || { echo "check ESTABLISHED and nf_conntrack_tcp_timeout_unack (failed)"; exit 1; }
 ip netns exec $C echo "send sth" >> pipefile
 ip netns exec $R grep 'OFFLOAD' /proc/net/nf_conntrack   || { echo "traffic seen, back to OFFLOAD path (failed)"; exit 1; }
 ip netns exec $C sleep 3
-- 
2.30.2

