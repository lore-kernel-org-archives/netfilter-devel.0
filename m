Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E07331AA8B;
	Wed, 10 Dec 2025 11:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765364900; cv=none; b=T+l8HsClC97gn1l0kC0hHY65q5QZ1wS0U/y10ShhYCKwjUzLyBAxW4uVMlcWAfnc2UKhCJugfuzEqHyqo41fYT9MQH5cnLcJfovC0+4vp9K8IwyZmMdSCLjnzXtXfEp3Q0B38nsM5jAYSu7FpJoOZzz/FDPjYW1WOXfzDopsx4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765364900; c=relaxed/simple;
	bh=DAv2l7W00UxvUjAGkM/i7GFyw04TMLOKTkp0TNtrgi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQi9MNtv5lNWlNNFJxvMKbLY5EoCtCfnfMHk5otQP+s1gFNDUojRNn3PKVIv0MLcol7ZqzwXOUBRJe6lHwt8p79H2PbqPzx8AegGZ96GppG9xL1xs+WfkvJfDPz7JfCalimAUALu7H2/Huz2wR6VKUD+hrzS6uqyENBlur3FOl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6AA0F605E6; Wed, 10 Dec 2025 12:08:16 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 4/4] selftests: netfilter: prefer xfail in case race wasn't triggered
Date: Wed, 10 Dec 2025 12:07:54 +0100
Message-ID: <20251210110754.22620-5-fw@strlen.de>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251210110754.22620-1-fw@strlen.de>
References: <20251210110754.22620-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jakub says: "We try to reserve SKIP for tests skipped because tool is
missing in env, something isn't built into the kernel etc."

use xfail, we can't force the race condition to appear at will
so its expected that the test 'fails' occasionally.

Fixes: 78a588363587 ("selftests: netfilter: add conntrack clash resolution test case")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20251206175647.5c32f419@kernel.org/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/conntrack_clash.sh | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_clash.sh b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
index 7fc6c5dbd551..84b8eb12143a 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_clash.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
@@ -116,7 +116,7 @@ run_one_clash_test()
 	# not a failure: clash resolution logic did not trigger.
 	# With right timing, xmit completed sequentially and
 	# no parallel insertion occurs.
-	return $ksft_skip
+	return $ksft_xfail
 }
 
 run_clash_test()
@@ -133,12 +133,12 @@ run_clash_test()
 		if [ $rv -eq 0 ];then
 			echo "PASS: clash resolution test for $daddr:$dport on attempt $i"
 			return 0
-		elif [ $rv -eq $ksft_skip ]; then
+		elif [ $rv -eq $ksft_xfail ]; then
 			softerr=1
 		fi
 	done
 
-	[ $softerr -eq 1 ] && echo "SKIP: clash resolution for $daddr:$dport did not trigger"
+	[ $softerr -eq 1 ] && echo "XFAIL: clash resolution for $daddr:$dport did not trigger"
 }
 
 ip link add veth0 netns "$nsclient1" type veth peer name veth0 netns "$nsrouter"
@@ -167,8 +167,7 @@ load_simple_ruleset "$nsclient2"
 run_clash_test "$nsclient2" "$nsclient2" 127.0.0.1 9001
 
 if [ $clash_resolution_active -eq 0 ];then
-	[ "$ret" -eq 0 ] && ret=$ksft_skip
-	echo "SKIP: Clash resolution did not trigger"
+	[ "$ret" -eq 0 ] && ret=$ksft_xfail
 fi
 
 exit $ret
-- 
2.51.2

