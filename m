From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: New draft document on nat / traversal / hole punching (with
	Dan Kegel)
Date: Wed, 10 Nov 2004 10:42:04 +1100
Message-ID: <1100043724.25963.19.camel@localhost.localdomain>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<1100024526.6496.10.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	coreteam@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1100024526.6496.10.camel@tux.rsn.bth.se>
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

On Tue, 2004-11-09 at 19:22 +0100, Martin Josefsson wrote:
> Rusty, iirc we have a problem in the NAT core when we SNAT and have to
> remap ports, later SNAT'd connections from the same host:port pair
> doesn't get the same mapping as the first one. You were working on a fix
> for this? Was this ever made public?

Dave, please apply.  (Thanks for the reminder Martin).

Rusty.

Name: Fix find_appropriate_src() To Actually Work
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

We try to bind to the same source port when sending packets from the
same source IP/source port to the outside world.  Normally, this is
simple, since we always try to keep the same source port anyway, but
there are cases where that is not available.

This is a requirement for the Kegel Peer-to-Peer NAT paper:

	http://alumnus.caltech.edu/~dank/peer-nat.html

Unfortunately, our current implementation is useless.  It looks up a
hash to see if this srcip/srcpt has been used, but instead of
returning the mapping to use, it simply returns that same srcip/srcpt.
This is clearly wrong.  As pointed out by Krisztian Kovacs.

Also, we are no longer using the netfilter-special list iterators, so
we can split src_cmp, in_range and the actual result manipulation for
much clearer code.

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal .8770-linux-2.6.9-bk3/net/ipv4/netfilter/ip_nat_core.c .8770-linux-2.6.9-bk3.updated/net/ipv4/netfilter/ip_nat_core.c
--- .8770-linux-2.6.9-bk3/net/ipv4/netfilter/ip_nat_core.c	2004-10-19 14:34:25.000000000 +1000
+++ .8770-linux-2.6.9-bk3.updated/net/ipv4/netfilter/ip_nat_core.c	2004-10-20 11:07:45.000000000 +1000
@@ -118,31 +118,30 @@ ip_nat_used_tuple(const struct ip_conntr
 	return ip_conntrack_tuple_taken(&reply, ignored_conntrack);
 }
 
-/* Does tuple + the source manip come within the range mr */
+/* If we source map this tuple so reply looks like reply_tuple, will
+ * that meet the constraints of mr. */
 static int
 in_range(const struct ip_conntrack_tuple *tuple,
-	 const struct ip_conntrack_manip *manip,
 	 const struct ip_nat_multi_range *mr)
 {
 	struct ip_nat_protocol *proto = ip_nat_find_proto(tuple->dst.protonum);
 	unsigned int i;
-	struct ip_conntrack_tuple newtuple = { *manip, tuple->dst };
 
 	for (i = 0; i < mr->rangesize; i++) {
 		/* If we are allowed to map IPs, then we must be in the
 		   range specified, otherwise we must be unchanged. */
 		if (mr->range[i].flags & IP_NAT_RANGE_MAP_IPS) {
-			if (ntohl(newtuple.src.ip) < ntohl(mr->range[i].min_ip)
-			    || (ntohl(newtuple.src.ip)
+			if (ntohl(tuple->src.ip) < ntohl(mr->range[i].min_ip)
+			    || (ntohl(tuple->src.ip)
 				> ntohl(mr->range[i].max_ip)))
 				continue;
 		} else {
-			if (newtuple.src.ip != tuple->src.ip)
+			if (tuple->src.ip != tuple->src.ip)
 				continue;
 		}
 
 		if (!(mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
-		    || proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
+		    || proto->in_range(tuple, IP_NAT_MANIP_SRC,
 				       &mr->range[i].min, &mr->range[i].max))
 			return 1;
 	}
@@ -150,33 +149,40 @@ in_range(const struct ip_conntrack_tuple
 }
 
 static inline int
-src_cmp(const struct ip_conntrack *ct,
-	const struct ip_conntrack_tuple *tuple,
-	const struct ip_nat_multi_range *mr)
+same_src(const struct ip_conntrack *ct,
+	 const struct ip_conntrack_tuple *tuple)
 {
 	return (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum
 		== tuple->dst.protonum
 		&& ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip
 		== tuple->src.ip
 		&& ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all
-		== tuple->src.u.all
-		&& in_range(tuple,
-			    &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src, mr));
+		== tuple->src.u.all);
 }
 
 /* Only called for SRC manip */
-static struct ip_conntrack_manip *
+static int
 find_appropriate_src(const struct ip_conntrack_tuple *tuple,
+		     struct ip_conntrack_tuple *result,
 		     const struct ip_nat_multi_range *mr)
 {
 	unsigned int h = hash_by_src(&tuple->src, tuple->dst.protonum);
 	struct ip_conntrack *ct;
 
 	MUST_BE_READ_LOCKED(&ip_nat_lock);
-	list_for_each_entry(ct, &bysource[h], nat.info.bysource)
-		if (src_cmp(ct, tuple, mr))
-			return &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src;
-	return NULL;
+
+	list_for_each_entry(ct, &bysource[h], nat.info.bysource) {
+		if (same_src(ct, tuple)) {
+			/* Copy source part from reply tuple. */
+			invert_tuplepr(result,
+				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+			result->dst = tuple->dst;
+
+			if (in_range(result, mr))
+				return 1;
+		}
+	}
+	return 0;
 }
 
 #ifdef CONFIG_IP_NF_NAT_LOCAL
@@ -393,13 +399,7 @@ get_unique_tuple(struct ip_conntrack_tup
 	   So far, we don't do local source mappings, so multiple
 	   manips not an issue.  */
 	if (hooknum == NF_IP_POST_ROUTING) {
-		struct ip_conntrack_manip *manip;
-
-		manip = find_appropriate_src(orig_tuple, mr);
-		if (manip) {
-			/* Apply same source manipulation. */
-			*tuple = ((struct ip_conntrack_tuple)
-				  { *manip, orig_tuple->dst });
+		if (find_appropriate_src(orig_tuple, tuple, mr)) {
 			DEBUGP("get_unique_tuple: Found current src map\n");
 			if (!ip_nat_used_tuple(tuple, conntrack))
 				return 1;

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
