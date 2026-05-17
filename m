Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B00351C17
	for <netfilter-devel@vger.kernel.org>; Sun, 17 May 2026 11:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779017918; cv=none; b=ZFjjm+Q3llW+iUfQ2kAeYFb1llhf27zKYxXqyvBmIA9BFIDCrQjSXGQn7RbzHxWsVODn0T8yz75qRrVP+nZ9zj9Nq1XVIJttinxnNoJure+O8Nz/M9t++O1sENV40y1b0R67x7bsbIfAhlccCkaiQnER2gSSkNEzE5sLzSpjxRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779017918; c=relaxed/simple;
	bh=9V4/dPA7hBlZxbxm2+EWIYEVzvLMzhi+p9bQIF99Sgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5j5E0B8vqTbur1v1poGLqrzs6k1AgT+4SIPGylgpIOAlyQySgnDwiJBk79/R1ehIDC9dcHdN2Ow6j/MY6lgFvDim1+PJcynpqkCVEEl6wh4iwyZG3A4ukAcSVa6KLbebGC5pqlms1GVWvZDVmMCFhPDa8yHOpdMOC/Y+h2i8bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowABXesSNqAlq3iwLAA--.12437S3;
	Sun, 17 May 2026 19:38:02 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	kaber@trash.net,
	jengelh@medozas.de,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	tonanli66@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: nf_dup: preserve socket ownership on egress duplicates
Date: Sun, 17 May 2026 19:37:45 +0800
Message-ID: <7b2643cdbf92aab1eb0ce00f2c6e7151839cbe40.1778945319.git.tonanli66@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1778922878.git.tonanli66@gmail.com>
References: <cover.1778922878.git.tonanli66@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowABXesSNqAlq3iwLAA--.12437S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKr15tryxtr47AF43JF43Wrg_yoW7XFyxpF
	4jk3y5JrsrAF129r4xAw42yr4ava18Wry7W3y3AayfKrnIqrs8Ca4SgryUWF45trs5Wr45
	tFZ2gr45Kr90y3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
	x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
	GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8V
	W8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEKCWoJXG8B7QAAs-

From: Nan Li <tonanli66@gmail.com>

pskb_copy() does not preserve skb socket ownership on the duplicate.
As a result, nf_dup_ipv4() and nf_dup_ipv6() can reinject locally
generated egress packets without the original socket association.

Some later transmit-side paths still rely on skb->sk and on the
associated skb destructor for socket write-memory accounting.
Preserve the socket on egress duplicates, and restore the original
destructor/accounting only when the source skb was already owner
charged.

Keep the ingress-side behavior unchanged, since there is no local
transmit socket to carry over for PRE_ROUTING or LOCAL_IN traffic.

The issue predates the nf_dup split and was already present in the
original xt_TEE implementation.

Fixes: e281b19897dc ("netfilter: xtables: inclusion of xt_TEE")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Nan Li <tonanli66@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/ipv4/netfilter/nf_dup_ipv4.c | 30 ++++++++++++++++++++++++++++++
 net/ipv6/netfilter/nf_dup_ipv6.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index 9a773502f10a..fd469f47bbf7 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -16,6 +16,8 @@
 #include <net/icmp.h>
 #include <net/ip.h>
 #include <net/route.h>
+#include <net/sock.h>
+#include <net/tcp.h>
 #include <net/netfilter/ipv4/nf_dup_ipv4.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack.h>
@@ -48,9 +50,25 @@ static bool nf_dup_ipv4_route(struct net *net, struct sk_buff *skb,
 	return true;
 }
 
+static bool nf_dup_ipv4_tx_owner(struct sock *sk,
+				 void (*destructor)(struct sk_buff *))
+{
+	return sk && (destructor == sock_wfree ||
+		      destructor == __sock_wfree ||
+		      destructor == tcp_wfree);
+}
+
+static bool nf_dup_ipv4_egress(unsigned int hooknum)
+{
+	return hooknum == NF_INET_LOCAL_OUT ||
+	       hooknum == NF_INET_POST_ROUTING;
+}
+
 void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in_addr *gw, int oif)
 {
+	void (*destructor)(struct sk_buff *) = skb->destructor;
+	struct sock *sk = skb->sk;
 	struct iphdr *iph;
 
 	local_bh_disable();
@@ -86,6 +104,18 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		--iph->ttl;
 
 	if (nf_dup_ipv4_route(net, skb, gw, oif)) {
+		/* pskb_copy() drops skb ownership. Preserve the originating
+		 * socket for egress duplicates, and restore write-memory
+		 * accounting when the original skb was owner charged.
+		 */
+		if (nf_dup_ipv4_egress(hooknum) && sk && sk_fullsock(sk)) {
+			skb->sk = sk;
+			if (nf_dup_ipv4_tx_owner(sk, destructor)) {
+				skb->destructor = destructor;
+				refcount_add(skb->truesize,
+					     &sk->sk_wmem_alloc);
+			}
+		}
 		current->in_nf_duplicate = true;
 		ip_local_out(net, skb->sk, skb);
 		current->in_nf_duplicate = false;
diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
index 6da3102b7c1b..973c860cf387 100644
--- a/net/ipv6/netfilter/nf_dup_ipv6.c
+++ b/net/ipv6/netfilter/nf_dup_ipv6.c
@@ -9,6 +9,8 @@
 #include <linux/percpu.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
+#include <net/sock.h>
+#include <net/tcp.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
 #include <net/netfilter/ipv6/nf_dup_ipv6.h>
@@ -44,9 +46,26 @@ static bool nf_dup_ipv6_route(struct net *net, struct sk_buff *skb,
 	return true;
 }
 
+static bool nf_dup_ipv6_tx_owner(struct sock *sk,
+				 void (*destructor)(struct sk_buff *))
+{
+	return sk && (destructor == sock_wfree ||
+		      destructor == __sock_wfree ||
+		      destructor == tcp_wfree);
+}
+
+static bool nf_dup_ipv6_egress(unsigned int hooknum)
+{
+	return hooknum == NF_INET_LOCAL_OUT ||
+	       hooknum == NF_INET_POST_ROUTING;
+}
+
 void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in6_addr *gw, int oif)
 {
+	void (*destructor)(struct sk_buff *) = skb->destructor;
+	struct sock *sk = skb->sk;
+
 	local_bh_disable();
 	if (current->in_nf_duplicate)
 		goto out;
@@ -64,6 +83,18 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		--iph->hop_limit;
 	}
 	if (nf_dup_ipv6_route(net, skb, gw, oif)) {
+		/* pskb_copy() drops skb ownership. Preserve the originating
+		 * socket for egress duplicates, and restore write-memory
+		 * accounting when the original skb was owner charged.
+		 */
+		if (nf_dup_ipv6_egress(hooknum) && sk && sk_fullsock(sk)) {
+			skb->sk = sk;
+			if (nf_dup_ipv6_tx_owner(sk, destructor)) {
+				skb->destructor = destructor;
+				refcount_add(skb->truesize,
+					     &sk->sk_wmem_alloc);
+			}
+		}
 		current->in_nf_duplicate = true;
 		ip6_local_out(net, skb->sk, skb);
 		current->in_nf_duplicate = false;
-- 
2.43.0

