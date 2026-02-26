Received: from mail-yx1-f74.google.com (mail-yx1-f74.google.com [74.125.224.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E242C234B
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 09:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772098840; cv=none; b=k89BYGSxR/OoBFxhfRlYws1/w/pX3qyySW+sy+5xs7/9wxwDqXvGD+l3G+GXoNWx/MxFMlVKGlOnk5hQ2IEtaK+jIoW0eyGz9v3fUqYFeNmZBB9ALyJKo77Admy1of9g23+2Q8aAYRBXkS9vQ2JwXXhiNhUU2xQRnXFDMmuAtwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772098840; c=relaxed/simple;
	bh=6Y2r1m4ktKYWJZA5fuQy2TxAyWNeR/WGqtQQWHR9Lqw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=WjmtXoW5EXVAwHfwxFcLjtQ1ySukZX9XtyH6ku1Vca1h0exY7li8P+YMWDp3virU2qV2LLzyn4AAUiLZyJ3u/bmEM96RtzuV2P5HAssy3NxIvEjHchhjZyE/uRFiojru8B9BCzRUFMhKVuvv4mgvE1KBqXWh5UTvMWh35fwu5ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i/oIbMCl; arc=none smtp.client-ip=74.125.224.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i/oIbMCl"
Received: by mail-yx1-f74.google.com with SMTP id 956f58d0204a3-64956932a51so554681d50.0
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 01:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772098838; x=1772703638; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=htXESGH862/A++yJsW09A3WDgNddAXJDDbqtkvvU8IY=;
        b=i/oIbMClBJPPvq2s1erUSnfRCG9hRXTaLVrM3nqIib+I0STC79jYAiG1nLecCDfq91
         OuyfKJnScJu2618/L+Yo8l3NQ7yxi4jDHAXN/vmQCWejDp779oHiY466nhxKFz24e/S2
         gV/3EUuZHYXdMbeY8MEx5uFZzPuLviDFdcFfhiTABOoP0BXHUHnytXgFXXV4RUI4w7vs
         KiRVW4Sp8FBjxE7l8QCFaDCSgo0+PN66G1MP2HXg/isml1UWOmkCk4wZRg8bbf496ZSc
         aolPrb4mJWBz8oGZnU+1MXjRXtZNTnleolCWpRHUTZh10slk7TOwZDxCEILIcUuifYy0
         aiUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772098838; x=1772703638;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=htXESGH862/A++yJsW09A3WDgNddAXJDDbqtkvvU8IY=;
        b=YxY/jFiVriw2hAOUfGkXtBn3/SXIkzS2hsbwrnfOck84VmTQj+qik3F+01kV8hNKBp
         eu7CBETWblbwz/jxDsFttVi9NDx4OxS7BhJURAL8L+ttg8jOxb/bPmqrjsOfMvWocjxT
         UWQtPKFMYFKUdqc1tR2QkZ4ihYivEHfrRACTWxn2o9oPlUG50+5nfF0KRFAuBo1vTJNR
         C7Bp/qAI7DGWLcp19X4EanOG4DAQW+ADniO6mOQQQc0jmMG9FHMblFDcO0cEuVVg8K3X
         fNZa8f6ZRJwLUBWM/PCqZFYXQ9a84yQObc+9YLyVXYYN54jS14ime5qBgtP5sQmSWXVK
         PkoA==
X-Forwarded-Encrypted: i=1; AJvYcCUB8m2U1NgpNLIx8PLBY0rDZefWcpmqllEYnUxHeWgVJicFtYbLvTgPajKjSCyJUQLBa9ZXNlS5eEge5Pf8J40=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIqzCj9ttPO9/NzeIV89lSBlVvMc5oFMpooq3hvEosNolo8hG1
	OUESrCqyEfozpfGXd2Ore6jlaFwEIYKsoh3Wg8OJoFi/SNnf4mDIxkWOnG0yO2/ThvLWPUCkKBf
	X2InCAgDaVHgJtA==
X-Received: from yxww8.prod.google.com ([2002:a05:690e:42c8:b0:646:e5d7:6a3a])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:690e:14c6:b0:64a:d9b3:6ef3 with SMTP id 956f58d0204a3-64cb7bf5638mr1041583d50.6.1772098838386;
 Thu, 26 Feb 2026 01:40:38 -0800 (PST)
Date: Thu, 26 Feb 2026 09:40:36 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260226094036.2309604-1-edumazet@google.com>
Subject: [PATCH nf-next] netfilter: nfnetlink_queue: no longer acquire sk_callback_lock
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

After commit 983512f3a87f ("net: Drop the lock in skb_may_tx_timestamp()")
from Sebastian Andrzej Siewior, apply the same logic in
nfqnl_put_sk_uidgid() to avoid touching sk->sk_callback_lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nfnetlink_queue.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f1c8049861a6b7c91c2d1fd0aa1ddb2db9a31d8f..fbe5a8d7143358906d8e77d3e7a62152fdac337b 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -545,14 +545,23 @@ nfqnl_put_packet_info(struct sk_buff *nlskb, struct sk_buff *packet,
 
 static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 {
+	const struct socket *sock;
+	const struct file *file;
 	const struct cred *cred;
 
 	if (!sk_fullsock(sk))
 		return 0;
 
-	read_lock_bh(&sk->sk_callback_lock);
-	if (sk->sk_socket && sk->sk_socket->file) {
-		cred = sk->sk_socket->file->f_cred;
+	/* The sk pointer remains valid as long as the skb is.
+	 * The sk_socket and file pointer may become NULL
+	 * if the socket is closed.
+	 * Both structures (including file->cred) are RCU freed
+	 * which means they can be accessed within a RCU read section.
+	 */
+	sock = READ_ONCE(sk->sk_socket);
+	file = sock ? READ_ONCE(sock->file) : NULL;
+	if (file) {
+		cred = file->f_cred;
 		if (nla_put_be32(skb, NFQA_UID,
 		    htonl(from_kuid_munged(&init_user_ns, cred->fsuid))))
 			goto nla_put_failure;
@@ -560,11 +569,9 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 		    htonl(from_kgid_munged(&init_user_ns, cred->fsgid))))
 			goto nla_put_failure;
 	}
-	read_unlock_bh(&sk->sk_callback_lock);
 	return 0;
 
 nla_put_failure:
-	read_unlock_bh(&sk->sk_callback_lock);
 	return -1;
 }
 
-- 
2.53.0.414.gf7e9f6c205-goog

