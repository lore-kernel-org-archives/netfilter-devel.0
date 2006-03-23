From: Kovesdi Gyorgy <kgy@deverto.com>
Subject: Re: output device
Date: Thu, 23 Mar 2006 16:05:37 +0100
Message-ID: <200603231605.37957.kgy@deverto.com>
References: <200603030944.11858.kgy@deverto.com>
	<440845B4.3000208@ufomechanic.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_BlrIEM0TvCC/Fkh"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <440845B4.3000208@ufomechanic.net>
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

--Boundary-00=_BlrIEM0TvCC/Fkh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I created a patch for the kernel 2.6.16 and the iptables 1.3.5 to do the 
followings:

1) I sent some emails about necessity of selecting output device in a single 
DNAT rule. This patch does this, adding a --to-device option to the DNAT.
2) The conntrack handles the input and output devices to be able to route 
between overlapping VLAN interfaces.
3) This patch contains the icmp patch to resolve the same problem in 'ping'.

I tested it in some simple cases to route between overlapping VLAN interfaces. 
There is one problem which I could not resolve: the original (2.6.15 and 
2.6.16) kernels can route to/from only one of the overlapping VLAN 
interfaces: if I route back to the same (overlapping) address range, only one 
of the overlapping devices is working properly. If I change the input flow to 
the other device (with the same ip/port values), the packets gets dropped 
after 30 seconds. My patch resolves this only if the output device is 
explicitly given in the rule.

Regards
Gyorgy Kovesdi

--Boundary-00=_BlrIEM0TvCC/Fkh
Content-Type: text/x-diff; charset="iso-8859-1"; name="iptables-patch-1.3.5"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="iptables-patch-1.3.5"

--- iptables-1.3.5/extensions/libipt_DNAT.c	2006-01-30 09:43:11.000000000 +0100
+++ iptables-work-1.3.5/extensions/libipt_DNAT.c	2006-03-22 11:05:51.766869936 +0100
@@ -24,30 +24,35 @@
 "DNAT v%s options:\n"
 " --to-destination <ipaddr>[-<ipaddr>][:port-port]\n"
 "				Address to map destination to.\n"
-"				(You can use this more than once)\n\n",
+" --to-device <name>\n"
+"				The network device name to route\n"
+"				the package to\n\n",
 IPTABLES_VERSION);
 }
 
 static struct option opts[] = {
 	{ "to-destination", 1, 0, '1' },
+	{ "to-device", 1, 0, '2' },
 	{ 0 }
 };
 
 static struct ipt_natinfo *
 append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
 {
-	unsigned int size;
+	if (info->mr.rangesize < 1) {
+		unsigned int size;
 
-	/* One rangesize already in struct ipt_natinfo */
-	size = IPT_ALIGN(sizeof(*info) + info->mr.rangesize * sizeof(*range));
+		/* One rangesize already in struct ipt_natinfo */
+		size = IPT_ALIGN(sizeof(*info) + info->mr.rangesize * sizeof(*range));
 
-	info = realloc(info, size);
-	if (!info)
-		exit_error(OTHER_PROBLEM, "Out of memory\n");
-
-	info->t.u.target_size = size;
-	info->mr.range[info->mr.rangesize] = *range;
-	info->mr.rangesize++;
+		info = realloc(info, size);
+		if (!info)
+			exit_error(OTHER_PROBLEM, "Out of memory\n");
+		info->t.u.target_size = size;
+		info->mr.rangesize++;
+	}
+
+	info->mr.range[0] = *range;
 
 	return info;
 }
@@ -132,6 +137,36 @@
 	return &(append_range(info, &range)->t);
 }
 
+static struct ipt_entry_target *
+parse_dev(char *arg, struct ipt_natinfo *info)
+{
+	if (strlen(arg) > sizeof(info->mr.range->ifname) - 1)
+		exit_error(PARAMETER_PROBLEM,
+			   "The maximum interface name length is %u",
+			   sizeof(info->mr.range->ifname) - 1);
+
+	if (info->mr.rangesize < 1) {
+		unsigned int size;
+
+		/* One rangesize already in struct ipt_natinfo */
+		size = IPT_ALIGN(sizeof(*info) + info->mr.rangesize * sizeof(info->mr.range[0]));
+
+		info = realloc(info, size);
+		if (!info)
+			exit_error(OTHER_PROBLEM, "Out of memory\n");
+		info->t.u.target_size = size;
+		info->mr.rangesize++;
+	}
+
+	strcpy(info->mr.range[0].ifname, arg);
+	info->mr.range[0].flags |= IP_NAT_RANGE_DEV_SPECIFIED;
+
+	return &info->t;
+}
+
+#define IPT_DNAT_OPT_DADDR	0x01
+#define IPT_DNAT_OPT_DDEVICE	0x02
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -155,7 +190,7 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-destination");
 
-		if (*flags) {
+		if (*flags & IPT_DNAT_OPT_DADDR) {
 			if (!kernel_version)
 				get_kernel_version();
 			if (kernel_version > LINUX_VERSION(2, 6, 10))
@@ -163,7 +198,20 @@
 					   "Multiple --to-destination not supported");
 		}
 		*target = parse_to(optarg, portok, info);
-		*flags = 1;
+		*flags |= IPT_DNAT_OPT_DADDR;
+		return 1;
+
+	case '2':
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unexpected `!' after --to-device");
+
+		if (*flags & IPT_DNAT_OPT_DDEVICE) {
+			exit_error(PARAMETER_PROBLEM,
+				   "You cannot specify --to-device twice");
+		}
+		*flags |= IPT_DNAT_OPT_DDEVICE;
+		*target = parse_dev(optarg, info);
 		return 1;
 
 	default:
@@ -176,23 +224,31 @@
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-			   "You must specify --to-destination");
+			   "You must specify --to-destination or "
+			   "--to-device");
 }
 
 static void print_range(const struct ip_nat_range *r)
 {
+	int f=0;
+	if (r->flags & IP_NAT_RANGE_DEV_SPECIFIED) {
+		printf("%s", r->ifname);
+		f=1;
+	}
 	if (r->flags & IP_NAT_RANGE_MAP_IPS) {
 		struct in_addr a;
 
+		if (f==1) printf(":");
 		a.s_addr = r->min_ip;
 		printf("%s", addr_to_dotted(&a));
 		if (r->max_ip != r->min_ip) {
 			a.s_addr = r->max_ip;
 			printf("-%s", addr_to_dotted(&a));
 		}
+		f=1;
 	}
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
-		printf(":");
+		if (f==1) printf(":");
 		printf("%hu", ntohs(r->min.tcp.port));
 		if (r->max.tcp.port != r->min.tcp.port)
 			printf("-%hu", ntohs(r->max.tcp.port));

--Boundary-00=_BlrIEM0TvCC/Fkh
Content-Type: text/x-diff; charset="iso-8859-1";
	name="schyzo-routing-patch-2.6.16"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="schyzo-routing-patch-2.6.16"

--- linux-2.6.16/net/ipv4/route.c	2006-03-20 06:53:29.000000000 +0100
+++ linux-work-2.6.16/net/ipv4/route.c	2006-03-23 10:16:16.000000000 +0100
@@ -1784,7 +1784,11 @@
 	rth->u.dst.dev	= (out_dev)->dev;
 	dev_hold(rth->u.dst.dev);
 	rth->idev	= in_dev_get(rth->u.dst.dev);
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+	rth->fl.oif 	= skb->oif;
+#else
 	rth->fl.oif 	= 0;
+#endif
 	rth->rt_spec_dst= spec_dst;
 
 	rth->u.dst.input = ip_forward;
@@ -1922,6 +1926,11 @@
 	if (!in_dev)
 		goto out;
 
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+	if (skb->oif > 0) {
+		fl.oif = skb->oif;
+	}
+#endif
 	/* Check for the most weird martians, which can be not detected
 	   by fib_lookup.
 	 */
@@ -2096,7 +2105,11 @@
 		if (rth->fl.fl4_dst == daddr &&
 		    rth->fl.fl4_src == saddr &&
 		    rth->fl.iif == iif &&
-		    rth->fl.oif == 0 &&
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+		    rth->fl.oif == skb->oif &&
+#else
+			rth->fl.oif == 0 &&
+#endif
 #ifdef CONFIG_IP_ROUTE_FWMARK
 		    rth->fl.fl4_fwmark == skb->nfmark &&
 #endif
@@ -2781,6 +2794,7 @@
 		if (rta[RTA_OIF - 1])
 			memcpy(&oif, RTA_DATA(rta[RTA_OIF - 1]), sizeof(int));
 		fl.oif = oif;
+		//printk("inet_rtm_getroute(): %d -> %d \n", oif, in_skb->oif);
 		err = ip_route_output_key(&rt, &fl);
 	}
 	if (err)
--- linux-2.6.16/net/ipv4/netfilter/ip_conntrack_core.c	2006-03-20 06:53:29.000000000 +0100
+++ linux-work-2.6.16/net/ipv4/netfilter/ip_conntrack_core.c	2006-03-23 10:16:16.000000000 +0100
@@ -166,10 +166,10 @@
 
 int
 ip_ct_get_tuple(const struct iphdr *iph,
-		const struct sk_buff *skb,
-		unsigned int dataoff,
-		struct ip_conntrack_tuple *tuple,
-		const struct ip_conntrack_protocol *protocol)
+                const struct sk_buff *skb,
+                unsigned int dataoff,
+                struct ip_conntrack_tuple *tuple,
+                const struct ip_conntrack_protocol *protocol)
 {
 	/* Never happen */
 	if (iph->frag_off & htons(IP_OFFSET)) {
@@ -179,6 +179,10 @@
 	}
 
 	tuple->src.ip = iph->saddr;
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+	tuple->dst.ifindex = 0;
+	tuple->src.ifindex = skb->dev != NULL ? skb->dev->ifindex : 0;
+#endif
 	tuple->dst.ip = iph->daddr;
 	tuple->dst.protonum = iph->protocol;
 	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
@@ -188,13 +192,17 @@
 
 int
 ip_ct_invert_tuple(struct ip_conntrack_tuple *inverse,
-		   const struct ip_conntrack_tuple *orig,
-		   const struct ip_conntrack_protocol *protocol)
+                   const struct ip_conntrack_tuple *orig,
+                   const struct ip_conntrack_protocol *protocol)
 {
 	inverse->src.ip = orig->dst.ip;
 	inverse->dst.ip = orig->src.ip;
 	inverse->dst.protonum = orig->dst.protonum;
 	inverse->dst.dir = !orig->dst.dir;
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+	inverse->src.ifindex = orig->dst.ifindex;
+	inverse->dst.ifindex = orig->src.ifindex;
+#endif
 
 	return protocol->invert_tuple(inverse, orig);
 }
@@ -374,8 +382,8 @@
 		    const struct ip_conntrack *ignored_conntrack)
 {
 	ASSERT_READ_LOCK(&ip_conntrack_lock);
-	return tuplehash_to_ctrack(i) != ignored_conntrack
-		&& ip_ct_tuple_equal(tuple, &i->tuple);
+	return tuplehash_to_ctrack(i) != ignored_conntrack &&
+	       ip_ct_tuple_equal_srcdev(tuple, &i->tuple);
 }
 
 struct ip_conntrack_tuple_hash *
@@ -632,7 +640,7 @@
 }
 
 struct ip_conntrack *ip_conntrack_alloc(struct ip_conntrack_tuple *orig,
-					struct ip_conntrack_tuple *repl)
+                                        struct ip_conntrack_tuple *repl)
 {
 	struct ip_conntrack *conntrack;
 
@@ -761,7 +769,7 @@
 	IP_NF_ASSERT((skb->nh.iph->frag_off & htons(IP_OFFSET)) == 0);
 
 	if (!ip_ct_get_tuple(skb->nh.iph, skb, skb->nh.iph->ihl*4, 
-				&tuple,proto))
+	                     &tuple,proto))
 		return NULL;
 
 	/* look for tuple match */
@@ -824,8 +832,8 @@
 	/* Never happen */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) {
 		if (net_ratelimit()) {
-		printk(KERN_ERR "ip_conntrack_in: Frag of proto %u (hook=%u)\n",
-		       (*pskb)->nh.iph->protocol, hooknum);
+			printk(KERN_ERR "ip_conntrack_in: Frag of proto %u (hook=%u)\n",
+			       (*pskb)->nh.iph->protocol, hooknum);
 		}
 		return NF_DROP;
 	}
--- linux-2.6.16/net/ipv4/netfilter/ip_nat_core.c	2006-03-20 06:53:29.000000000 +0100
+++ linux-work-2.6.16/net/ipv4/netfilter/ip_nat_core.c	2006-03-23 10:16:16.000000000 +0100
@@ -202,39 +202,45 @@
 */
 static void
 find_best_ips_proto(struct ip_conntrack_tuple *tuple,
-		    const struct ip_nat_range *range,
-		    const struct ip_conntrack *conntrack,
-		    enum ip_nat_manip_type maniptype)
+                    const struct ip_nat_range *range,
+                    const struct ip_conntrack *conntrack,
+                    enum ip_nat_manip_type maniptype)
 {
 	u_int32_t *var_ipp;
 	/* Host order */
 	u_int32_t minip, maxip, j;
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+	if (range->flags & IP_NAT_RANGE_DEV_SPECIFIED) {
+		const struct net_device *dev = dev_get_by_name(range->ifname);
+		tuple->dst.ifindex = dev ? dev->ifindex : 0;
+	} else {
+		tuple->dst.ifindex = 0;
+	}
+#endif
+	/* Is there any IP mapping? */
+	if (range->flags & IP_NAT_RANGE_MAP_IPS) {
 
-	/* No IP mapping?  Do nothing. */
-	if (!(range->flags & IP_NAT_RANGE_MAP_IPS))
-		return;
-
-	if (maniptype == IP_NAT_MANIP_SRC)
-		var_ipp = &tuple->src.ip;
-	else
-		var_ipp = &tuple->dst.ip;
+		if (maniptype == IP_NAT_MANIP_SRC)
+			var_ipp = &tuple->src.ip;
+		else
+			var_ipp = &tuple->dst.ip;
 
-	/* Fast path: only one choice. */
-	if (range->min_ip == range->max_ip) {
-		*var_ipp = range->min_ip;
-		return;
+		/* Fast path: only one choice. */
+		if (range->min_ip == range->max_ip) {
+			*var_ipp = range->min_ip;
+		} else {
+			/* Hashing source and destination IPs gives a fairly even
+			 * spread in practice (if there are a small number of IPs
+			 * involved, there usually aren't that many connections
+			 * anyway).  The consistency means that servers see the same
+			 * client coming from the same IP (some Internet Banking sites
+			 * like this), even across reboots. */
+			minip = ntohl(range->min_ip);
+			maxip = ntohl(range->max_ip);
+			j = jhash_2words(tuple->src.ip, tuple->dst.ip, 0);
+			*var_ipp = htonl(minip + j % (maxip - minip + 1));
+		}
 	}
-
-	/* Hashing source and destination IPs gives a fairly even
-	 * spread in practice (if there are a small number of IPs
-	 * involved, there usually aren't that many connections
-	 * anyway).  The consistency means that servers see the same
-	 * client coming from the same IP (some Internet Banking sites
-	 * like this), even across reboots. */
-	minip = ntohl(range->min_ip);
-	maxip = ntohl(range->max_ip);
-	j = jhash_2words(tuple->src.ip, tuple->dst.ip, 0);
-	*var_ipp = htonl(minip + j % (maxip - minip + 1));
 }
 
 /* Manipulate the tuple into the range given.  For NF_IP_POST_ROUTING,
@@ -245,10 +251,10 @@
  * __ip_conntrack_confirm and drop the packet. */
 static void
 get_unique_tuple(struct ip_conntrack_tuple *tuple,
-		 const struct ip_conntrack_tuple *orig_tuple,
-		 const struct ip_nat_range *range,
-		 struct ip_conntrack *conntrack,
-		 enum ip_nat_manip_type maniptype)
+                 const struct ip_conntrack_tuple *orig_tuple,
+                 const struct ip_nat_range *range,
+                 struct ip_conntrack *conntrack,
+                 enum ip_nat_manip_type maniptype)
 {
 	struct ip_nat_protocol *proto;
 
@@ -313,7 +319,7 @@
 	   orig_tp =
 	   conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple) */
 	invert_tuplepr(&curr_tuple,
-		       &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple);
+	               &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple);
 
 	get_unique_tuple(&new_tuple, &curr_tuple, range, conntrack, maniptype);
 
@@ -351,13 +357,14 @@
 }
 EXPORT_SYMBOL(ip_nat_setup_info);
 
-/* Returns true if succeeded. */
+/*	This function is called for each packet received.
+	Returns true if succeeded. */
 static int
 manip_pkt(u_int16_t proto,
-	  struct sk_buff **pskb,
-	  unsigned int iphdroff,
-	  const struct ip_conntrack_tuple *target,
-	  enum ip_nat_manip_type maniptype)
+          struct sk_buff **pskb,
+          unsigned int iphdroff,
+          const struct ip_conntrack_tuple *target,
+          enum ip_nat_manip_type maniptype)
 {
 	struct iphdr *iph;
 	struct ip_nat_protocol *p;
@@ -379,12 +386,15 @@
 
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		iph->check = ip_nat_cheat_check(~iph->saddr, target->src.ip,
-						iph->check);
+		                                iph->check);
 		iph->saddr = target->src.ip;
 	} else {
 		iph->check = ip_nat_cheat_check(~iph->daddr, target->dst.ip,
-						iph->check);
+		                                iph->check);
 		iph->daddr = target->dst.ip;
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+		(*pskb)->oif = target->dst.ifindex;
+#endif
 	}
 	return 1;
 }
--- linux-2.6.16/net/ipv4/netfilter/ip_nat_rule.c	2006-03-20 06:53:29.000000000 +0100
+++ linux-work-2.6.16/net/ipv4/netfilter/ip_nat_rule.c	2006-03-23 10:16:16.000000000 +0100
@@ -174,31 +174,32 @@
 			       unsigned int targinfosize,
 			       unsigned int hook_mask)
 {
+    int Status = 1;
 	struct ip_nat_multi_range_compat *mr = targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
 		printk("SNAT: multiple ranges no longer supported\n");
-		return 0;
+		Status = 0;
 	}
 
 	if (targinfosize != IPT_ALIGN(sizeof(struct ip_nat_multi_range_compat))) {
 		DEBUGP("SNAT: Target size %u wrong for %u ranges\n",
 		       targinfosize, mr->rangesize);
-		return 0;
+		Status = 0;
 	}
 
 	/* Only allow these for NAT. */
 	if (strcmp(tablename, "nat") != 0) {
 		DEBUGP("SNAT: wrong table %s\n", tablename);
-		return 0;
+		Status = 0;
 	}
 
 	if (hook_mask & ~(1 << NF_IP_POST_ROUTING)) {
 		DEBUGP("SNAT: hook mask 0x%x bad\n", hook_mask);
-		return 0;
+		Status = 0;
 	}
-	return 1;
+	return Status;
 }
 
 static int ipt_dnat_checkentry(const char *tablename,
@@ -207,32 +208,43 @@
 			       unsigned int targinfosize,
 			       unsigned int hook_mask)
 {
+	int status = 1;
 	struct ip_nat_multi_range_compat *mr = targinfo;
 
 	/* Must be a valid range */
-	if (mr->rangesize != 1) {
+	if (mr->rangesize < 1) {
+		printk("DNAT: invalid rangesize.\n");
+		status = 0;
+    }
+    if (mr->rangesize > 1) {
 		printk("DNAT: multiple ranges no longer supported\n");
-		return 0;
+		status = 0;
 	}
 
+    if (mr->range[0].flags & IP_NAT_RANGE_DEV_SPECIFIED &&
+        dev_get_by_name(mr->range[0].ifname) == NULL) {
+        printk("DNAT: Unknown device: \"%s\"!\n", mr->range[0].ifname);
+        status = 0;
+    }
+
 	if (targinfosize != IPT_ALIGN(sizeof(struct ip_nat_multi_range_compat))) {
 		DEBUGP("DNAT: Target size %u wrong for %u ranges\n",
 		       targinfosize, mr->rangesize);
-		return 0;
+		status = 0;
 	}
 
 	/* Only allow these for NAT. */
 	if (strcmp(tablename, "nat") != 0) {
 		DEBUGP("DNAT: wrong table %s\n", tablename);
-		return 0;
+		status = 0;
 	}
 
 	if (hook_mask & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT))) {
 		DEBUGP("DNAT: hook mask 0x%x bad\n", hook_mask);
-		return 0;
+		status = 0;
 	}
-	
-	return 1;
+
+	return status;
 }
 
 inline unsigned int
--- linux-2.6.16/net/ipv4/icmp.c	2006-03-20 06:53:29.000000000 +0100
+++ linux-work-2.6.16/net/ipv4/icmp.c	2006-03-23 10:31:03.000000000 +0100
@@ -406,7 +406,8 @@
 					      { .daddr = daddr,
 						.saddr = rt->rt_spec_dst,
 						.tos = RT_TOS(skb->nh.iph->tos) } },
-				    .proto = IPPROTO_ICMP };
+                                   .proto = IPPROTO_ICMP,
+                                   .oif = skb->dev->ifindex};
 		if (ip_route_output_key(&rt, &fl))
 			goto out_unlock;
 	}
--- linux-2.6.16/include/linux/skbuff.h	2006-03-20 06:53:29.000000000 +0100
+++ linux-work-2.6.16/include/linux/skbuff.h	2006-03-23 10:16:16.000000000 +0100
@@ -285,7 +285,9 @@
 	__u16			tc_verd;	/* traffic control verdict */
 #endif
 #endif
-
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+	int				oif;
+#endif
 
 	/* These elements must be at the end, see alloc_skb() for details.  */
 	unsigned int		truesize;
--- linux-2.6.16/include/linux/netfilter_ipv4/ip_nat.h	2006-03-20 06:53:29.000000000 +0100
+++ linux-work-2.6.16/include/linux/netfilter_ipv4/ip_nat.h	2006-03-23 10:16:16.000000000 +0100
@@ -16,6 +16,7 @@
 
 #define IP_NAT_RANGE_MAP_IPS 1
 #define IP_NAT_RANGE_PROTO_SPECIFIED 2
+#define IP_NAT_RANGE_DEV_SPECIFIED 4
 
 /* NAT sequence number modifications */
 struct ip_nat_seq {
@@ -26,17 +27,25 @@
 	int32_t offset_before, offset_after;
 };
 
+#define IPT_NAT_IFNAMESIZE 16
+
 /* Single range specification. */
 struct ip_nat_range
 {
 	/* Set to OR of flags above. */
 	unsigned int flags;
 
+	/* If the flag contains IP_NAT_RANGE_MAP_IPS */
 	/* Inclusive: network order. */
 	u_int32_t min_ip, max_ip;
 
+	/* if the flag contains IP_NAT_RANGE_PROTO_SPECIFIED */
 	/* Inclusive: network order */
 	union ip_conntrack_manip_proto min, max;
+
+	/* If the flag contains IP_NAT_RANGE_DEV_SPECIFIED */
+	/* The target device name */
+	char ifname[IPT_NAT_IFNAMESIZE];
 };
 
 /* For backwards compat: don't use in modern code. */
--- linux-2.6.16/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2006-03-20 06:53:29.000000000 +0100
+++ linux-work-2.6.16/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2006-03-23 10:16:16.000000000 +0100
@@ -41,6 +41,10 @@
 {
 	u_int32_t ip;
 	union ip_conntrack_manip_proto u;
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+	// This is the index of the source interface, or 0 if no such given
+	int ifindex;
+#endif
 };
 
 /* This contains the information to distinguish a connection. */
@@ -78,6 +82,10 @@
 
 		/* The direction (for tuplehash) */
 		u_int8_t dir;
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+		/* The destination device index, used in DNAT */
+		int ifindex;
+#endif
 	} dst;
 };
 
@@ -131,16 +139,51 @@
 	return ip_ct_tuple_src_equal(t1, t2) && ip_ct_tuple_dst_equal(t1, t2);
 }
 
+static inline int ip_ct_tuple_srcdev_equal(const struct ip_conntrack_tuple *t1,
+                                           const struct ip_conntrack_tuple *t2)
+{
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+	return t1->src.ifindex == t2->src.ifindex ||
+	       // If the dievice index is not given, evaluate it as equal:
+	       t1->src.ifindex <= 0 ||
+	       t2->src.ifindex <= 0;
+#else
+	return 1;
+#endif
+}
+
+static inline int ip_ct_tuple_dstdev_equal(const struct ip_conntrack_tuple *t1,
+                                           const struct ip_conntrack_tuple *t2)
+{
+#if 1 // CONFIG_SCHYZOPHRENIC_ROUTING
+	return t1->dst.ifindex == t2->dst.ifindex ||
+	       // If the dievice index is not given, evaluate it as equal:
+	       t1->dst.ifindex <= 0 ||
+	       t2->dst.ifindex <= 0;
+#else
+	return 1;
+#endif
+}
+
+static inline int ip_ct_tuple_equal_srcdev(const struct ip_conntrack_tuple *t1,
+                                           const struct ip_conntrack_tuple *t2)
+{
+	return ip_ct_tuple_equal(t1, t2) &&
+	       ip_ct_tuple_srcdev_equal(t1, t2);
+}
+
 static inline int ip_ct_tuple_mask_cmp(const struct ip_conntrack_tuple *t,
-				       const struct ip_conntrack_tuple *tuple,
-				       const struct ip_conntrack_tuple *mask)
+                                       const struct ip_conntrack_tuple *tuple,
+                                       const struct ip_conntrack_tuple *mask)
 {
-	return !(((t->src.ip ^ tuple->src.ip) & mask->src.ip)
-		 || ((t->dst.ip ^ tuple->dst.ip) & mask->dst.ip)
-		 || ((t->src.u.all ^ tuple->src.u.all) & mask->src.u.all)
-		 || ((t->dst.u.all ^ tuple->dst.u.all) & mask->dst.u.all)
-		 || ((t->dst.protonum ^ tuple->dst.protonum)
-		     & mask->dst.protonum));
+	return ip_ct_tuple_srcdev_equal(t, tuple)
+		&& ip_ct_tuple_dstdev_equal(t, tuple)
+	    && !(((t->src.ip ^ tuple->src.ip) & mask->src.ip)
+	      || ((t->dst.ip ^ tuple->dst.ip) & mask->dst.ip)
+	      || ((t->src.u.all ^ tuple->src.u.all) & mask->src.u.all)
+	      || ((t->dst.u.all ^ tuple->dst.u.all) & mask->dst.u.all)
+	      || ((t->dst.protonum ^ tuple->dst.protonum)
+	          & mask->dst.protonum));
 }
 
 #endif /* _IP_CONNTRACK_TUPLE_H */

--Boundary-00=_BlrIEM0TvCC/Fkh--
