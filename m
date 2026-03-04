Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044DF390221;
	Wed,  4 Mar 2026 11:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772624994; cv=none; b=s4zrLxLAxCYc7WVgmiAxZLs0fMR8Ktp//HhOzdYnwHDJw0XH+WdnGo1QUQy1/Uab4HAPG8/DucUlIHZD6/Wm2RteXgeJ1MKfQEoSUcTDYsAxIc2gS3nUzASEvPlbru1bDI4DETDq6CsYLSQzPIw+QzHZpWNB959vboiA1HEyhN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772624994; c=relaxed/simple;
	bh=rZ8BZk952ITWQ0BSpEdpYUFrqbQ6TyNIsRo07z0gcw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTuE5mwy/dicW2i6gk2j5xV89GraOFRh2Uc86uyFqMzuDU4UkY4FnAdYSZMGNJxyoENxCXoN2OoSnWRPoyN6Q8mqsUaIeyHDk6GXwUroKtLR3oL8Pm1dJt1S82msg3rag/RKo+vM6hbhx4iEz6DqILGD3pr0CCU0ZI8MK0zB1ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C33D96026E; Wed, 04 Mar 2026 12:49:51 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 05/14] netfilter: xt_owner: no longer acquire sk_callback_lock in mt_owner()
Date: Wed,  4 Mar 2026 12:49:12 +0100
Message-ID: <20260304114921.31042-6-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260304114921.31042-1-fw@strlen.de>
References: <20260304114921.31042-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

After commit 983512f3a87f ("net: Drop the lock in skb_may_tx_timestamp()")
from Sebastian Andrzej Siewior, apply the same logic in mt_owner()
to avoid touching sk_callback_lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_owner.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 50332888c8d2..5bfb4843df66 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -63,11 +63,12 @@ static bool
 owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_owner_match_info *info = par->matchinfo;
-	const struct file *filp;
 	struct sock *sk = skb_to_full_sk(skb);
 	struct net *net = xt_net(par);
+	const struct socket *sock;
+	const struct file *filp;
 
-	if (!sk || !sk->sk_socket || !net_eq(net, sock_net(sk)))
+	if (!sk || !READ_ONCE(sk->sk_socket) || !net_eq(net, sock_net(sk)))
 		return (info->match ^ info->invert) == 0;
 	else if (info->match & info->invert & XT_OWNER_SOCKET)
 		/*
@@ -76,23 +77,25 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		 */
 		return false;
 
-	read_lock_bh(&sk->sk_callback_lock);
-	filp = sk->sk_socket ? sk->sk_socket->file : NULL;
-	if (filp == NULL) {
-		read_unlock_bh(&sk->sk_callback_lock);
+	/* The sk pointer remains valid as long as the skb is. The sk_socket and
+	 * file pointer may become NULL if the socket is closed. Both structures
+	 * (including file->cred) are RCU freed which means they can be accessed
+	 * within a RCU read section.
+	 */
+	sock = READ_ONCE(sk->sk_socket);
+	filp = sock ? READ_ONCE(sock->file) : NULL;
+	if (filp == NULL)
 		return ((info->match ^ info->invert) &
 		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
-	}
 
 	if (info->match & XT_OWNER_UID) {
 		kuid_t uid_min = make_kuid(net->user_ns, info->uid_min);
 		kuid_t uid_max = make_kuid(net->user_ns, info->uid_max);
+
 		if ((uid_gte(filp->f_cred->fsuid, uid_min) &&
 		     uid_lte(filp->f_cred->fsuid, uid_max)) ^
-		    !(info->invert & XT_OWNER_UID)) {
-			read_unlock_bh(&sk->sk_callback_lock);
+		    !(info->invert & XT_OWNER_UID))
 			return false;
-		}
 	}
 
 	if (info->match & XT_OWNER_GID) {
@@ -117,13 +120,10 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			}
 		}
 
-		if (match ^ !(info->invert & XT_OWNER_GID)) {
-			read_unlock_bh(&sk->sk_callback_lock);
+		if (match ^ !(info->invert & XT_OWNER_GID))
 			return false;
-		}
 	}
 
-	read_unlock_bh(&sk->sk_callback_lock);
 	return true;
 }
 
-- 
2.52.0

