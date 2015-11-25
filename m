From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 3/6] netfilter: nf_tables: disable old tracing if
 listener is present
Date: Wed, 25 Nov 2015 15:06:40 +0000
Message-ID: <20151125150640.GE18449@macbook.localdomain>
References: <20151124102445.GE2683@salvia>
 <20151124103105.GE1740@breakpoint.cc>
 <20151124103938.GB3014@salvia>
 <20151124105300.GK2310@macbook.localdomain>
 <20151124111029.GH1740@breakpoint.cc>
 <20151124113341.GO2310@macbook.localdomain>
 <20151124151542.GA20972@breakpoint.cc>
 <20151124152649.GK14478@macbook.localdomain>
 <20151124153550.GC20972@breakpoint.cc>
 <20151124154241.GL14478@macbook.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:57904 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751364AbbKYPGp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 10:06:45 -0500
Content-Disposition: inline
In-Reply-To: <20151124154241.GL14478@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 24.11, Patrick McHardy wrote:
> Sounds good. I'm having first success decoding headers using the nft internal
> protocol structure. Needs more refinement but I expect to have a RFC later
> today.

Just FYI, this is my current approach. Still WIP, just so you get the idea,
in case you'd like to add some comments.

Basically for the headers, we allocate a constant expression using the
header data, based on the hook and (not correctly done so far) ethertype
we set up the proto ctx and start expanding the payload expression.

This allows us to decode all the protocols nft knows of.

For things like mark and interfaces we do something quite similar, we
allocate the corresponding meta match and dump that.

All together this results in a quite small amount of code and reuses the
parts we have.

The current downside is mainly the output ordering and verbosity:

The ordering corresponds to the ordering of the header fields, f.i.:

trace id 85898000 ip ip length 60 ip id 220 ip ttl 64 ip protocol tcp ip saddr 192.168.122.1 ip daddr 192.168.122.84 tcp sport 39558 tcp dport 10000 iif ens3 
trace id 85898000 ip filter input verdict 4294967295 iif ens3 
trace id 85898000 rule tcp dport 10000 nftrace set 1 
trace id 85898000 ip filter input verdict 4294967295 iif ens3 
trace id 85898000 rule tcp dport 10000 counter packets 79 bytes 4740 
trace id 85898000 ip filter input verdict 4294967295 iif ens3 
trace id 85898000 rule tcp dport 10000 continue 
trace id 85898000 ip filter input verdict 4294967295 mark 0x00000001 iif ens3 
trace id 85898000 rule tcp dport 10000 mark set 0x00000001 
trace id 85898000 ip filter input verdict 1 mark 0x00000001 iif ens3 

As you can see, the IP addresses are the last two members of the IP header
that are dumped, which is not really ideal for readability. Not sure how
to fix that yet. Any ideas?

The verbosity results out of two things:

By default we dump every field we can decode. For testing purposes I included
a filter in the IPv4 header, so certain fields are skipped. A positive list
would also be possible but I've chosen this one so by default we will get
everything.

The second part is the we output normal nft expressions, so "ip" is repeated
for every header field. Would be easy to surpress that, I'm not sure since
the upside is that the expressions can be easily copy and pasted into the
ruleset if necessary.

I've also tested with ARP, a couple of fixed were necessary and I've added
some members to the ARP definitions for MAC and IP decoding. This is of course
not 100% correct since it simply assumes all ARP is related to these protocols:

trace id 85898200 arp ether daddr c9:4b:a9:00:54:52 ether saddr 63:f6:4b:00:54:52 ether type arp arp htype 1 arp ptype ip arp hlen 6 arp plen 4 arp operation reply arp sha 63:f6:4b:00:54:52 arp sip 192.168.122.1 arp tha c9:4b:a9:00:54:52 arp tip 192.168.122.84 iif ens3 
trace id 85898200 arp filter input verdict 4294967295 iif ens3 
trace id 85898200 rule nftrace set 1 
trace id 85898200 arp filter input verdict 4294967295 mark 0x00000001 iif ens3 
trace id 85898200 rule mark set 0x00000001 counter packets 599 bytes 27554 
trace id 85898200 arp filter input verdict 4294967295 mark 0x00000001 iif ens3 
trace id 85898200 rule mark 0x00000001 counter packets 599 bytes 27554 
trace id 85898200 arp filter input verdict 1 mark 0x00000001 iif ens3

Comments welcome, especially regarding the current limitations we have.

Cheers,
Patrick

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="x.diff"

diff --git a/include/proto.h b/include/proto.h
index a43bf98..fa8ff8c 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -78,6 +78,7 @@ struct proto_desc {
 	enum proto_bases		base;
 	unsigned int			protocol_key;
 	unsigned int			length;
+	unsigned int			filter;
 	struct {
 		unsigned int			num;
 		const struct proto_desc		*desc;
@@ -170,6 +171,10 @@ enum arp_hdr_fields {
 	ARPHDR_HLN,
 	ARPHDR_PLN,
 	ARPHDR_OP,
+	ARPHDR_SHA,
+	ARPHDR_SPA,
+	ARPHDR_THA,
+	ARPHDR_TPA,
 };
 
 enum ip_hdr_fields {
diff --git a/src/netlink.c b/src/netlink.c
index 8ab7bbe..90665fb 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -2165,19 +2165,79 @@ static void trace_print_rule(const struct nftnl_trace *nlt)
 	}
 }
 
-static void trace_print_if(const struct nftnl_trace *nlt, uint16_t attr, const char *str)
+static void trace_print_hdr(struct proto_ctx *ctx,
+			    const struct nftnl_trace *nlt,
+			    unsigned int attr, unsigned int lvl)
 {
-	char __name[IFNAMSIZ];
-	const char *ifname;
+	struct list_head list = LIST_HEAD_INIT(list);
+	struct expr *rel, *lhs, *rhs, *tmp, *next;
+	const void *hdr;
+	uint32_t hlen;
+	unsigned int n;
 
-        if (!nftnl_trace_is_set(nlt, attr))
+	if (!nftnl_trace_is_set(nlt, attr))
 		return;
 
-	ifname = nft_if_indextoname(nftnl_trace_get_u32(nlt, attr), __name);
-	if (ifname)
-		printf(" %s %s", str, ifname);
-	else
-		printf(" %s %d", str, nftnl_trace_get_u32(nlt, attr));
+	hdr = nftnl_trace_get_data(nlt, attr, &hlen);
+	lhs = payload_expr_alloc(&netlink_location, NULL, 0);
+	payload_init_raw(lhs, lvl, 0, hlen * BITS_PER_BYTE);
+
+	rhs = constant_expr_alloc(&netlink_location,
+				  &invalid_type, BYTEORDER_INVALID,
+				  hlen * BITS_PER_BYTE, hdr);
+
+	payload_expr_expand(&list, lhs, NULL, ctx);
+	list_for_each_entry_safe(lhs, next, &list, list) {
+		tmp = constant_expr_splice(rhs, lhs->len);
+		expr_set_type(tmp, lhs->dtype, lhs->byteorder);
+
+		rel = relational_expr_alloc(&lhs->location, OP_EQ, lhs, tmp);
+		lhs->ops->pctx_update(ctx, rel);
+
+		if (lhs->dtype == &invalid_type)
+			goto next;
+		n = lhs->payload.tmpl - lhs->payload.desc->templates;
+		if (lhs->payload.desc->filter & (1 << n))
+			goto next;
+
+		expr_print(rel);
+		printf(" ");
+next:
+		expr_free(rel);
+	}
+}
+
+static void trace_print_packet(const struct nftnl_trace *nlt)
+{
+	struct proto_ctx ctx;
+
+	proto_ctx_init(&ctx, nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY));
+	// NFTA_TRACE_DEV_TYPE
+	proto_ctx_update(&ctx, PROTO_BASE_LL_HDR, &internal_location, &proto_eth);
+	trace_print_hdr(&ctx, nlt, NFTNL_TRACE_LL_HEADER,
+			PROTO_BASE_LL_HDR);
+	trace_print_hdr(&ctx, nlt, NFTNL_TRACE_NETWORK_HEADER,
+			PROTO_BASE_NETWORK_HDR);
+	trace_print_hdr(&ctx, nlt, NFTNL_TRACE_TRANSPORT_HEADER,
+			PROTO_BASE_TRANSPORT_HDR);
+}
+
+static struct expr *trace_alloc_expr(const struct nftnl_trace *nlt,
+				     unsigned int attr,
+				     struct expr *lhs)
+{
+	struct expr *rhs, *rel;
+	const void *data;
+	uint32_t len;
+
+	data = nftnl_trace_get_data(nlt, attr, &len);
+	rhs  = constant_expr_alloc(&netlink_location,
+				   lhs->dtype, lhs->byteorder,
+				   len * BITS_PER_BYTE, data);
+	rel = relational_expr_alloc(&netlink_location, OP_EQ, lhs, rhs);
+	expr_print(rel);
+	printf(" ");
+	return rel;
 }
 
 static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
@@ -2194,11 +2254,36 @@ static int netlink_events_trace_cb(const struct nlmsghdr *nlh, int type,
 	if (nftnl_trace_nlmsg_parse(nlh, nlt) < 0)
 		netlink_abi_error();
 
-	printf("trace ");
-	nftnl_trace_fprintf(stdout, nlt, monh->format);
+	printf("trace id %08x ", nftnl_trace_get_u32(nlt, NFTNL_TRACE_ID));
+
+	printf("%s ", family2str(nftnl_trace_get_u32(nlt, NFTNL_TRACE_FAMILY)));
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_TABLE))
+		printf("%s ", nftnl_trace_get_str(nlt, NFTNL_TRACE_TABLE));
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_CHAIN))
+		printf("%s ", nftnl_trace_get_str(nlt, NFTNL_TRACE_CHAIN));
+
+	// type
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_VERDICT))
+		printf("verdict %u ", nftnl_trace_get_u32(nlt, NFTNL_TRACE_VERDICT));
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_MARK))
+		trace_alloc_expr(nlt, NFTNL_TRACE_MARK,
+			meta_expr_alloc(&netlink_location, NFT_META_MARK));
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_VLAN_TAG))
+		printf("vlan id %u ", nftnl_trace_get_u16(nlt, NFTNL_TRACE_VLAN_TAG));
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_LL_HEADER) ||
+	    nftnl_trace_is_set(nlt, NFTNL_TRACE_NETWORK_HEADER))
+		trace_print_packet(nlt);
+
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_IIF))
+		trace_alloc_expr(nlt, NFTNL_TRACE_IIF,
+			meta_expr_alloc(&netlink_location, NFT_META_IIF));
 
-	trace_print_if(nlt, NFTNL_TRACE_IIF, "iif");
-	trace_print_if(nlt, NFTNL_TRACE_OIF, "oif");
+	if (nftnl_trace_is_set(nlt, NFTNL_TRACE_OIF))
+		trace_alloc_expr(nlt, NFTNL_TRACE_OIF,
+			meta_expr_alloc(&netlink_location, NFT_META_OIF));
 
 	trace_print_rule(nlt);
 	printf("\n");
diff --git a/src/payload.c b/src/payload.c
index b75527a..48fc723 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -397,6 +397,7 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 		goto raw;
 	assert(desc->base == expr->payload.base);
 
+restart:
 	for (i = 1; i < array_size(desc->templates); i++) {
 		tmpl = &desc->templates[i];
 		if (tmpl->offset != expr->payload.offset)
@@ -409,6 +410,7 @@ void payload_expr_expand(struct list_head *list, struct expr *expr,
 			expr->payload.offset += tmpl->len;
 			if (expr->len == off)
 				return;
+			goto restart;
 		} else
 			break;
 	}
diff --git a/src/proto.c b/src/proto.c
index 28b93cb..88999a9 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -503,6 +503,11 @@ const struct proto_desc proto_ip = {
 		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
 	},
+	.filter		= (1 << IPHDR_VERSION) |
+			  (1 << IPHDR_HDRLENGTH) |
+			  (1 << IPHDR_TOS) |
+			  (1 << IPHDR_FRAG_OFF) |
+			  (1 << IPHDR_CHECKSUM),
 	.templates	= {
 		[IPHDR_VERSION]		= HDR_BITFIELD("version", &integer_type, 4, 4),
 		[IPHDR_HDRLENGTH]	= HDR_BITFIELD("hdrlength", &integer_type, 0, 4),
@@ -663,13 +668,13 @@ const struct proto_desc proto_inet_service = {
 
 static const struct symbol_table arpop_tbl = {
 	.symbols	= {
-		SYMBOL("request",	ARPOP_REQUEST),
-		SYMBOL("reply",		ARPOP_REPLY),
-		SYMBOL("rrequest",	ARPOP_RREQUEST),
-		SYMBOL("rreply",	ARPOP_RREPLY),
-		SYMBOL("inrequest",	ARPOP_InREQUEST),
-		SYMBOL("inreply",	ARPOP_InREPLY),
-		SYMBOL("nak",		ARPOP_NAK),
+		SYMBOL("request",	__constant_htons(ARPOP_REQUEST)),
+		SYMBOL("reply",		__constant_htons(ARPOP_REPLY)),
+		SYMBOL("rrequest",	__constant_htons(ARPOP_RREQUEST)),
+		SYMBOL("rreply",	__constant_htons(ARPOP_RREPLY)),
+		SYMBOL("inrequest",	__constant_htons(ARPOP_InREQUEST)),
+		SYMBOL("inreply",	__constant_htons(ARPOP_InREPLY)),
+		SYMBOL("nak",		__constant_htons(ARPOP_NAK)),
 		SYMBOL_LIST_END
 	},
 };
@@ -698,6 +703,10 @@ const struct proto_desc proto_arp = {
 		[ARPHDR_HLN]		= ARPHDR_FIELD("hlen", ar_hln),
 		[ARPHDR_PLN]		= ARPHDR_FIELD("plen", ar_pln),
 		[ARPHDR_OP]		= ARPHDR_TYPE("operation", &arpop_type, ar_op),
+		[ARPHDR_SHA]		= PROTO_HDR_TEMPLATE("sha", &etheraddr_type, BYTEORDER_BIG_ENDIAN, 8 * BITS_PER_BYTE, 6 * BITS_PER_BYTE),
+		[ARPHDR_SPA]		= PROTO_HDR_TEMPLATE("sip", &ipaddr_type, BYTEORDER_BIG_ENDIAN, 14 * BITS_PER_BYTE, 4 * BITS_PER_BYTE),
+		[ARPHDR_THA]		= PROTO_HDR_TEMPLATE("tha", &etheraddr_type, BYTEORDER_BIG_ENDIAN, 18 * BITS_PER_BYTE, 6 * BITS_PER_BYTE),
+		[ARPHDR_TPA]		= PROTO_HDR_TEMPLATE("tip", &ipaddr_type, BYTEORDER_BIG_ENDIAN, 24 * BITS_PER_BYTE, 4 * BITS_PER_BYTE),
 	},
 };
 

--wRRV7LY7NUeQGEoC--
