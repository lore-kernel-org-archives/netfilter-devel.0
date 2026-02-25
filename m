Received: from mail-yx1-f73.google.com (mail-yx1-f73.google.com [74.125.224.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528113B8BBE
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Feb 2026 13:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772025803; cv=none; b=mtrLSlH1ukV/NEdd7w671IvdT0EY2c6njBujmnk3I6Pwj3LeeHrA2kCFNS5iazKxAe49ffN5x1T51fLDytoDgMR3Qk5872VH8yskht/2FbIiJ+ETDcVJSe7Ah7kIy4H9VUUfCEbhXsO2fkQ8cfSdUsifbFGTlm+6TrP7ZHkUit0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772025803; c=relaxed/simple;
	bh=EDvvMJnXQra5tEuY/SmcZgpW0zOulJCc2wCVrofLAeU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AIzowK4lKjMgEHqWO1PaGjm/ykqfbM/JxewLuXh66DUwxb3St1gar1C/qwV+Pre/98xamCLGle3hpU5o52DnXY6GCiqw2eTUdJ7UTj6wrefhMCh+NLbWFbEoIu/E0iuDDC+4GbzsQ7aIMjhIygdKjqWw1lSN/Hnd/IA+n/9dT2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r6UAeff9; arc=none smtp.client-ip=74.125.224.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r6UAeff9"
Received: by mail-yx1-f73.google.com with SMTP id 956f58d0204a3-64adb64a043so13265598d50.3
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Feb 2026 05:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772025801; x=1772630601; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gvFzdvfLXphXqn/1tN6RKBp/6lv+fHrWozsbx5t7T1Q=;
        b=r6UAeff9wJlhSmROEUVP2znPfzRAnhDhBSYDSz0PDvKRr82fakJec8zl+pgwquE6hz
         rKYH8NEk8c1qDApyc0jjDvl0xV4O7yH2oP7l3+R5GqqpXC1ZrvjRqHwgOq5/kKSUgsQi
         XATD1oxts6UbB3pEtgZ/ERDNbv5itxK4Sv4v35NbjAWcs3w1hZExmwxr/mFkS4LD+Duw
         KewuuCJ71uTJv2WAc2jJZ3yx4JyDVKA3JxefChtmGZUz9c2hOHHvf58ei2uda1ei1eKZ
         WbRdo6pLmaRog+lmdaHMV973RzuAZe+D7Ad2K6nSHP5tO5yC62cG98BV0VDezsWzDHnq
         8MsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772025801; x=1772630601;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gvFzdvfLXphXqn/1tN6RKBp/6lv+fHrWozsbx5t7T1Q=;
        b=cplo3XK3brDIEC664Djr3kEQ0+iVhpgIsriplfNDeeEteZnxZ00dMK83aBUdO173GR
         46vYNPakayO9+1aWhE6MWMvMPYOyOL8JNfO+i2jDf7grdlr6U0O/dvxfFokPinhAULv+
         OYue74MNlj7h8RcKO9eituzEhBSep1QGgNA3e2DrR+Xm/BJO4th/bMXlHYPRnfPCIft+
         6kiLq+t6bh1P38Gpl5BGmHNF2vzfrAw4vnbJg7Yw/khb7v7HRM1cacU48xuOWpGLA6FV
         7+b05d4gbDGMoY4ImJbj91FxwnvXQS1lU0FTDQcgg5tdFGqg6vdmdRFpePAkXbVpSZ0b
         qI1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXbjrOHHkhcIJEaAioeQtGz74R8nyI0mkPzia7sIBDPSRDjKGfYVSYpyi0/6D7Wk5n44cFbnjJzVoOujhW2m8k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8/w2JZtwA3OxrTM+5Bn0OSQZgiNeB+eQxsB3l7WpJu4G0tJrt
	FILK9uxkhjikhtw3QszGmPa+zlrDe7suwr3ULFhV2jWY3ec9wwLv3XsYDha9t0pCVd5PiMlhhMW
	TtXQYuzST5fVOIA==
X-Received: from yxpk16.prod.google.com ([2002:a53:e810:0:b0:64c:a65a:b147])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:690e:2058:b0:649:cbdc:c491 with SMTP id 956f58d0204a3-64cb25aeb0fmr294514d50.84.1772025801046;
 Wed, 25 Feb 2026 05:23:21 -0800 (PST)
Date: Wed, 25 Feb 2026 13:23:19 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225132319.1108400-1-edumazet@google.com>
Subject: [PATCH v2 nf-next] netfilter: xt_owner: no longer acquire
 sk_callback_lock in mt_owner()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

After commit 983512f3a87f ("net: Drop the lock in skb_may_tx_timestamp()")
from Sebastian Andrzej Siewior, apply the same logic in mt_owner()
to avoid touching sk_callback_lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_owner.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 50332888c8d233aab0915a31f2f616f3171da45e..5bfb4843df66361a930b0b2ed8ad936d5a38eeba 100644
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
2.53.0.414.gf7e9f6c205-goog

