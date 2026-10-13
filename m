Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835024E73D8
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2026 23:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791935028; cv=none; b=WzWjWeBe34GeuCq0cRTicohtQ00bo3TZsaxuAUSYM8L0lqSuuuputEKMuw72wh7jMx8KESwD8iNmE6xD0R3YIi6P8qZ616PocHQ+on02k0+OVsv9rw4qZM69LSaX5HASDd9V9PIp8MofYqehWY1Oqa320cvr54/zoLPFxoQUijc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791935028; c=relaxed/simple;
	bh=tQhRPjbpm5bw4SJApOkVBgcnuTmGSv7bVfdhlLbwMOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apXph3jME0VeqkDkFGhOflKq0oYELhYZyIFqQcAZpeAulU5hRX7OuDqZUenFWIUB/xtaEQSKCwq8p5Y0itz1wK3KP9acJ5oNBdz7GBH+PM7vkvhaRD1UDfU4rwljFFke0mGVwPY9AUEqm2RSmQMK+nHmT92XdxsMDvoG5YjjZ1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fsrCH3MP; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fsrCH3MP"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48b0ef9c76eso2726962f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2026 16:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791935025; x=1792539825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XrQ3pYkWsUkZm6c4Y630wMw1ofCmIUu+ku1D5bRsOSA=;
        b=fsrCH3MP+GxQaUmiEtAr5f+U/ctPY1nWGDo7rDt0uK1GeqXyJV6v+49m6Kcppvg1Q0
         4U2TN9Z6//DS1UtlX9mQ0Bn1enQv8y4y033w+EJmh4xux9S45z/rd7KosFKCvlR4dIYG
         zXpGFSTETBubQLZHZTqa4tC5moV9gEP0DI/KoU38LSiP9g2FVHEpRDQqMV2f2VCAOcFS
         uy7xKY4qclTqrm0he22CUGrInJf/rHLXm4G/Lz6Jdr6kNkTrJ7JwII2QDvZKczhMtXKa
         yaVRQQk+Kw04S8lhUlVu8pQPm/VisQeG4mAi7Y8wyw5Ug7b+xSN3sk2ac2Do69ewBuBe
         chMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791935025; x=1792539825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XrQ3pYkWsUkZm6c4Y630wMw1ofCmIUu+ku1D5bRsOSA=;
        b=DZdnCC4zMAXkg6t7xpv59XejeFPUpsCLNRgmpJV3/DW5O2FFNtU9xvfkSbCYGjr4f8
         1WNZoe/+89F3zMgaDRWnYiDgY8uN7lCiYuBytDMPvwVdNtjmanXPytjiAbXGZrlBn/vO
         sbF1CdYewUAleSt5iwau01/npoESEo+enhrR0gqKXQ40dNOMnejhIflBML1pPi5Td4CV
         wlPzMQ2nMw5qjbDnMP317N9ryzp6bpAyP87xPWOHLBhpZorhlUlNi6M2x5qGTDpbCmu+
         fXgQn1cLBESlilgUxtySRrsqbrKaKi4EZKKbQnRbNtBGnqly0Kvp39Jv5vG3XED2uxpm
         YxnQ==
X-Forwarded-Encrypted: i=1; AKwUvBwn9K3VfxndVGUdO8TFJ+/RwQtopxyApXVbg0wcWyYUKda1UEf4w2UVFsmbCnn/bot09dSWqSB2sIVD7DUWFjg=@vger.kernel.org
X-Gm-Message-State: AFq9FYI13HnenLp0mr9+3PLixEQrivtcSvHUUSfeVOMv7SvfoHT/K9BS
	EdRfEYsPAYR6/PPOtH7U1MbnXliUlFJWkrUxAHbueZMEMnAZCBcvQY1bY1YB
X-Gm-Gg: AYBFou0tW48SFLTRzUKaL3c7i/VmJLBOSMU4hSq0VWanHuHzS2/li1XSY4bBITRYQa0
	BPD+cgjI7opDjGwgX/f1mBJKqsfM4xS5DZdUoYZfYaGzq7W4feQDNStRhODnKZo/80Nfqqhqe0n
	ScYrZU54VDgial0OO9OydvY1lLaBFY2vEl9oU9xyCX8gMS/Ws1pI46jxgGKhLCh1crAESv8r38D
	lknvX4j1FyQ1IlmKorXXcu8b1M5glM6dhqo3ftJ4Yr0fm6RUecwgiPMTLtFQQ4dhldCaJ4THi5j
	1S4IxLpayGyjZslo5sRu8pCIHoG83EyF0BWrT7B5tydGZqBiO7cX38XP99lIsRD4ZRkj6i+qTw6
	4RwXJ7D4+6yeotuNIAt8FPffwYpfOpyJ3xiX0r+T032r8YZlb+WCW+X3eK2CmPtbf5CRBAG1F0+
	1nxe/8JHOOe3fc3h2V656R16W56ft7uFRrWaamvIw=
X-Received: by 2002:a05:600c:699b:b0:4a0:4a8:d444 with SMTP id 5b1f17b1804b1-4a18e4af334mr291263645e9.33.1791935024497;
        Tue, 13 Oct 2026 16:43:44 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf35930sm390372155e9.13.2026.10.13.16.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 16:43:43 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	Christian Brauner <brauner@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>,
	stable@vger.kernel.org
Subject: [PATCH nf 5/5] netfilter: nf_log_syslog: pin file with get_file_rcu() before reading f_cred
Date: Tue, 13 Oct 2026 23:43:28 +0000
Message-ID: <20261013234329.2797868-6-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261013234329.2797868-1-tristmd@gmail.com>
References: <20261013234329.2797868-1-tristmd@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

Since commit 0ede61d8589cc ("file: convert to SLAB_TYPESAFE_BY_RCU"),
struct file objects can have their slab slot reused while RCU readers
still hold pointers to them. The syslog UID/GID output reads
file->f_cred without pinning the file, which could lead to logging
credentials from an unrelated file if the slab slot is reused.

Use get_file_rcu() to take a reference on the file before reading
credentials, and fput() to release it after extracting the values.

Fixes: 0ede61d8589cc ("file: convert to SLAB_TYPESAFE_BY_RCU")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 net/netfilter/nf_log_syslog.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index c3fd398ffcd77..f41bf83190912 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -168,22 +168,27 @@ static struct nf_logger nf_arp_logger __read_mostly = {
 static void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
 				   struct sock *sk)
 {
-	const struct socket *sock;
-	const struct file *file;
+	struct socket *sock;
+	struct file *file;
 
 	if (!sk || !sk_fullsock(sk) || !net_eq(net, sock_net(sk)))
 		return;
 
-	/* The sk pointer remains valid as long as the skb is. The sk_socket and
-	 * file pointer may become NULL if the socket is closed. Both structures
-	 * (including file->cred) are RCU freed which means they can be accessed
-	 * within a RCU read section.
+	/* The sk pointer remains valid as long as the skb is. The
+	 * sk_socket and file pointer may become NULL if the socket is
+	 * closed. Since struct file uses SLAB_TYPESAFE_BY_RCU, pin the
+	 * file with get_file_rcu() to ensure f_cred is not from a
+	 * reused slab slot.
 	 */
 	sock = READ_ONCE(sk->sk_socket);
-	file = sock ? READ_ONCE(sock->file) : NULL;
+	if (sock)
+		file = get_file_rcu(&sock->file);
+	else
+		file = NULL;
 	if (file) {
 		const struct cred *cred = file->f_cred;
 
+		fput(file);
 		nf_log_buf_add(m, "UID=%u GID=%u ",
 			       from_kuid_munged(&init_user_ns, cred->fsuid),
 			       from_kgid_munged(&init_user_ns, cred->fsgid));
-- 
2.47.3

