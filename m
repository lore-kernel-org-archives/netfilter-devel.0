From: Pablo Neira <pablo@eurodev.net>
Subject: Re: patch for conntrack expectations
Date: Sun, 22 Feb 2004 14:40:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4038B14C.901@eurodev.net>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net> <20040218172539.GX9464@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070604030502040208030105"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <20040218172539.GX9464@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070604030502040208030105
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald and list!

I finished my patch to add an ip_conntrack_expect_alloc(...) function. I 
also patched all the current conntrack helpers available in the stable 
branch and patch-o-matic-ng.

Some considerations:

- I tested the irc, tftp and ftp helpers, they work fine for me. I 
haven't tested the others since I don't have access to all those 
protocols (I mean, I would need more time to install some programs and 
do some testing), but I have no problem about fixing problems related to 
those patches.

- I saw that Patrick submitted recently a patch to clean up the amanda 
helper (BTW, nice work!), I tried to patch my kernel with his patch 
available in patch-o-matic but it failed. So I patched the current. I 
also have no problem about patching the new one.

BTW, I know that there's a skeleton of a helper in the documention, due 
to they mostly look the same but I think that I could add it more details.

- There's a memset in expect_alloc (see expect.patch) after the 
allocation is done, I don't like it anyway but I just added to keep 
backward compatibility because some helper usually do it. I think that 
it's better setting all the fields of the new expectation in the helper 
(this implies being a bit more restrictive with the programmer but well, 
this is kernel programming anyway, it's restrictive :-)).

I could delete that memset and have a look at all the helpers to make 
sure that all the fields are correctly set.

- I didn't exported the expect_insert function, but you could do it 
later to use it in the ct_sync code.

- I found a condition where expect_related could succesfully insert an 
expectaction when removing an old one and return EPERM (see 
expect_related-newnat14.patch). I think that this doesn't make sense. Am 
I forgetting something? That patch fix that problem.

- I also have no problem about updating the documentation to add info 
about expect_alloc.

cheers,
Pablo

--------------070604030502040208030105
Content-Type: text/plain;
 name="expect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="expect.patch"

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-22 13:29:30.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-22 13:29:12.000000000 +0100
@@ -917,11 +917,53 @@
 	WRITE_UNLOCK(&ip_conntrack_lock);
 }
 
+int
+ip_conntrack_expect_alloc(struct ip_conntrack_expect **new)
+{
+        *new = (struct ip_conntrack_expect *)
+              kmalloc(sizeof(struct ip_conntrack_expect), GFP_ATOMIC);
+        if (!*new) {
+                DEBUGP("expect_related: OOM allocating expect\n");
+                return -ENOMEM;
+        }
+
+	/* is this important? */
+	memset(*new, 0, sizeof(struct ip_conntrack_expect));
+
+        return 1;
+}
+
+void
+ip_conntrack_expect_insert(struct ip_conntrack_expect *new,
+               struct ip_conntrack *related_to)
+{
+       DEBUGP("new expectation %p of conntrack %p\n", new, related_to);
+       new->expectant = related_to;
+       new->sibling = NULL;
+       atomic_set(&new->use, 1);
+
+       /* add to expected list for this connection */
+       list_add(&new->expected_list, &related_to->sibling_list);
+       /* add to global list of expectations */
+
+       list_prepend(&ip_conntrack_expect_list, &new->list);
+       /* add and start timer if required */
+       if (related_to->helper->timeout) {
+               init_timer(&new->timeout);
+               new->timeout.data = (unsigned long)new;
+               new->timeout.function = expectation_timed_out;
+               new->timeout.expires = jiffies +
+                                       related_to->helper->timeout * HZ;
+               add_timer(&new->timeout);
+       }
+       related_to->expecting++;
+}
+
 /* Add a related connection. */
 int ip_conntrack_expect_related(struct ip_conntrack *related_to,
 				struct ip_conntrack_expect *expect)
 {
-	struct ip_conntrack_expect *old, *new;
+	struct ip_conntrack_expect *old;
 	int ret = 0;
 
 	WRITE_LOCK(&ip_conntrack_lock);
@@ -953,6 +995,7 @@
 
 		if (old) {
 			WRITE_UNLOCK(&ip_conntrack_lock);
+			kfree(expect);
 			return -EEXIST;
 		}
 	} else if (related_to->helper->max_expected && 
@@ -971,6 +1014,7 @@
 				       related_to->helper->name,
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
+			kfree(expect);
 			return -EPERM;
 		}
 		DEBUGP("ip_conntrack: max number of expected "
@@ -1004,43 +1048,17 @@
 		 * related_to->expecting. 
 		 */
 		unexpect_related(old);
-		ret = -EPERM;
 	} else if (LIST_FIND(&ip_conntrack_expect_list, expect_clash,
 			     struct ip_conntrack_expect *, &expect->tuple, 
 			     &expect->mask)) {
 		WRITE_UNLOCK(&ip_conntrack_lock);
 		DEBUGP("expect_related: busy!\n");
+
+		kfree(expect);
 		return -EBUSY;
 	}
-	
-	new = (struct ip_conntrack_expect *) 
-	      kmalloc(sizeof(struct ip_conntrack_expect), GFP_ATOMIC);
-	if (!new) {
-		WRITE_UNLOCK(&ip_conntrack_lock);
-		DEBUGP("expect_relaed: OOM allocating expect\n");
-		return -ENOMEM;
-	}
-	
-	DEBUGP("new expectation %p of conntrack %p\n", new, related_to);
-	memcpy(new, expect, sizeof(*expect));
-	new->expectant = related_to;
-	new->sibling = NULL;
-	atomic_set(&new->use, 1);
-	
-	/* add to expected list for this connection */	
-	list_add(&new->expected_list, &related_to->sibling_list);
-	/* add to global list of expectations */
-	list_prepend(&ip_conntrack_expect_list, &new->list);
-	/* add and start timer if required */
-	if (related_to->helper->timeout) {
-		init_timer(&new->timeout);
-		new->timeout.data = (unsigned long)new;
-		new->timeout.function = expectation_timed_out;
-		new->timeout.expires = jiffies + 
-					related_to->helper->timeout * HZ;
-		add_timer(&new->timeout);
-	}
-	related_to->expecting++;
+
+	ip_conntrack_expect_insert(expect, related_to);
 
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.6.3/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-18 04:57:46.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-22 12:50:49.000000000 +0100
@@ -497,6 +497,7 @@
 EXPORT_SYMBOL(ip_ct_find_proto);
 EXPORT_SYMBOL(__ip_ct_find_proto);
 EXPORT_SYMBOL(ip_ct_find_helper);
+EXPORT_SYMBOL_GPL(ip_conntrack_expect_alloc);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
 EXPORT_SYMBOL(ip_conntrack_change_expect);
 EXPORT_SYMBOL(ip_conntrack_unexpect_related);
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-old/include/linux/netfilter_ipv4/ip_conntrack_helper.h linux-2.6.3/include/linux/netfilter_ipv4/ip_conntrack_helper.h
--- linux-2.6.3-old/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-02-18 04:57:16.000000000 +0100
+++ linux-2.6.3/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-02-22 12:52:20.000000000 +0100
@@ -35,6 +35,10 @@
 
 extern struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple);
 
+
+/* Allocate space for an expectation: this is mandatory before calling 
+   ip_conntrack_expect_related. */
+extern int ip_conntrack_expect_alloc(struct ip_conntrack_expect **new);
 /* Add an expected connection: can have more than one per connection */
 extern int ip_conntrack_expect_related(struct ip_conntrack *related_to,
 				       struct ip_conntrack_expect *exp);

--------------070604030502040208030105
Content-Type: text/plain;
 name="expect_related-newnat14.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="expect_related-newnat14.patch"

--- ip_conntrack_core.old	2004-02-22 12:43:27.000000000 +0100
+++ ip_conntrack_core.c	2004-02-22 12:44:14.000000000 +0100
@@ -1004,7 +1004,6 @@
 		 * related_to->expecting. 
 		 */
 		unexpect_related(old);
-		ret = -EPERM;
 	} else if (LIST_FIND(&ip_conntrack_expect_list, expect_clash,
 			     struct ip_conntrack_expect *, &expect->tuple, 
 			     &expect->mask)) {

--------------070604030502040208030105
Content-Type: text/plain;
 name="ip_conntrack_amanda.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_amanda.patch"

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_amanda.c linux-2.6.3/net/ipv4/netfilter/ip_conntrack_amanda.c
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-02-18 04:58:39.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-02-22 12:51:29.000000000 +0100
@@ -104,18 +104,20 @@
 		char *match = strstr(data, conns[i]);
 		if (match) {
 			char *portchr;
-			struct ip_conntrack_expect expect;
-			struct ip_ct_amanda_expect *exp_amanda_info =
-				&expect.help.exp_amanda_info;
+			struct ip_conntrack_expect *expect;
+			struct ip_ct_amanda_expect *exp_amanda_info;
 
-			memset(&expect, 0, sizeof(expect));
+			if (ip_conntrack_expect_alloc(&expect) < 0)
+				return -ENOMEM;
 
+			exp_amanda_info = &expect->help.exp_amanda_info;
+			
 			data += strlen(conns[i]);
 			/* this is not really tcp, but let's steal an
 			 * idea from a tcp stream helper :-) */
 			// XXX expect.seq = data - amanda_buffer;
 			exp_amanda_info->offset = data - amanda_buffer;
-// XXX DEBUGP("expect.seq = %p - %p = %d\n", data, amanda_buffer, expect.seq);
+// XXX DEBUGP("expect->seq = %p - %p = %d\n", data, amanda_buffer, expect->seq);
 DEBUGP("exp_amanda_info->offset = %p - %p = %d\n", data, amanda_buffer, exp_amanda_info->offset);
 			portchr = data;
 			exp_amanda_info->port = simple_strtoul(data, &data,10);
@@ -129,26 +131,26 @@
 			       "%u found\n", conns[i],
 			       exp_amanda_info->port);
 
-			expect.tuple = ((struct ip_conntrack_tuple)
+			expect->tuple = ((struct ip_conntrack_tuple)
 				{ { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
 				    { 0 } },
 				  { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip,
 				    { htons(exp_amanda_info->port) },
 				    IPPROTO_TCP }});
-			expect.mask = ((struct ip_conntrack_tuple)
+			expect->mask = ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },
 				  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
 
-			expect.expectfn = NULL;
+			expect->expectfn = NULL;
 
 			DEBUGP ("ip_conntrack_amanda_help: "
 				"expect_related: %u.%u.%u.%u:%u - "
 				"%u.%u.%u.%u:%u\n",
-				NIPQUAD(expect.tuple.src.ip),
-				ntohs(expect.tuple.src.u.tcp.port),
-				NIPQUAD(expect.tuple.dst.ip),
-				ntohs(expect.tuple.dst.u.tcp.port));
-			if (ip_conntrack_expect_related(ct, &expect)
+				NIPQUAD(expect->tuple.src.ip),
+				ntohs(expect->tuple.src.u.tcp.port),
+				NIPQUAD(expect->tuple.dst.ip),
+				ntohs(expect->tuple.dst.u.tcp.port));
+			if (ip_conntrack_expect_related(ct, expect)
 			    == -EEXIST) {
 				;
 				/* this must be a packet being resent */

--------------070604030502040208030105
Content-Type: text/plain;
 name="ip_conntrack_egg-expect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_egg-expect.patch"

--- ip_conntrack_egg.old	2004-02-22 02:24:10.000000000 +0100
+++ ip_conntrack_egg.c	2004-02-22 02:25:19.000000000 +0100
@@ -87,7 +87,7 @@
 	u_int32_t datalen = tcplen - tcph->doff * 4;
 	int dir = CTINFO2DIR(ctinfo);
 	int bytes_scanned = 0;
-	struct ip_conntrack_expect exp;
+	struct ip_conntrack_expect *exp;
 
 	u_int32_t egg_ip;
 	u_int16_t egg_port;
@@ -142,7 +142,8 @@
 			return NF_ACCEPT;
 		}
 
-		memset(&exp, 0, sizeof(exp));
+		if (ip_conntrack_expect_alloc(&exp) < 0)
+			return -ENOMEM;
 
 		if (ct->tuplehash[dir].tuple.src.ip != htonl(egg_ip)) {
 			if (net_ratelimit())
@@ -153,20 +154,20 @@
 			return NF_ACCEPT;
 		}
 
-		exp.tuple.src.ip = iph->daddr;
-		exp.tuple.src.u.tcp.port = 0;
-		exp.tuple.dst.ip = htonl(egg_ip);
-		exp.tuple.dst.u.tcp.port = htons(egg_port);
-		exp.tuple.dst.protonum = IPPROTO_TCP;
+		exp->tuple.src.ip = iph->daddr;
+		exp->tuple.src.u.tcp.port = 0;
+		exp->tuple.dst.ip = htonl(egg_ip);
+		exp->tuple.dst.u.tcp.port = htons(egg_port);
+		exp->tuple.dst.protonum = IPPROTO_TCP;
 
-		exp.mask.dst.u.tcp.port = 0xffff;
-		exp.mask.dst.protonum = 0xffff;
+		exp->mask.dst.u.tcp.port = 0xffff;
+		exp->mask.dst.protonum = 0xffff;
 
 		DEBUGP("expect_related %u.%u.%u.%u:%u - %u.%u.%u.%u:%u\n",
 			NIPQUAD(t.src.ip), ntohs(t.src.u.tcp.port),
 			NIPQUAD(t.dst.ip), ntohs(t.dst.u.tcp.port));
 
-		ip_conntrack_expect_related(ct, &exp);
+		ip_conntrack_expect_related(ct, exp);
 		break;
 	}
 	return NF_ACCEPT;

--------------070604030502040208030105
Content-Type: text/plain;
 name="ip_conntrack_ftp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_ftp.patch"

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_ftp.c linux-2.6.3/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-02-18 04:59:06.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-02-22 12:51:05.000000000 +0100
@@ -256,8 +256,8 @@
 	int dir = CTINFO2DIR(ctinfo);
 	unsigned int matchlen, matchoff;
 	struct ip_ct_ftp_master *ct_ftp_info = &ct->help.ct_ftp_info;
-	struct ip_conntrack_expect expect, *exp = &expect;
-	struct ip_ct_ftp_expect *exp_ftp_info = &exp->help.exp_ftp_info;
+	struct ip_conntrack_expect *exp;
+	struct ip_ct_ftp_expect *exp_ftp_info;
 
 	unsigned int i;
 	int found = 0;
@@ -346,8 +346,12 @@
 	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
 	       (int)matchlen, data + matchoff,
 	       matchlen, ntohl(tcph.seq) + matchoff);
-	       
-	memset(&expect, 0, sizeof(expect));
+
+	/* Allocate expectation which will be inserted */
+	if (ip_conntrack_expect_alloc(&exp) < 0)
+		return -ENOMEM;
+
+	exp_ftp_info = &exp->help.exp_ftp_info;
 
 	/* Update the ftp info */
 	if (htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3])
@@ -389,7 +393,7 @@
 	exp->expectfn = NULL;
 
 	/* Ignore failure; should only happen with NAT */
-	ip_conntrack_expect_related(ct, &expect);
+	ip_conntrack_expect_related(ct, exp);
 	ret = NF_ACCEPT;
  out:
 	UNLOCK_BH(&ip_ftp_lock);

--------------070604030502040208030105
Content-Type: text/plain;
 name="ip_conntrack_h323-expect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_h323-expect.patch"

--- ip_conntrack_h323.old	2004-02-22 02:27:17.000000000 +0100
+++ ip_conntrack_h323.c	2004-02-22 02:31:05.000000000 +0100
@@ -47,8 +47,8 @@
 	u_int32_t datalen = tcplen - tcph->doff * 4;
 	int dir = CTINFO2DIR(ctinfo);
 	struct ip_ct_h225_master *info = &ct->help.ct_h225_info;
-	struct ip_conntrack_expect expect, *exp = &expect;
-	struct ip_ct_h225_expect *exp_info = &exp->help.exp_h225_info;
+	struct ip_conntrack_expect *exp;
+	struct ip_ct_h225_expect *exp_info = NULL;
 	u_int16_t data_port;
 	u_int32_t data_ip;
 	unsigned int i;
@@ -91,7 +91,12 @@
 		data_ip = *((u_int32_t *)data);
 		if (data_ip == iph->saddr) {
 			data_port = *((u_int16_t *)(data + 4));
-			memset(&expect, 0, sizeof(expect));
+
+			if (ip_conntrack_expect_alloc(&exp) < 0)
+				return -ENOMEM;
+
+			exp_info = &exp->help.exp_h225_info;
+			
 			/* update the H.225 info */
 			DEBUGP("ct_h245_help: new RTCP/RTP requested %u.%u.%u.%u:->%u.%u.%u.%u:%u\n",
 				NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
@@ -164,8 +169,8 @@
 	u_int32_t datalen = tcplen - tcph->doff * 4;
 	int dir = CTINFO2DIR(ctinfo);
 	struct ip_ct_h225_master *info = &ct->help.ct_h225_info;
-	struct ip_conntrack_expect expect, *exp = &expect;
-	struct ip_ct_h225_expect *exp_info = &exp->help.exp_h225_info;
+	struct ip_conntrack_expect *exp;
+	struct ip_ct_h225_expect *exp_info = NULL;
 	u_int16_t data_port;
 	u_int32_t data_ip;
 	unsigned int i;
@@ -222,7 +227,10 @@
 				UNLOCK_BH(&ip_h323_lock);
 #endif
 			} else {
-				memset(&expect, 0, sizeof(expect));
+				if (ip_conntrack_expect_alloc(&exp) < 0)
+					return -ENOMEM;
+
+				exp_info = &exp->help.exp_h225_info;
 
 				/* update the H.225 info */
 				LOCK_BH(&ip_h323_lock);

--------------070604030502040208030105
Content-Type: text/plain;
 name="ip_conntrack_irc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_irc.patch"

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_irc.c linux-2.6.3/net/ipv4/netfilter/ip_conntrack_irc.c
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_irc.c	2004-02-18 04:59:06.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_irc.c	2004-02-22 12:51:19.000000000 +0100
@@ -106,8 +106,8 @@
 	struct tcphdr tcph;
 	char *data, *data_limit;
 	int dir = CTINFO2DIR(ctinfo);
-	struct ip_conntrack_expect expect, *exp = &expect;
-	struct ip_ct_irc_expect *exp_irc_info = &exp->help.exp_irc_info;
+	struct ip_conntrack_expect *exp;
+	struct ip_ct_irc_expect *exp_irc_info = NULL;
 
 	u_int32_t dcc_ip;
 	u_int16_t dcc_port;
@@ -190,8 +190,11 @@
 
 				continue;
 			}
-			
-			memset(&expect, 0, sizeof(expect));
+
+			if (ip_conntrack_expect_alloc(&exp) < 0)
+				return -ENOMEM;
+
+			exp_irc_info = &exp->help.exp_irc_info;
 
 			/* save position of address in dcc string,
 			 * necessary for NAT */
@@ -218,7 +221,7 @@
 				NIPQUAD(exp->tuple.dst.ip),
 				ntohs(exp->tuple.dst.u.tcp.port));
 
-			ip_conntrack_expect_related(ct, &expect);
+			ip_conntrack_expect_related(ct, exp);
 
 			goto out;
 		} /* for .. NUM_DCCPROTO */

--------------070604030502040208030105
Content-Type: text/plain;
 name="ip_conntrack_mms-expect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_mms-expect.patch"

--- ip_conntrack_mms.old	2004-02-22 02:32:36.000000000 +0100
+++ ip_conntrack_mms.c	2004-02-22 02:34:25.000000000 +0100
@@ -150,8 +150,8 @@
 	unsigned int tcplen = len - iph->ihl * 4;
 	unsigned int datalen = tcplen - tcph->doff * 4;
 	int dir = CTINFO2DIR(ctinfo);
-	struct ip_conntrack_expect expect, *exp = &expect; 
-	struct ip_ct_mms_expect *exp_mms_info = &exp->help.exp_mms_info;
+	struct ip_conntrack_expect *exp; 
+	struct ip_ct_mms_expect *exp_mms_info = NULL;
 	
 	u_int32_t mms_ip;
 	u_int16_t mms_proto;
@@ -207,7 +207,10 @@
 				printk(KERN_WARNING
 				       "ip_conntrack_mms: Unable to parse data payload\n");
 
-		memset(&expect, 0, sizeof(expect));
+		if (ip_conntrack_expect_alloc(&exp) < 0)
+			return -ENOMEM;
+
+		exp_mms_info = &exp->help.exp_mms_info;
 
 		sprintf(mms_proto_string, "(%u)", mms_proto);
 		DEBUGP("ip_conntrack_mms: adding %s expectation %u.%u.%u.%u -> %u.%u.%u.%u:%u\n",
@@ -243,7 +246,7 @@
 		             { { 0xFFFFFFFF, { 0 } },
 		               { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
 		exp->expectfn = NULL;
-		ip_conntrack_expect_related(ct, &expect);
+		ip_conntrack_expect_related(ct, exp);
 		UNLOCK_BH(&ip_mms_lock);
 	}
 

--------------070604030502040208030105
Content-Type: text/plain;
 name="ip_conntrack_pptp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_pptp.patch"

--- ip_conntrack_pptp.old	2004-02-22 12:18:11.000000000 +0100
+++ ip_conntrack_pptp.c	2004-02-22 12:57:42.000000000 +0100
@@ -169,72 +169,74 @@
 	u_int16_t callid,
 	u_int16_t peer_callid)
 {
-	struct ip_conntrack_expect exp;
+	struct ip_conntrack_expect *exp;
 	struct ip_conntrack_tuple inv_tuple;
 
-	memset(&exp, 0, sizeof(exp));
+	if (ip_conntrack_expect_alloc(&exp) < 0)
+		return -ENOMEM;
+	
 	/* tuple in original direction, PNS->PAC */
-	exp.tuple.src.ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-	exp.tuple.src.u.gre.key = htonl(ntohs(peer_callid));
-	exp.tuple.dst.ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-	exp.tuple.dst.u.gre.key = htonl(ntohs(callid));
-	exp.tuple.dst.u.gre.protocol = __constant_htons(GRE_PROTOCOL_PPTP);
-	exp.tuple.dst.u.gre.version = GRE_VERSION_PPTP;
-	exp.tuple.dst.protonum = IPPROTO_GRE;
-
-	exp.mask.src.ip = 0xffffffff;
-	exp.mask.src.u.all = 0;
-	exp.mask.dst.u.all = 0;
-	exp.mask.dst.u.gre.key = 0xffffffff;
-	exp.mask.dst.u.gre.version = 0xff;
-	exp.mask.dst.u.gre.protocol = 0xffff;
-	exp.mask.dst.ip = 0xffffffff;
-	exp.mask.dst.protonum = 0xffff;
+	exp->tuple.src.ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+	exp->tuple.src.u.gre.key = htonl(ntohs(peer_callid));
+	exp->tuple.dst.ip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+	exp->tuple.dst.u.gre.key = htonl(ntohs(callid));
+	exp->tuple.dst.u.gre.protocol = __constant_htons(GRE_PROTOCOL_PPTP);
+	exp->tuple.dst.u.gre.version = GRE_VERSION_PPTP;
+	exp->tuple.dst.protonum = IPPROTO_GRE;
+
+	exp->mask.src.ip = 0xffffffff;
+	exp->mask.src.u.all = 0;
+	exp->mask.dst.u.all = 0;
+	exp->mask.dst.u.gre.key = 0xffffffff;
+	exp->mask.dst.u.gre.version = 0xff;
+	exp->mask.dst.u.gre.protocol = 0xffff;
+	exp->mask.dst.ip = 0xffffffff;
+	exp->mask.dst.protonum = 0xffff;
 			
-	exp.seq = seq;
-	exp.expectfn = pptp_expectfn;
+	exp->seq = seq;
+	exp->expectfn = pptp_expectfn;
 
-	exp.help.exp_pptp_info.pac_call_id = ntohs(callid);
-	exp.help.exp_pptp_info.pns_call_id = ntohs(peer_callid);
+	exp->help.exp_pptp_info.pac_call_id = ntohs(callid);
+	exp->help.exp_pptp_info.pns_call_id = ntohs(peer_callid);
 
 	DEBUGP("calling expect_related ");
-	DUMP_TUPLE_RAW(&exp.tuple);
+	DUMP_TUPLE_RAW(&exp->tuple);
 	
 	/* Add GRE keymap entries */
-	if (ip_ct_gre_keymap_add(&exp, &exp.tuple, 0) != 0)
+	if (ip_ct_gre_keymap_add(exp, &exp->tuple, 0) != 0)
 		return 1;
 
-	invert_tuplepr(&inv_tuple, &exp.tuple);
-	if (ip_ct_gre_keymap_add(&exp, &inv_tuple, 1) != 0) {
-		ip_ct_gre_keymap_destroy(&exp);
+	invert_tuplepr(&inv_tuple, &exp->tuple);
+	if (ip_ct_gre_keymap_add(exp, &inv_tuple, 1) != 0) {
+		ip_ct_gre_keymap_destroy(exp);
 		return 1;
 	}
 	
-	if (ip_conntrack_expect_related(master, &exp) != 0) {
-		ip_ct_gre_keymap_destroy(&exp);
+	if (ip_conntrack_expect_related(master, exp) != 0) {
+		ip_ct_gre_keymap_destroy(exp);
 		DEBUGP("cannot expect_related()\n");
 		return 1;
 	}
 
 	/* tuple in reply direction, PAC->PNS */
-	exp.tuple.src.ip = master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
-	exp.tuple.src.u.gre.key = htonl(ntohs(callid));
-	exp.tuple.dst.ip = master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
-	exp.tuple.dst.u.gre.key = htonl(ntohs(peer_callid));
+	exp->tuple.src.ip = master->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
+	exp->tuple.src.u.gre.key = htonl(ntohs(callid));
+	exp->tuple.dst.ip = master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
+	exp->tuple.dst.u.gre.key = htonl(ntohs(peer_callid));
 
 	DEBUGP("calling expect_related ");
-	DUMP_TUPLE_RAW(&exp.tuple);
+	DUMP_TUPLE_RAW(&exp->tuple);
 	
 	/* Add GRE keymap entries */
-	ip_ct_gre_keymap_add(&exp, &exp.tuple, 0);
-	invert_tuplepr(&inv_tuple, &exp.tuple);
-	ip_ct_gre_keymap_add(&exp, &inv_tuple, 1);
+	ip_ct_gre_keymap_add(exp, &exp->tuple, 0);
+	invert_tuplepr(&inv_tuple, &exp->tuple);
+	ip_ct_gre_keymap_add(exp, &inv_tuple, 1);
 	/* FIXME: cannot handle error correctly, since we need to free
 	 * the above keymap :( */
 	
-	if (ip_conntrack_expect_related(master, &exp) != 0) {
+	if (ip_conntrack_expect_related(master, exp) != 0) {
 		/* free the second pair of keypmaps */
-		ip_ct_gre_keymap_destroy(&exp);
+		ip_ct_gre_keymap_destroy(exp);
 		DEBUGP("cannot expect_related():\n");
 		return 1;
 	}

--------------070604030502040208030105
Content-Type: text/plain;
 name="ip_conntrack_quake3-expect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_quake3-expect.patch"

--- ip_conntrack_quake3.old	2004-02-22 02:37:23.000000000 +0100
+++ ip_conntrack_quake3.c	2004-02-22 02:38:18.000000000 +0100
@@ -58,7 +58,7 @@
 {
 	struct udphdr *udph = (void *)iph + iph->ihl * 4;
 	int dir = CTINFO2DIR(ctinfo);
-	struct ip_conntrack_expect exp;
+	struct ip_conntrack_expect *exp;
 	int i;
 	
         /* Until there's been traffic both ways, don't look in packets. note: it's UDP ! */
@@ -77,20 +77,21 @@
 			       NIPQUAD( (u_int32_t) *( (u_int32_t *)( (int)udph + i ) ) ), 
 			       ntohs((__u16) *( (__u16 *)( (int)udph + i + 4 ) ) ) );
 
-			memset(&exp, 0, sizeof(exp));
+			if (ip_conntrack_expect_alloc(&exp) < 0)
+				return -ENOMEM;
 
-			exp.tuple = ((struct ip_conntrack_tuple)
+			exp->tuple = ((struct ip_conntrack_tuple)
 			             { { ct->tuplehash[!dir].tuple.src.ip, { 0 } },
 			               { (u_int32_t) *((u_int32_t *)((int)udph + i)), 
 			               { .udp = { (__u16) *((__u16 *)((int)udph+i+4)) } }, 
 			                 IPPROTO_UDP } }
 			            );
-			exp.mask  = ((struct ip_conntrack_tuple)
+			exp->mask  = ((struct ip_conntrack_tuple)
 			             { { 0xFFFFFFFF, { 0 } },
 		                       { 0xFFFFFFFF, { .udp = { 0xFFFF } }, 0xFFFF }});
-			exp.expectfn = NULL;
+			exp->expectfn = NULL;
 
-			ip_conntrack_expect_related(ct, &exp);
+			ip_conntrack_expect_related(ct, exp);
 		}
 
 	}

--------------070604030502040208030105
Content-Type: text/plain;
 name="ip_conntrack_rtsp-expect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_rtsp-expect.patch"

--- ip_conntrack_rtsp.c	2004-02-22 02:43:27.000000000 +0100
+++ ip_conntrack_rtsp.old	2004-02-22 02:42:50.000000000 +0100
@@ -269,7 +269,7 @@
     uint    datalen = tcplen - tcph->doff * 4;
     uint    dataoff = 0;
 
-    struct ip_conntrack_expect exp;
+    struct ip_conntrack_expect *exp;
 
     while (dataoff < datalen)
     {
@@ -296,7 +296,8 @@
         }
         DEBUGP("found a setup message\n");
 
-        memset(&exp, 0, sizeof(exp));
+	if (ip_conntrack_expect_alloc(&exp) < 0)
+		return -ENOMEM;
 
         off = 0;
         while (nf_mime_nextline(pdata+hdrsoff, hdrslen, &off,
@@ -315,42 +316,42 @@
             if (nf_strncasecmp(pdata+hdrsoff+lineoff, "Transport:", 10) == 0)
             {
                 rtsp_parse_transport(pdata+hdrsoff+lineoff, linelen,
-                                     &exp.help.exp_rtsp_info);
+                                     &exp->help.exp_rtsp_info);
             }
         }
 
-        if (exp.help.exp_rtsp_info.loport == 0)
+        if (exp->help.exp_rtsp_info.loport == 0)
         {
             DEBUGP("no udp transports found\n");
             continue;   /* no udp transports found */
         }
 
         DEBUGP("udp transport found, ports=(%d,%hu,%hu)\n",
-              (int)exp.help.exp_rtsp_info.pbtype,
-              exp.help.exp_rtsp_info.loport,
-              exp.help.exp_rtsp_info.hiport);
+              (int)exp->help.exp_rtsp_info.pbtype,
+              exp->help.exp_rtsp_info.loport,
+              exp->help.exp_rtsp_info.hiport);
 
         LOCK_BH(&ip_rtsp_lock);
-        exp.seq = ntohl(tcph->seq) + hdrsoff; /* mark all the headers */
-        exp.help.exp_rtsp_info.len = hdrslen;
+        exp->seq = ntohl(tcph->seq) + hdrsoff; /* mark all the headers */
+        exp->help.exp_rtsp_info.len = hdrslen;
 
-        exp.tuple.src.ip = ct->tuplehash[!dir].tuple.src.ip;
-        exp.mask.src.ip  = 0xffffffff;
-        exp.tuple.dst.ip = ct->tuplehash[dir].tuple.src.ip;
-        exp.mask.dst.ip  = 0xffffffff;
-        exp.tuple.dst.u.udp.port = exp.help.exp_rtsp_info.loport;
-        exp.mask.dst.u.udp.port  = (exp.help.exp_rtsp_info.pbtype == pb_range) ? 0xfffe : 0xffff;
-        exp.tuple.dst.protonum = IPPROTO_UDP;
-        exp.mask.dst.protonum  = 0xffff;
+        exp->tuple.src.ip = ct->tuplehash[!dir].tuple.src.ip;
+        exp->mask.src.ip  = 0xffffffff;
+        exp->tuple.dst.ip = ct->tuplehash[dir].tuple.src.ip;
+        exp->mask.dst.ip  = 0xffffffff;
+        exp->tuple.dst.u.udp.port = exp->help.exp_rtsp_info.loport;
+        exp->mask.dst.u.udp.port  = (exp->help.exp_rtsp_info.pbtype == pb_range) ? 0xfffe : 0xffff;
+        exp->tuple.dst.protonum = IPPROTO_UDP;
+        exp->mask.dst.protonum  = 0xffff;
 
         DEBUGP("expect_related %u.%u.%u.%u:%u-%u.%u.%u.%u:%u\n",
-                NIPQUAD(exp.tuple.src.ip),
-                ntohs(exp.tuple.src.u.tcp.port),
-                NIPQUAD(exp.tuple.dst.ip),
-                ntohs(exp.tuple.dst.u.tcp.port));
+                NIPQUAD(exp->tuple.src.ip),
+                ntohs(exp->tuple.src.u.tcp.port),
+                NIPQUAD(exp->tuple.dst.ip),
+                ntohs(exp->tuple.dst.u.tcp.port));
 
         /* pass the request off to the nat helper */
-        rc = ip_conntrack_expect_related(ct, &exp);
+        rc = ip_conntrack_expect_related(ct, exp);
         UNLOCK_BH(&ip_rtsp_lock);
         if (rc == 0)
         {

--------------070604030502040208030105
Content-Type: text/plain;
 name="ip_conntrack_talk-expect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_talk-expect.patch"

--- ip_conntrack_talk.old	2004-02-22 02:46:10.000000000 +0100
+++ ip_conntrack_talk.c	2004-02-22 02:48:15.000000000 +0100
@@ -94,8 +94,8 @@
 		              struct talk_addr *addr)
 {
 	int dir = CTINFO2DIR(ctinfo);
-	struct ip_conntrack_expect expect, *exp = &expect;
-	struct ip_ct_talk_expect *exp_talk_info = &exp->help.exp_talk_info;
+	struct ip_conntrack_expect *exp;
+	struct ip_ct_talk_expect *exp_talk_info = NULL;
 
 	DEBUGP("ip_ct_talk_help_response: %u.%u.%u.%u:%u, type %d answer %d\n",
 		NIPQUAD(addr->ta_addr), ntohs(addr->ta_port),
@@ -103,8 +103,11 @@
 
 	if (!(answer == SUCCESS && type == mode))
 		return NF_ACCEPT;
-	
-	memset(&expect, 0, sizeof(expect));
+
+	if (ip_conntrack_expect_alloc(&exp) < 0)
+		return -ENOMEM;
+
+	exp_talk_info = &exp->help.exp_talk_info;
 	
 	if (type == ANNOUNCE) {
 
@@ -132,7 +135,7 @@
 		       NIPQUAD(exp->tuple.dst.ip), ntohs(exp->tuple.dst.u.udp.port));
 
 		/* Ignore failure; should only happen with NAT */
-		ip_conntrack_expect_related(ct, &expect);
+		ip_conntrack_expect_related(ct, exp);
 		UNLOCK_BH(&ip_talk_lock);
 	}
 	if (type == LOOK_UP) {

--------------070604030502040208030105
Content-Type: text/plain;
 name="ip_conntrack_tftp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_tftp.patch"

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_tftp.c linux-2.6.3/net/ipv4/netfilter/ip_conntrack_tftp.c
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-02-18 04:57:22.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-02-22 12:51:42.000000000 +0100
@@ -44,7 +44,7 @@
 		     enum ip_conntrack_info ctinfo)
 {
 	struct tftphdr tftph;
-	struct ip_conntrack_expect exp;
+	struct ip_conntrack_expect *exp;
 
 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4 + sizeof(struct udphdr),
 			  &tftph, sizeof(tftph)) != 0)
@@ -57,19 +57,21 @@
 		DEBUGP("");
 		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
 		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
-		memset(&exp, 0, sizeof(exp));
 
-		exp.tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-		exp.mask.src.ip = 0xffffffff;
-		exp.mask.dst.ip = 0xffffffff;
-		exp.mask.dst.u.udp.port = 0xffff;
-		exp.mask.dst.protonum = 0xffff;
-		exp.expectfn = NULL;
+		if (ip_conntrack_expect_alloc(&exp) < 0)
+			return -ENOMEM;
+
+		exp->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+		exp->mask.src.ip = 0xffffffff;
+		exp->mask.dst.ip = 0xffffffff;
+		exp->mask.dst.u.udp.port = 0xffff;
+		exp->mask.dst.protonum = 0xffff;
+		exp->expectfn = NULL;
 
 		DEBUGP("expect: ");
-		DUMP_TUPLE(&exp.tuple);
-		DUMP_TUPLE(&exp.mask);
-		ip_conntrack_expect_related(ct, &exp);
+		DUMP_TUPLE(&exp->tuple);
+		DUMP_TUPLE(&exp->mask);
+		ip_conntrack_expect_related(ct, exp);
 		break;
 	default:
 		DEBUGP("Unknown opcode\n");


--------------070604030502040208030105--
