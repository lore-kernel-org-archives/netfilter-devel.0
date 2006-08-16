From: Patrick McHardy <kaber@trash.net>
Subject: Re: possible Bug in ip_conntrack
Date: Wed, 16 Aug 2006 13:31:06 +0200
Message-ID: <44E301FA.9020608@trash.net>
References: <1155545885.44e03b1dcec01@www.domainfactory-webmail.de>
	<44E0719C.9050307@trash.net>
	<1155630570.44e185ea45986@www.domainfactory-webmail.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070506090807030504050604"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maik Hentsche <netfilter@mm-double.de>
In-Reply-To: <1155630570.44e185ea45986@www.domainfactory-webmail.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070506090807030504050604
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Maik Hentsche wrote:
> Zitat von Patrick McHardy <kaber@trash.net>:
> 
> 
>>Can you test current -git please? We had some changes in that area ..
>>I don't recall any explicit bugfixes, but who knows ..
> 
> 
> Unfortunatelly, it still occurs with -git.

Can you try this patch please? It should fix the problem.


--------------070506090807030504050604
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: ctnetlink: fix deadlock in table dumping

ip_conntrack_put must not be called while holding ip_conntrack_lock
since destroy_conntrack takes it again.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8ebd6bb0f469f2759f39e73adee6916a3d975393
tree ebd73ee261508d483654416b03610910a2968e21
parent 338fe5c67e8fb799c9e3470331db6f3c60a31b1e
author Patrick McHardy <kaber@trash.net> Wed, 16 Aug 2006 13:32:27 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 16 Aug 2006 13:32:27 +0200

 net/ipv4/netfilter/ip_conntrack_netlink.c |   17 +++++++----------
 net/netfilter/nf_conntrack_netlink.c      |   17 +++++++----------
 2 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 33891bb..0d4cc92 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -415,21 +415,18 @@ ctnetlink_dump_table(struct sk_buff *skb
 			cb->args[0], *id);
 
 	read_lock_bh(&ip_conntrack_lock);
+	last = (struct ip_conntrack *)cb->args[1];
 	for (; cb->args[0] < ip_conntrack_htable_size; cb->args[0]++) {
 restart:
-		last = (struct ip_conntrack *)cb->args[1];
 		list_for_each_prev(i, &ip_conntrack_hash[cb->args[0]]) {
 			h = (struct ip_conntrack_tuple_hash *) i;
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = tuplehash_to_ctrack(h);
-			if (last != NULL) {
-				if (ct == last) {
-					ip_conntrack_put(last);
-					cb->args[1] = 0;
-					last = NULL;
-				} else
+			if (cb->args[1]) {
+				if (ct != last)
 					continue;
+				cb->args[1] = 0;
 			}
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 		                        	cb->nlh->nlmsg_seq,
@@ -440,17 +437,17 @@ restart:
 				goto out;
 			}
 		}
-		if (last != NULL) {
-			ip_conntrack_put(last);
+		if (cb->args[1]) {
 			cb->args[1] = 0;
 			goto restart;
 		}
 	}
 out:
 	read_unlock_bh(&ip_conntrack_lock);
+	if (last)
+		ip_conntrack_put(last);
 
 	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
-
 	return skb->len;
 }
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index af48459..6527d4e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -429,9 +429,9 @@ ctnetlink_dump_table(struct sk_buff *skb
 			cb->args[0], *id);
 
 	read_lock_bh(&nf_conntrack_lock);
+	last = (struct nf_conn *)cb->args[1];
 	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
 restart:
-		last = (struct nf_conn *)cb->args[1];
 		list_for_each_prev(i, &nf_conntrack_hash[cb->args[0]]) {
 			h = (struct nf_conntrack_tuple_hash *) i;
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
@@ -442,13 +442,10 @@ restart:
 			 * then dump everything. */
 			if (l3proto && L3PROTO(ct) != l3proto)
 				continue;
-			if (last != NULL) {
-				if (ct == last) {
-					nf_ct_put(last);
-					cb->args[1] = 0;
-					last = NULL;
-				} else
+			if (cb->args[1]) {
+				if (ct != last)
 					continue;
+				cb->args[1] = 0;
 			}
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 		                        	cb->nlh->nlmsg_seq,
@@ -459,17 +456,17 @@ restart:
 				goto out;
 			}
 		}
-		if (last != NULL) {
-			nf_ct_put(last);
+		if (cb->args[1]) {
 			cb->args[1] = 0;
 			goto restart;
 		}
 	}
 out:
 	read_unlock_bh(&nf_conntrack_lock);
+	if (last)
+		nf_ct_put(last);
 
 	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);
-
 	return skb->len;
 }
 

--------------070506090807030504050604--
