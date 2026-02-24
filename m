Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com [209.85.219.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A443803D1
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 12:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771936430; cv=none; b=rkuyFWPKVsWNUt3s7xzZZQOLD564mcexBnqHLs945hYY4NiC62RvDslaT7Lp/dlKCiI+T/gDfKMtbuIC58Um4J3k8L0KdKq3j3xfOeYkCWJe8sCGlGUST3tB3Eki68plD3GDTG9yTha4QLtJA90YVuZaLEQsO4e4DApvXvsIigU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771936430; c=relaxed/simple;
	bh=clZnONM24nEys84smKGnPS40DZNnvZ0axgHZ537gWa8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lrQBr5as2VMkC4dEEaE8dznXjDv83X36WaleWoXY9JeEJ+cAJZs89CXcPEa9TOWYszdxpn7XGXDR9kEbRn3PecztSuRZcgH2NqPP2CDYKtlYtjepLV3T6tONhF9PAkkmiw31uk1VYdcvNxnxpDFsXcNcG6kOlG+F8lcx/RqaO0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DRfJcHyZ; arc=none smtp.client-ip=209.85.219.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edumazet.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DRfJcHyZ"
Received: by mail-qv1-f73.google.com with SMTP id 6a1803df08f44-89700915423so66218396d6.2
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2026 04:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771936428; x=1772541228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fQbu6Cl/paq0E3UGNbm7xLXUbURoFHMRf6FXvlp9cXk=;
        b=DRfJcHyZo/thIw0B82gbRNF0xsmJbkZsu+3/nqihuaJMlQaTepzOdb2cibeNP3/hi4
         qyA2u0XRgeuaNgnPB75K0ZrC7FFudSDP0XZPgx+e8p60RSddUXYai81xEG28HSz1rto5
         k+hBVIKjlAAxFl9ljvIK8bvRNM736Fxxdx2QAf4JpEp9wm0pOFMgGwAKNZWJ/MSDGMsq
         oSmgGWRDf2jklSm95lgjl7fZ2r+SitFxB1MazUFFbo1ZJVvGxumtHdqtbgIG458PotII
         FT7Q4hBTegrALhUy8KFll0N8b3WpmKKWtpTGQsISYzUrGzhh92zwqJ/SguHHNUgjIk7q
         bCGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771936428; x=1772541228;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fQbu6Cl/paq0E3UGNbm7xLXUbURoFHMRf6FXvlp9cXk=;
        b=mBMtOVg1gnnU12DC8KLS+8G5dirzIutGzCnkqlDCJ4Va+JOj0iS8RO7Nsh/M1BCCNv
         Otwl6uMlU0EjC8H273mS4UOtOT+52SIIOSwFXI0JX4EiJIakD28cBtbuWxzmWkDdH0bY
         0vxQvBS4VaPba6U23ksu0a1hDQrgx9OCjzprh/l3Hi8h0yHsNHFPNGJKdTaqTwkhESqu
         3QcYArWAyay/8gXuVBboHFx7Y1Uf+kj9YQAqYksRjAQ7EZ+uE1eYHRPRTsMMCyHDlEPj
         OMkVuaTjerHJFpKZM7j7UnA57/QZIcRJhBx43qrIItmJqZpASy8ew1qMyweJCwDaaWym
         1UPA==
X-Forwarded-Encrypted: i=1; AJvYcCVA/v/wTbo+T4O0SNUByrndVvbX/p83FjICcxYWD9FZsyduOovMvd4mVTsfH1utUbnBVAeLaF/bAYfCmQyskIo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo1QrXLRHub4UdqUIolCZSLdrE3Ob1Laak8rmWeGHAn6vobdUP
	ijevZxgeQpOBdNStiZrbyFuw9T2keSIr+C5DFRK5OB7de1YFauZRCo45bBaXZeHo0KmayUP2TEI
	haowUkAiyNWlaQg==
X-Received: from qvbif8.prod.google.com ([2002:a05:6214:1c48:b0:894:2b9f:cc7e])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:ad4:5c8c:0:b0:880:498e:a63e with SMTP id 6a1803df08f44-89979c53d67mr180727396d6.2.1771936428183;
 Tue, 24 Feb 2026 04:33:48 -0800 (PST)
Date: Tue, 24 Feb 2026 12:33:47 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
Message-ID: <20260224123347.3163030-1-edumazet@google.com>
Subject: [PATCH nf-next] netfilter: nf_log_syslog: no longer acquire
 sk_callback_lock in nf_log_dump_sk_uid_gid()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

After commit 983512f3a87f ("net: Drop the lock in skb_may_tx_timestamp()")
from Sebastian Andrzej Siewior, apply the same logic in nf_log_dump_sk_uid_gid()
to avoid touching sk_callback_lock.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nf_log_syslog.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 41503847d9d7fb21824fabb1b57b45f2622b9310..dee6be17440c6c0f202fc2ba67129437879e45a6 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -165,18 +165,28 @@ static struct nf_logger nf_arp_logger __read_mostly = {
 static void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
 				   struct sock *sk)
 {
+	const struct socket *sock;
+	const struct file *file;
+
 	if (!sk || !sk_fullsock(sk) || !net_eq(net, sock_net(sk)))
 		return;
 
-	read_lock_bh(&sk->sk_callback_lock);
-	if (sk->sk_socket && sk->sk_socket->file) {
-		const struct cred *cred = sk->sk_socket->file->f_cred;
+	/* The sk pointer remains valid as long as the skb is. The sk_socket and
+	 * file pointer may become NULL if the socket is closed. Both structures
+	 * (including file->cred) are RCU freed which means they can be accessed
+	 * within a RCU read section.
+	 */
+	rcu_read_lock();
+	sock = READ_ONCE(sk->sk_socket);
+	file = sock ? READ_ONCE(sock->file) : NULL;
+	if (file) {
+		const struct cred *cred = file->f_cred;
 
 		nf_log_buf_add(m, "UID=%u GID=%u ",
 			       from_kuid_munged(&init_user_ns, cred->fsuid),
 			       from_kgid_munged(&init_user_ns, cred->fsgid));
 	}
-	read_unlock_bh(&sk->sk_callback_lock);
+	rcu_read_unlock();
 }
 
 static noinline_for_stack int
-- 
2.53.0.371.g1d285c8824-goog

