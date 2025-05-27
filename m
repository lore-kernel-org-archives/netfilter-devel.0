Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BCC253933;
	Tue, 27 May 2025 09:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748338896; cv=none; b=UVPLg06W8QYxob8Ck8iU2q77q6E7I3agUNKBG0Z8SxwECb9VlKNDEq66JdnQQiVKMPgjb/Xj6wvB/y4UgKwHOnjhq1RAPilDFOGyhpgicdUqx5GIUN0+PC6GDVNEBKRzGuj0oM9A0BzXTrFkstnqmIGLpNyl8hjpU46yJ8XOrww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748338896; c=relaxed/simple;
	bh=Tf4+2pzIQGf2Iq9ORSTInND5kBo1kQFyRgXGXrVsgjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F/uDoFg19jFyGj4U1Z6H123/P4Bjl6mIkOU8VOpxgETFvmasbsNZalnU6ocFzxyKbBq57d7SeEetQozaQRr9xSYMnPFEhEOpgpHODBewJYkEE/i/E3dN6n75bwHu3s7bLj7lY5RuCVBrJLnfj/Yv/19YVLyGXTooTc+dH0lhRn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=P2x1DOlf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="P2x1DOlf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QpKW2UUxFflXuz0fXtVW1rmAbXl57/PLqT/MCDlFb/A=; b=P2x1DOlf8YHy11NEQJR4HKPjLx
	qKywfCMOn+SbaekAagEDrhE4xVPiJ97Y8wuBNfiF+b3Jy6EPH/YC3XHrUKdh+Oqagl3GO5tfHO9jT
	5+f6wZT6jOVvjX5fC3/8mDpPQQklXlhsshqs38dfHM39uf5qmpscq32wVmRQCFmqENA7XPqbRhR7O
	oX2NOeCI29+eYCHmJMHJati4rZbI9N69PNlpt7I54giT23wy45k06IotqrKI8kui0t13rd6Nt99P6
	n99LndT3dV+JC+qzNr3pLQkJEb7AB2kpyu83fJjDfb2eXVdFDBYzW/PKyZJjuvy53POMF0BrIk/H3
	Di06gBVA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uJqoE-0000000058Q-3hyO;
	Tue, 27 May 2025 11:41:22 +0200
From: Phil Sutter <phil@nwl.cc>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [net-next PATCH] selftests: netfilter: Fix skip of wildcard interface test
Date: Tue, 27 May 2025 11:41:17 +0200
Message-ID: <20250527094117.18589-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The script is supposed to skip wildcard interface testing if unsupported
by the host's nft tool. The failing check caused script abort due to
'set -e' though. Fix this by running the potentially failing nft command
inside the if-conditional pipe.

Fixes: 73db1b5dab6f ("selftests: netfilter: Torture nftables netdev hooks")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../selftests/net/netfilter/nft_interface_stress.sh        | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_interface_stress.sh b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
index 11d82d11495e..5ff7be9daeee 100755
--- a/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
+++ b/tools/testing/selftests/net/netfilter/nft_interface_stress.sh
@@ -97,7 +97,8 @@ kill $nft_monitor_pid
 kill $rename_loop_pid
 wait
 
-ip netns exec $nsr nft -f - <<EOF
+wildcard_prep() {
+	ip netns exec $nsr nft -f - <<EOF
 table ip t {
 	flowtable ft_wild {
 		hook ingress priority 0
@@ -105,7 +106,9 @@ table ip t {
 	}
 }
 EOF
-if [[ $? -ne 0 ]]; then
+}
+
+if ! wildcard_prep; then
 	echo "SKIP wildcard tests: not supported by host's nft?"
 else
 	for ((i = 0; i < 100; i++)); do
-- 
2.49.0

