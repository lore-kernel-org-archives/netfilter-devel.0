From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Thu, 06 Apr 2006 13:02:18 +0200
Message-ID: <4434F53A.2030302@trash.net>
References: <Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>	<43F43FA9.4000906@trash.net>	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>	<43F4426D.9060807@trash.net>	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>	<43F4DBDF.9010008@trash.net>
	<442B9765.2020105@ufomechanic.net>	<442C81A6.3040501@trash.net>	<Pine.LNX.4.58.0603312026030.9154@blackhole.kfki.hu>	<442D78A8.4050300@trash.net>
	<20060401193138.GG11031@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060304050803030906090405"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060401193138.GG11031@sunbeam.de.gnumonks.org>
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
--------------060304050803030906090405
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
> So if there's now a majority of people who want to delete the ID: Go for
> it :)

Found the patch again. What it does is:

- note entry of next conntrack to be dumped and keep a reference to it
- when continuing, look for the conntrack and continue at it if its
  still there
- if not, dump the entire bucket again

In theory we could end up in an endless loop if the conntrack entry
we're keeping the reference to is deleted everytime we want to
continue dumping. It shouldn't be triggerable intentionally because
of the jenkins hash though. If there are no objections I'll port
it to nf_conntrack_netlink and submit it.


--------------060304050803030906090405
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index e0b5926..5a1769d 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -387,38 +387,52 @@ nfattr_failure:
 static int ctnetlink_done(struct netlink_callback *cb)
 {
 	DEBUGP("entered %s\n", __FUNCTION__);
+	if (cb->args[1])
+		ip_conntrack_put(cb->args[1]);
 	return 0;
 }
 
 static int
 ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct ip_conntrack *ct = NULL;
+	struct ip_conntrack *ct;
 	struct ip_conntrack_tuple_hash *h;
 	struct list_head *i;
-	u_int32_t *id = (u_int32_t *) &cb->args[1];
 
 	DEBUGP("entered %s, last bucket=%lu id=%u\n", __FUNCTION__, 
 			cb->args[0], *id);
 
 	read_lock_bh(&ip_conntrack_lock);
-	for (; cb->args[0] < ip_conntrack_htable_size; cb->args[0]++, *id = 0) {
+	for (; cb->args[0] < ip_conntrack_htable_size; cb->args[0]++) {
+restart:
 		list_for_each_prev(i, &ip_conntrack_hash[cb->args[0]]) {
 			h = (struct ip_conntrack_tuple_hash *) i;
 			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
 				continue;
 			ct = tuplehash_to_ctrack(h);
-			if (ct->id <= *id)
-				continue;
+			if (cb->args[1]) {
+				if (ct == cb->args[1]) {
+					ip_conntrack_put(cb->args[1]);
+					cb->args[1] = NULL;
+				} else
+					continue;
+			}
 			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
 		                        	cb->nlh->nlmsg_seq,
 						IPCTNL_MSG_CT_NEW,
-						1, ct) < 0)
+						1, ct) < 0) {
+				nf_conntrack_get(&ct->ct_general);
+				cb->args[1] = ct;
 				goto out;
-			*id = ct->id;
+			}
+		}
+		if (cb->args[1]) {
+			ip_conntrack_put(cb->args[1]);
+			cb->args[1] = NULL;
+			goto restart;
 		}
 	}
-out:	
+out:
 	read_unlock_bh(&ip_conntrack_lock);
 
 	DEBUGP("leaving, last bucket=%lu id=%u\n", cb->args[0], *id);

--------------060304050803030906090405--
