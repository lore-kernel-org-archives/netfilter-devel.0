Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F99E13C914
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 20:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759868835; cv=none; b=TrdGGUVBmYLl6FdFGcu9WuEnCGxxPwqOX1V7aN5gU9+y0vsX+UwVRaMrXf3geySZy2Z3Q6S9U+XzG/TPhz56PI0F5z7Xuk3Gwxs5GRawiw5Ri4oV7nh9YG34gS+Q5fk8zCwy8dxoYfMtHGXwUAU9EAivVxUdidKS/U0nu9gN1xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759868835; c=relaxed/simple;
	bh=FS0S6ekBRjHwmMnCwhLRyN4D+U8VQNC2VDIKV3TzhrE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OYYYAV8vd8ub65fddJ7eVBclmjJy1LW6sgbinKGBboXDsNx/5ARRIMcXbVnT/m4mkZuwOJRqbXhPgMBiY1YiyQtlFfajN4VAWtCBY5gQglBqHNC7Hh6fIrUk+l9NceRZYivBLDEM7vF/asfBXcCZ3RVT3WwRBSrhJWCA75AGJOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C386A60299; Tue,  7 Oct 2025 22:27:04 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: type_route_chain: use in-tree nftables, not system-wide one
Date: Tue,  7 Oct 2025 22:26:51 +0200
Message-ID: <20251007202655.23599-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch this to $NFT, which contains the locally-compiled binary.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/packetpath/type_route_chain | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/shell/testcases/packetpath/type_route_chain b/tests/shell/testcases/packetpath/type_route_chain
index b4052fd90393..6459451d48b5 100755
--- a/tests/shell/testcases/packetpath/type_route_chain
+++ b/tests/shell/testcases/packetpath/type_route_chain
@@ -133,7 +133,7 @@ echo -e "\nTest ipv6 dscp reroute"
 ip -6 -n $C route add default via ${ip6_r2_br1} dev c_br1 table 100
 ip -6 -n $C rule add dsfield 0x08 pref 1010 table 100
 assert_pass "Add ipv6 dscp policy routing rule"
-ip netns exec $C nft -f - <<-EOF
+ip netns exec $C $NFT -f - <<-EOF
 table inet outgoing {
 	chain output_route {
 		type route hook output priority filter; policy accept;
@@ -151,7 +151,7 @@ echo -e "\nTest ipv4 dscp reroute"
 ip -n $C route add default via ${ip4_r2_br1} dev c_br1 table 100
 ip -n $C rule add dsfield 0x08 pref 1010 table 100
 assert_pass "Add ipv4 dscp policy routing rule"
-ip netns exec $C nft -f - <<-EOF
+ip netns exec $C $NFT -f - <<-EOF
 table inet outgoing {
 	chain output_route {
 		type route hook output priority filter; policy accept;
@@ -169,7 +169,7 @@ echo -e "\nTest ipv4 fwmark reroute"
 ip -n $C route add default via ${ip4_r2_br1} dev c_br1 table 100
 ip -n $C rule add fwmark 0x0100 lookup 100
 assert_pass "Add ipv4 fwmark policy routing rule"
-ip netns exec $C nft -f - <<-EOF
+ip netns exec $C $NFT -f - <<-EOF
 table inet outgoing {
 	chain output_route {
 		type route hook output priority filter; policy accept;
@@ -187,7 +187,7 @@ echo -e "\nTest ipv6 fwmark reroute"
 ip -6 -n $C route add default via ${ip6_r2_br1} dev c_br1 table 100
 ip -6 -n $C rule add fwmark 0x0100 lookup 100
 assert_pass "Add ipv6 fwmark policy routing rule"
-ip netns exec $C nft -f - <<-EOF
+ip netns exec $C $NFT -f - <<-EOF
 table inet outgoing {
 	chain output_route {
 		type route hook output priority filter; policy accept;
-- 
2.49.1

