Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=57.103.64.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916429;
	b=e72LNDkeIUoWvAyuUJC7z5yihdeMeNkg86/Dtn6+dkYI/Fwh9YT9raph6Iy/0CW8KPo5
	 Cd4UbeKz8cmgIVbGicv9hNPYBbJ1A3/a0hdg4ulbcYhsqtuFNPOB+TzCoXaV0iLcD9RVr
	 bImGUaRRrUPwcjrTF7ZSI770vGpeCAdMenOjAeGm/rYAirp8M/ks8TyI/VfYj1sFcXUob
	 sGy0CRWkk/1r+EXWXEGOu9yuHrYlxxFDTWhsVj0iplt6lD/n4N+KCAj7+HwTpEUD4eCgk
	 ge/X/oOqIF4M2gUsAWZeyIR+c2vMwv0KizFjrDoLLJbb735qQLBiEU+8pcXeTxmgZlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916429;
	h=DMARC-Filter:Received:X-ICL-RepId:Dkim-Signature:
	 mail-alias-created-date:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Authority-Info-Out:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:X-JNJ;
	bh=/FnNG8vqcCiU2cyM1KkwsgWOUElHYE9t3oC7rJ9yncA=;
	b=1xlC053xioh6WIp24UkRczD8b1WZ1+AVL1sWD4iq7tQUHW6cHlU7PpI06vQfjxRrtTOo
	 swG8/M8lWeoQonKTwG+SpAYwuN4qTMQwWaB69MrMdHywjBRoREy/BEAt+Tb/LfDTsgdI8
	 BESrKfF5OCwVTnPGo8BDOOFXGWCKMdFHW1oPZS0ooRF/QlkXnuvg2ymUsqHrEKViiNNwd
	 H35LH0qFgNAX2qlOFfDdNXOYdXyl7bGsViimdQEo701lLcuNEwx3HWhTz41OLxiYgkGrP
	 odxkIbOY3QvGW3ktMwaQJUk8gYtuPqlMYvMMZb4/logK9+Anzb4dyRWa3iDeWGZSD8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=verdict.gg;
	spf=pass smtp.mailfrom=verdict.gg;
	dkim=pass header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=e4kZUtng;
	arc=none smtp.remote-ip=57.103.64.176
Received: from outbound.pv.icloud.com (pv-2002a-snip4-5.eps.apple.com [57.103.64.176])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4F9606A89F
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:53:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B4F9606A89F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verdict.gg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=verdict.gg header.i=@verdict.gg header.a=rsa-sha256 header.s=sig1 header.b=e4kZUtng
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPS id EFED318000BC;
	Tue, 17 Nov 2026 11:53:46 +0000 (UTC)
X-ICL-RepId: 01a1e95b-2497-7cf0-9c77-3bf765588f1f
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verdict.gg; s=sig1; t=1794916429; x=1826452429; bh=/FnNG8vqcCiU2cyM1KkwsgWOUElHYE9t3oC7rJ9yncA=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=e4kZUtngllAAcMXLhDcoNaGeEf9XdNSmFy4g3oZgrMykjhU+TddLjximwVCVzGcI3WGJXe5Mgz3Fq+sbqJCiXKq+F7U7PAamBQRQlW2hOHOvnmEEy07WNrnj2f2Shxq9y7Xjo/Y7+bgJ54aeZJ0E6MD1PlYZTqc2/B0YEE+0MT8jeMT1VfNvrqsvQLJT8Q7cD84FOHTokYF9Kkjt323jtKgNzLQBerWoTYbZBxAmTJm79N0oPNjrL7xPCiQpXPY9Uoo9IDonDaSzgQiX7GNJt4fE/mpGg2hFs7dp/S0GOHrQN6wPGAksSepE+DJbdycUXnPl7xn0Numz7+h6i6nU1w==
mail-alias-created-date: 1621344842221
Received: from DelNac.mail.msk (unknown [17.156.192.29])
	by p00-icloudmta-asmtp-us-west-1a-20-percent-1 (Postfix) with ESMTPSA id 5A85018001A9;
	Tue, 17 Nov 2026 11:53:42 +0000 (UTC)
From: Vladimir Vdovin <deliran@verdict.gg>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Aaron Conole <aconole@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Ilya Maximets <i.maximets@ovn.org>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dev@openvswitch.org,
	linux-hardening@vger.kernel.org,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Vladimir Vdovin <deliran@verdict.gg>
Subject: [PATCH nf-next v1 1/5] netfilter: nf_conncount: bound the gc walk by examined entries
Date: Tue, 17 Nov 2026 14:53:04 +0300
Message-ID: <20261117115308.95134-2-deliran@verdict.gg>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261117115308.95134-1-deliran@verdict.gg>
References: <20261117115308.95134-1-deliran@verdict.gg>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=f+5FxeyM c=1 sm=1 tr=0 ts=6afc404c
 cx=c_apl:c_pps:t_out a=aW9mcIavGNWWFvFFKOxBSA==:117
 a=aW9mcIavGNWWFvFFKOxBSA==:17 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Y_NIGFiZ6U2ltCn7DMEA:9
X-Proofpoint-GUID: GtEXESwVMOMfDuoaNcvlo_Mwg5R3km_b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDA0NyBTYWx0ZWRfX9jbzQhTkSopV
 joqfBH+Iccnu9qLjdSnp7AZeIdrf+EBRr2cNR45fxlRWxJI98g2N/iw8cdiqNDIiOEZd8bPrc0u
 pS97uyh804O+lbBvE/IcSVYavEbOMH8S3mEFy/WRvvN1GLMxt4v4PTmRq6KneHILEw3dAIlPR9D
 dZ9rpWbvJYfWeO7toJBXLn1GRj36Xxu6NEcBt98DGtdZm0f5xhBgS2VOEH2wiQ0667yXtJwUTk4
 IxNv8/7N6ogVT8pzv+0dC1btjBo23ZuYCa5+WzYFEgeA6T3UjtkkJa0W/n07DzwKfEHX4mBw5s1
 9ZjLe1mp2/MnRtHGtV1/pAgUY5WD3vhj/9LjIydpTlXJEPpsTS80E93U8uYBQI=
X-Proofpoint-ORIG-GUID: GtEXESwVMOMfDuoaNcvlo_Mwg5R3km_b
X-JNJ: AAAAAAABlLv8BcWSW2AxynIy4vyDYETJcqdS45kX6kSxavv5zhuw1qMawmYTkRDjKNr50F
 pJHyH2MXj8LiyV1b/x8UxqOgxW9WhlBKR4YGET/plPR5zLuxqCR4LVbE1Ft425oNGtYMK5
 2PtLX+7n9T/HVZh1qB6nn5+8hGE/hEnJ5o4ww5QnMK+vA2Ix0ulEDIEqIzS5jiBHBtlloc
 cVRhoOj9IaQShFgftrHy36l+44AT7mx7WsjRfxLOJehlSgxKwQhuisAP349M9xfQsI+jFL
 Nlb1bxv5G+9tKgmUREZyyUaZbfrAH1kZYu7+7UZjfmWZW6EWRWO74yvtPZ/VibbfU52wc9
 kIAUwk99XrQM+FM3EVNxsf+UjxEqnkGLH4wYLoUDLaNbfUvSNM/yNSI/dQtWDXWblYRGo/
 uW4MAkUfFizMgZ2wQ3P4B98wJ6ILBovlU/UFMCChMFjJoqhi75hwwc9UuBHhNOrHQZe0Pe
 IU9H6sM5PBHStldDqxr3TtcbNyAx/5QU3GaU6yW9hZJqDzpVhi5uVqib5P7CDmUA8wqhmF
 COQWq4khsBvAnXrQjRUwMAxHWjS9RUIHokoWbq7u9ZDoxmZcl7kme/RjXY3wfyG8vCWgNf
 YI9Z+izoMF+BLT81OIB1wuyj+VtQOuwJWi8BHH51/ZNttRudQ1pMFlNwSaS9bzj3toWk/D
 d47NgU9umL3y6cXuDfoLnlM1S+zB7huuIaY+G8E7o4g/+vvwpvjGwvHkIjxwTpFyxxSVPk
 nPNq384a8fTMHBLFN5gvuo8v2ih1hjeAEYwtBHP7Xg7uSE0+K+3f24hrAz71WNFsMmZp8L
 bB76PDI2s0qAaHhaianBgE4DKTEA5UL98NBBYoszKgnYRS/IdeLdNiWMxfnn5fN8UL3lu7
 fIE0Nm7VqeUn9wqPcKxVD9jFPfRuRvebzm17bz65l9yRQTygSQJI3pIjIUAJtwkNR6tQZX
 M9Uh

The gc walk in __nf_conncount_add() and __nf_conncount_gc_list() stops
once CONNCOUNT_GC_MAX_COLLECT entries have been evicted, but nothing
bounds how many entries it examines to get there. Live entries and
entries another cpu is still adding (-EAGAIN) do not count, so on a
list made of such entries every pass walks the whole list, one
conntrack hash lookup per entry, under list_lock with BH disabled.

Stop a pass after CONNCOUNT_GC_MAX_SCAN examined entries and rotate
the list so that the next pass resumes where this one stopped.
Successive passes still cover the whole list, so stale entries are
reclaimed as before, spread over several passes instead of one.

The walk done for an already confirmed conntrack looks for a
duplicate, which can be anywhere in the list, so it stays unbounded.

Signed-off-by: Vladimir Vdovin <deliran@verdict.gg>
---
 net/netfilter/nf_conncount.c | 34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index eca7a8d330ce..84290e363245 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -36,6 +36,8 @@
 
 #define CONNCOUNT_GC_MAX_NODES		8
 #define CONNCOUNT_GC_MAX_COLLECT	64
+/* Upper bound on the number of entries examined by one gc pass. */
+#define CONNCOUNT_GC_MAX_SCAN		(CONNCOUNT_GC_MAX_COLLECT * 2)
 #define MAX_KEYLEN			5
 
 /* we will save the tuples of all connections we care about */
@@ -98,6 +100,19 @@ static void conn_free(struct nf_conncount_list *list,
 	kmem_cache_free(conncount_conn_cachep, conn);
 }
 
+/* A gc pass that stopped at @conn has examined every entry in front of it.
+ * Move those behind @conn so that the next pass resumes where this one
+ * stopped instead of rescanning the same live entries over and over.
+ */
+static void gc_resume_at(struct nf_conncount_list *list,
+			 struct nf_conncount_tuple *conn)
+{
+	lockdep_assert_held(&list->list_lock);
+
+	if (&conn->node != &list->head)
+		list_rotate_to_front(&conn->node, &list->head);
+}
+
 static const struct nf_conntrack_tuple_hash *
 find_or_evict(struct net *net, struct nf_conncount_list *list,
 	      struct nf_conncount_tuple *conn)
@@ -176,8 +191,10 @@ static int __nf_conncount_add(struct net *net,
 	struct nf_conncount_tuple *conn, *conn_n;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct = NULL;
+	unsigned int max_scan = CONNCOUNT_GC_MAX_SCAN;
 	struct nf_conn *found_ct;
 	unsigned int collect = 0;
+	unsigned int scanned = 0;
 	bool refcounted = false;
 	int err = 0;
 
@@ -195,6 +212,10 @@ static int __nf_conncount_add(struct net *net,
 			goto out_put;
 		}
 
+		/* The entry for this connection can be anywhere in the list,
+		 * so deduplication needs a full walk.
+		 */
+		max_scan = UINT_MAX;
 		goto check_connections;
 	}
 
@@ -205,8 +226,9 @@ static int __nf_conncount_add(struct net *net,
 check_connections:
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
-		if (collect > CONNCOUNT_GC_MAX_COLLECT)
+		if (collect > CONNCOUNT_GC_MAX_COLLECT || scanned >= max_scan)
 			break;
+		scanned++;
 
 		found = find_or_evict(net, list, conn);
 		if (IS_ERR(found)) {
@@ -247,6 +269,7 @@ static int __nf_conncount_add(struct net *net,
 
 		nf_ct_put(found_ct);
 	}
+	gc_resume_at(list, conn);
 	list->last_gc = (u32)jiffies;
 	list->last_gc_count = list->count;
 
@@ -310,6 +333,7 @@ static bool __nf_conncount_gc_list(struct net *net,
 	struct nf_conncount_tuple *conn, *conn_n;
 	struct nf_conn *found_ct;
 	unsigned int collected = 0;
+	unsigned int scanned = 0;
 	bool ret = false;
 
 	/* don't bother if we just did GC */
@@ -317,6 +341,11 @@ static bool __nf_conncount_gc_list(struct net *net,
 		return false;
 
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
+		if (collected > CONNCOUNT_GC_MAX_COLLECT ||
+		    scanned >= CONNCOUNT_GC_MAX_SCAN)
+			break;
+		scanned++;
+
 		found = find_or_evict(net, list, conn);
 		if (IS_ERR(found)) {
 			if (PTR_ERR(found) == -ENOENT)
@@ -337,9 +366,8 @@ static bool __nf_conncount_gc_list(struct net *net,
 		}
 
 		nf_ct_put(found_ct);
-		if (collected > CONNCOUNT_GC_MAX_COLLECT)
-			break;
 	}
+	gc_resume_at(list, conn);
 
 	if (!list->count)
 		ret = true;
-- 
2.56.0

