From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Mon, 05 Dec 2005 02:10:03 +0900 (JST)
Message-ID: <200512041710.jB4HA40F021665@toshiba.co.jp>
References: <43627A8F.9060307@eurodev.net> <436281BB.2010100@fliegl.de>
	<4392510A.3030400@eurodev.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Dec__5_02_10_03_2005_682)--"
Content-Transfer-Encoding: 7bit
Cc: deti@fliegl.de, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	romary@nikoon.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <4392510A.3030400@eurodev.net>
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

----Next_Part(Mon_Dec__5_02_10_03_2005_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

From: Pablo Neira Ayuso <pablo@eurodev.net>
Date: Sun, 04 Dec 2005 03:14:34 +0100

> Hi Patrick,
> 
> Deti Fliegl wrote:
> > The kernel oops still happens - but this time I had access to the
> > console (hope that helps):
> > 
> > <4>Badness in __kfree_skb at net/core/skbuff.c:330
> > <4>
> > <4>Call Trace:<ffffffff802a2f77>{__kfree_skb+167}
> > <ffffffff802bb597>{netlink_recvmsg+279}
> > <4>       <ffffffff8029cb2b>{sock_recvmsg+315}
> > <ffffffff8025a4d8>{n_tty_receive_buf+4392}
> > <4>       <ffffffff8025a4d8>{n_tty_receive_buf+4392}
> > <ffffffff8015d828>{filemap_nopage+424}
> > <4>       <ffffffff8013003b>{try_to_wake_up+1083}
> > <ffffffff8014b2f0>{autoremove_wake_function+0}
> > <4>       <ffffffff8025bbd9>{pty_write+89}
> > <ffffffff8029e38b>{sys_recvmsg+395}
> > <4>       <ffffffff80130f23>{__wake_up+67}
> > <ffffffff80181208>{vfs_write+344}
> > <4>       <ffffffff80181343>{sys_write+83}
> > <ffffffff8010dc4e>{system_call+126}
> > <4>
> > <3>scheduling while atomic: conntrack/0xffffff00/7887

I'm reading some codes around preempt/spinlock and 0xffffff00 seems to mean
local_bh_enable() without local_bh_disable(). But I've not found such bug yet.

> Romary Sonrier is reporting a similar problem on a i586 box:
> 
> https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=409
> 
> I can't see a way how the ctnetlink code can trigger that oops at moment
> :(. Any clue on this?

Deti, Romary, could you try CONFIG_DEBUG_PREEMPT and CONFIG_DEBUG_SPINLOCK ?

And did you apply Pablo's patch (attached in this mail) which fixes refcount
leak ? linux 2.6.14.3 doesn't include this fix. If no, please try it.

Regards,

-- Yasuyuki Kozakai


----Next_Part(Mon_Dec__5_02_10_03_2005_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="proto_find.patch"

Remove proto == NULL checking since ip_conntrack_[nat_]proto_find_get always
returns a valid pointer. Fix missing ip_conntrack_proto_put in some paths.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-21 15:00:28.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-21 15:03:49.000000000 +0100
@@ -59,11 +59,13 @@ ctnetlink_dump_tuples_proto(struct sk_bu
 
 	NFA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
 
+	/* If no protocol helper is found, this function will return the
+	 * generic protocol helper, so proto won't *ever* be NULL */
 	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
-	if (likely(proto && proto->tuple_to_nfattr)) {
+	if (likely(proto->tuple_to_nfattr))
 		ret = proto->tuple_to_nfattr(skb, tuple);
-		ip_conntrack_proto_put(proto);
-	}
+	
+	ip_conntrack_proto_put(proto);
 
 	return ret;
 
@@ -128,9 +130,11 @@ ctnetlink_dump_protoinfo(struct sk_buff 
 
 	struct nfattr *nest_proto;
 	int ret;
-	
-	if (!proto || !proto->to_nfattr)
+
+	if (!proto->to_nfattr) {
+		ip_conntrack_proto_put(proto);
 		return 0;
+	}
 	
 	nest_proto = NFA_NEST(skb, CTA_PROTOINFO);
 
@@ -527,10 +531,10 @@ ctnetlink_parse_tuple_proto(struct nfatt
 
 	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
 
-	if (likely(proto && proto->nfattr_to_tuple)) {
+	if (likely(proto->nfattr_to_tuple))
 		ret = proto->nfattr_to_tuple(tb, tuple);
-		ip_conntrack_proto_put(proto);
-	}
+	
+	ip_conntrack_proto_put(proto);
 	
 	return ret;
 }
@@ -596,8 +600,6 @@ static int ctnetlink_parse_nat_proto(str
 		return -EINVAL;
 
 	npt = ip_nat_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
-	if (!npt)
-		return 0;
 
 	if (!npt->nfattr_to_range) {
 		ip_nat_proto_put(npt);
@@ -957,8 +959,6 @@ ctnetlink_change_protoinfo(struct ip_con
 	nfattr_parse_nested(tb, CTA_PROTOINFO_MAX, attr);
 
 	proto = ip_conntrack_proto_find_get(npt);
-	if (!proto)
-		return -EINVAL;
 
 	if (proto->from_nfattr)
 		err = proto->from_nfattr(tb, ct);

----Next_Part(Mon_Dec__5_02_10_03_2005_682)----
