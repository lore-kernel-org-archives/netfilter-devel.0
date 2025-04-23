Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54085280A21;
	Wed, 23 Apr 2025 18:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745432132; cv=none; b=rfvhz/A0oZRskpF61v5Fh5mIUW7xK2N/e4PkR3ubg5rxNvPwqId2iSYLe37FiGte7CUJIMc/U3N/a5hxVY8pPHds9i8nmVL30JdOFQgBeVDYm0+5L07gVbj6n7/fzbtAPQopVrujVCHqu8UUJVoopQgDWvf/AoGweu/oT0GFMTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745432132; c=relaxed/simple;
	bh=bahC4EZGyLZ5JcodwBxNGpmpVQpi+ynBeIQYEPfwdfY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fecgTTyCIxBk8QXHlnu8dlwOTMel9IGEGUKwq1Lek0VN6AGL9HD5eVz5KIkpGG6YtTKC4S5TL4Czi5Jmam744zCJE5eZL5icU5PAAZtwXsdiHlpaydev10V6Khp0igi6TXijOSkxY/mphDhJBpZ55rFoEK48rwsrDSHvMLb/u0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VdMPgVIx; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VdMPgVIx"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-54998f865b8so82172e87.3;
        Wed, 23 Apr 2025 11:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745432127; x=1746036927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=60ooqHv4lubF04MISs1yun2dS0JF24QIl5RyblgguIU=;
        b=VdMPgVIxt/RtNU31RooXe4QjQ2d3c3IkX6kpvjteLUsLNirqR6scw5AyszlsfXSAg4
         w/sS28MYmVQOsFZQiwzNKI47XZVWrqFsSKBgAnikDwENbyZqDfXKVTM5jWjmO/pWaEGJ
         brbUkDDPcFbcKOIoy8MMjNUV7rAd2Pt6PiM92+6zPswEYb0W4wj0EGzxWl6bMMQkB+LP
         S6Y7xwejaMrk/6p8EgMfRoimDCRsony2gwIyviYWR0hVBcE+hMHoqutJrvVlZK8Zm07x
         kQR6XuNaxAtd8lRgTRo/4UYYU7U1ronHtYB2AffwdSokDveuZTNuixOeUA3CTow9juKm
         x0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745432127; x=1746036927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=60ooqHv4lubF04MISs1yun2dS0JF24QIl5RyblgguIU=;
        b=QH+rCt/vUUSVfe4VoacLxd27rQqeCvBp4omzjPpTKnd3UZOT/9wk/nHJQOhLJY8bHU
         8TfoI3Ytk+FZcx22py71b5VXTTuiD9O2k0eJgbunqKv9HGAP2O401hYRq9UOfYzev6v3
         dqb4CiaXEbCfVAhf2NsBdo8kwSg2Lf+Oob0eMUIGNATmTGRnjSwzvUmsBM56nelM6aMP
         G/74e5QzOTWflFzBLXZVLcxdoWLVyiadVmdK3R10duzzhDCH2EnInv9VdhNYqwDn8vSx
         8h0qoEuqR2n/6kzxO7jiNjszxQQNq8S3FFd4khf+DuYDx25KUra6CXzBnOlVj+gjV4xj
         ej1w==
X-Forwarded-Encrypted: i=1; AJvYcCU0NQhl0NNLfklU2zU+6JQPp3+ox4vpf8UKLQV8LYwmztUGVi9UOvtrSYN9x+/gqTmWSrIIPWnl@vger.kernel.org, AJvYcCVxwfHzln4UMWqNC0/ZrYOQxZ0Q8Q2UsXQOMePtq21fcxS5RR9Dx8qkPr69sNFW4HekgyoZ23al@vger.kernel.org, AJvYcCX9pn6pqoxoiB8TUh8PW6AwVE7kjbSn1X4LJ3PPL3lQ3F+tWsxUDqmPgUtXJZt4ZsBGF0axP23mU0xsoV0DqAtM@vger.kernel.org, AJvYcCXvQPvURcf3rsGLtIlIEZsTRO+rR2WOLg+JSw4NNZq9wfJRewZBkPweLfA48Kr2CsAIHL1PQ5aNjIG5gwo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxad2leXoZox9FJsgaGM9LaC/yOVM9nyatAI6aBOcS2Vl7mfp1G
	/Zj8nPDeWbGpjl/DmZWBHSQSLwLGtZ7lfV67mxpAFe1/gtwHDxuq
X-Gm-Gg: ASbGncu4NhEuOM0wejGB8iy5vRj/unZq9uowOxjZ3D+7wm6wM7a8PIqhKltIFJOJkGv
	n1kb3kwkCplHSVuU0Xjil7O1A+16yMNeGaIBUIaKosYtWPcp62pt18gFRp2nIEaopaRhkIFYV0R
	hVNSi9HM0VlVu8tyTUV51MvYYo1Bf+KJkPvX89/R0YR1lDfVki7MJ/9/RDewjZqNXqne1QuEO1E
	pm/KUMWeY8XCkY9R55KaEIPfPrqOidQOXqPXA7CGwV9TVKPih0UjLopARBY3RnMh6iLc7xo4fao
	IUJu13a8tmAYnBfvcKNPud5yk2yjhxqxuiRCXaUOHqDA2cmC4ADgX6M=
X-Google-Smtp-Source: AGHT+IFG0X8R3+9zVQjwFuLKdnVhwPWdDHjtGIJi+PAV1z4CfmJthxydm3SWJC3j0gwdpys72wiu6w==
X-Received: by 2002:a05:6512:224b:b0:545:60b:f394 with SMTP id 2adb3069b0e04-54e7b5ba31cmr217791e87.4.1745432127102;
        Wed, 23 Apr 2025 11:15:27 -0700 (PDT)
Received: from localhost.localdomain ([87.249.25.136])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54d6e5d0146sm1603134e87.128.2025.04.23.11.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 11:15:25 -0700 (PDT)
From: Evgeny Pimenov <pimenoveu12@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Evgeny Pimenov <pimenoveu12@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Taehee Yoo <ap420073@gmail.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 5.10/5.15/6.1] netfilter: ipt_CLUSTERIP: change mutex location
Date: Wed, 23 Apr 2025 21:12:46 +0300
Message-Id: <20250423181245.14794-1-pimenoveu12@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No upstream commit exists for this patch.

The file ipt_CLUSTERIP.c was deleted in commit 9db5d918e2c0
("netfilter: ip_tables: remove clusterip target"), but races still exist
in stable branches.

Thread A in clusterip_config_entry_put() decrements refcount and removes
config from the list but doesn't call proc_remove(). Thread B searches
the config, doesn't find it, re-adds it to the list, and calls
proc_create_data() with an IP that still exists in the tree.

|A| refcount_dec_and_lock()
|A| list_del_rcu()
=== Must be here
|A| proc_remove()
===
|B| __clusterip_config_find()
|B| list_add_rcu()
|B| proc_create_data()
|B| WARN()

As a fix, also cover with mutex the places of interaction with the list of
configs before proc_remove() and proc_create_data() functions.

------------[ cut here ]------------
proc_dir_entry 'ipt_CLUSTERIP/100.1.1.2' already registered
WARNING: CPU: 0 PID: 2597 at fs/proc/generic.c:381 proc_register+0x517/0x6e0 fs/proc/generic.c:381
[...]
Call Trace:
 proc_create_data+0x130/0x1a0 fs/proc/generic.c:583
 clusterip_config_init net/ipv4/netfilter/ipt_CLUSTERIP.c:281 [inline]
 clusterip_tg_check+0xb8d/0x1380 net/ipv4/netfilter/ipt_CLUSTERIP.c:502
 xt_check_target+0x27c/0xa00 net/netfilter/x_tables.c:1018
 check_target net/ipv4/netfilter/ip_tables.c:511 [inline]
 find_check_entry.constprop.0+0x7b0/0x9b0 net/ipv4/netfilter/ip_tables.c:553
 translate_table+0xc6a/0x16a0 net/ipv4/netfilter/ip_tables.c:717
 do_replace net/ipv4/netfilter/ip_tables.c:1138 [inline]
 do_ipt_set_ctl+0x54e/0xb00 net/ipv4/netfilter/ip_tables.c:1636
 nf_setsockopt+0x88/0xf0 net/netfilter/nf_sockopt.c:101
 ip_setsockopt+0xe4d/0x3d10 net/ipv4/ip_sockglue.c:1442
 sctp_setsockopt+0x135/0xa390 net/sctp/socket.c:4475
 __sys_setsockopt+0x234/0x5a0 net/socket.c:2145
 __do_sys_setsockopt net/socket.c:2156 [inline]
 __se_sys_setsockopt net/socket.c:2153 [inline]
 __x64_sys_setsockopt+0xb9/0x150 net/socket.c:2153
 do_syscall_64+0x30/0x40 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x67/0xd1

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 2a61d8b883bb ("netfilter: ipt_CLUSTERIP: fix sleep-in-atomic bug in clusterip_config_entry_put()")
Cc: stable@vger.kernel.org # v5.4+
Suggested-by: Fedor Pchelkin <pchelkin@ispras.ru>
Suggested-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Evgeny Pimenov <pimenoveu12@gmail.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 77e3b67e8790..61ccfd97841f 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -79,6 +79,22 @@ static inline struct clusterip_net *clusterip_pernet(struct net *net)
 	return net_generic(net, clusterip_net_id);
 }
 
+static inline void
+clusterip_net_lock(struct clusterip_net *cn)
+{
+#ifdef CONFIG_PROC_FS
+	mutex_lock(&cn->mutex);
+#endif
+};
+
+static inline void
+clusterip_net_unlock(struct clusterip_net *cn)
+{
+#ifdef CONFIG_PROC_FS
+	mutex_unlock(&cn->mutex);
+#endif
+};
+
 static inline void
 clusterip_config_get(struct clusterip_config *c)
 {
@@ -114,6 +130,7 @@ clusterip_config_entry_put(struct clusterip_config *c)
 {
 	struct clusterip_net *cn = clusterip_pernet(c->net);
 
+	clusterip_net_lock(cn);
 	local_bh_disable();
 	if (refcount_dec_and_lock(&c->entries, &cn->lock)) {
 		list_del_rcu(&c->list);
@@ -123,14 +140,14 @@ clusterip_config_entry_put(struct clusterip_config *c)
 		 * functions are also incrementing the refcount on their own,
 		 * so it's safe to remove the entry even if it's in use. */
 #ifdef CONFIG_PROC_FS
-		mutex_lock(&cn->mutex);
 		if (cn->procdir)
 			proc_remove(c->pde);
-		mutex_unlock(&cn->mutex);
 #endif
+		clusterip_net_unlock(cn);
 		return;
 	}
 	local_bh_enable();
+	clusterip_net_unlock(cn);
 }
 
 static struct clusterip_config *
@@ -262,6 +279,7 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
 	c->net = net;
 	refcount_set(&c->refcount, 1);
 
+	clusterip_net_lock(cn);
 	spin_lock_bh(&cn->lock);
 	if (__clusterip_config_find(net, ip)) {
 		err = -EBUSY;
@@ -277,11 +295,9 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
 
 		/* create proc dir entry */
 		sprintf(buffer, "%pI4", &ip);
-		mutex_lock(&cn->mutex);
 		c->pde = proc_create_data(buffer, 0600,
 					  cn->procdir,
 					  &clusterip_proc_ops, c);
-		mutex_unlock(&cn->mutex);
 		if (!c->pde) {
 			err = -ENOMEM;
 			goto err;
@@ -290,6 +306,7 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
 #endif
 
 	refcount_set(&c->entries, 1);
+	clusterip_net_unlock(cn);
 	return c;
 
 #ifdef CONFIG_PROC_FS
@@ -300,6 +317,7 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
 out_config_put:
 	spin_unlock_bh(&cn->lock);
 	clusterip_config_put(c);
+	clusterip_net_unlock(cn);
 	return ERR_PTR(err);
 }
 
@@ -848,10 +866,10 @@ static void clusterip_net_exit(struct net *net)
 #ifdef CONFIG_PROC_FS
 	struct clusterip_net *cn = clusterip_pernet(net);
 
-	mutex_lock(&cn->mutex);
+	clusterip_net_lock(cn);
 	proc_remove(cn->procdir);
 	cn->procdir = NULL;
-	mutex_unlock(&cn->mutex);
+	clusterip_net_unlock(cn);
 #endif
 	nf_unregister_net_hook(net, &cip_arp_ops);
 }
-- 
2.39.5
