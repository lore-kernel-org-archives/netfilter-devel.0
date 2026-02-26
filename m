Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com [209.85.160.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D9438F23D
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 08:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772096302; cv=none; b=ulfp8SFRt1Ai+M1vCWZRbcAMBAC5YPNvWoe/wk7BVnEDyiF/GuouGNIZ+xwtu7NikPxq9+GNVuYVO0lULONuKFOWfOt0eZSnuzvRr73mxSZIlYpHSzNW2khvnd4wTr69TrflefzGknC6TY/U46+Z7fxrHOiXikvn+fT5nz4mtdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772096302; c=relaxed/simple;
	bh=SlOHjbFT6bgglmBCcv8V5rdB3omMjR2vXC7pzkgZVik=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MVI6ehJVS+Q5UB+OdXxR0JAmH39y5EztmOV6EqOVk30p6PC9weSwEdsdkpqMvrjXI0h3KlZetwBQCbSQt+v6oQhj+lIv0gW0Xjk3/q7xjIfS+Jj2O5v/SjSV0CrnkqYT980XSpgFVHIiPFRAEba/dswuHAYboa0LHmjCVVrKCFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n9jHG6mU; arc=none smtp.client-ip=209.85.160.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n9jHG6mU"
Received: by mail-qt1-f202.google.com with SMTP id d75a77b69052e-50340e2b4dfso114106721cf.3
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2026 00:58:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772096298; x=1772701098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0wuPspiPv1csZE43cGiBpIC+UQAJFmaKX0o5kmlUK68=;
        b=n9jHG6mULKfDQlh4lWSJVn4TClmcBExfDhWyIgUW/K8fkb/spUSmqiYHO3cUqilygo
         DMRy/k1H2e2XjWiVEQewd0NCA2nN/JoBs72JBjM+LB/GWmoxmVoJHxHzGRR8NQ6UcWcA
         XcTR1lqQH5u+GoyX9A2/x7Za7KCHpyAxZ+U2rnCLqS50ZAlujmHj+8viI4ATDZY4Ez0W
         Z7qCbyRy94RY6fiV+wPwe1BQsbpdja6czLPYqXGRRPVkLzd4aRttujJGBx1LA3nu+oVn
         8CRqCsZOyWMIR4z+CSu0cpE22h+hBW8cyjDyWZTrzyH2b2WsZm7RzFQHcFwDcE/3jgEH
         l3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772096298; x=1772701098;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0wuPspiPv1csZE43cGiBpIC+UQAJFmaKX0o5kmlUK68=;
        b=jcbJQn0XbIngYO7zC2NldQz/MTqYO2Vizs79wUvDdsLZRc7zu2P5eq1aR6bpWl69+J
         ZL/fmOvzkU0QNMPGWSa4MQZDsuwp0/EQC6/Kdx0i7NYQMToClnHNOZzREbbKKUw/3Rkn
         fKDzvAPiWJAmKaRXsRsiKizHi6GJ/UCmuTqCFDwwIefnyz0uk0UYdwpSqrtTnPwnSWW8
         9TweETZPmMtF1HOmJAlAqaLgGh2vvH05wmCpDUxq+BybnYtf8Eu8EFZA7dbOVuBGM94s
         2CHHdvf8LBkHhfITV1JDrRhCJQvCuXm0vGyH0es/u2dM0tXgWzJXweQZiqJfaXJd0j6x
         L6ZA==
X-Forwarded-Encrypted: i=1; AJvYcCW8kZAQT3bGFF5tl4Pd0ljFBH6h33vFdHUlPmiiDK31Us9bYBIzQrndqFjeEFsAkPSdGNGxwMIXyclcwaGqhxw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhjmsR5VMSCm5FYylAJTmN+tdx44cRlMTdl4YNmawlJsyNysVm
	6AbXvNAZOsgStGiS6Pqr6JLA4Tq7ss4JRoLQsyH3z7+dw0LFSH7oU60YOlZcgNDp7GswQ+u8DA8
	9wscXkFLF8mo5Uw==
X-Received: from qtxn14.prod.google.com ([2002:a05:622a:40e:b0:506:5118:a54f])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:ac8:5d4a:0:b0:4ed:b441:d866 with SMTP id d75a77b69052e-50741fbd9ecmr46698241cf.65.1772096298187;
 Thu, 26 Feb 2026 00:58:18 -0800 (PST)
Date: Thu, 26 Feb 2026 08:58:16 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260226085816.2272259-1-edumazet@google.com>
Subject: [PATCH nf-next] netfilter: nfnetlink_log: no longer acquire sk_callback_lock
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

After commit 983512f3a87f ("net: Drop the lock in skb_may_tx_timestamp()")
from Sebastian Andrzej Siewior, apply the same logic in
__build_packet_message() to avoid touching sk->sk_callback_lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nfnetlink_log.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index bfcb9cd335bff59fa4d0d09eb52943566e4098e7..bef28e5230bb3b4d4b1ef4d5111909bac969b343 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -611,19 +611,26 @@ __build_packet_message(struct nfnl_log_net *log,
 	/* UID */
 	sk = skb->sk;
 	if (sk && sk_fullsock(sk)) {
-		read_lock_bh(&sk->sk_callback_lock);
-		if (sk->sk_socket && sk->sk_socket->file) {
-			struct file *file = sk->sk_socket->file;
+		const struct socket *sock;
+		const struct file *file;
+
+		/* The sk pointer remains valid as long as the skb is.
+		 * The sk_socket and file pointer may become NULL
+		 * if the socket is closed.
+		 * Both structures (including file->cred) are RCU freed
+		 * which means they can be accessed within a RCU read section.
+		 */
+		sock = READ_ONCE(sk->sk_socket);
+		file = sock ? READ_ONCE(sock->file) : NULL;
+		if (file) {
 			const struct cred *cred = file->f_cred;
 			struct user_namespace *user_ns = inst->peer_user_ns;
 			__be32 uid = htonl(from_kuid_munged(user_ns, cred->fsuid));
 			__be32 gid = htonl(from_kgid_munged(user_ns, cred->fsgid));
-			read_unlock_bh(&sk->sk_callback_lock);
 			if (nla_put_be32(inst->skb, NFULA_UID, uid) ||
 			    nla_put_be32(inst->skb, NFULA_GID, gid))
 				goto nla_put_failure;
-		} else
-			read_unlock_bh(&sk->sk_callback_lock);
+		}
 	}
 
 	/* local sequence number */
-- 
2.53.0.414.gf7e9f6c205-goog

