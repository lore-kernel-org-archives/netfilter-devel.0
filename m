From: Kovacs Krisztian <piglet@sch.bme.hu>
Subject: [PATCH] find_appropriate_src() fix
Date: Sun, 7 Mar 2004 13:24:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040307122404.GA10059@sch.bme.hu>
References: <OF87010E92.B8DC3ACD-ON48256E4B.002B8F90@legend.com.cn> <1078226407.821.117.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <1078226407.821.117.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


  Hi,

  I've created a patch for the (suspected) problem described below. I've
test-booted the patch, and it seems to work in a simple MASQ setup, but
since this is my small home-network, I can't tell if it really does things
right.

  Could someone give it a try, and see if SNAT still works after applying
these changes? (The patch is for 2.6, won't do any good on 2.4 since the
in_range() function in 2.4 is seriously broken.)

On Tue, Mar 02, 2004 at 12:20:07PM +0100, KOVACS Krisztian wrote:
>   Oops, you're right. However, I don't think this is the intended
> operation of find_appropriate_src(), I suspect this is a bug. The
> problem seems to be the following:
> 
> 1. ip_nat_setup_info() passes the inverse of the reply tuple to
> get_unique_tuple() as orig_tuple, in our case this will be the same as
> the tuple in the original direction (A.1 -> C.2). mr will be set to
> MANIP_SRC to B. 
> 
> 2. get_unique_tuple() calls find_appropriate_src() with orig_tuple and
> mr.
> 
> 3. find_appropriate_src() traverses the appropriate hash chain,
> returning the first list entry for which src_cmp() returns true.
> 
> 4. src_cmp() gets the following arguments: the current nat hash entry,
> orig_tuple, and mr. It compares the list entry's ORIG_DIR source to
> orig_tuple's source. In our case this matches. Then it calls in_range()
> 
> 5. in_range() gets the following arguments: orig_tuple, ORIG_DIR source
> of the current list entry as the manip, and mr. It constructs newtuple:
> the source will be current conntrack's ORIG_DIR's source, the
> destination that of orig_tuple. Note that orig_tuple is the same as the
> to-be-NAT-ed connection's ORIG_DIR tuple, and the conntrack's source
> must be equal, if in_range() is called by src_cmp(). However, in this
> case, in_range returns false, because newtuple's source IP (A) won't be
> the same as that given by mr (B).
> 
>   So, in our case in_range() does not apply the source manip to
> orig_tuple, because src_cmp() passes the wrong manip to it. Maybe
> src_cmp() should pass
> 
> &i->conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.dst
> instead of
> &i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src
> 
> as manip to in_range()? I think it would make more sense, since we are
> interested in the probably matching connection's NAT-ed source.

-- 
 Regards,
   Krisztian KOVACS


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="find_appropriate_src_fix.patch"

Index: linux/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux.orig/net/ipv4/netfilter/ip_nat_core.c	2004-03-06 18:52:05.000000000 +0100
+++ linux/net/ipv4/netfilter/ip_nat_core.c	2004-03-07 13:05:42.000000000 +0100
@@ -176,20 +176,25 @@
 	const struct ip_conntrack_tuple *tuple,
 	const struct ip_nat_multi_range *mr)
 {
-	return (i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum
-		== tuple->dst.protonum
-		&& i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip
-		== tuple->src.ip
-		&& i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all
-		== tuple->src.u.all
-		&& in_range(tuple,
-			    &i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
-			    .tuple.src,
-			    mr));
+	struct ip_conntrack_tuple reverse;
+
+	if (i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum
+	    == tuple->dst.protonum
+	    && i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip
+	    == tuple->src.ip
+	    && i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all
+	    == tuple->src.u.all) {
+		/* the original source is the same, check if the same manip
+		 * would be appropriate for the given multi-range */
+		invert_tuplepr(&reverse, &i->conntrack->tuplehash[IP_CT_DIR_REPLY].tuple);
+		return in_range(tuple, &reverse.src, mr);
+	}
+
+	return 0;
 }
 
 /* Only called for SRC manip */
-static struct ip_conntrack_manip *
+static struct ip_conntrack_tuple *
 find_appropriate_src(const struct ip_conntrack_tuple *tuple,
 		     const struct ip_nat_multi_range *mr)
 {
@@ -199,7 +204,7 @@
 	MUST_BE_READ_LOCKED(&ip_nat_lock);
 	i = LIST_FIND(&bysource[h], src_cmp, struct ip_nat_hash *, tuple, mr);
 	if (i)
-		return &i->conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src;
+		return &i->conntrack->tuplehash[IP_CT_DIR_REPLY].tuple;
 	else
 		return NULL;
 }
@@ -419,13 +424,14 @@
 	   So far, we don't do local source mappings, so multiple
 	   manips not an issue.  */
 	if (hooknum == NF_IP_POST_ROUTING) {
-		struct ip_conntrack_manip *manip;
+		struct ip_conntrack_tuple *srctuple, mtuple;
 
-		manip = find_appropriate_src(orig_tuple, mr);
-		if (manip) {
+		srctuple = find_appropriate_src(orig_tuple, mr);
+		if (srctuple) {
 			/* Apply same source manipulation. */
+			invert_tuplepr(&mtuple, srctuple);
 			*tuple = ((struct ip_conntrack_tuple)
-				  { *manip, orig_tuple->dst });
+				  { mtuple.src, orig_tuple->dst });
 			DEBUGP("get_unique_tuple: Found current src map\n");
 			if (!ip_nat_used_tuple(tuple, conntrack))
 				return 1;

--wac7ysb48OaltWcw--
