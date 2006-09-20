From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/39]: xt_conntrack: clean up overly long lines
Date: Wed, 20 Sep 2006 10:23:55 +0200 (MEST)
Message-ID: <20060920082446.14636.86678.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_conntrack: clean up overly long lines

Also fix some whitespace errors and use the NAT bits instead of deriving
the state manually.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9e49956af011aa3825b17ab6edd18a9eafa19bc2
tree 55415a6fa0ce4faa16296e2a1dbf2dcafdf3503b
parent 02f2210c487d5c2c48fb2b30d15d6dec688e1152
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:27:54 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:27:54 +0200

 net/netfilter/xt_conntrack.c |  179 +++++++++++++++++++++++-------------------
 1 files changed, 98 insertions(+), 81 deletions(-)

diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 39c57e9..0ea501a 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -45,7 +45,7 @@ match(const struct sk_buff *skb,
 
 	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
 
-#define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
+#define FWINV(bool, invflg) ((bool) ^ !!(sinfo->invflags & invflg))
 
 	if (ct == &ip_conntrack_untracked)
 		statebit = XT_CONNTRACK_STATE_UNTRACKED;
@@ -54,63 +54,72 @@ #define FWINV(bool,invflg) ((bool) ^ !!(
  	else
  		statebit = XT_CONNTRACK_STATE_INVALID;
  
-	if(sinfo->flags & XT_CONNTRACK_STATE) {
+	if (sinfo->flags & XT_CONNTRACK_STATE) {
 		if (ct) {
-			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip !=
-			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip)
+			if (test_bit(IPS_SRC_NAT_BIT, &ct->status))
 				statebit |= XT_CONNTRACK_STATE_SNAT;
-
-			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip !=
-			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip)
+			if (test_bit(IPS_DST_NAT_BIT, &ct->status))
 				statebit |= XT_CONNTRACK_STATE_DNAT;
 		}
-
-		if (FWINV((statebit & sinfo->statemask) == 0, XT_CONNTRACK_STATE))
+		if (FWINV((statebit & sinfo->statemask) == 0,
+			  XT_CONNTRACK_STATE))
 			return 0;
 	}
 
-	if(sinfo->flags & XT_CONNTRACK_PROTO) {
-		if (!ct || FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum, XT_CONNTRACK_PROTO))
-                	return 0;
-	}
-
-	if(sinfo->flags & XT_CONNTRACK_ORIGSRC) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip&sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip, XT_CONNTRACK_ORIGSRC))
+	if (ct == NULL) {
+		if (sinfo->flags & ~XT_CONNTRACK_STATE)
 			return 0;
+		return 1;
 	}
 
-	if(sinfo->flags & XT_CONNTRACK_ORIGDST) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip&sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip, XT_CONNTRACK_ORIGDST))
-			return 0;
-	}
-
-	if(sinfo->flags & XT_CONNTRACK_REPLSRC) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip&sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].src.ip, XT_CONNTRACK_REPLSRC))
-			return 0;
-	}
+	if (sinfo->flags & XT_CONNTRACK_PROTO &&
+	    FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum !=
+		  sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum,
+		  XT_CONNTRACK_PROTO))
+                return 0;
+
+	if (sinfo->flags & XT_CONNTRACK_ORIGSRC &&
+	    FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip &
+		   sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) !=
+		  sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip,
+		  XT_CONNTRACK_ORIGSRC))
+		return 0;
 
-	if(sinfo->flags & XT_CONNTRACK_REPLDST) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip&sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].dst.ip, XT_CONNTRACK_REPLDST))
-			return 0;
-	}
+	if (sinfo->flags & XT_CONNTRACK_ORIGDST &&
+	    FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip &
+		   sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) !=
+		  sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip,
+		  XT_CONNTRACK_ORIGDST))
+		return 0;
 
-	if(sinfo->flags & XT_CONNTRACK_STATUS) {
-		if (!ct || FWINV((ct->status & sinfo->statusmask) == 0, XT_CONNTRACK_STATUS))
-			return 0;
-	}
+	if (sinfo->flags & XT_CONNTRACK_REPLSRC &&
+	    FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip &
+		   sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) !=
+		  sinfo->tuple[IP_CT_DIR_REPLY].src.ip,
+		  XT_CONNTRACK_REPLSRC))
+		return 0;
 
-	if(sinfo->flags & XT_CONNTRACK_EXPIRES) {
-		unsigned long expires;
+	if (sinfo->flags & XT_CONNTRACK_REPLDST &&
+	    FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip &
+		   sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) !=
+		  sinfo->tuple[IP_CT_DIR_REPLY].dst.ip,
+		  XT_CONNTRACK_REPLDST))
+		return 0;
 
-		if(!ct)
-			return 0;
+	if (sinfo->flags & XT_CONNTRACK_STATUS &&
+	    FWINV((ct->status & sinfo->statusmask) == 0,
+		  XT_CONNTRACK_STATUS))
+		return 0;
 
-		expires = timer_pending(&ct->timeout) ? (ct->timeout.expires - jiffies)/HZ : 0;
+	if (sinfo->flags & XT_CONNTRACK_EXPIRES) {
+		unsigned long expires = timer_pending(&ct->timeout) ?
+					(ct->timeout.expires - jiffies)/HZ : 0;
 
-		if (FWINV(!(expires >= sinfo->expires_min && expires <= sinfo->expires_max), XT_CONNTRACK_EXPIRES))
+		if (FWINV(!(expires >= sinfo->expires_min &&
+			    expires <= sinfo->expires_max),
+			  XT_CONNTRACK_EXPIRES))
 			return 0;
 	}
-
 	return 1;
 }
 
@@ -141,63 +150,72 @@ #define FWINV(bool,invflg) ((bool) ^ !!(
  	else
  		statebit = XT_CONNTRACK_STATE_INVALID;
  
-	if(sinfo->flags & XT_CONNTRACK_STATE) {
+	if (sinfo->flags & XT_CONNTRACK_STATE) {
 		if (ct) {
-			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip !=
-			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip)
+			if (test_bit(IPS_SRC_NAT_BIT, &ct->status))
 				statebit |= XT_CONNTRACK_STATE_SNAT;
-
-			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip !=
-			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip)
+			if (test_bit(IPS_DST_NAT_BIT, &ct->status))
 				statebit |= XT_CONNTRACK_STATE_DNAT;
 		}
-
-		if (FWINV((statebit & sinfo->statemask) == 0, XT_CONNTRACK_STATE))
+		if (FWINV((statebit & sinfo->statemask) == 0,
+			  XT_CONNTRACK_STATE))
 			return 0;
 	}
 
-	if(sinfo->flags & XT_CONNTRACK_PROTO) {
-		if (!ct || FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum, XT_CONNTRACK_PROTO))
-                	return 0;
-	}
-
-	if(sinfo->flags & XT_CONNTRACK_ORIGSRC) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip&sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip, XT_CONNTRACK_ORIGSRC))
+	if (ct == NULL) {
+		if (sinfo->flags & ~XT_CONNTRACK_STATE)
 			return 0;
+		return 1;
 	}
 
-	if(sinfo->flags & XT_CONNTRACK_ORIGDST) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip&sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip, XT_CONNTRACK_ORIGDST))
-			return 0;
-	}
-
-	if(sinfo->flags & XT_CONNTRACK_REPLSRC) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip&sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].src.ip, XT_CONNTRACK_REPLSRC))
-			return 0;
-	}
+	if (sinfo->flags & XT_CONNTRACK_PROTO &&
+	    FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum !=
+	    	  sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum,
+		  XT_CONNTRACK_PROTO))
+                return 0;
+
+	if (sinfo->flags & XT_CONNTRACK_ORIGSRC &&
+	    FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip &
+	    	   sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) !=
+		  sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip,
+		  XT_CONNTRACK_ORIGSRC))
+		return 0;
 
-	if(sinfo->flags & XT_CONNTRACK_REPLDST) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip&sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].dst.ip, XT_CONNTRACK_REPLDST))
-			return 0;
-	}
+	if (sinfo->flags & XT_CONNTRACK_ORIGDST &&
+	    FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip &
+	    	   sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) !=
+		  sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip,
+		  XT_CONNTRACK_ORIGDST))
+		return 0;
 
-	if(sinfo->flags & XT_CONNTRACK_STATUS) {
-		if (!ct || FWINV((ct->status & sinfo->statusmask) == 0, XT_CONNTRACK_STATUS))
-			return 0;
-	}
+	if (sinfo->flags & XT_CONNTRACK_REPLSRC &&
+	    FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip &
+	    	   sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) !=
+		  sinfo->tuple[IP_CT_DIR_REPLY].src.ip,
+		  XT_CONNTRACK_REPLSRC))
+		return 0;
 
-	if(sinfo->flags & XT_CONNTRACK_EXPIRES) {
-		unsigned long expires;
+	if (sinfo->flags & XT_CONNTRACK_REPLDST &&
+	    FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip &
+	    	   sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) !=
+		  sinfo->tuple[IP_CT_DIR_REPLY].dst.ip,
+		  XT_CONNTRACK_REPLDST))
+		return 0;
 
-		if(!ct)
-			return 0;
+	if (sinfo->flags & XT_CONNTRACK_STATUS &&
+	    FWINV((ct->status & sinfo->statusmask) == 0,
+	    	  XT_CONNTRACK_STATUS))
+		return 0;
 
-		expires = timer_pending(&ct->timeout) ? (ct->timeout.expires - jiffies)/HZ : 0;
+	if(sinfo->flags & XT_CONNTRACK_EXPIRES) {
+		unsigned long expires = timer_pending(&ct->timeout) ?
+					(ct->timeout.expires - jiffies)/HZ : 0;
 
-		if (FWINV(!(expires >= sinfo->expires_min && expires <= sinfo->expires_max), XT_CONNTRACK_EXPIRES))
+		if (FWINV(!(expires >= sinfo->expires_min &&
+			    expires <= sinfo->expires_max),
+			  XT_CONNTRACK_EXPIRES))
 			return 0;
 	}
-
 	return 1;
 }
 
@@ -220,8 +238,7 @@ #endif
 	return 1;
 }
 
-static void
-destroy(const struct xt_match *match, void *matchinfo)
+static void destroy(const struct xt_match *match, void *matchinfo)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_ct_l3proto_module_put(match->family);
