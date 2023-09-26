Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E7DE7F126
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 20:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbjIZUF0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 16:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235817AbjIZUFZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 16:05:25 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BC413A
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 13:05:17 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59c0327b75dso179927777b3.2
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 13:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695758716; x=1696363516; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iUWT+ccHYSlqR7Gmrnq8A76xPWnK8wJVTcz3EkgFwkk=;
        b=fHvz/oXfN/BEP2dph9JC3zX7RplJK25pHOYQ4k6IYY2hH90LJ9R8h6X9CBSdVPWzOA
         zZ/uFcKpr7u4eQsd5O2ZSK+xcQXrOywBXajCGjcm0whNsAFfSsrd738LczlzCSllqloF
         pEzhSw4I1X44/guUCDwGqfzt9QuibRzEndhzaLrYP7lK6AG64NG8oc2alRg7CkTJ7JOZ
         bOx/0fu4TVsqxt+gD/reQgOiiGqTXzlYIgCQRXfciGybYOOS7c1U9Q1SAtvzHOyiSP4G
         taSxv0/UENApCkCQ7xsaAMjZBN1Pgu/eEuwoYJpS59T8gWm6HkncOggfOM07dVhLywpq
         HUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695758716; x=1696363516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iUWT+ccHYSlqR7Gmrnq8A76xPWnK8wJVTcz3EkgFwkk=;
        b=MvbtCES3va5i/6x0ZZ+F4sATRbDkAf2/AeyfmkUYm1nWLX1I0hAUOsyyAqALdB/8+7
         huSdgzw9rnJx7g4tuCT5Lj8N63C+Cl6cwAu6tFGxA86nSxNyy5Zw+XyBZd/ChAqrPDmz
         tT00vNfX0pad85film0ZPzopxblm6cz5jJKenBN4MnEo7CGzVwCVLYgGAdP1QLeiYevH
         yriW0Bj3WRHvrUdWaeUg7sxWW3lNQmEJDo+fwz8UsxkDLZn02RPPtgHyiuY/i7Op9nIv
         LBw71ZQJU/QULZ1t5C0usdAMFVWFE8A5AbHU8VKLMl2aP4SecKh9sdPh3ER8BBOM9EDs
         b7MQ==
X-Gm-Message-State: AOJu0YzDx3OgmI/tHNoRpv43xelbyLZJotX1tyKpszqFwte40Xo0K+zw
        26US547qMkbq5UJ23R9jzOecglENhw==
X-Google-Smtp-Source: AGHT+IEUd45Rw2MBKHocGo/lYiGWT9CIksAVWd6cnwx9BMyxx8zuAa0FUl0Vs9Eq31nY+vAcjI1OSk/2lQ==
X-Received: from jrife.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:9f])
 (user=jrife job=sendgmr) by 2002:a81:af60:0:b0:59b:ca80:919a with SMTP id
 x32-20020a81af60000000b0059bca80919amr428ywj.0.1695758716434; Tue, 26 Sep
 2023 13:05:16 -0700 (PDT)
Date:   Tue, 26 Sep 2023 15:05:05 -0500
In-Reply-To: <20230926200505.2804266-1-jrife@google.com>
Mime-Version: 1.0
References: <20230926200505.2804266-1-jrife@google.com>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230926200505.2804266-4-jrife@google.com>
Subject: [PATCH net v6 3/3] net: prevent address rewrite in kernel_bind()
From:   Jordan Rife <jrife@google.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com,
        netdev@vger.kernel.org
Cc:     dborkman@kernel.org, horms@verge.net.au, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, santosh.shilimkar@oracle.com,
        ast@kernel.org, rdna@fb.com, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, ja@ssi.bg,
        lvs-devel@vger.kernel.org, kafai@fb.com, daniel@iogearbox.net,
        daan.j.demeyer@gmail.com, Jordan Rife <jrife@google.com>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Similar to the change in commit 0bdf399342c5("net: Avoid address
overwrite in kernel_connect"), BPF hooks run on bind may rewrite the
address passed to kernel_bind(). This change

1) Makes a copy of the bind address in kernel_bind() to insulate
   callers.
2) Replaces direct calls to sock->ops->bind() in net with kernel_bind()

Link: https://lore.kernel.org/netdev/20230912013332.2048422-1-jrife@google.com/
Fixes: 4fbac77d2d09 ("bpf: Hooks for sys_bind")
Cc: stable@vger.kernel.org
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Jordan Rife <jrife@google.com>
---
 net/netfilter/ipvs/ip_vs_sync.c | 4 ++--
 net/rds/tcp_connect.c           | 2 +-
 net/rds/tcp_listen.c            | 2 +-
 net/socket.c                    | 7 ++++++-
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 6e4ed1e11a3b7..4174076c66fa7 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1439,7 +1439,7 @@ static int bind_mcastif_addr(struct socket *sock, struct net_device *dev)
 	sin.sin_addr.s_addr  = addr;
 	sin.sin_port         = 0;
 
-	return sock->ops->bind(sock, (struct sockaddr*)&sin, sizeof(sin));
+	return kernel_bind(sock, (struct sockaddr *)&sin, sizeof(sin));
 }
 
 static void get_mcast_sockaddr(union ipvs_sockaddr *sa, int *salen,
@@ -1546,7 +1546,7 @@ static int make_receive_sock(struct netns_ipvs *ipvs, int id,
 
 	get_mcast_sockaddr(&mcast_addr, &salen, &ipvs->bcfg, id);
 	sock->sk->sk_bound_dev_if = dev->ifindex;
-	result = sock->ops->bind(sock, (struct sockaddr *)&mcast_addr, salen);
+	result = kernel_bind(sock, (struct sockaddr *)&mcast_addr, salen);
 	if (result < 0) {
 		pr_err("Error binding to the multicast addr\n");
 		goto error;
diff --git a/net/rds/tcp_connect.c b/net/rds/tcp_connect.c
index d788c6d28986f..a0046e99d6df7 100644
--- a/net/rds/tcp_connect.c
+++ b/net/rds/tcp_connect.c
@@ -145,7 +145,7 @@ int rds_tcp_conn_path_connect(struct rds_conn_path *cp)
 		addrlen = sizeof(sin);
 	}
 
-	ret = sock->ops->bind(sock, addr, addrlen);
+	ret = kernel_bind(sock, addr, addrlen);
 	if (ret) {
 		rdsdebug("bind failed with %d at address %pI6c\n",
 			 ret, &conn->c_laddr);
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 014fa24418c12..53b3535a1e4a8 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -306,7 +306,7 @@ struct socket *rds_tcp_listen_init(struct net *net, bool isv6)
 		addr_len = sizeof(*sin);
 	}
 
-	ret = sock->ops->bind(sock, (struct sockaddr *)&ss, addr_len);
+	ret = kernel_bind(sock, (struct sockaddr *)&ss, addr_len);
 	if (ret < 0) {
 		rdsdebug("could not bind %s listener socket: %d\n",
 			 isv6 ? "IPv6" : "IPv4", ret);
diff --git a/net/socket.c b/net/socket.c
index 107a257a75186..3408bd6bb1e5a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3518,7 +3518,12 @@ static long compat_sock_ioctl(struct file *file, unsigned int cmd,
 
 int kernel_bind(struct socket *sock, struct sockaddr *addr, int addrlen)
 {
-	return READ_ONCE(sock->ops)->bind(sock, addr, addrlen);
+	struct sockaddr_storage address;
+
+	memcpy(&address, addr, addrlen);
+
+	return READ_ONCE(sock->ops)->bind(sock, (struct sockaddr *)&address,
+					  addrlen);
 }
 EXPORT_SYMBOL(kernel_bind);
 
-- 
2.42.0.515.g380fc7ccd1-goog

