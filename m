From: Pablo Neira <pablo@eurodev.net>
Subject: Re: patch for conntrack expectations
Date: Tue, 09 Mar 2004 18:15:11 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404DFB9F.7010205@eurodev.net>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net> <20040218172539.GX9464@sunbeam.de.gnumonks.org> <4038B14C.901@eurodev.net> <20040224094014.GV13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080309050809040002060105"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040224094014.GV13386@sunbeam.de.gnumonks.org>
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
--------------080309050809040002060105
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I already sent the updates patches for expect-optimize in pom-ng to 
Harald but I forgot redirecting them to the maillist.

Please use these ones instead since they are the last version.

regards,
Pablo

--------------080309050809040002060105
Content-Type: text/plain;
 name="expect-06032004.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="expect-06032004.patch"

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-18 04:57:11.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c	2004-03-05 03:08:30.000000000 +0100
@@ -917,11 +917,55 @@
 	WRITE_UNLOCK(&ip_conntrack_lock);
 }
 
+struct ip_conntrack_expect *
+ip_conntrack_expect_alloc()
+{
+	struct ip_conntrack_expect *new;
+	
+	new = (struct ip_conntrack_expect *)
+		kmalloc(sizeof(struct ip_conntrack_expect), GFP_ATOMIC);
+	if (!new) {
+		DEBUGP("expect_related: OOM allocating expect\n");
+		return NULL;
+	}
+
+	/* tuple_cmp compares whole union, we have to initialized cleanly */
+	memset(new, 0, sizeof(struct ip_conntrack_expect));
+
+	return new;
+}
+
+static void
+ip_conntrack_expect_insert(struct ip_conntrack_expect *new,
+			   struct ip_conntrack *related_to)
+{
+	DEBUGP("new expectation %p of conntrack %p\n", new, related_to);
+	new->expectant = related_to;
+	new->sibling = NULL;
+	atomic_set(&new->use, 1);
+
+	/* add to expected list for this connection */
+	list_add(&new->expected_list, &related_to->sibling_list);
+	/* add to global list of expectations */
+
+	list_prepend(&ip_conntrack_expect_list, &new->list);
+	/* add and start timer if required */
+	if (related_to->helper->timeout) {
+		init_timer(&new->timeout);
+		new->timeout.data = (unsigned long)new;
+		new->timeout.function = expectation_timed_out;
+		new->timeout.expires = jiffies +
+					related_to->helper->timeout * HZ;
+		add_timer(&new->timeout);
+	}
+	related_to->expecting++;
+}
+
 /* Add a related connection. */
-int ip_conntrack_expect_related(struct ip_conntrack *related_to,
-				struct ip_conntrack_expect *expect)
+int ip_conntrack_expect_related(struct ip_conntrack_expect *expect,
+				struct ip_conntrack *related_to)
 {
-	struct ip_conntrack_expect *old, *new;
+	struct ip_conntrack_expect *old;
 	int ret = 0;
 
 	WRITE_LOCK(&ip_conntrack_lock);
@@ -943,7 +987,7 @@
 		if (related_to->helper->timeout) {
 			if (!del_timer(&old->timeout)) {
 				/* expectation is dying. Fall through */
-				old = NULL;
+				goto out;
 			} else {
 				old->timeout.expires = jiffies + 
 					related_to->helper->timeout * HZ;
@@ -951,10 +995,10 @@
 			}
 		}
 
-		if (old) {
-			WRITE_UNLOCK(&ip_conntrack_lock);
-			return -EEXIST;
-		}
+		WRITE_UNLOCK(&ip_conntrack_lock);
+		kfree(expect);
+		return -EEXIST;
+
 	} else if (related_to->helper->max_expected && 
 		   related_to->expecting >= related_to->helper->max_expected) {
 		struct list_head *cur_item;
@@ -971,6 +1015,7 @@
 				       related_to->helper->name,
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
+			kfree(expect);
 			return -EPERM;
 		}
 		DEBUGP("ip_conntrack: max number of expected "
@@ -1010,37 +1055,12 @@
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
+out:	ip_conntrack_expect_insert(expect, related_to);
 
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-18 04:57:46.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-03-05 03:06:54.000000000 +0100
@@ -497,6 +497,7 @@
 EXPORT_SYMBOL(ip_ct_find_proto);
 EXPORT_SYMBOL(__ip_ct_find_proto);
 EXPORT_SYMBOL(ip_ct_find_helper);
+EXPORT_SYMBOL(ip_conntrack_expect_alloc);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
 EXPORT_SYMBOL(ip_conntrack_change_expect);
 EXPORT_SYMBOL(ip_conntrack_unexpect_related);
--- linux-2.6.3-old/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-02-18 04:57:16.000000000 +0100
+++ linux-2.6.3/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-03-05 15:11:02.000000000 +0100
@@ -35,9 +35,13 @@
 
 extern struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple);
 
+
+/* Allocate space for an expectation: this is mandatory before calling 
+   ip_conntrack_expect_related. */
+extern struct ip_conntrack_expect *ip_conntrack_expect_alloc(void);
 /* Add an expected connection: can have more than one per connection */
-extern int ip_conntrack_expect_related(struct ip_conntrack *related_to,
-				       struct ip_conntrack_expect *exp);
+extern int ip_conntrack_expect_related(struct ip_conntrack_expect *exp,
+				       struct ip_conntrack *related_to);
 extern int ip_conntrack_change_expect(struct ip_conntrack_expect *expect,
 				      struct ip_conntrack_tuple *newtuple);
 extern void ip_conntrack_unexpect_related(struct ip_conntrack_expect *exp);
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-02-18 04:57:22.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-03-06 02:54:05.000000000 +0100
@@ -44,7 +44,7 @@
 		     enum ip_conntrack_info ctinfo)
 {
 	struct tftphdr tftph;
-	struct ip_conntrack_expect exp;
+	struct ip_conntrack_expect *exp;
 
 	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4 + sizeof(struct udphdr),
 			  &tftph, sizeof(tftph)) != 0)
@@ -57,19 +57,22 @@
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
+		exp = ip_conntrack_expect_alloc();
+		if (exp == NULL)
+			return NF_ACCEPT;
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
+		ip_conntrack_expect_related(exp, ct);
 		break;
 	default:
 		DEBUGP("Unknown opcode\n");
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_irc.c	2004-02-18 04:59:06.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_irc.c	2004-03-06 02:55:26.000000000 +0100
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
@@ -190,8 +190,12 @@
 
 				continue;
 			}
-			
-			memset(&expect, 0, sizeof(expect));
+
+			exp = ip_conntrack_expect_alloc();
+			if (exp == NULL)
+				goto out;
+
+			exp_irc_info = &exp->help.exp_irc_info;
 
 			/* save position of address in dcc string,
 			 * necessary for NAT */
@@ -218,7 +222,7 @@
 				NIPQUAD(exp->tuple.dst.ip),
 				ntohs(exp->tuple.dst.u.tcp.port));
 
-			ip_conntrack_expect_related(ct, &expect);
+			ip_conntrack_expect_related(exp, ct);
 
 			goto out;
 		} /* for .. NUM_DCCPROTO */
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-02-18 04:59:06.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-03-06 02:56:56.000000000 +0100
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
@@ -346,8 +346,15 @@
 	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
 	       (int)matchlen, data + matchoff,
 	       matchlen, ntohl(tcph.seq) + matchoff);
-	       
-	memset(&expect, 0, sizeof(expect));
+
+	/* Allocate expectation which will be inserted */
+	exp = ip_conntrack_expect_alloc();
+	if (exp == NULL) {
+		ret = NF_ACCEPT;
+		goto out;
+	}
+
+	exp_ftp_info = &exp->help.exp_ftp_info;
 
 	/* Update the ftp info */
 	if (htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3])
@@ -389,7 +396,7 @@
 	exp->expectfn = NULL;
 
 	/* Ignore failure; should only happen with NAT */
-	ip_conntrack_expect_related(ct, &expect);
+	ip_conntrack_expect_related(exp, ct);
 	ret = NF_ACCEPT;
  out:
 	UNLOCK_BH(&ip_ftp_lock);
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-03-05 03:24:47.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-03-06 02:22:20.000000000 +0100
@@ -46,10 +46,11 @@
 static int help(struct sk_buff *skb,
                 struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
 {
-	struct ip_conntrack_expect exp;
+	struct ip_conntrack_expect *exp;
 	struct ip_ct_amanda_expect *exp_amanda_info;
 	char *data, *data_limit, *tmp;
 	unsigned int dataoff, i;
+	u_int16_t port, len;
 
 	/* Only look at packets from the Amanda server */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
@@ -79,33 +80,40 @@
 		goto out;
 	data += strlen("CONNECT ");
 
-	memset(&exp, 0, sizeof(exp));
-	exp.tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-	exp.tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-	exp.tuple.dst.protonum = IPPROTO_TCP;
-	exp.mask.src.ip = 0xFFFFFFFF;
-	exp.mask.dst.ip = 0xFFFFFFFF;
-	exp.mask.dst.protonum = 0xFFFF;
-	exp.mask.dst.u.tcp.port = 0xFFFF;
-
 	/* Only search first line. */	
 	if ((tmp = strchr(data, '\n')))
 		*tmp = '\0';
 
-	exp_amanda_info = &exp.help.exp_amanda_info;
 	for (i = 0; i < ARRAY_SIZE(conns); i++) {
 		char *match = strstr(data, conns[i]);
 		if (!match)
 			continue;
 		tmp = data = match + strlen(conns[i]);
-		exp_amanda_info->offset = data - amanda_buffer;
-		exp_amanda_info->port   = simple_strtoul(data, &data, 10);
-		exp_amanda_info->len    = data - tmp;
-		if (exp_amanda_info->port == 0 || exp_amanda_info->len > 5)
+		port = simple_strtoul(data, &data, 10);
+		len = data - tmp;
+		if (port == 0 || len > 5)
 			break;
 
-		exp.tuple.dst.u.tcp.port = htons(exp_amanda_info->port);
-		ip_conntrack_expect_related(ct, &exp);
+		exp = ip_conntrack_expect_alloc();
+		if (exp == NULL)
+			goto out;
+
+		exp->tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+		exp->tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+		exp->tuple.dst.protonum = IPPROTO_TCP;
+		exp->mask.src.ip = 0xFFFFFFFF;
+		exp->mask.dst.ip = 0xFFFFFFFF;
+		exp->mask.dst.protonum = 0xFFFF;
+		exp->mask.dst.u.tcp.port = 0xFFFF;
+
+		exp_amanda_info = &exp->help.exp_amanda_info;
+		exp_amanda_info->offset = data - amanda_buffer;
+		exp_amanda_info->port   = port;
+		exp_amanda_info->len    = len;
+
+		exp->tuple.dst.u.tcp.port = htons(port);
+
+		ip_conntrack_expect_related(exp, ct);
 	}
 
 out:

--------------080309050809040002060105
Content-Type: text/plain;
 name="expect-06032004-CVS.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="expect-06032004-CVS.patch"

--- /home/pablo/CVS/patch-o-matic-ng/expect-optimize/linux-2.6.patch	2004-03-05 12:56:01.000000000 +0100
+++ expect-06032004.patch	2004-03-06 03:08:10.000000000 +0100
@@ -1,23 +1,25 @@
---- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-22 13:29:30.000000000 +0100
-+++ linux-2.6.3-new/net/ipv4/netfilter/ip_conntrack_core.c	2004-03-02 00:39:35.000000000 +0100
-@@ -917,11 +917,53 @@
+--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-18 04:57:11.000000000 +0100
++++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c	2004-03-05 03:08:30.000000000 +0100
+@@ -917,11 +917,55 @@
  	WRITE_UNLOCK(&ip_conntrack_lock);
  }
  
-+int
-+ip_conntrack_expect_alloc(struct ip_conntrack_expect **new)
++struct ip_conntrack_expect *
++ip_conntrack_expect_alloc()
 +{
-+	*new = (struct ip_conntrack_expect *)
++	struct ip_conntrack_expect *new;
++	
++	new = (struct ip_conntrack_expect *)
 +		kmalloc(sizeof(struct ip_conntrack_expect), GFP_ATOMIC);
-+	if (!*new) {
++	if (!new) {
 +		DEBUGP("expect_related: OOM allocating expect\n");
-+		return -ENOMEM;
++		return NULL;
 +	}
 +
 +	/* tuple_cmp compares whole union, we have to initialized cleanly */
-+	memset(*new, 0, sizeof(struct ip_conntrack_expect));
++	memset(new, 0, sizeof(struct ip_conntrack_expect));
 +
-+	return 1;
++	return new;
 +}
 +
 +static void
@@ -57,7 +59,7 @@
  	int ret = 0;
  
  	WRITE_LOCK(&ip_conntrack_lock);
-@@ -943,7 +985,7 @@
+@@ -943,7 +987,7 @@
  		if (related_to->helper->timeout) {
  			if (!del_timer(&old->timeout)) {
  				/* expectation is dying. Fall through */
@@ -66,7 +68,7 @@
  			} else {
  				old->timeout.expires = jiffies + 
  					related_to->helper->timeout * HZ;
-@@ -951,10 +993,10 @@
+@@ -951,10 +995,10 @@
  			}
  		}
  
@@ -81,7 +83,7 @@
  	} else if (related_to->helper->max_expected && 
  		   related_to->expecting >= related_to->helper->max_expected) {
  		struct list_head *cur_item;
-@@ -971,6 +1013,7 @@
+@@ -971,6 +1015,7 @@
  				       related_to->helper->name,
   		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
   		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
@@ -89,7 +91,7 @@
  			return -EPERM;
  		}
  		DEBUGP("ip_conntrack: max number of expected "
-@@ -1010,37 +1053,12 @@
+@@ -1010,37 +1055,12 @@
  			     &expect->mask)) {
  		WRITE_UNLOCK(&ip_conntrack_lock);
  		DEBUGP("expect_related: busy!\n");
@@ -132,7 +134,7 @@
  	WRITE_UNLOCK(&ip_conntrack_lock);
  
 --- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-18 04:57:46.000000000 +0100
-+++ linux-2.6.3-new/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-03-02 00:31:00.000000000 +0100
++++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-03-05 03:06:54.000000000 +0100
 @@ -497,6 +497,7 @@
  EXPORT_SYMBOL(ip_ct_find_proto);
  EXPORT_SYMBOL(__ip_ct_find_proto);
@@ -142,7 +144,7 @@
  EXPORT_SYMBOL(ip_conntrack_change_expect);
  EXPORT_SYMBOL(ip_conntrack_unexpect_related);
 --- linux-2.6.3-old/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-02-18 04:57:16.000000000 +0100
-+++ linux-2.6.3-new/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-03-02 00:31:00.000000000 +0100
++++ linux-2.6.3/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-03-05 15:11:02.000000000 +0100
 @@ -35,9 +35,13 @@
  
  extern struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple);
@@ -150,7 +152,7 @@
 +
 +/* Allocate space for an expectation: this is mandatory before calling 
 +   ip_conntrack_expect_related. */
-+extern int ip_conntrack_expect_alloc(struct ip_conntrack_expect **new);
++extern struct ip_conntrack_expect *ip_conntrack_expect_alloc(void);
  /* Add an expected connection: can have more than one per connection */
 -extern int ip_conntrack_expect_related(struct ip_conntrack *related_to,
 -				       struct ip_conntrack_expect *exp);
@@ -160,7 +162,7 @@
  				      struct ip_conntrack_tuple *newtuple);
  extern void ip_conntrack_unexpect_related(struct ip_conntrack_expect *exp);
 --- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-02-18 04:57:22.000000000 +0100
-+++ linux-2.6.3-new/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-02-25 15:31:52.000000000 +0100
++++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-03-06 02:54:05.000000000 +0100
 @@ -44,7 +44,7 @@
  		     enum ip_conntrack_info ctinfo)
  {
@@ -170,7 +172,7 @@
  
  	if (skb_copy_bits(skb, skb->nh.iph->ihl * 4 + sizeof(struct udphdr),
  			  &tftph, sizeof(tftph)) != 0)
-@@ -57,19 +57,21 @@
+@@ -57,19 +57,22 @@
  		DEBUGP("");
  		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
  		DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
@@ -182,8 +184,9 @@
 -		exp.mask.dst.u.udp.port = 0xffff;
 -		exp.mask.dst.protonum = 0xffff;
 -		exp.expectfn = NULL;
-+		if (ip_conntrack_expect_alloc(&exp) < 0)
-+			return -ENOMEM;
++		exp = ip_conntrack_expect_alloc();
++		if (exp == NULL)
++			return NF_ACCEPT;
 +
 +		exp->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
 +		exp->mask.src.ip = 0xffffffff;
@@ -203,7 +206,7 @@
  	default:
  		DEBUGP("Unknown opcode\n");
 --- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_irc.c	2004-02-18 04:59:06.000000000 +0100
-+++ linux-2.6.3-new/net/ipv4/netfilter/ip_conntrack_irc.c	2004-02-25 15:32:27.000000000 +0100
++++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_irc.c	2004-03-06 02:55:26.000000000 +0100
 @@ -106,8 +106,8 @@
  	struct tcphdr tcph;
  	char *data, *data_limit;
@@ -215,21 +218,22 @@
  
  	u_int32_t dcc_ip;
  	u_int16_t dcc_port;
-@@ -190,8 +190,11 @@
+@@ -190,8 +190,12 @@
  
  				continue;
  			}
 -			
 -			memset(&expect, 0, sizeof(expect));
 +
-+			if (ip_conntrack_expect_alloc(&exp) < 0)
-+				return -ENOMEM;
++			exp = ip_conntrack_expect_alloc();
++			if (exp == NULL)
++				goto out;
 +
 +			exp_irc_info = &exp->help.exp_irc_info;
  
  			/* save position of address in dcc string,
  			 * necessary for NAT */
-@@ -218,7 +221,7 @@
+@@ -218,7 +222,7 @@
  				NIPQUAD(exp->tuple.dst.ip),
  				ntohs(exp->tuple.dst.u.tcp.port));
  
@@ -239,7 +243,7 @@
  			goto out;
  		} /* for .. NUM_DCCPROTO */
 --- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-02-18 04:59:06.000000000 +0100
-+++ linux-2.6.3-new/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-02-25 15:31:41.000000000 +0100
++++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-03-06 02:56:56.000000000 +0100
 @@ -256,8 +256,8 @@
  	int dir = CTINFO2DIR(ctinfo);
  	unsigned int matchlen, matchoff;
@@ -251,7 +255,7 @@
  
  	unsigned int i;
  	int found = 0;
-@@ -346,8 +346,12 @@
+@@ -346,8 +346,15 @@
  	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
  	       (int)matchlen, data + matchoff,
  	       matchlen, ntohl(tcph.seq) + matchoff);
@@ -259,14 +263,17 @@
 -	memset(&expect, 0, sizeof(expect));
 +
 +	/* Allocate expectation which will be inserted */
-+	if (ip_conntrack_expect_alloc(&exp) < 0)
-+		return -ENOMEM;
++	exp = ip_conntrack_expect_alloc();
++	if (exp == NULL) {
++		ret = NF_ACCEPT;
++		goto out;
++	}
 +
 +	exp_ftp_info = &exp->help.exp_ftp_info;
  
  	/* Update the ftp info */
  	if (htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3])
-@@ -389,7 +393,7 @@
+@@ -389,7 +396,7 @@
  	exp->expectfn = NULL;
  
  	/* Ignore failure; should only happen with NAT */
@@ -275,9 +282,9 @@
  	ret = NF_ACCEPT;
   out:
  	UNLOCK_BH(&ip_ftp_lock);
---- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-02-25 17:34:05.000000000 +0100
-+++ linux-2.6.3-new/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-02-25 17:39:34.000000000 +0100
-@@ -46,7 +46,7 @@
+--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-03-05 03:24:47.000000000 +0100
++++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-03-06 02:22:20.000000000 +0100
+@@ -46,10 +46,11 @@
  static int help(struct sk_buff *skb,
                  struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
  {
@@ -286,7 +293,11 @@
  	struct ip_ct_amanda_expect *exp_amanda_info;
  	char *data, *data_limit, *tmp;
  	unsigned int dataoff, i;
-@@ -79,20 +79,22 @@
++	u_int16_t port, len;
+ 
+ 	/* Only look at packets from the Amanda server */
+ 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
+@@ -79,33 +80,40 @@
  		goto out;
  	data += strlen("CONNECT ");
  
@@ -298,33 +309,47 @@
 -	exp.mask.dst.ip = 0xFFFFFFFF;
 -	exp.mask.dst.protonum = 0xFFFF;
 -	exp.mask.dst.u.tcp.port = 0xFFFF;
-+	if (ip_conntrack_expect_alloc(&exp) < 0)
-+		return -ENOMEM;
-+	
-+	exp->tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-+	exp->tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
-+	exp->tuple.dst.protonum = IPPROTO_TCP;
-+	exp->mask.src.ip = 0xFFFFFFFF;
-+	exp->mask.dst.ip = 0xFFFFFFFF;
-+	exp->mask.dst.protonum = 0xFFFF;
-+	exp->mask.dst.u.tcp.port = 0xFFFF;
- 
+-
  	/* Only search first line. */	
  	if ((tmp = strchr(data, '\n')))
  		*tmp = '\0';
  
 -	exp_amanda_info = &exp.help.exp_amanda_info;
-+	exp_amanda_info = &exp->help.exp_amanda_info;
  	for (i = 0; i < ARRAY_SIZE(conns); i++) {
  		char *match = strstr(data, conns[i]);
  		if (!match)
-@@ -104,8 +106,8 @@
- 		if (exp_amanda_info->port == 0 || exp_amanda_info->len > 5)
+ 			continue;
+ 		tmp = data = match + strlen(conns[i]);
+-		exp_amanda_info->offset = data - amanda_buffer;
+-		exp_amanda_info->port   = simple_strtoul(data, &data, 10);
+-		exp_amanda_info->len    = data - tmp;
+-		if (exp_amanda_info->port == 0 || exp_amanda_info->len > 5)
++		port = simple_strtoul(data, &data, 10);
++		len = data - tmp;
++		if (port == 0 || len > 5)
  			break;
  
 -		exp.tuple.dst.u.tcp.port = htons(exp_amanda_info->port);
 -		ip_conntrack_expect_related(ct, &exp);
-+		exp->tuple.dst.u.tcp.port = htons(exp_amanda_info->port);
++		exp = ip_conntrack_expect_alloc();
++		if (exp == NULL)
++			goto out;
++
++		exp->tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
++		exp->tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
++		exp->tuple.dst.protonum = IPPROTO_TCP;
++		exp->mask.src.ip = 0xFFFFFFFF;
++		exp->mask.dst.ip = 0xFFFFFFFF;
++		exp->mask.dst.protonum = 0xFFFF;
++		exp->mask.dst.u.tcp.port = 0xFFFF;
++
++		exp_amanda_info = &exp->help.exp_amanda_info;
++		exp_amanda_info->offset = data - amanda_buffer;
++		exp_amanda_info->port   = port;
++		exp_amanda_info->len    = len;
++
++		exp->tuple.dst.u.tcp.port = htons(port);
++
 +		ip_conntrack_expect_related(exp, ct);
  	}
  

--------------080309050809040002060105--
