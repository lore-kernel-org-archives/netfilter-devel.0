Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8250448788;
	Sun, 12 May 2024 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715530493; cv=none; b=GMAhOuZijIMw4S7tS0WG580W0IgVTeGkIufDJjm6eprRzuSpCNNYeNE9BXcOkGqbVm3FJ9K9VTyR/05vCd+v7pkg6Sjvy7RaNphgXQ8XZh1Tiuc14KGNJovXnCO7tHlgwmJPb2i8FKS91md6hD5ea8/lLedOanVeduWvth5NobU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715530493; c=relaxed/simple;
	bh=VCsclNw9n+t5AONhNUibLcz108u/GU5hTBng27CVFI4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tnTpN5Wc6N78hrjE6MtCBaiFSJ/5ltnouixjQDdRwL3ywGlN64G6cZlghVeMK4bCHe/mfzEvGjXIBUVAtdbLouroaaFZ5ux9g1E5eVi6FsvrtHCdOAcT1aorVZTfjF8KXSkr8vns3cux3vgl2AMtMGgoCOkE2aTAlHUpJfmHbFI=
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
Subject: [PATCH net-next 06/17] netfilter: conntrack: documentation: remove reference to non-existent sysctl
Date: Sun, 12 May 2024 18:14:25 +0200
Message-Id: <20240512161436.168973-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240512161436.168973-1-pablo@netfilter.org>
References: <20240512161436.168973-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

The referenced sysctl doesn't exist anymore.

Fixes: 4592ee7f525c ("netfilter: conntrack: remove offload_pickup sysctl again")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index c383a394c665..238b66d0e059 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -222,11 +222,11 @@ nf_flowtable_tcp_timeout - INTEGER (seconds)
 
         Control offload timeout for tcp connections.
         TCP connections may be offloaded from nf conntrack to nf flow table.
-        Once aged, the connection is returned to nf conntrack with tcp pickup timeout.
+        Once aged, the connection is returned to nf conntrack.
 
 nf_flowtable_udp_timeout - INTEGER (seconds)
         default 30
 
         Control offload timeout for udp connections.
         UDP connections may be offloaded from nf conntrack to nf flow table.
-        Once aged, the connection is returned to nf conntrack with udp pickup timeout.
+        Once aged, the connection is returned to nf conntrack.
-- 
2.30.2

