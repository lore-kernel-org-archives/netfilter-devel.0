From: Philip Craig <philipc@snapgear.com>
Subject: [PATCH] Re: another PPTP conntrack problem (no fix this time)
Date: Tue, 18 Feb 2003 11:21:50 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E518AAE.4040005@snapgear.com>
References: <4.2.0.58.20030129161653.01aab6e8@avocetgw> <4.2.0.58.20030131122321.01a7a8b8@avocetgw> <3E40CA1F.1080205@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010003030804040709070206"
Cc: Paul Mielke <paulm@routefree.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------010003030804040709070206
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Philip Craig wrote:
> Paul Mielke wrote:
> 
>>Does this seem to make sense?  Please let me know if you think I am
>>mistaken in my analysis and that the previous ICMP patches would help.
> 
> 
> You've convinced me that there is a problem here.  I think
> that gre_pkt_to_tuple() needs to handle the case when
> gre_keymap_lookup() fails by trying to do an inverse
> lookup.  I haven't tried fixing this yet.
> 
> I suspect that you will still need the other ICMP patches
> as well once you have the gre lookup succeeding though.
> 

I've attached a patch that Paul has tested that fixes this
problem.  He had to use it in conjunction with an ICMP patch
posted by Balazs Scheidler.

The problem is that there are only gre keymaps for packets
in the state where they first arrive at a machine.  But when
we need to generate an ICMP error, the gre packet may have
been NATed, and so it no longer matches the keymaps.

The attached patch extends gre_keymap_lookup to also compare
against the inverted keymaps.

I'm not happy with this patch, but I don't have the time to
fix it properly at the moment, so I've post it here.  There
are 2 problems with the patch.

Firstly, it is combining two tasks into the one function.
That means that incoming packets are compared against the
inverted keymap, when they shouldn't be.  Similarly, when
generating ICMP errors, the packet is matched against the
original keymap when it only needs to be matched against
inverted one.

Secondly, matching against inverted tuples is not going to
work when we are doing both SNAT and DNAT.  This problem may
not be specific to the gre conntrack either; ip_conntrack_core.c
has the following comment in icmp_error_track():

/* FIXME: NAT code has to handle half-done double NAT --RR */

I think the fix to both of these problems is to add another
pkt_to_tuple function to the ip_conntrack_protocol structure
which converts a half-NATed packet to a tuple.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances

--------------010003030804040709070206
Content-Type: text/plain;
 name="gre-lookup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gre-lookup.patch"

diff -u -r1.4 ip_conntrack_proto_gre.c
--- ip_conntrack_proto_gre.c	4 Dec 2002 23:44:24 -0000	1.4
+++ ip_conntrack_proto_gre.c	6 Feb 2003 03:38:39 -0000
@@ -79,6 +79,17 @@
 	        (km->tuple.dst.u.all == t->dst.u.all));
 }
 
+static inline int gre_key_inverse_cmpfn(const struct ip_ct_gre_keymap *km,
+					const struct ip_conntrack_tuple *t)
+{
+	return ((km->tuple.dst.ip == t->src.ip) &&
+		(km->tuple.src.ip == t->dst.ip) &&
+	        (km->tuple.dst.protonum == t->dst.protonum) &&
+		(km->tuple.dst.u.gre.protocol == t->dst.u.gre.protocol) &&
+		(km->tuple.dst.u.gre.version == t->dst.u.gre.version) &&
+	        (km->tuple.src.u.gre.key == t->dst.u.gre.key));
+}
+
 /* look up the source key for a given tuple */
 static u_int32_t gre_keymap_lookup(struct ip_conntrack_tuple *t)
 {
@@ -88,12 +99,18 @@
 	READ_LOCK(&ip_ct_gre_lock);
 	km = LIST_FIND(&gre_keymap_list, gre_key_cmpfn,
 			struct ip_ct_gre_keymap *, t);
-	if (!km) {
-		READ_UNLOCK(&ip_ct_gre_lock);
-		return 0;
+	if (km) {
+		key = km->tuple.src.u.gre.key;
+	} else {
+		km = LIST_FIND(&gre_keymap_list, gre_key_inverse_cmpfn,
+				struct ip_ct_gre_keymap *, t);
+		if (km) {
+			key = km->tuple.dst.u.gre.key;
+		} else {
+			key = 0;
+		}
 	}
 
-	key = km->tuple.src.u.gre.key;
 	READ_UNLOCK(&ip_ct_gre_lock);
 
 	return key;

--------------010003030804040709070206--
