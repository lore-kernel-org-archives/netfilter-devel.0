Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11FDE1991DA;
	Thu, 28 Nov 2024 12:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732796598; cv=none; b=WBvwOVGajeM9xfwf3m0TeBPfzWVTNTyXQTJiAyrU+tsjGVU30yz/eaDHHWHNbwjWuakacSgtWMWv8YbgKpejlzo8qHpqGsGdrEFFmc3qqQ5wukYcglhSFMJ0bz+521lJZP5tfLO89pVx2QmJVMapNkknEP6fv67y/5ClF2/S6y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732796598; c=relaxed/simple;
	bh=QkK+4o+GxL8Vwgw3KI84zT5wXflQ89/VDVRsXipyGzA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yw/DtVpgffDTU1HCp6NOJ+kZP/Z+9x/SpxF7SUcefR6GgN5oNbxdb+JTwMLWUpPpRwLJACH3p5nyyAqVv8TMTh+SVIVNxJ4y7UDfOnoZhvj+rXVy8OUrtircwPaS15EdBEX7jZbLIorVrZ0KMIbPC9TALvugYPSmfiUFQnip66w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 3/4] netfilter: nft_socket: remove WARN_ON_ONCE on maximum cgroup level
Date: Thu, 28 Nov 2024 13:23:04 +0100
Message-Id: <20241128122305.14091-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241128122305.14091-1-pablo@netfilter.org>
References: <20241128122305.14091-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cgroup maximum depth is INT_MAX by default, there is a cgroup toggle to
restrict this maximum depth to a more reasonable value not to harm
performance. Remove unnecessary WARN_ON_ONCE which is reachable from
userspace.

Fixes: 7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces")
Reported-by: syzbot+57bac0866ddd99fe47c0@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index f5da0c1775f2..35d0409b0095 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -68,7 +68,7 @@ static noinline int nft_socket_cgroup_subtree_level(void)
 
 	cgroup_put(cgrp);
 
-	if (WARN_ON_ONCE(level > 255))
+	if (level > 255)
 		return -ERANGE;
 
 	if (WARN_ON_ONCE(level < 0))
-- 
2.30.2

