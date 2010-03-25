From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH] netfilter: CLUSTERIP: clusterip_seq_stop() fix
Date: Thu, 25 Mar 2010 20:47:22 +0100
Message-ID: <1269546442.2894.5.camel@edumazet-laptop>
References: <1269539686-3885-1-git-send-email-kaber@trash.net>
	 <1269539686-3885-2-git-send-email-kaber@trash.net>
	 <1269539686-3885-3-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	David Miller <davem@davemloft.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1269539686-3885-3-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

If clusterip_seq_start() memory allocation fails, we crash later in
clusterip_seq_start(), trying to kfree(ERR_PTR(-ENOMEM))

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 0886f96..afa937b 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -600,7 +600,8 @@ static void *clusterip_seq_next(struct seq_file *s, void *v, loff_t *pos)
 
 static void clusterip_seq_stop(struct seq_file *s, void *v)
 {
-	kfree(v);
+	if (!IS_ERR(v))
+		kfree(v);
 }
 
 static int clusterip_seq_show(struct seq_file *s, void *v)


