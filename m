Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC99F6CDCC;
	Tue, 23 Apr 2024 11:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713870677; cv=none; b=fLMOO0GUO8x0eqn4sr35JKYNUKhiVsY8jX/W7Tt57++CTU8LTr4Lf0lPOw+nJaa9JN5Xq4LcV5re1B1T41FlaBK5ovRrhVYHhOwAOHuQMTHQd8C+fwbFjUemBQqVeuCipJNmzFwgLAyd9NfI0NXwS39JF7OEP6UrmU3ZgyKKCJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713870677; c=relaxed/simple;
	bh=SVcr1bUMQbS0XEqP6YsnmbuxbzKy9VRubKmc6AndO68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTtA+sY3nLP80LXMz4KQOFTGguvzXurIhFYyEYfMIKVi865kc7OiDnrt06XN41sQtLPsrwhp+VeE4OUcPafb2G274hXFpIOxMsLC7WM2KU2UTg/r8S0QMbeNYnNMEcl2w7Dj1WmzFl40HrPSgPmsT8wXtzdFDSXPUc6cKucbSAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rzE3M-0006wD-09; Tue, 23 Apr 2024 13:11:12 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 4/7] selftests: netfilter: nft_flowtable.sh: re-run with random mtu sizes
Date: Tue, 23 Apr 2024 15:05:47 +0200
Message-ID: <20240423130604.7013-5-fw@strlen.de>
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

Now that the test runs much faster, also re-run it with random MTU sizes
for the different link legs.  flowtable should pass ip fragments, if
any, up to the normal forwarding path.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index d765c65c31f3..8b5a3a7e22f0 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -100,6 +100,14 @@ if ! ip -net $nsr2 link set veth1 mtu $rmtu; then
 	exit 1
 fi
 
+if ! ip -net "$nsr1" link set veth1 mtu "$lmtu"; then
+	exit 1
+fi
+
+if ! ip -net "$nsr2" link set veth0 mtu "$lmtu"; then
+	exit 1
+fi
+
 ip -net $ns2 link set eth0 mtu $rmtu
 
 # transfer-net between nsr1 and nsr2.
@@ -633,4 +641,15 @@ else
 	ip netns exec "$nsr1" cat /proc/net/xfrm_stat 1>&2
 fi
 
+if [ x"$1" = x ]; then
+	low=1280
+	mtu=$((65536 - low))
+	o=$(((RANDOM%mtu) + low))
+	l=$(((RANDOM%mtu) + low))
+	r=$(((RANDOM%mtu) + low))
+
+	echo "re-run with random mtus: -o $o -l $l -r $r"
+	$0 -o "$o" -l "$l" -r "$r"
+fi
+
 exit $ret
-- 
2.43.2

