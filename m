Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F0A1FAC4A;
	Thu, 14 Nov 2024 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731589513; cv=none; b=qL18XHgtci4rcLOcfqvjhYayR/twbCbJRCBk0LfQt1P1odQzlXPu3mmT4QrGgJWx7ARdUVPnNbUyItuKeRGNh0hscokLL6OQUdy8eo9WLGh2UIrZOj2qTsPmvwMc/yQs5IyHRtBofT1VcQmYWhtJau/mwxpcJVRkdq1uKp1zO6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731589513; c=relaxed/simple;
	bh=WBK+wBYscKRT42FriCCjmW+aJF/c7VxM45CwP46g7ls=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A2+qSLYTa4su+QIeFpPVv/ypD5s0KsX28FLA5b/voE3pACVn3biik3A/xMJ6YFy7cEU+cb9l30cYCZ0u/ZeGVBO/+3WztKaYWi7w5sbd011LSVeeDmoGR4zt0svDhWRe+XIXSwE2sYp1ZoPvhxe/DI9VetCnvWuw+5bAB6YRN8o=
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
Subject: [PATCH net 1/3] selftests: netfilter: Add missing gitignore file
Date: Thu, 14 Nov 2024 13:57:21 +0100
Message-Id: <20241114125723.82229-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241114125723.82229-1-pablo@netfilter.org>
References: <20241114125723.82229-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Zhijian <lizhijian@fujitsu.com>

Compiled binary files should be added to .gitignore
'git status' complains:
   Untracked files:
   (use "git add <file>..." to include in what will be committed)
         net/netfilter/conntrack_reverse_clash

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/net/netfilter/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/netfilter/.gitignore b/tools/testing/selftests/net/netfilter/.gitignore
index 0a64d6d0e29a..64c4f8d9aa6c 100644
--- a/tools/testing/selftests/net/netfilter/.gitignore
+++ b/tools/testing/selftests/net/netfilter/.gitignore
@@ -2,5 +2,6 @@
 audit_logread
 connect_close
 conntrack_dump_flush
+conntrack_reverse_clash
 sctp_collision
 nf_queue
-- 
2.30.2

