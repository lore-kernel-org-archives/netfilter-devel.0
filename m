From: Pablo Neira <pablo@eurodev.net>
Subject: Re: patch for conntrack expectations
Date: Wed, 25 Feb 2004 17:29:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <403CCD69.1080308@eurodev.net>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net> <20040218172539.GX9464@sunbeam.de.gnumonks.org> <4038B14C.901@eurodev.net> <20040224094014.GV13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000706040604030507060701"
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
--------------000706040604030507060701
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi harald,

attached with this email last version of patches and some comments.

Harald Welte wrote:

>Thanks pablo.
>
>I am fine with that patch, and I'd like to put it in patch-o-matic for
>now.  As the changes are fairly obvious, I hope we won't get too much
>trouble with it ;)  However, please see my following comments.
>
>  
>
ok, feedback is always welcome. :-)

>>I finished my patch to add an ip_conntrack_expect_alloc(...) function. I 
>>also patched all the current conntrack helpers available in the stable 
>>branch and patch-o-matic-ng.
>>    
>>
>
>thanks. This means that once we get it into the core kernel, we should
>definitely have  the first pom-ng release out, otherwise people will
>still use the old API.
>
>This makes me think of another issue.  We should either rename the
>function, reorder arguments, do whatever.   We cannot just make all old
>(unpatched) code compile without any warning, and still have it crash :(
>I think it's best to exchange the order of the two arguments in
>ip_conntrack_expect_related().  This way a compiler would complain if
>some old helper was compiled with the new core.
>
>  
>

As you suggested, I modified the order of the arguments in expect_related.

>>BTW, I know that there's a skeleton of a helper in the documention, due 
>>to they mostly look the same but I think that I could add it more details.
>>    
>>
>
>yes, please.  Use the SGML master file, don't edit the HTML
>  
>

ok! I will.

>>- There's a memset in expect_alloc (see expect.patch) after the 
>>allocation is done, I don't like it anyway but I just added to keep 
>>backward compatibility because some helper usually do it. I think that 
>>it's better setting all the fields of the new expectation in the helper 
>>(this implies being a bit more restrictive with the programmer but well, 
>>this is kernel programming anyway, it's restrictive :-)).
>>    
>>
>
>yes, sometimes code like this is included mainly for debugging purpose
>and then left behind.
>
>  
>
>>I could delete that memset and have a look at all the helpers to make 
>>sure that all the fields are correctly set.
>>    
>>
>
>The issue is not very easy in this case.  Assume that tuple->dst.u
>is 32bits wide (like after applying the pptp patch).  This in turn means
>that every helper has to explicitly take care not to initialize
>tuple->dst.u with a 16bit tcp/udp port number, since it could end
>up in the 'other' 16bit half.  Rather, they have to assign
>tuple->dst.u.tcp.port.  Those cases should all be fixed by now.
>
>Now look what tuple_cmp does.  It memcmp's the whole union, not just the
>individual fields.  This means that a tuple always has to be cleanly
>initialized with zero, even in those parts that don't contain any
>useful information.
>
>So for now, I'd like to keep that memset until all the code is audited
>with that regard.
>  
>

ok, i'll study this issue calmly.

>>- I found a condition where expect_related could succesfully insert an 
>>expectaction when removing an old one and return EPERM (see 
>>expect_related-newnat14.patch). I think that this doesn't make sense. Am 
>>I forgetting something? That patch fix that problem.
>>    
>>
>
> 
>  
>
>>- I also have no problem about updating the documentation to add info 
>>about expect_alloc.
>>    
>>
>
>ok, please do so.
>  
>

ok! I will.

>One issue with your patch:  It doesn't seem to use tab's for
>indentation, but rather 8 spaces. Please clean this up.
>  
>

it's true, I think that it was because of some copy&paste issues related 
to vim and the use of cat. I'll pay attention to this kind of stuff in 
future since it seems that they are not sensible to indentation. I think 
these patches don't have this problem.

>Also, we cannot export that symbol GPL only, since it doesn't add a new
>API but rather replaces an old one.
> 
>  
>
also fixed!

If these patches are ok, I'll also prepare the patches for the pom-ng 
helpers.

Pablo

P.D: BTW, so should I patch the amanda helper against patrick patch?

--------------000706040604030507060701
Content-Type: text/plain;
 name="expect-ip_conntrack_amanda.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="expect-ip_conntrack_amanda.patch"

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-02-18 04:58:39.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-02-25 15:32:06.000000000 +0100
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
+			if (ip_conntrack_expect_related(expect, ct)
 			    == -EEXIST) {
 				;
 				/* this must be a packet being resent */

--------------000706040604030507060701
Content-Type: text/plain;
 name="expect-ip_conntrack_ftp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="expect-ip_conntrack_ftp.patch"

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-02-18 04:59:06.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-02-25 15:31:41.000000000 +0100
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
+	ip_conntrack_expect_related(exp, ct);
 	ret = NF_ACCEPT;
  out:
 	UNLOCK_BH(&ip_ftp_lock);

--------------000706040604030507060701
Content-Type: text/plain;
 name="expect-ip_conntrack_irc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="expect-ip_conntrack_irc.patch"

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_irc.c	2004-02-18 04:59:06.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_irc.c	2004-02-25 15:32:27.000000000 +0100
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
+			ip_conntrack_expect_related(exp, ct);
 
 			goto out;
 		} /* for .. NUM_DCCPROTO */

--------------000706040604030507060701
Content-Type: text/plain;
 name="expect-ip_conntrack_tftp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="expect-ip_conntrack_tftp.patch"

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-02-18 04:57:22.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_tftp.c	2004-02-25 15:31:52.000000000 +0100
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
+		ip_conntrack_expect_related(exp, ct);
 		break;
 	default:
 		DEBUGP("Unknown opcode\n");

--------------000706040604030507060701
Content-Type: text/plain;
 name="expect.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="expect.patch"

--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-22 13:29:30.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-25 16:31:09.000000000 +0100
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
@@ -1010,37 +1054,12 @@
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

--------------000706040604030507060701--
