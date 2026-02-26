Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25174392810
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 08:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772094577; cv=none; b=SmeZ+IiJiEK1/U3ByPySmI9CWNwkLfDd6zdkKIJKq+u16nfliYlODEaEdUB/dMevt0JUowWrKB8X0XucxC9yS7TmviMVTCQ5FwVh/GQ0tcyT+BmOFAMMc/7Y/aX8Q6bAiqEO/9BTLU+I6q3C2UCERn6N8PeQF/EV8Yzpy+vij0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772094577; c=relaxed/simple;
	bh=HSNHNWilE0WePK9+G9tgFk2R/X9oV5NWXBly4avELcc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=LuSeJxjLAR+r/uCs5PA/NlUSNnyTxy9VHhdEt2ri5DqrmwpGoAnGj1ldIFRvD8hwF2I5mZEb6Ote5oO61cKQKyoSioEs3XDTA49QB/eKacgUFZcK033xvWqcw2HnT3Jb8a/D/HNYLg4W8A05qnfTCYmT+mfPxHF2c6MUkbkTCog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=obNBBClo; arc=none smtp.client-ip=209.85.222.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="obNBBClo"
Received: by mail-qk1-f202.google.com with SMTP id af79cd13be357-8c71655aa11so711442485a.3
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 00:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772094568; x=1772699368; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iCsbJfC3CsgwU4dZ0i+L360fn2q0VpoL/Uu/WwKuSu8=;
        b=obNBBCloCk2YQLv6LA72CHHEJa8rOY863a94oJ32kSt6Z126kAprYX7pgoKbcGvC06
         t+w+7vRan3FG+xsJgiyNfQ10tILXGlJso/8H8JBVVzx3Svxa/2Q0ZqDPxdwj4UdG3Rzn
         J5i1hnOfmj/c0gUKU8aErNLhJ/rrm6XdOINZsjbm8tjyu4eZSb9wDsoU5FfVoVZ2PEYx
         0yYBKPrFF38fhZwIdlnDORVSaGrrFxEvacpJ/Spi1RBmZOLnl/ImzUejrzm+ceT7RQTP
         O9mQKgMjHuyD7v1Jk7z4hqxgz7g88ADqerB46onDsI8hWJD7vdDubYnhNoyXj/d6LXmK
         q0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772094568; x=1772699368;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iCsbJfC3CsgwU4dZ0i+L360fn2q0VpoL/Uu/WwKuSu8=;
        b=jWvasfyf4Mszhg1otLpompD86TIT8cEFjKnHzjv+EPEQwOciJN9O1Ul3wHP2Nv8K4z
         /N8+iwDVgEDp+ne9SfQJXjCo3ejOVCqsfA2vTphHyTUYsV7qRs/8AF336kchyXgyBFJn
         MW9PS28gVHX5+vrapwjt+XGYtB5URf9uPptepwSvBIwIQDiMTHyu19V+lmy8AmuoXgL+
         iYnAWTrDbFBbqpxUFLTc635/CksEs0oq37zCkkZ9o5IlRkS5zuZksYTOP+h9F2g3whg8
         UZ8h28vog5W69f8FiituCAgUyUzqFYjWWzjdLXHouBAwMgQVns5p9xRnvWn1X6k0HhDh
         zuhw==
X-Forwarded-Encrypted: i=1; AJvYcCWUw1mBMvEziE3hypkPOtIoc0Ng3/ufUMzD4rO+aVTDVI2wixp+75k3ZRvo9yFyENxV+iQaIEEeygKy1WbIryI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmptOJbo4fXrQVi4vYNHI4fWfEhC3mb3YhNqUVy8yvA2Y8m8tF
	eKzVmp+3M+q3EPV/tZfUOl2CbAOhwuDo+B04TDHAWx8n/TqyKXtrFTIPEILeMLqQ7t+XSyex1KX
	Bep4++AD6LrQgcA==
X-Received: from qkbc19.prod.google.com ([2002:a05:620a:31d3:b0:8c7:cb6:2f03])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:2947:b0:8c6:abc5:f169 with SMTP id af79cd13be357-8cbc11db1d9mr133441985a.73.1772094567693;
 Thu, 26 Feb 2026 00:29:27 -0800 (PST)
Date: Thu, 26 Feb 2026 08:29:22 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260226082922.2246271-1-edumazet@google.com>
Subject: [PATCH nf-next] netfilter: nft_meta: no longer acquire
 sk_callback_lock in nft_meta_get_eval_skugid()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

After commit 983512f3a87f ("net: Drop the lock in skb_may_tx_timestamp()")
from Sebastian Andrzej Siewior, apply the same logic in
nft_meta_get_eval_skugid() to avoid touching sk->sk_callback_lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nft_meta.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 983158274c68dc6626032e6f55afc452c4be443f..d0df6cf374d1abe83ce2a02d93fb366e12b3d8d2 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -131,33 +131,36 @@ nft_meta_get_eval_skugid(enum nft_meta_keys key,
 			 u32 *dest,
 			 const struct nft_pktinfo *pkt)
 {
-	struct sock *sk = skb_to_full_sk(pkt->skb);
-	struct socket *sock;
+	const struct sock *sk = skb_to_full_sk(pkt->skb);
+	const struct socket *sock;
+	const struct file *file;
 
 	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
 		return false;
 
-	read_lock_bh(&sk->sk_callback_lock);
-	sock = sk->sk_socket;
-	if (!sock || !sock->file) {
-		read_unlock_bh(&sk->sk_callback_lock);
+	/* The sk pointer remains valid as long as the skb is. The sk_socket and
+	 * file pointer may become NULL if the socket is closed. Both structures
+	 * (including file->cred) are RCU freed which means they can be accessed
+	 * within a RCU read section.
+	 */
+	sock = READ_ONCE(sk->sk_socket);
+	file = sock ? READ_ONCE(sock->file) : NULL;
+	if (!file)
 		return false;
-	}
 
 	switch (key) {
 	case NFT_META_SKUID:
 		*dest = from_kuid_munged(sock_net(sk)->user_ns,
-					 sock->file->f_cred->fsuid);
+					 file->f_cred->fsuid);
 		break;
 	case NFT_META_SKGID:
 		*dest =	from_kgid_munged(sock_net(sk)->user_ns,
-					 sock->file->f_cred->fsgid);
+					 file->f_cred->fsgid);
 		break;
 	default:
 		break;
 	}
 
-	read_unlock_bh(&sk->sk_callback_lock);
 	return true;
 }
 
-- 
2.53.0.414.gf7e9f6c205-goog

