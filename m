From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Conntrack targets/matches work with nfconntrack
Date: Sat, 02 Apr 2005 23:25:42 +0200
Message-ID: <424F0DD6.9070002@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090904020806030707030008"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------090904020806030707030008
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This patch makes work conntrack related matches and targets with both 
ip_conntrack and nf_conntrack (ipt_state, ipt_CONNMARK, ipt_connmark, 
ipt_NOTRACK, ipt_conntrack). Two comments about this:

o I've slighty modified the ip_conntrack structure to make it look like 
nf_conntrack.

-               u_int32_t ip;
+               union {
+                       u_int32_t ip;
+               } u3;

o This patch adds some ifdef's. I understand that this isn't the more 
elegant way to do this but it's rather straight forward. I think that 
this solution is not that bad since ip_conntrack will dissapear some day 
together with those ifdef's.

Q: anyone working to make nat work with nf_conntrack? Hm, I think it's 
the only feature missing.

--
Pablo

--------------090904020806030707030008
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

--- nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_amanda.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-04-02 15:20:49.000000000 +0200
@@ -111,15 +111,15 @@
 		exp->expectfn = NULL;
 		exp->master = ct;
 
-		exp->tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+		exp->tuple.src.u3.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip;
 		exp->tuple.src.u.tcp.port = 0;
-		exp->tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
+		exp->tuple.dst.u3.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip;
 		exp->tuple.dst.protonum = IPPROTO_TCP;
 		exp->tuple.dst.u.tcp.port = htons(port);
 
-		exp->mask.src.ip = 0xFFFFFFFF;
+		exp->mask.src.u3.ip = 0xFFFFFFFF;
 		exp->mask.src.u.tcp.port = 0;
-		exp->mask.dst.ip = 0xFFFFFFFF;
+		exp->mask.dst.u3.ip = 0xFFFFFFFF;
 		exp->mask.dst.protonum = 0xFF;
 		exp->mask.dst.u.tcp.port = 0xFFFF;
 
--- nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_core.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_core.c	2005-04-02 15:20:49.000000000 +0200
@@ -94,8 +94,8 @@
 #if 0
 	dump_tuple(tuple);
 #endif
-	return (jhash_3words(tuple->src.ip,
-	                     (tuple->dst.ip ^ tuple->dst.protonum),
+	return (jhash_3words(tuple->src.u3.ip,
+	                     (tuple->dst.u3.ip ^ tuple->dst.protonum),
 	                     (tuple->src.u.all | (tuple->dst.u.all << 16)),
 	                     ip_conntrack_hash_rnd) % ip_conntrack_htable_size);
 }
@@ -114,8 +114,8 @@
 		return 0;
 	}
 
-	tuple->src.ip = iph->saddr;
-	tuple->dst.ip = iph->daddr;
+	tuple->src.u3.ip = iph->saddr;
+	tuple->dst.u3.ip = iph->daddr;
 	tuple->dst.protonum = iph->protocol;
 	tuple->dst.dir = IP_CT_DIR_ORIGINAL;
 
@@ -127,8 +127,8 @@
 		   const struct ip_conntrack_tuple *orig,
 		   const struct ip_conntrack_protocol *protocol)
 {
-	inverse->src.ip = orig->dst.ip;
-	inverse->dst.ip = orig->src.ip;
+	inverse->src.u3.ip = orig->dst.u3.ip;
+	inverse->dst.u3.ip = orig->src.u3.ip;
 	inverse->dst.protonum = orig->dst.protonum;
 	inverse->dst.dir = !orig->dst.dir;
 
@@ -701,9 +701,9 @@
 	/* Part covered by intersection of masks must be unequal,
            otherwise they clash */
 	struct ip_conntrack_tuple intersect_mask
-		= { { a->mask.src.ip & b->mask.src.ip,
+		= { { {a->mask.src.u3.ip & b->mask.src.u3.ip  },
 		      { a->mask.src.u.all & b->mask.src.u.all } },
-		    { a->mask.dst.ip & b->mask.dst.ip,
+		    { {a->mask.dst.u3.ip & b->mask.dst.u3.ip  },
 		      { a->mask.dst.u.all & b->mask.dst.u.all },
 		      a->mask.dst.protonum & b->mask.dst.protonum } };
 
@@ -1055,9 +1055,9 @@
 	struct ip_conntrack_tuple tuple;
 	
 	IP_CT_TUPLE_U_BLANK(&tuple);
-	tuple.src.ip = inet->rcv_saddr;
+	tuple.src.u3.ip = inet->rcv_saddr;
 	tuple.src.u.tcp.port = inet->sport;
-	tuple.dst.ip = inet->daddr;
+	tuple.dst.u3.ip = inet->daddr;
 	tuple.dst.u.tcp.port = inet->dport;
 	tuple.dst.protonum = IPPROTO_TCP;
 
@@ -1082,7 +1082,7 @@
 		sin.sin_port = ct->tuplehash[IP_CT_DIR_ORIGINAL]
 			.tuple.dst.u.tcp.port;
 		sin.sin_addr.s_addr = ct->tuplehash[IP_CT_DIR_ORIGINAL]
-			.tuple.dst.ip;
+			.tuple.dst.u3.ip;
 
 		DEBUGP("SO_ORIGINAL_DST: %u.%u.%u.%u %u\n",
 		       NIPQUAD(sin.sin_addr.s_addr), ntohs(sin.sin_port));
@@ -1093,8 +1093,8 @@
 			return 0;
 	}
 	DEBUGP("SO_ORIGINAL_DST: Can't find %u.%u.%u.%u/%u-%u.%u.%u.%u/%u.\n",
-	       NIPQUAD(tuple.src.ip), ntohs(tuple.src.u.tcp.port),
-	       NIPQUAD(tuple.dst.ip), ntohs(tuple.dst.u.tcp.port));
+	       NIPQUAD(tuple.src.u3.ip), ntohs(tuple.src.u.tcp.port),
+	       NIPQUAD(tuple.dst.u3.ip), ntohs(tuple.dst.u.tcp.port));
 	return -ENOENT;
 }
 
--- nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_ftp.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-04-02 15:20:49.000000000 +0200
@@ -339,10 +339,10 @@
 
 	/* Initialize IP array to expected address (it's not mentioned
            in EPSV responses) */
-	array[0] = (ntohl(ct->tuplehash[dir].tuple.src.ip) >> 24) & 0xFF;
-	array[1] = (ntohl(ct->tuplehash[dir].tuple.src.ip) >> 16) & 0xFF;
-	array[2] = (ntohl(ct->tuplehash[dir].tuple.src.ip) >> 8) & 0xFF;
-	array[3] = ntohl(ct->tuplehash[dir].tuple.src.ip) & 0xFF;
+	array[0] = (ntohl(ct->tuplehash[dir].tuple.src.u3.ip) >> 24) & 0xFF;
+	array[1] = (ntohl(ct->tuplehash[dir].tuple.src.u3.ip) >> 16) & 0xFF;
+	array[2] = (ntohl(ct->tuplehash[dir].tuple.src.u3.ip) >> 8) & 0xFF;
+	array[3] = ntohl(ct->tuplehash[dir].tuple.src.u3.ip) & 0xFF;
 
 	for (i = 0; i < ARRAY_SIZE(search); i++) {
 		if (search[i].dir != dir) continue;
@@ -386,10 +386,10 @@
 	/* We refer to the reverse direction ("!dir") tuples here,
 	 * because we're expecting something in the other direction.
 	 * Doesn't matter unless NAT is happening.  */
-	exp->tuple.dst.ip = ct->tuplehash[!dir].tuple.dst.ip;
+	exp->tuple.dst.u3.ip = ct->tuplehash[!dir].tuple.dst.u3.ip;
 
 	if (htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3])
-	    != ct->tuplehash[dir].tuple.src.ip) {
+	    != ct->tuplehash[dir].tuple.src.u3.ip) {
 		/* Enrico Scholz's passive FTP to partially RNAT'd ftp
 		   server: it really wants us to connect to a
 		   different IP address.  Simply don't record it for
@@ -407,17 +407,17 @@
 			ip_conntrack_expect_free(exp);
 			goto out_update_nl;
 		}
-		exp->tuple.dst.ip = htonl((array[0] << 24) | (array[1] << 16)
-					 | (array[2] << 8) | array[3]);
+		exp->tuple.dst.u3.ip = htonl((array[0] << 24) | (array[1] << 16)
+					    | (array[2] << 8) | array[3]);
 	}
 
-	exp->tuple.src.ip = ct->tuplehash[!dir].tuple.src.ip;
+	exp->tuple.src.u3.ip = ct->tuplehash[!dir].tuple.src.u3.ip;
 	exp->tuple.dst.u.tcp.port = htons(array[4] << 8 | array[5]);
 	exp->tuple.src.u.tcp.port = 0; /* Don't care. */
 	exp->tuple.dst.protonum = IPPROTO_TCP;
 	exp->mask = ((struct ip_conntrack_tuple)
-		{ { 0xFFFFFFFF, { 0 } },
-		  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
+		{ { {0xFFFFFFFF}, { 0 } },
+		  { {0xFFFFFFFF}, { .tcp = { 0xFFFF } }, 0xFF }});
 
 	exp->expectfn = NULL;
 	exp->master = ct;
--- nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_irc.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_irc.c	2005-04-02 15:20:49.000000000 +0200
@@ -186,13 +186,13 @@
 
 			/* dcc_ip can be the internal OR external (NAT'ed) IP
 			 * Tiago Sousa <mirage@kaotik.org> */
-			if (ct->tuplehash[dir].tuple.src.ip != htonl(dcc_ip)
-			    && ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip != htonl(dcc_ip)) {
+			if (ct->tuplehash[dir].tuple.src.u3.ip != htonl(dcc_ip)
+			    && ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip != htonl(dcc_ip)) {
 				if (net_ratelimit())
 					printk(KERN_WARNING
 						"Forged DCC command from "
 						"%u.%u.%u.%u: %u.%u.%u.%u:%u\n",
-				NIPQUAD(ct->tuplehash[dir].tuple.src.ip),
+				NIPQUAD(ct->tuplehash[dir].tuple.src.u3.ip),
 						HIPQUAD(dcc_ip), dcc_port);
 
 				continue;
@@ -214,13 +214,13 @@
 			 * something in the other * direction.
 			 * Doesn't matter unless NAT is happening.  */
 			exp->tuple = ((struct ip_conntrack_tuple)
-				{ { 0, { 0 } },
-				  { ct->tuplehash[!dir].tuple.dst.ip,
+				{ { {0}, { 0 } },
+				  { { ct->tuplehash[!dir].tuple.dst.u3.ip },
 				    { .tcp = { htons(dcc_port) } },
 				    IPPROTO_TCP }});
 			exp->mask = ((struct ip_conntrack_tuple)
-				{ { 0, { 0 } },
-				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
+				{ { {0}, { 0 } },
+				  { {0xFFFFFFFF}, { .tcp = { 0xFFFF } },0xFF}});
 			exp->expectfn = NULL;
 			exp->master = ct;
 			if (ip_nat_irc_hook)
--- nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_standalone.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-04-02 15:20:49.000000000 +0200
@@ -60,7 +60,7 @@
 	    struct ip_conntrack_protocol *proto)
 {
 	seq_printf(s, "src=%u.%u.%u.%u dst=%u.%u.%u.%u ",
-		   NIPQUAD(tuple->src.ip), NIPQUAD(tuple->dst.ip));
+		   NIPQUAD(tuple->src.u3.ip), NIPQUAD(tuple->dst.u3.ip));
 	return proto->print_tuple(s, tuple);
 }
 
--- nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_tftp.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-04-02 15:20:49.000000000 +0200
@@ -70,8 +70,8 @@
 			return NF_DROP;
 
 		exp->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
-		exp->mask.src.ip = 0xffffffff;
-		exp->mask.dst.ip = 0xffffffff;
+		exp->mask.src.u3.ip = 0xffffffff;
+		exp->mask.dst.u3.ip = 0xffffffff;
 		exp->mask.dst.u.udp.port = 0xffff;
 		exp->mask.dst.protonum = 0xff;
 		exp->expectfn = NULL;
--- nf-2.6-nfct/net/ipv4/netfilter/ip_nat_core.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_nat_core.c	2005-04-02 15:20:49.000000000 +0200
@@ -55,7 +55,7 @@
 hash_by_src(const struct ip_conntrack_tuple *tuple)
 {
 	/* Original src, to ensure we map it consistently if poss. */
-	return jhash_3words(tuple->src.ip, tuple->src.u.all,
+	return jhash_3words(tuple->src.u3.ip, tuple->src.u.all,
 			    tuple->dst.protonum, 0) % ip_nat_htable_size;
 }
 
@@ -108,8 +108,8 @@
 	/* If we are supposed to map IPs, then we must be in the
 	   range specified, otherwise let this drag us onto a new src IP. */
 	if (range->flags & IP_NAT_RANGE_MAP_IPS) {
-		if (ntohl(tuple->src.ip) < ntohl(range->min_ip)
-		    || ntohl(tuple->src.ip) > ntohl(range->max_ip))
+		if (ntohl(tuple->src.u3.ip) < ntohl(range->min_ip)
+		    || ntohl(tuple->src.u3.ip) > ntohl(range->max_ip))
 			return 0;
 	}
 
@@ -127,8 +127,8 @@
 {
 	return (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum
 		== tuple->dst.protonum
-		&& ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip
-		== tuple->src.ip
+		&& ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip
+		== tuple->src.u3.ip
 		&& ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all
 		== tuple->src.u.all);
 }
@@ -181,9 +181,9 @@
 		return;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
-		var_ipp = &tuple->src.ip;
+		var_ipp = &tuple->src.u3.ip;
 	else
-		var_ipp = &tuple->dst.ip;
+		var_ipp = &tuple->dst.u3.ip;
 
 	/* Fast path: only one choice. */
 	if (range->min_ip == range->max_ip) {
@@ -199,7 +199,7 @@
 	 * like this), even across reboots. */
 	minip = ntohl(range->min_ip);
 	maxip = ntohl(range->max_ip);
-	j = jhash_2words(tuple->src.ip, tuple->dst.ip, 0);
+	j = jhash_2words(tuple->src.u3.ip, tuple->dst.u3.ip, 0);
 	*var_ipp = htonl(minip + j % (maxip - minip + 1));
 }
 
@@ -335,13 +335,13 @@
 	iph = (void *)(*pskb)->data + iphdroff;
 
 	if (maniptype == IP_NAT_MANIP_SRC) {
-		iph->check = ip_nat_cheat_check(~iph->saddr, target->src.ip,
+		iph->check = ip_nat_cheat_check(~iph->saddr, target->src.u3.ip,
 						iph->check);
-		iph->saddr = target->src.ip;
+		iph->saddr = target->src.u3.ip;
 	} else {
-		iph->check = ip_nat_cheat_check(~iph->daddr, target->dst.ip,
+		iph->check = ip_nat_cheat_check(~iph->daddr, target->dst.u3.ip,
 						iph->check);
-		iph->daddr = target->dst.ip;
+		iph->daddr = target->dst.u3.ip;
 	}
 	return 1;
 }
@@ -469,7 +469,7 @@
 	   such addresses are not too uncommon, as Alan Cox points
 	   out) */
 	if (manip != IP_NAT_MANIP_SRC
-	    || ((*pskb)->nh.iph->saddr == ct->tuplehash[dir].tuple.src.ip)) {
+	    || ((*pskb)->nh.iph->saddr == ct->tuplehash[dir].tuple.src.u3.ip)) {
 		invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
 		if (!manip_pkt(0, pskb, 0, &target, manip))
 			return 0;
--- nf-2.6-nfct/net/ipv4/netfilter/ip_nat_ftp.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_nat_ftp.c	2005-04-02 15:20:49.000000000 +0200
@@ -128,7 +128,7 @@
 	DEBUGP("FTP_NAT: type %i, off %u len %u\n", type, matchoff, matchlen);
 
 	/* Connection will come from wherever this packet goes, hence !dir */
-	newip = ct->tuplehash[!dir].tuple.dst.ip;
+	newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
 	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
 	exp->dir = !dir;
 
--- nf-2.6-nfct/net/ipv4/netfilter/ip_nat_helper.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_nat_helper.c	2005-04-02 15:20:49.000000000 +0200
@@ -416,7 +416,7 @@
 	/* Change src to where master sends to */
 	range.flags = IP_NAT_RANGE_MAP_IPS;
 	range.min_ip = range.max_ip
-		= ct->master->tuplehash[!exp->dir].tuple.dst.ip;
+		= ct->master->tuplehash[!exp->dir].tuple.dst.u3.ip;
 	/* hook doesn't matter, but it has to do source manip */
 	ip_nat_setup_info(ct, &range, NF_IP_POST_ROUTING);
 
@@ -424,7 +424,7 @@
 	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
 	range.min = range.max = exp->saved_proto;
 	range.min_ip = range.max_ip
-		= ct->master->tuplehash[!exp->dir].tuple.src.ip;
+		= ct->master->tuplehash[!exp->dir].tuple.src.u3.ip;
 	/* hook doesn't matter, but it has to do destination manip */
 	ip_nat_setup_info(ct, &range, NF_IP_PRE_ROUTING);
 }
--- nf-2.6-nfct/net/ipv4/netfilter/ip_nat_irc.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_nat_irc.c	2005-04-02 15:20:49.000000000 +0200
@@ -85,10 +85,10 @@
 
 	/* AAA = "us", ie. where server normally talks to. */
 	sprintf(buffer, "%u %u",
-		ntohl(exp->master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip),
+		ntohl(exp->master->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip),
 		port);
 	DEBUGP("ip_nat_irc: Inserting '%s' == %u.%u.%u.%u, port %u\n",
-	       buffer, NIPQUAD(exp->tuple.src.ip), port);
+	       buffer, NIPQUAD(exp->tuple.src.u3.ip), port);
 
 	ret = ip_nat_mangle_tcp_packet(pskb, exp->master, ctinfo, 
 				       matchoff, matchlen, buffer, 
--- nf-2.6-nfct/net/ipv4/netfilter/ip_nat_proto_tcp.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_nat_proto_tcp.c	2005-04-02 15:20:49.000000000 +0200
@@ -110,13 +110,13 @@
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		/* Get rid of src ip and src pt */
 		oldip = iph->saddr;
-		newip = tuple->src.ip;
+		newip = tuple->src.u3.ip;
 		newport = tuple->src.u.tcp.port;
 		portptr = &hdr->source;
 	} else {
 		/* Get rid of dst ip and dst pt */
 		oldip = iph->daddr;
-		newip = tuple->dst.ip;
+		newip = tuple->dst.u3.ip;
 		newport = tuple->dst.u.tcp.port;
 		portptr = &hdr->dest;
 	}
--- nf-2.6-nfct/net/ipv4/netfilter/ip_nat_proto_udp.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_nat_proto_udp.c	2005-04-02 15:20:49.000000000 +0200
@@ -102,13 +102,13 @@
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		/* Get rid of src ip and src pt */
 		oldip = iph->saddr;
-		newip = tuple->src.ip;
+		newip = tuple->src.u3.ip;
 		newport = tuple->src.u.udp.port;
 		portptr = &hdr->source;
 	} else {
 		/* Get rid of dst ip and dst pt */
 		oldip = iph->daddr;
-		newip = tuple->dst.ip;
+		newip = tuple->dst.u3.ip;
 		newport = tuple->dst.u.udp.port;
 		portptr = &hdr->dest;
 	}
--- nf-2.6-nfct/net/ipv4/netfilter/ip_nat_rule.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_nat_rule.c	2005-04-02 15:20:49.000000000 +0200
@@ -245,8 +245,8 @@
 	*/
 	u_int32_t ip
 		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
-		   ? conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip
-		   : conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip);
+		   ? conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip
+		   : conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip);
 	struct ip_nat_range range
 		= { IP_NAT_RANGE_MAP_IPS, ip, ip, { 0 }, { 0 } };
 
--- nf-2.6-nfct/net/ipv4/netfilter/ip_nat_snmp_basic.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ip_nat_snmp_basic.c	2005-04-02 15:20:49.000000000 +0200
@@ -1220,12 +1220,12 @@
 	 */
 	if (dir == IP_CT_DIR_ORIGINAL) {
 		/* SNAT traps */
-		map.from = NOCT1(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip);
-		map.to = NOCT1(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip);
+		map.from = NOCT1(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip);
+		map.to = NOCT1(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip);
 	} else {
 		/* DNAT replies */
-		map.from = NOCT1(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip);
-		map.to = NOCT1(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip);
+		map.from = NOCT1(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip);
+		map.to = NOCT1(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip);
 	}
 	
 	if (map.from == map.to)
--- nf-2.6-nfct/net/ipv4/netfilter/ipt_connmark.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ipt_connmark.c	2005-04-02 22:41:04.000000000 +0200
@@ -29,6 +29,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_connmark.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/nf_conntrack.h>
 
 static int
 match(const struct sk_buff *skb,
@@ -40,7 +41,11 @@
 {
 	const struct ipt_connmark_info *info = matchinfo;
 	enum ip_conntrack_info ctinfo;
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
 	struct ip_conntrack *ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
+#else /* CONFIG_NF_CONNTRACK_IPV4 */
+	struct nf_conn *ct = nf_ct_get((struct sk_buff *)skb, &ctinfo);
+#endif
 	if (!ct)
 		return 0;
 
@@ -69,6 +74,11 @@
 
 static int __init init(void)
 {
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
+	need_ip_conntrack();
+#else /* CONFIG_NF_CONNTRACK_IPV4 */
+	need_nf_conntrack_ipv4();
+#endif
 	return ipt_register_match(&connmark_match);
 }
 
--- nf-2.6-nfct/net/ipv4/netfilter/ipt_CONNMARK.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ipt_CONNMARK.c	2005-04-02 22:41:12.000000000 +0200
@@ -30,6 +30,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_CONNMARK.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/nf_conntrack.h>
 
 static unsigned int
 target(struct sk_buff **pskb,
@@ -45,7 +46,11 @@
 	unsigned long newmark;
 
 	enum ip_conntrack_info ctinfo;
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
 	struct ip_conntrack *ct = ip_conntrack_get((*pskb), &ctinfo);
+#else /* CONFIG_NF_CONNTRACK_IPV4 */
+	struct nf_conn *ct = nf_ct_get((*pskb), &ctinfo);
+#endif
 	if (ct) {
 	    switch(markinfo->mode) {
 	    case IPT_CONNMARK_SET:
@@ -106,6 +111,11 @@
 
 static int __init init(void)
 {
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
+	need_ip_conntrack();
+#else /* CONFIG_NF_CONNTRACK_IPV4 */
+	need_nf_conntrack_ipv4();
+#endif
 	return ipt_register_target(&ipt_connmark_reg);
 }
 
--- nf-2.6-nfct/net/ipv4/netfilter/ipt_conntrack.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ipt_conntrack.c	2005-04-02 22:41:45.000000000 +0200
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/nf_conntrack.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_conntrack.h>
 
@@ -18,6 +19,8 @@
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("iptables connection tracking match module");
 
+#define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -26,16 +29,16 @@
       int offset,
       int *hotdrop)
 {
+	unsigned int statebit;
 	const struct ipt_conntrack_info *sinfo = matchinfo;
-	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
-	unsigned int statebit;
-
-	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
-
-#define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
-
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
+	struct ip_conntrack *ct = ip_conntrack_get(skb, &ctinfo);
 	if (ct == &ip_conntrack_untracked)
+#else /* CONFIG_NF_CONNTRACK_IPV4 */
+	struct nf_conn *ct = nf_ct_get((struct sk_buff *)skb, &ctinfo);
+	if (ct == &nf_conntrack_untracked)
+#endif
 		statebit = IPT_CONNTRACK_STATE_UNTRACKED;
 	else if (ct)
  		statebit = IPT_CONNTRACK_STATE_BIT(ctinfo);
@@ -44,12 +47,12 @@
  
 	if(sinfo->flags & IPT_CONNTRACK_STATE) {
 		if (ct) {
-			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip !=
-			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip)
+			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip !=
+			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip)
 				statebit |= IPT_CONNTRACK_STATE_SNAT;
 
-			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip !=
-			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip)
+			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip !=
+			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip)
 				statebit |= IPT_CONNTRACK_STATE_DNAT;
 		}
 
@@ -63,22 +66,22 @@
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_ORIGSRC) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip&sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip, IPT_CONNTRACK_ORIGSRC))
+		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip&sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip, IPT_CONNTRACK_ORIGSRC))
 			return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_ORIGDST) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip&sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip, IPT_CONNTRACK_ORIGDST))
+		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip&sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip, IPT_CONNTRACK_ORIGDST))
 			return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_REPLSRC) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip&sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].src.ip, IPT_CONNTRACK_REPLSRC))
+		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip&sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].src.ip, IPT_CONNTRACK_REPLSRC))
 			return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_REPLDST) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip&sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].dst.ip, IPT_CONNTRACK_REPLDST))
+		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip&sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].dst.ip, IPT_CONNTRACK_REPLDST))
 			return 0;
 	}
 
@@ -123,7 +126,11 @@
 
 static int __init init(void)
 {
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
 	need_ip_conntrack();
+#else /* CONFIG_NF_CONNTRACK_IPV4 */
+	need_nf_conntrack_ipv4();
+#endif
 	return ipt_register_match(&conntrack_match);
 }
 
--- nf-2.6-nfct/net/ipv4/netfilter/ipt_NOTRACK.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ipt_NOTRACK.c	2005-04-02 22:40:37.000000000 +0200
@@ -6,6 +6,7 @@
 
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/nf_conntrack.h>
 
 static unsigned int
 target(struct sk_buff **pskb,
@@ -23,7 +24,11 @@
 	   If there is a real ct entry correspondig to this packet, 
 	   it'll hang aroun till timing out. We don't deal with it
 	   for performance reasons. JK */
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
 	(*pskb)->nfct = &ip_conntrack_untracked.ct_general;
+#else /* CONFIG_NF_CONNTRACK_IPV4 */
+	(*pskb)->nfct = &nf_conntrack_untracked.ct_general;
+#endif
 	(*pskb)->nfctinfo = IP_CT_NEW;
 	nf_conntrack_get((*pskb)->nfct);
 
@@ -60,6 +65,11 @@
 
 static int __init init(void)
 {
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
+	need_ip_conntrack();
+#else /* CONFIG_NF_CONNTRACK_IPV4 */
+	need_nf_conntrack_ipv4();
+#endif
 	if (ipt_register_target(&ipt_notrack_reg))
 		return -EINVAL;
 
--- nf-2.6-nfct/net/ipv4/netfilter/ipt_SAME.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ipt_SAME.c	2005-04-02 15:20:49.000000000 +0200
@@ -164,10 +164,10 @@
 	   Here we calculate the index in same->iparray which
 	   holds the ipaddress we should use */
 	
-	tmpip = ntohl(t->src.ip);
+	tmpip = ntohl(t->src.u3.ip);
 
 	if (!(same->info & IPT_SAME_NODST))
-		tmpip += ntohl(t->dst.ip);
+		tmpip += ntohl(t->dst.u3.ip);
 	
 	aindex = tmpip % same->ipnum;
 
--- nf-2.6-nfct/net/ipv4/netfilter/ipt_state.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/ipt_state.c	2005-04-02 22:39:57.000000000 +0200
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/nf_conntrack.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_state.h>
 
@@ -30,9 +31,15 @@
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
 	if (skb->nfct == &ip_conntrack_untracked.ct_general)
 		statebit = IPT_STATE_UNTRACKED;
 	else if (!ip_conntrack_get(skb, &ctinfo))
+#else /* CONFIG_NF_CONNTRACK_IPV4 */
+	if (skb->nfct == &nf_conntrack_untracked.ct_general)
+		statebit = IPT_STATE_UNTRACKED;
+	else if (!nf_ct_get((struct sk_buff *)skb, &ctinfo))
+#endif
 		statebit = IPT_STATE_INVALID;
 	else
 		statebit = IPT_STATE_BIT(ctinfo);
@@ -61,7 +68,11 @@
 
 static int __init init(void)
 {
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
 	need_ip_conntrack();
+#else /* CONFIG_NF_CONNTRACK_IPV4 */
+	need_nf_conntrack_ipv4();
+#endif
 	return ipt_register_match(&state_match);
 }
 
--- nf-2.6-nfct/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-04-02 22:42:27.000000000 +0200
@@ -529,6 +529,12 @@
 	return ret;
 }
 
+/* Some modules need us, but don't depend directly on any symbol.
+   They should call this. */
+void need_nf_conntrack_ipv4(void)
+{
+}
+
 MODULE_LICENSE("GPL");
 
 static int __init init(void)
@@ -547,3 +553,4 @@
 
 PROVIDES_CONNTRACK(ipv4);
 EXPORT_SYMBOL(nf_ct_ipv4_gather_frags);
+EXPORT_SYMBOL(need_nf_conntrack_ipv4);
--- nf-2.6-nfct/include/linux/netfilter_ipv4/ip_conntrack_tuple.h.orig	2005-04-02 15:20:25.000000000 +0200
+++ nf-2.6-nfct/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-04-02 15:20:49.000000000 +0200
@@ -35,7 +35,9 @@
 /* The manipulable part of the tuple. */
 struct ip_conntrack_manip
 {
-	u_int32_t ip;
+	union {
+		u_int32_t ip;
+	} u3;
 	union ip_conntrack_manip_proto u;
 };
 
@@ -46,7 +48,9 @@
 
 	/* These are the parts of the tuple which are fixed. */
 	struct {
-		u_int32_t ip;
+		union {
+			u_int32_t ip;
+		} u3;
 		union {
 			/* Add other protocols here. */
 			u_int16_t all;
@@ -105,14 +109,14 @@
 static inline int ip_ct_tuple_src_equal(const struct ip_conntrack_tuple *t1,
 				        const struct ip_conntrack_tuple *t2)
 {
-	return t1->src.ip == t2->src.ip
+	return t1->src.u3.ip == t2->src.u3.ip
 		&& t1->src.u.all == t2->src.u.all;
 }
 
 static inline int ip_ct_tuple_dst_equal(const struct ip_conntrack_tuple *t1,
 				        const struct ip_conntrack_tuple *t2)
 {
-	return t1->dst.ip == t2->dst.ip
+	return t1->dst.u3.ip == t2->dst.u3.ip
 		&& t1->dst.u.all == t2->dst.u.all
 		&& t1->dst.protonum == t2->dst.protonum;
 }
@@ -127,8 +131,8 @@
 				       const struct ip_conntrack_tuple *tuple,
 				       const struct ip_conntrack_tuple *mask)
 {
-	return !(((t->src.ip ^ tuple->src.ip) & mask->src.ip)
-		 || ((t->dst.ip ^ tuple->dst.ip) & mask->dst.ip)
+	return !(((t->src.u3.ip ^ tuple->src.u3.ip) & mask->src.u3.ip)
+		 || ((t->dst.u3.ip ^ tuple->dst.u3.ip) & mask->dst.u3.ip)
 		 || ((t->src.u.all ^ tuple->src.u.all) & mask->src.u.all)
 		 || ((t->dst.u.all ^ tuple->dst.u.all) & mask->dst.u.all)
 		 || ((t->dst.protonum ^ tuple->dst.protonum)
--- nf-2.6-nfct/include/linux/netfilter/nf_conntrack.h.orig	2005-04-02 15:20:26.000000000 +0200
+++ nf-2.6-nfct/include/linux/netfilter/nf_conntrack.h	2005-04-02 22:43:20.000000000 +0200
@@ -103,7 +103,7 @@
 
 	union nf_conntrack_proto proto;
 
-#if defined(CONFIG_NF_CONNTRACK_MARK)
+#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
 	unsigned long mark;
 #endif
 
--- nf-2.6-nfct/include/linux/netfilter/ipv4/nf_conntrack_ipv4.h.orig	2005-04-02 15:20:26.000000000 +0200
+++ nf-2.6-nfct/include/linux/netfilter/ipv4/nf_conntrack_ipv4.h	2005-04-02 22:37:20.000000000 +0200
@@ -37,4 +37,6 @@
 struct sk_buff *
 nf_ct_ipv4_ct_gather_frags(struct sk_buff *skb);
 
+extern void need_nf_conntrack_ipv4(void);
+
 #endif /*_NF_CONNTRACK_IPV4_H*/

--------------090904020806030707030008--
