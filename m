Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62600392814
	for <netfilter-devel@vger.kernel.org>; Mon,  3 Aug 2026 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785775386; cv=none; b=kq34D7AiIF6QkLdRmjU0NZ+zHVu6eSrSGss6yTq7wHYx9MQWfOLRN4yKReJ6LaYjGp9h241Bq6Sf9cQMy0r+WF7xEu/CCKapT02ba+KgcmAHAZacCB3ZlKQRiKUvhLXvrlCdOg+baW2HZtjcmSwIGieOdZ+7PzdbQeSLWMUViIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785775386; c=relaxed/simple;
	bh=Ge12SN+28XUGmti96mzh0RzM5LIC5EceIkiyKlYNB7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XoSzNRovMn4dLwQ9x4q4+jdXq9LIHuPhjxx0IdvQlk64D4fITEXBzkYnJjAELDCMY44IDhhhgTRNu8CQ3abozvZ+hexw9zpBCKAbDqJXVA7pdK0ZFxEQW9tqvdGoNKgl1pGiqsowM9dY2+raY/cAKxd2j/u3v7IPAzcawZlH7+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D24AA6059E; Mon, 03 Aug 2026 18:43:01 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] test: shell: add regression test for 'ip fwd to' stack recursion
Date: Mon,  3 Aug 2026 18:42:49 +0200
Message-ID: <20260803164256.24948-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check for:

BUG: IRQ stack guard page was hit at ffffc90000650f58 (stack is ffffc90000651000..ffffc90000659000)
RIP: 0010:nft_do_chain+0x2e/0x1580 [nf_tables]
 <IRQ>
 nft_do_chain_netdev+0x146/0x1220 [nf_tables]
 nf_hook_slow+0xaa/0x1e0
 nf_hook_egress+0x1dd/0x3c0
 __dev_queue_xmit+0x9eb/0x1b60
 nft_fwd_neigh_eval+0x40a/0x13a0 [nft_fwd_netdev]
 neigh_xmit+0x156/0x860
 nft_fwd_neigh_eval+0x40a/0x13a0 [nft_fwd_netdev]
 nft_do_chain+0x225/0x1580 [nf_tables]
 nft_do_chain_netdev+0x146/0x1220 [nf_tables]
 [..]

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/packetpath/fwd_ip | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tests/shell/testcases/packetpath/fwd_ip b/tests/shell/testcases/packetpath/fwd_ip
index 5494d4c8fe06..302f48afa554 100755
--- a/tests/shell/testcases/packetpath/fwd_ip
+++ b/tests/shell/testcases/packetpath/fwd_ip
@@ -152,4 +152,21 @@ echo "Egress ruleset loaded"
 ip netns exec "$ns3" $NFT "reset counter inet rxt rxc"
 ping_and_check
 
+ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
+flush ruleset
+table netdev fwd_test {
+	chain egress_veth3 {
+		type filter hook egress device veth3 priority 0; policy accept;
+		# Forward ICMP packets to 10.0.3.1 via neigh
+		ip protocol icmp counter fwd ip to 10.0.3.1 device "veth3"
+	}
+}
+EOF
+[ $? -ne 0 ] && exit 1
+
+# old kernels that lack
+# 1d47b55b36d2 ("netfilter: nft_fwd_netdev: use recursion counter in neigh egress path")
+# can crash here.
+ip netns exec "$ns1" ping -c 1 -W 1 10.0.3.1
+
 exit 0
-- 
2.54.0

