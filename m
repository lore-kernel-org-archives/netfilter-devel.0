Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com [209.85.219.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A2C37E2F5
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771936143; cv=none; b=ptJVLiCr4evbPUhEcDJVOMupIiFhA3m6FOq+Ux2o7qmswFB1RHO8wDWTnXmmPO6d/IsjWrpXACelptZTtcPd08H5ZcddbIT3X42Wq+81zNa+jIUR/AsDqp234SC4s+BBepvCSK26JJOZbXm/Vg/GbEO8nBld7UfcRhT1Rdf6QfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771936143; c=relaxed/simple;
	bh=Hsp3tQRgE2zFNjV/zPyI9+zpkx3vWREcoZDnXwGASz4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HXFSg8aSxnAQmLmxiFfuR0+kR6WX03uJdDcbYVLuRBwcdfI5TIgxgSHKyWb058mzkPHC5m3cPm8rqwo9ouAv1N5uvLF2Jjd8gJ36YXJLjd3F7mfVpvddPrTh7M55iFwOujy6TprQ+y4P28Aggv2qpXsmIfZX9zgLLtbY0IlcupM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pQF8ulBj; arc=none smtp.client-ip=209.85.219.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pQF8ulBj"
Received: by mail-qv1-f74.google.com with SMTP id 6a1803df08f44-89546cbb998so502664926d6.0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 04:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771936139; x=1772540939; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a3rCfk+n+zciKXPjSKsHFA//hqZJBADhsDjD5jNhlu0=;
        b=pQF8ulBjgHi6Qwhdh7vHAV1pUExFxKgs4FchQvk91eIGbSOyhJeeWwTvoqet9tTkhY
         5wxuF98tQouSTrg5bxK1XHerVSLOgZK4DGHLsBUobXjiT/zY3yISiSKlm/vpKJv34lLn
         rBQPeCWG8FKi1nnQ+VppHDECOGFrIo/tLaVPOSv5iQoMJL6byJRpJksEtfHauWyeO+89
         nFwnX50s8NzBvbAgVnToCBeFIDv7rsLOgfb9dnJcVNdleu6BTv+w2k9fkTLjmoD+1vL1
         puI3/uBStM3ZYOEc47WiPgnW3FaPJWlYuLy+YwI5jyLyaR3oGiuCjQIl3AYaFBElIhuY
         Scng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771936139; x=1772540939;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a3rCfk+n+zciKXPjSKsHFA//hqZJBADhsDjD5jNhlu0=;
        b=bA3U20ntLlYCZlS7/MMZ4a/SLGQNp9hRbNt6eHboCK+AAUxLRT22MBxuhnCaWNN+mz
         9R8TM3PGnDDAQTTISCeAq1ZSnLe6xWP9BjKT31a0qA1+zHQ/puiyAo3vdn/UpYGmEY0w
         5iBuyx1+NDwB9NozQu6PkWD7SjmmwhdMWzvL0pu+YCrlpbSbnRUPkXGq+MYlc9ABd4mE
         cbvDv87sUIJUCXGlpNBKlLMzteZWfUm6U4ABJm3X+bC78T9qJrFk4/W3cO2ardP8rqd2
         fiP1AkQy5xAORf8WKxwIKQeZYXkQqrBsAsGtXtS6NeCEF47uASaYwsSQBK+5hKZhYK+r
         RMhg==
X-Forwarded-Encrypted: i=1; AJvYcCVpyg37VI20nWBtKJtlkYn4iIzdQABAkzEJKOpWkuLo6mI7oetTT7jklORNwxLnvjwhb50kHyrLfpzy4m6XTjg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqXLHMJq1kTo4yjSabtg0yV5z61NRM3nEjBZxmnUAiOwSaArB0
	dXyOSLc03aVwuQ5qb4RUVY8Vkjd2sr89iy1UY78rgYHbaEdO2OXSCO5fXU6M86TxLvNykKbmqij
	9/i9HRBWqQPqhQw==
X-Received: from qvbqo13.prod.google.com ([2002:a05:6214:590d:b0:894:946e:3688])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6214:5646:b0:899:b004:13c with SMTP id 6a1803df08f44-899b00402f3mr4162046d6.17.1771936139013;
 Tue, 24 Feb 2026 04:28:59 -0800 (PST)
Date: Tue, 24 Feb 2026 12:28:56 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260224122856.3152608-1-edumazet@google.com>
Subject: [PATCH net-next] netfilter: xt_owner: no longer acquire
 sk_callback_lock in mt_owner()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

After commit 983512f3a87f ("net: Drop the lock in skb_may_tx_timestamp()")
from Sebastian Andrzej Siewior, apply the same logic in mt_owner()
to avoid touching sk_callback_lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/xt_owner.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 50332888c8d233aab0915a31f2f616f3171da45e..5845eabe6161b3a90df422e6e1055165d6538791 100644
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
@@ -76,10 +77,16 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		 */
 		return false;
 
-	read_lock_bh(&sk->sk_callback_lock);
-	filp = sk->sk_socket ? sk->sk_socket->file : NULL;
+	/* The sk pointer remains valid as long as the skb is. The sk_socket and
+	 * file pointer may become NULL if the socket is closed. Both structures
+	 * (including file->cred) are RCU freed which means they can be accessed
+	 * within a RCU read section.
+	 */
+	rcu_read_lock();
+	sock = READ_ONCE(sk->sk_socket);
+	filp = sock ? READ_ONCE(sock->file) : NULL;
 	if (filp == NULL) {
-		read_unlock_bh(&sk->sk_callback_lock);
+		rcu_read_unlock();
 		return ((info->match ^ info->invert) &
 		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
 	}
@@ -90,7 +97,7 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		if ((uid_gte(filp->f_cred->fsuid, uid_min) &&
 		     uid_lte(filp->f_cred->fsuid, uid_max)) ^
 		    !(info->invert & XT_OWNER_UID)) {
-			read_unlock_bh(&sk->sk_callback_lock);
+			rcu_read_unlock();
 			return false;
 		}
 	}
@@ -118,12 +125,12 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		}
 
 		if (match ^ !(info->invert & XT_OWNER_GID)) {
-			read_unlock_bh(&sk->sk_callback_lock);
+			rcu_read_unlock();
 			return false;
 		}
 	}
 
-	read_unlock_bh(&sk->sk_callback_lock);
+	rcu_read_unlock();
 	return true;
 }
 
-- 
2.53.0.371.g1d285c8824-goog

