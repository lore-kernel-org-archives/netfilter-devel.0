Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6593FC388F2
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 12:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3DEF22267
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 12:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898289AbgJVMhu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 08:37:50 -0400
Received: from correo.us.es ([193.147.175.20]:38904 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898281AbgJVMhu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 08:37:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C821D4A706E
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 14:37:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1B15DA78D
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 14:37:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A74F3DA78C; Thu, 22 Oct 2020 14:37:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E8C1DA796;
        Thu, 22 Oct 2020 14:37:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 22 Oct 2020 14:37:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 79D1242EE393;
        Thu, 22 Oct 2020 14:37:40 +0200 (CEST)
Date:   Thu, 22 Oct 2020 14:37:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 6/8] conntrack: implement options output format
Message-ID: <20201022123740.GA17175@salvia>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
 <20200925124919.9389-7-mikhail.sennikovskii@cloud.ionos.com>
 <20201022123647.GA15948@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20201022123647.GA15948@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Oct 22, 2020 at 02:36:47PM +0200, Pablo Neira Ayuso wrote:
> Hi Mikhail,
> 
> Thanks for your patchset.
> 
> On Fri, Sep 25, 2020 at 02:49:17PM +0200, Mikhail Sennikovsky wrote:
> > As a counterpart to the "conntrack: accept parameters from stdin"
> > commit, this commit allows dumping conntrack entries in the format
> > used by the conntrack parameters.
> > This is useful for transfering a large set of ct entries between
> > hosts or between different ct zones in an efficient way.
> > 
> > To enable the "options" output the "-o opts" parameter needs to be
> > passed to the "contnrack -L" tool invocation.
> 
> I started slightly revisiting this 6/8 patch a bit (please find it
> enclosed to this email), I have rename -o opts to -o save, to get this
> aligned with iptables-save.

Attaching the revisited patch 6/8 to this email.

> I have also added a check for -o xml,save , to reject this
> combination.
> 
> I have extended it to display -I, -U, -D in the conntrack events.
> 
> I have removed several safety runtime checks, that can be done at
> registration time (make sure the option description is well-formed
> from there, otherwise rise an error message to spot buggy protocol
> extensions).
> 
> This patch should also be extended to support for other existing
> output flags combinations. Or just bail out if they are specified.
> 
> At this point I have concerns with NAT: I don't see how this can work
> as is. There is also a conntrack helpers that might trigger NAT
> sequence adjustments, this information would be lost.
> 
> We would need to expose all these details through the -o save, see
> below. For some of this, there is no options from command line,
> because it made no sense to expose them.
> 
> We have to discuss this before deciding where to go. See below for
> details.
> 
> > To demonstrate the overall idea of the options output format works
> > in conjunction with the "stdin parameter"s mode,
> > the following command will copy all ct entries from one ct zone
> > to another.
> > 
> > conntrack -L -w 15 -o opts | sed 's/-w 15/-w 9915/g' | conntrack -I -
> 
> For zone updates in the same host, probably conntrack can be extended
> to support for:
> 
>         conntrack -U --zone 15 --set-zone 9915
> 
> If --set-zone is specified, then --zone is used a filter.
> 
> Then, for "zone transfers" *between hosts*, a different way to address
> this is to extend conntrackd.
> 
> The idea is:
> 
> 1) Add new "transfer" mode which does _not_ subscribe to
>    conntrack events, it needs to register a new struct ct_mode
>    (currently there is "sync" and "stats" ct_modes).
> 
> 2) Add a new message type to request a zone transfer, e.g.
> 
>         conntrackd --from 192.168.10.20 --zone 15 --set-zone 9915
> 
>    This will make your local daemon send a request to the conntrackd
>    instance running on host 192.168.10.20 to retrieve zone 1200. The
>    remote conntrackd instance dumps the existing conntrack table from
>    kernel and sends it to you.
> 
>    You can reuse the channel infrastructure to establish communications
>    between conntrackd instances in the new "transfer mode". You can
>    also reuse the sync protocol, see network.h, build.c and parse.c,
>    which takes a conntrack object and it translates it to network
>    message.
> 
>    Note that the struct internal_handler actually refers to the
>    netlink handler for this new struct ct_mode that you would be
>    registering.
> 
> Let me know, thanks.

--bg08WKrSYDhXBjb5
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/extensions/libct_proto_dccp.c b/extensions/libct_proto_dccp.c
index f6258ad82a72..13cd7c53e292 100644
--- a/extensions/libct_proto_dccp.c
+++ b/extensions/libct_proto_dccp.c
@@ -198,6 +198,22 @@ static int parse_options(char c,
 	return 1;
 }
 
+
+static const char *dccp_roles[__DCCP_CONNTRACK_ROLE_MAX] = {
+	[DCCP_CONNTRACK_ROLE_CLIENT]	= "client",
+	[DCCP_CONNTRACK_ROLE_SERVER]	= "server",
+};
+
+static struct ct_print_opts dccp_print_opts[] = {
+	{ "--sport", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, NULL },
+	{ "--dport", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, NULL },
+	{ "--reply-port-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, NULL },
+	{ "--reply-port-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, NULL },
+	{ "--state", ATTR_DCCP_STATE, CT_ATTR_TYPE_U8, DCCP_CONNTRACK_MAX, dccp_states },
+	{ "--role", ATTR_DCCP_ROLE, CT_ATTR_TYPE_U8, __DCCP_CONNTRACK_ROLE_MAX, dccp_roles },
+	{},
+};
+
 #define DCCP_VALID_FLAGS_MAX	2
 static unsigned int dccp_valid_flags[DCCP_VALID_FLAGS_MAX] = {
 	CT_DCCP_ORIG_SPORT | CT_DCCP_ORIG_DPORT,
@@ -235,6 +251,7 @@ static struct ctproto_handler dccp = {
 	.protonum		= IPPROTO_DCCP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= dccp_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_gre.c b/extensions/libct_proto_gre.c
index 2dc63d14f498..406eb0691b1b 100644
--- a/extensions/libct_proto_gre.c
+++ b/extensions/libct_proto_gre.c
@@ -144,6 +144,14 @@ static int parse_options(char c,
 	return 1;
 }
 
+static struct ct_print_opts gre_print_opts[] = {
+	{ "--srckey", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--dstkey", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-key-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-key-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{},
+};
+
 #define GRE_VALID_FLAGS_MAX   2
 static unsigned int gre_valid_flags[GRE_VALID_FLAGS_MAX] = {
        CT_GRE_ORIG_SKEY | CT_GRE_ORIG_DKEY,
@@ -181,6 +189,7 @@ static struct ctproto_handler gre = {
 	.protonum		= IPPROTO_GRE,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= gre_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_icmp.c b/extensions/libct_proto_icmp.c
index 7fc82bdaddb6..a438d113f04a 100644
--- a/extensions/libct_proto_icmp.c
+++ b/extensions/libct_proto_icmp.c
@@ -102,6 +102,13 @@ static int parse(char c,
 	return 1;
 }
 
+static struct ct_print_opts icmp_print_opts[] = {
+	{ "--icmp-type", ATTR_ICMP_TYPE, CT_ATTR_TYPE_U8, 0, 0 },
+	{ "--icmp-code", ATTR_ICMP_CODE, CT_ATTR_TYPE_U8, 0, 0 },
+	{ "--icmp-id", ATTR_ICMP_ID, CT_ATTR_TYPE_BE16, 0, 0 },
+	{}
+};
+
 static void final_check(unsigned int flags,
 		        unsigned int cmd,
 		        struct nf_conntrack *ct)
@@ -117,6 +124,7 @@ static struct ctproto_handler icmp = {
 	.protonum	= IPPROTO_ICMP,
 	.parse_opts	= parse,
 	.final_check	= final_check,
+	.print_opts	= icmp_print_opts,
 	.help		= help,
 	.opts		= opts,
 	.version	= VERSION,
diff --git a/extensions/libct_proto_icmpv6.c b/extensions/libct_proto_icmpv6.c
index f872c23a1075..20b9d79aaf78 100644
--- a/extensions/libct_proto_icmpv6.c
+++ b/extensions/libct_proto_icmpv6.c
@@ -105,6 +105,13 @@ static int parse(char c,
 	return 1;
 }
 
+static struct ct_print_opts icmpv6_print_opts[] = {
+	{"--icmpv6-type", ATTR_ICMP_TYPE, CT_ATTR_TYPE_U8, 0, 0},
+	{"--icmpv6-code", ATTR_ICMP_CODE, CT_ATTR_TYPE_U8, 0, 0},
+	{"--icmpv6-id", ATTR_ICMP_ID, CT_ATTR_TYPE_BE16, 0, 0},
+	{0, 0, 0, 0, 0},
+};
+
 static void final_check(unsigned int flags,
 		        unsigned int cmd,
 		        struct nf_conntrack *ct)
@@ -119,6 +126,7 @@ static struct ctproto_handler icmpv6 = {
 	.protonum	= IPPROTO_ICMPV6,
 	.parse_opts	= parse,
 	.final_check	= final_check,
+	.print_opts	= icmpv6_print_opts,
 	.help		= help,
 	.opts		= opts,
 	.version	= VERSION,
diff --git a/extensions/libct_proto_sctp.c b/extensions/libct_proto_sctp.c
index 04828bf15815..e582e917d961 100644
--- a/extensions/libct_proto_sctp.c
+++ b/extensions/libct_proto_sctp.c
@@ -198,6 +198,17 @@ parse_options(char c, struct nf_conntrack *ct,
 	return 1;
 }
 
+static struct ct_print_opts sctp_print_opts[] = {
+	{ "--sport", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--dport", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-port-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-port-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--state", ATTR_SCTP_STATE, CT_ATTR_TYPE_U8, SCTP_CONNTRACK_MAX, sctp_states },
+	{ "--orig-vtag", ATTR_SCTP_VTAG_ORIG, CT_ATTR_TYPE_BE32, 0, 0 },
+	{ "--reply-vtag", ATTR_SCTP_VTAG_REPL, CT_ATTR_TYPE_BE32, 0, 0 },
+	{},
+};
+
 #define SCTP_VALID_FLAGS_MAX   2
 static unsigned int dccp_valid_flags[SCTP_VALID_FLAGS_MAX] = {
 	CT_SCTP_ORIG_SPORT | CT_SCTP_ORIG_DPORT,
@@ -235,6 +246,7 @@ static struct ctproto_handler sctp = {
 	.protonum		= IPPROTO_SCTP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= sctp_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_tcp.c b/extensions/libct_proto_tcp.c
index 8a37a556327c..5e580e939fba 100644
--- a/extensions/libct_proto_tcp.c
+++ b/extensions/libct_proto_tcp.c
@@ -177,6 +177,15 @@ static int parse_options(char c,
 	return 1;
 }
 
+static struct ct_print_opts tcp_print_opts[] = {
+	{"--sport", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--dport", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--reply-port-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--reply-port-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--state", ATTR_TCP_STATE, CT_ATTR_TYPE_U8, TCP_CONNTRACK_MAX, tcp_states},
+	{0, 0, 0, 0, 0},
+};
+
 #define TCP_VALID_FLAGS_MAX   2
 static unsigned int tcp_valid_flags[TCP_VALID_FLAGS_MAX] = {
        CT_TCP_ORIG_SPORT | CT_TCP_ORIG_DPORT,
@@ -228,6 +237,7 @@ static struct ctproto_handler tcp = {
 	.protonum		= IPPROTO_TCP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= tcp_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_udp.c b/extensions/libct_proto_udp.c
index e30637c7bd1f..02e368b38073 100644
--- a/extensions/libct_proto_udp.c
+++ b/extensions/libct_proto_udp.c
@@ -144,6 +144,14 @@ static int parse_options(char c,
 	return 1;
 }
 
+static struct ct_print_opts udp_print_opts[] = {
+	{"--sport", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--dport", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--reply-port-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0},
+	{"--reply-port-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0},
+	{},
+};
+
 #define UDP_VALID_FLAGS_MAX   2
 static unsigned int udp_valid_flags[UDP_VALID_FLAGS_MAX] = {
        CT_UDP_ORIG_SPORT | CT_UDP_ORIG_DPORT,
@@ -181,6 +189,7 @@ static struct ctproto_handler udp = {
 	.protonum		= IPPROTO_UDP,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= udp_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/extensions/libct_proto_udplite.c b/extensions/libct_proto_udplite.c
index f46cef0c30f5..80de70c56179 100644
--- a/extensions/libct_proto_udplite.c
+++ b/extensions/libct_proto_udplite.c
@@ -148,6 +148,14 @@ static int parse_options(char c,
 	return 1;
 }
 
+static struct ct_print_opts udplite_print_opts[] = {
+	{ "--sport", ATTR_ORIG_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--dport", ATTR_ORIG_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-port-src", ATTR_REPL_PORT_SRC, CT_ATTR_TYPE_BE16, 0, 0 },
+	{ "--reply-port-dst", ATTR_REPL_PORT_DST, CT_ATTR_TYPE_BE16, 0, 0 },
+	{},
+};
+
 #define UDPLITE_VALID_FLAGS_MAX   2
 static unsigned int udplite_valid_flags[UDPLITE_VALID_FLAGS_MAX] = {
        CT_UDPLITE_ORIG_SPORT | CT_UDPLITE_ORIG_DPORT,
@@ -186,6 +194,7 @@ static struct ctproto_handler udplite = {
 	.protonum		= IPPROTO_UDPLITE,
 	.parse_opts		= parse_options,
 	.final_check		= final_check,
+	.print_opts		= udplite_print_opts,
 	.help			= help,
 	.opts			= opts,
 	.version		= VERSION,
diff --git a/include/conntrack.h b/include/conntrack.h
index 37ccf6e9a87e..bc58d3be8f41 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -8,6 +8,9 @@
 
 #include <netinet/in.h>
 
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
 #define NUMBER_OF_CMD   19
 #define NUMBER_OF_OPT   29
 
@@ -32,6 +35,8 @@ struct ctproto_handler {
 			    unsigned int command,
 			    struct nf_conntrack *ct);
 
+	const struct ct_print_opts *print_opts;
+
 	void (*help)(void);
 
 	struct option 		*opts;
@@ -53,6 +58,31 @@ void exit_error(enum exittype status, const char *msg, ...);
 
 extern void register_proto(struct ctproto_handler *h);
 
+enum ct_attr_type {
+	CT_ATTR_TYPE_NONE = 0,
+	CT_ATTR_TYPE_U8,
+	CT_ATTR_TYPE_BE16,
+	CT_ATTR_TYPE_U16,
+	CT_ATTR_TYPE_BE32,
+	CT_ATTR_TYPE_U32,
+	CT_ATTR_TYPE_U64,
+	CT_ATTR_TYPE_U32_BITMAP,
+	CT_ATTR_TYPE_IPV4,
+	CT_ATTR_TYPE_IPV6,
+};
+
+struct ct_print_opts {
+	const char		*name;
+	enum nf_conntrack_attr	type;
+	short			value_type;
+	short			val_mapping_count;
+	const char		**val_mapping;
+};
+
+extern int ct_snprintf_opts(char *buf, unsigned int len,
+			    const struct nf_conntrack *ct,
+			    const struct ct_print_opts *attrs);
+
 extern void register_tcp(void);
 extern void register_udp(void);
 extern void register_udplite(void);
diff --git a/src/conntrack.c b/src/conntrack.c
index a26fa60bbbc9..4e1cb9fdc60c 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -53,6 +53,7 @@
 #include <sys/socket.h>
 #include <sys/time.h>
 #include <time.h>
+#include <inttypes.h>
 #ifdef HAVE_ARPA_INET_H
 #include <arpa/inet.h>
 #endif
@@ -607,6 +608,240 @@ void register_proto(struct ctproto_handler *h)
 	list_add(&h->head, &proto_list);
 }
 
+#define BUFFER_SIZE(ret, size, len, offset)		do {\
+	size += ret;					\
+	if ((int)ret > (int)len)					\
+		ret = len;				\
+	offset += ret;					\
+	len -= ret;	\
+} while(0)
+
+static int ct_snprintf_u32_bitmap(char *buf, size_t size,
+				  const struct nf_conntrack *ct,
+				  const struct ct_print_opts *attr)
+{
+	unsigned int offset = 0, ret, len = size;
+	bool found = false;
+	uint32_t val;
+	int i;
+
+	val = nfct_get_attr_u32(ct, attr->type);
+
+	for (i = 0; i < attr->val_mapping_count; i++) {
+		if (!(val & (1 << i)))
+			continue;
+		if (!attr->val_mapping[i])
+			continue;
+
+		ret = snprintf(buf + offset, len, "%s,", attr->val_mapping[i]);
+		BUFFER_SIZE(ret, size, len, offset);
+		found = true;
+	}
+
+	if (found) {
+		offset--;
+		ret = snprintf(buf + offset, len, " ");
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static int ct_snprintf_attr(char *buf, size_t size,
+			    const struct nf_conntrack *ct,
+			    const struct ct_print_opts *attr)
+{
+	char ipstr[INET6_ADDRSTRLEN] = {};
+	unsigned int offset = 0;
+	int type = attr->type;
+	int len = size;
+	int ret;
+
+	ret = snprintf(buf, len, "%s ", attr->name);
+	BUFFER_SIZE(ret, size, len, offset);
+
+	switch (attr->value_type) {
+	case CT_ATTR_TYPE_U8:
+		if (attr->val_mapping)
+			ret = snprintf(buf + offset, len, "%s ",
+				       attr->val_mapping[nfct_get_attr_u8(ct, type)]);
+		else
+			ret = snprintf(buf + offset, len, "%u ",
+				       nfct_get_attr_u8(ct, type));
+		break;
+	case CT_ATTR_TYPE_BE16:
+		ret = snprintf(buf + offset, len, "%u ",
+			       ntohs(nfct_get_attr_u16(ct, type)));
+		break;
+	case CT_ATTR_TYPE_U16:
+		ret = snprintf(buf + offset, len, "%u ",
+			       nfct_get_attr_u16(ct, type));
+		break;
+	case CT_ATTR_TYPE_BE32:
+		ret = snprintf(buf + offset, len, "%u ",
+			       ntohl(nfct_get_attr_u32(ct, type)));
+		break;
+	case CT_ATTR_TYPE_U32:
+		ret = snprintf(buf + offset, len, "%u ",
+			       nfct_get_attr_u32(ct, type));
+		break;
+	case CT_ATTR_TYPE_U64:
+		ret = snprintf(buf + offset, len, "%lu ",
+			       nfct_get_attr_u64(ct, type));
+		break;
+	case CT_ATTR_TYPE_IPV4:
+		inet_ntop(AF_INET, nfct_get_attr(ct, type),
+			  ipstr, sizeof(ipstr));
+		ret = snprintf(buf + offset, len, "%s ", ipstr);
+		break;
+	case CT_ATTR_TYPE_IPV6:
+		inet_ntop(AF_INET6, nfct_get_attr(ct, type),
+			  ipstr, sizeof(ipstr));
+		ret = snprintf(buf + offset, len, "%s ", ipstr);
+		break;
+	case CT_ATTR_TYPE_U32_BITMAP:
+		ret = ct_snprintf_u32_bitmap(buf + offset, len, ct, attr);
+		break;
+	default:
+		/* Unsupported datatype, should not ever happen */
+		ret = 0;
+		break;
+	}
+	BUFFER_SIZE(ret, size, len, offset);
+
+	return offset;
+}
+
+int ct_snprintf_opts(char *buf, unsigned int len, const struct nf_conntrack *ct,
+		     const struct ct_print_opts *attrs)
+{
+	unsigned int size = 0, offset = 0, ret;
+	int i;
+
+	for (i = 0; attrs[i].name; ++i) {
+		if (!nfct_attr_is_set(ct, attrs[i].type))
+			continue;
+
+		ret = ct_snprintf_attr(buf + offset, len, ct, &attrs[i]);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
+	return offset;
+}
+
+static struct ct_print_opts attrs_ipv4[] = {
+	{"-s", ATTR_ORIG_IPV4_SRC, CT_ATTR_TYPE_IPV4, 0, 0},
+	{"-d", ATTR_ORIG_IPV4_DST, CT_ATTR_TYPE_IPV4, 0, 0},
+	{"-g", ATTR_DNAT_IPV4, CT_ATTR_TYPE_IPV4, 0, 0},
+	{"-n", ATTR_SNAT_IPV4, CT_ATTR_TYPE_IPV4, 0, 0},
+	{"-r", ATTR_REPL_IPV4_SRC, CT_ATTR_TYPE_IPV4, 0, 0},
+	{"-q", ATTR_REPL_IPV4_DST, CT_ATTR_TYPE_IPV4, 0, 0},
+	{0, 0, 0, 0, 0},
+};
+
+static struct ct_print_opts attrs_ipv6[] = {
+	{"-s", ATTR_ORIG_IPV6_SRC, CT_ATTR_TYPE_IPV6, 0, 0},
+	{"-d", ATTR_ORIG_IPV6_DST, CT_ATTR_TYPE_IPV6, 0, 0},
+	{"-g", ATTR_DNAT_IPV6, CT_ATTR_TYPE_IPV6, 0, 0},
+	{"-n", ATTR_SNAT_IPV6, CT_ATTR_TYPE_IPV6, 0, 0},
+	{"-r", ATTR_REPL_IPV6_SRC, CT_ATTR_TYPE_IPV6, 0, 0},
+	{"-q", ATTR_REPL_IPV6_DST, CT_ATTR_TYPE_IPV6, 0, 0},
+	{0, 0, 0, 0, 0},
+};
+
+static const char *conntrack_status_map[] = {
+	[IPS_ASSURED_BIT] = "ASSURED",
+	[IPS_SEEN_REPLY_BIT] = "SEEN_REPLY",
+	[IPS_FIXED_TIMEOUT_BIT] = "FIXED_TIMEOUT",
+	[IPS_EXPECTED_BIT] = "EXPECTED"
+};
+
+static struct ct_print_opts attrs_generic[] = {
+	{"-t", ATTR_TIMEOUT, CT_ATTR_TYPE_U32, 0, 0},
+	{"-u", ATTR_STATUS, CT_ATTR_TYPE_U32_BITMAP,
+		sizeof(conntrack_status_map)/sizeof(conntrack_status_map[0]),
+		conntrack_status_map},
+	{"-c", ATTR_SECMARK, CT_ATTR_TYPE_U32, 0, 0},
+/*		{"-i", ATTR_ID, CT_ATTR_TYPE_U32, 0, 0}, */
+	{"-w", ATTR_ZONE, CT_ATTR_TYPE_U16, 0, 0},
+	{"--orig-zone", ATTR_ORIG_ZONE, CT_ATTR_TYPE_U16, 0, 0},
+	{"--reply-zone", ATTR_REPL_ZONE, CT_ATTR_TYPE_U16, 0, 0},
+	{},
+};
+
+static int ct_save_snprintf(char *buf, size_t len,
+			    const struct nf_conntrack *ct,
+			    struct nfct_labelmap *map,
+			    enum nf_conntrack_msg_type type)
+{
+	static struct ct_print_opts *attrs_l3;
+	unsigned int size = 0, offset = 0;
+	struct ctproto_handler *cur;
+	uint8_t l3proto, l4proto;
+	int ret;
+
+	switch (type) {
+	case NFCT_T_NEW:
+		ret = snprintf(buf + offset, len, "-I ");
+		BUFFER_SIZE(ret, size, len, offset);
+		break;
+	case NFCT_T_UPDATE:
+		ret = snprintf(buf + offset, len, "-U ");
+		BUFFER_SIZE(ret, size, len, offset);
+		break;
+	case NFCT_T_DESTROY:
+		ret = snprintf(buf + offset, len, "-D ");
+		BUFFER_SIZE(ret, size, len, offset);
+		break;
+	default:
+		ret = 0;
+		break;
+	}
+
+	ret = ct_snprintf_opts(buf + offset, len, ct, attrs_generic);
+	BUFFER_SIZE(ret, size, len, offset);
+
+	l3proto = nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO);
+	if (!l3proto)
+		l3proto = nfct_get_attr_u8(ct, ATTR_REPL_L3PROTO);
+	switch (l3proto) {
+	case AF_INET:
+		attrs_l3 = attrs_ipv4;
+		break;
+	case AF_INET6:
+		attrs_l3 = attrs_ipv6;
+		break;
+	default:
+		fprintf(stderr,
+				"WARNING: unknown l3proto %d, skipping..\n", l3proto);
+		return 0;
+	}
+
+	ret = ct_snprintf_opts(buf + offset, len, ct, attrs_l3);
+	BUFFER_SIZE(ret, size, len, offset);
+
+	l4proto = nfct_get_attr_u8(ct, ATTR_L4PROTO);
+
+	/* is it in the list of supported protocol? */
+	list_for_each_entry(cur, &proto_list, head) {
+		if (cur->protonum != l4proto)
+			continue;
+
+		ret = snprintf(buf + offset, len, "-p %s ", cur->name);
+		BUFFER_SIZE(ret, size, len, offset);
+
+		ret = ct_snprintf_opts(buf + offset, len, ct, cur->print_opts);
+		BUFFER_SIZE(ret, size, len, offset);
+		break;
+	}
+
+	/* skip trailing space, if any */
+	for (;size && buf[size-1] == ' '; --size)
+		buf[size-1] = '\0';
+
+	return size;
+}
+
 extern struct ctproto_handler ct_proto_unknown;
 
 static struct ctproto_handler *findproto(char *name, int *pnum)
@@ -856,6 +1091,7 @@ enum {
 	_O_KTMS	= (1 << 4),
 	_O_CL	= (1 << 5),
 	_O_US	= (1 << 6),
+	_O_SAVE	= (1 << 7),
 };
 
 enum {
@@ -866,7 +1102,7 @@ enum {
 };
 
 static struct parse_parameter {
-	const char	*parameter[7];
+	const char	*parameter[8];
 	size_t  size;
 	unsigned int value[8];
 } parse_array[PARSE_MAX] = {
@@ -874,8 +1110,8 @@ static struct parse_parameter {
 	  { IPS_ASSURED, IPS_SEEN_REPLY, 0, IPS_FIXED_TIMEOUT, IPS_EXPECTED, IPS_OFFLOAD, IPS_HW_OFFLOAD} },
 	{ {"ALL", "NEW", "UPDATES", "DESTROY"}, 4,
 	  { CT_EVENT_F_ALL, CT_EVENT_F_NEW, CT_EVENT_F_UPD, CT_EVENT_F_DEL } },
-	{ {"xml", "extended", "timestamp", "id", "ktimestamp", "labels", "userspace" }, 7,
-	  { _O_XML, _O_EXT, _O_TMS, _O_ID, _O_KTMS, _O_CL, _O_US },
+	{ {"xml", "extended", "timestamp", "id", "ktimestamp", "labels", "userspace", "save"}, 8,
+	  { _O_XML, _O_EXT, _O_TMS, _O_ID, _O_KTMS, _O_CL, _O_US, _O_SAVE },
 	},
 };
 
@@ -1458,6 +1694,11 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 	if (nfct_filter(obj, ct))
 		goto out;
 
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, type);
+		goto done;
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
@@ -1482,7 +1723,7 @@ static int event_cb(const struct nlmsghdr *nlh, void *data)
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf_labels(buf, sizeof(buf), ct, type, op_type, op_flags, labelmap);
-
+done:
 	if (output_mask & _O_US) {
 		if (nlh->nlmsg_pid)
 			userspace = true;
@@ -1511,6 +1752,11 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 	if (nfct_filter(obj, ct))
 		return NFCT_CB_CONTINUE;
 
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_NEW);
+		goto done;
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
@@ -1527,6 +1773,7 @@ static int dump_cb(enum nf_conntrack_msg_type type,
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
+done:
 	printf("%s\n", buf);
 
 	counter++;
@@ -1553,6 +1800,11 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 			   "Operation failed: %s",
 			   err2str(errno, CT_DELETE));
 
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_DESTROY);
+		goto done;
+	}
+
 	if (output_mask & _O_XML)
 		op_type = NFCT_O_XML;
 	if (output_mask & _O_EXT)
@@ -1561,6 +1813,7 @@ static int delete_cb(enum nf_conntrack_msg_type type,
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags);
+done:
 	printf("%s\n", buf);
 
 	counter++;
@@ -1576,6 +1829,11 @@ static int print_cb(enum nf_conntrack_msg_type type,
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
+	if (output_mask & _O_SAVE) {
+		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_NEW);
+		goto done;
+	}
+
 	if (output_mask & _O_XML)
 		op_type = NFCT_O_XML;
 	if (output_mask & _O_EXT)
@@ -1584,6 +1842,7 @@ static int print_cb(enum nf_conntrack_msg_type type,
 		op_flags |= NFCT_OF_ID;
 
 	nfct_snprintf_labels(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, op_type, op_flags, labelmap);
+done:
 	printf("%s\n", buf);
 
 	return NFCT_CB_CONTINUE;
@@ -1748,6 +2007,11 @@ static int dump_exp_cb(enum nf_conntrack_msg_type type,
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
+	if (output_mask & _O_SAVE) {
+		exit_error(PARAMETER_PROBLEM,
+		   "save output format is not supported for table of expectations");
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
@@ -1779,6 +2043,11 @@ static int event_exp_cb(enum nf_conntrack_msg_type type,
 	unsigned int op_type = NFCT_O_DEFAULT;
 	unsigned int op_flags = 0;
 
+	if (output_mask & _O_SAVE) {
+		exit_error(PARAMETER_PROBLEM,
+		   "save output format is not supported for table of expectations");
+	}
+
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
 		if (dump_xml_header_done) {
@@ -2445,6 +2714,10 @@ int main(int argc, char *argv[])
 			parse_parameter(optarg, &output_mask, PARSE_OUTPUT);
 			if (output_mask & _O_CL)
 				labelmap_init();
+			if ((output_mask & _O_SAVE) &&
+			    (output_mask & _O_XML))
+				exit_error(OTHER_PROBLEM,
+					   "cannot combine XML and save output types");
 			break;
 		case 'z':
 			options |= CT_OPT_ZERO;

--bg08WKrSYDhXBjb5--
