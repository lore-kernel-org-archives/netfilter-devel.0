From: Pablo Neira <pablo@eurodev.net>
Subject: Re: patch for conntrack expectations
Date: Sat, 28 Feb 2004 12:17:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404078E0.3030902@eurodev.net>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net> <20040218172539.GX9464@sunbeam.de.gnumonks.org> <4038B14C.901@eurodev.net> <20040224094014.GV13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000701010704070308010304"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
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
--------------000701010704070308010304
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald and list,

I modified the handling of old expectations in the expect_related 
function, some clean ups. Please see line 64 of this patch.

I merged this change to my lastest patch since I think that it's related 
stuff. anyway if you want me to keep this different patch, i won't have 
any problem to do it.

cheers,
Pablo

--------------000701010704070308010304
Content-Type: text/plain;
 name="expect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="expect.patch"

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-22 13:29:30.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-28 12:10:50.000000000 +0100
@@ -917,11 +917,53 @@
 	WRITE_UNLOCK(&ip_conntrack_lock);
 }
 
+int
+ip_conntrack_expect_alloc(struct ip_conntrack_expect **new)
+{
+	*new = (struct ip_conntrack_expect *)
+		kmalloc(sizeof(struct ip_conntrack_expect), GFP_ATOMIC);
+	if (!*new) {
+		DEBUGP("expect_related: OOM allocating expect\n");
+		return -ENOMEM;
+	}
+
+	/* is this important? */
+	memset(*new, 0, sizeof(struct ip_conntrack_expect));
+
+	return 1;
+}
+
+void
+ip_conntrack_expect_insert(struct ip_conntrack_expect *new,
+               struct ip_conntrack *related_to)
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
@@ -943,7 +985,7 @@
 		if (related_to->helper->timeout) {
 			if (!del_timer(&old->timeout)) {
 				/* expectation is dying. Fall through */
-				old = NULL;
+				goto out;
 			} else {
 				old->timeout.expires = jiffies + 
 					related_to->helper->timeout * HZ;
@@ -951,10 +993,10 @@
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
@@ -971,6 +1013,7 @@
 				       related_to->helper->name,
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip),
  		    	       	       NIPQUAD(related_to->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip));
+			kfree(expect);
 			return -EPERM;
 		}
 		DEBUGP("ip_conntrack: max number of expected "
@@ -1010,37 +1053,12 @@
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
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02-25 15:16:53.000000000 +0100
@@ -497,6 +497,7 @@
 EXPORT_SYMBOL(ip_ct_find_proto);
 EXPORT_SYMBOL(__ip_ct_find_proto);
 EXPORT_SYMBOL(ip_ct_find_helper);
+EXPORT_SYMBOL(ip_conntrack_expect_alloc);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
 EXPORT_SYMBOL(ip_conntrack_change_expect);
 EXPORT_SYMBOL(ip_conntrack_unexpect_related);
--- linux-2.6.3-old/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-02-18 04:57:16.000000000 +0100
+++ linux-2.6.3/include/linux/netfilter_ipv4/ip_conntrack_helper.h	2004-02-25 15:38:27.000000000 +0100
@@ -35,9 +35,13 @@
 
 extern struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tuple *tuple);
 
+
+/* Allocate space for an expectation: this is mandatory before calling 
+   ip_conntrack_expect_related. */
+extern int ip_conntrack_expect_alloc(struct ip_conntrack_expect **new);
 /* Add an expected connection: can have more than one per connection */
-extern int ip_conntrack_expect_related(struct ip_conntrack *related_to,
-				       struct ip_conntrack_expect *exp);
+extern int ip_conntrack_expect_related(struct ip_conntrack_expect *exp,
+				       struct ip_conntrack *related_to);
 extern int ip_conntrack_change_expect(struct ip_conntrack_expect *expect,
 				      struct ip_conntrack_tuple *newtuple);
 extern void ip_conntrack_unexpect_related(struct ip_conntrack_expect *exp);

--------------000701010704070308010304--
