From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH conntrack 4/5 v2] conntrack: add support for netmask filtering
Date: Mon, 25 Jan 2016 11:15:47 +0000
Message-ID: <1453720548-14413-4-git-send-email-ast@fiberby.dk>
References: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:38392 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbcAYLQI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2016 06:16:08 -0500
In-Reply-To: <1453720548-14413-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch extends --mask-src and --mask-dst to also work
with the conntrack table, with commands -L, -D, -E and -U.

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---

Notes:
    This is almost completely backward compatible,
    since the --mask-* arguments previously gave
    an error is used with these commands and the
    conntrack table.
   =20
    I have changed the global_family to filter_family,
    and it is only used to pass the family to the callback,
    the alternative would be to change the data argument of
    the callbacks to a struct.

 conntrack.8     |   7 ++-
 src/conntrack.c | 158 ++++++++++++++++++++++++++++++++++++++++++++++++=
+++-----
 2 files changed, 150 insertions(+), 15 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index 970c2d7..5bba1b1 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -191,10 +191,13 @@ Specify the tuple source address of an expectatio=
n.
 Specify the tuple destination address of an expectation.
 .TP
 .BI "--mask-src " IP_ADDRESS
-Specify the source address mask of an expectation.
+Specify the source address mask.
+For conntrack this option is only available in conjunction with "\-L, =
\-\-dump", "\-E, \-\-event", "\-U \-\-update" or "\-D \-\-delete".
+For expectations this option is only available in conjunction with "\-=
I, \-\-create".
 .TP
 .BI "--mask-dst " IP_ADDRESS
-Specify the destination address mask of an expectation.
+Specify the destination address mask.
+Same limitations as for "--mask-src".
 .SS PROTOCOL FILTER PARAMETERS
 .TP
 TCP-specific fields:
diff --git a/src/conntrack.c b/src/conntrack.c
index 3fc9c24..34785f3 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -377,13 +377,13 @@ static char commands_v_options[NUMBER_OF_CMD][NUM=
BER_OF_OPT] =3D
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
           /*   s d r q p t u z e [ ] { } a m i f n g o c b j w l < > (=
 ) */
-/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,0,0,0,2,0,2,2,2,2,2,0,2,2,2,0,0,2=
,2},
+/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,2,2,0,2,0,2,2,2,2,2,0,2,2,2,0,0,2=
,2},
 /*CT_CREATE*/ {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0,2=
,2},
-/*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,2,2,2,0=
,0},
-/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,2,2,0,0,2=
,2},
+/*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,0,2,2,2,0=
,0},
+/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,2,2,0,0,2=
,2},
 /*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0,0=
,0},
 /*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0=
,0},
-/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,0,0,0,2,0,0,2,2,2,2,2,2,2,2,0,0,2=
,2},
+/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,2,2,0,2,0,0,2,2,2,2,2,2,2,2,0,0,2=
,2},
 /*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0=
,0},
 /*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0=
,0},
 /*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0,0=
,0},
@@ -465,6 +465,26 @@ static const int opt2attr[] =3D {
 	[')']	=3D ATTR_REPL_ZONE,
 };
=20
+enum ct_direction {
+	DIR_SRC =3D 0,
+	DIR_DST =3D 1,
+};
+
+union ct_address {
+	uint32_t v4;
+	uint32_t v6[4];
+};
+
+static struct ct_network {
+	union ct_address netmask;
+	union ct_address network;
+} dir2network[2];
+
+static const int famdir2attr[2][2] =3D {
+	{ ATTR_ORIG_IPV4_SRC, ATTR_ORIG_IPV4_DST },
+	{ ATTR_ORIG_IPV6_SRC, ATTR_ORIG_IPV6_DST }
+};
+
 static char exit_msg[NUMBER_OF_CMD][64] =3D {
 	[CT_LIST_BIT] 		=3D "%d flow entries have been shown.\n",
 	[CT_CREATE_BIT]		=3D "%d flow entries have been created.\n",
@@ -507,8 +527,7 @@ static const char usage_expectation_parameters[] =3D
 	"Expectation parameters and options:\n"
 	"  --tuple-src ip\tSource address in expect tuple\n"
 	"  --tuple-dst ip\tDestination address in expect tuple\n"
-	"  --mask-src ip\t\tSource mask address\n"
-	"  --mask-dst ip\t\tDestination mask address\n";
+	;
=20
 static const char usage_update_parameters[] =3D
 	"Updating parameters and options:\n"
@@ -529,6 +548,8 @@ static const char usage_parameters[] =3D
 	"  --orig-zone value\t\tSet zone for original direction\n"
 	"  --reply-zone value\t\tSet zone for reply direction\n"
 	"  -b, --buffer-size\t\tNetlink socket buffer size\n"
+	"  --mask-src ip\t\t\tSource mask address\n"
+	"  --mask-dst ip\t\t\tDestination mask address\n"
 	;
=20
 #define OPTION_OFFSET 256
@@ -547,6 +568,7 @@ static LIST_HEAD(proto_list);
=20
 static unsigned int options;
 static struct nfct_labelmap *labelmap;
+static int filter_family;
=20
 void register_proto(struct ctproto_handler *h)
 {
@@ -1006,11 +1028,6 @@ parse_inetaddr(const char *cp, struct addr_parse=
 *parse)
 	return AF_UNSPEC;
 }
=20
-union ct_address {
-	uint32_t v4;
-	uint32_t v6[4];
-};
-
 static int
 parse_addr(const char *cp, union ct_address *address)
 {
@@ -1215,11 +1232,68 @@ filter_nat(const struct nf_conntrack *obj, cons=
t struct nf_conntrack *ct)
 }
=20
 static int
+nfct_ip6_net_cmp(const union ct_address *addr, const struct ct_network=
 *net)
+{
+	int i;
+	for (i=3D0;i<4;i++)
+		if ((addr->v6[i] & net->netmask.v6[i]) !=3D net->network.v6[i])
+			return 1;
+	return 0;
+}
+
+static int
+nfct_ip_net_cmp(int family, const union ct_address *addr,
+                const struct ct_network *net)
+{
+	switch(family) {
+	case AF_INET:
+		return (addr->v4 & net->netmask.v4) !=3D net->network.v4;
+	case AF_INET6:
+		return nfct_ip6_net_cmp(addr, net);
+	default:
+		return 0;
+	}
+}
+
+static int
+nfct_filter_network_direction(const struct nf_conntrack *ct, enum ct_d=
irection dir)
+{
+	const int family =3D filter_family;
+	const union ct_address *address;
+	enum nf_conntrack_attr attr;
+	struct ct_network *net =3D &dir2network[dir];
+
+	if (nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO) !=3D family)
+		return 1;
+
+	attr =3D famdir2attr[family =3D=3D AF_INET6][dir];
+	address =3D nfct_get_attr(ct, attr);
+
+	return nfct_ip_net_cmp(family, address, net);
+}
+
+static int
+filter_network(const struct nf_conntrack *ct)
+{
+	if (options & CT_OPT_MASK_SRC) {
+		if (nfct_filter_network_direction(ct, DIR_SRC))
+			return 1;
+	}
+
+	if (options & CT_OPT_MASK_DST) {
+		if (nfct_filter_network_direction(ct, DIR_DST))
+			return 1;
+	}
+	return 0;
+}
+
+static int
 nfct_filter(struct nf_conntrack *obj, struct nf_conntrack *ct)
 {
 	if (filter_nat(obj, ct) ||
 	    filter_mark(ct) ||
-	    filter_label(ct))
+	    filter_label(ct) ||
+	    filter_network(ct))
 		return 1;
=20
 	if (options & CT_COMPARISON &&
@@ -1490,7 +1564,8 @@ static int update_cb(enum nf_conntrack_msg_type t=
ype,
 	struct nf_conntrack *obj =3D data, *tmp;
=20
 	if (filter_nat(obj, ct) ||
-	    filter_label(ct))
+	    filter_label(ct) ||
+	    filter_network(ct))
 		return NFCT_CB_CONTINUE;
=20
 	if (nfct_attr_is_set(obj, ATTR_ID) && nfct_attr_is_set(ct, ATTR_ID) &=
&
@@ -1934,6 +2009,54 @@ static void labelmap_init(void)
 		perror("nfct_labelmap_new");
 }
=20
+static void
+nfct_network_attr_prepare(const int family, enum ct_direction dir)
+{
+	const union ct_address *address, *netmask;
+	enum nf_conntrack_attr attr;
+	int i;
+	struct ct_network *net =3D &dir2network[dir];
+
+	attr =3D famdir2attr[family =3D=3D AF_INET6][dir];
+
+	address =3D nfct_get_attr(tmpl.ct, attr);
+	netmask =3D nfct_get_attr(tmpl.mask, attr);
+
+	switch(family) {
+	case AF_INET:
+		net->network.v4 =3D address->v4 & netmask->v4;
+		break;
+	case AF_INET6:
+		for (i=3D0;i<4;i++)
+			net->network.v6[i] =3D address->v6[i] & netmask->v6[i];
+		break;
+	}
+
+	memcpy(&net->netmask, netmask, sizeof(union ct_address));
+
+	/* avoid exact source matching */
+	nfct_attr_unset(tmpl.ct, attr);
+}
+
+static void
+nfct_filter_init(const int family)
+{
+	filter_family =3D family;
+	if (options & CT_OPT_MASK_SRC) {
+		if (!(options & CT_OPT_ORIG_SRC))
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't use --mask-src without --src");
+		nfct_network_attr_prepare(family, DIR_SRC);
+	}
+
+	if (options & CT_OPT_MASK_DST) {
+		if (!(options & CT_OPT_ORIG_DST))
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't use --mask-dst without --dst");
+		nfct_network_attr_prepare(family, DIR_DST);
+	}
+}
+
 static void merge_bitmasks(struct nfct_bitmask **current,
 			  struct nfct_bitmask *src)
 {
@@ -2289,6 +2412,8 @@ int main(int argc, char *argv[])
 			exit_error(PARAMETER_PROBLEM, "Can't use -z with "
 						      "filtering parameters");
=20
+		nfct_filter_init(family);
+
 		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, tmpl.ct);
=20
 		filter_dump =3D nfct_filter_dump_create();
@@ -2375,6 +2500,8 @@ int main(int argc, char *argv[])
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
=20
+		nfct_filter_init(family);
+
 		nfct_callback_register(cth, NFCT_T_ALL, update_cb, tmpl.ct);
=20
 		res =3D nfct_query(cth, NFCT_Q_DUMP, &family);
@@ -2388,6 +2515,8 @@ int main(int argc, char *argv[])
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
=20
+		nfct_filter_init(family);
+
 		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, tmpl.ct);
=20
 		filter_dump =3D nfct_filter_dump_create();
@@ -2489,6 +2618,9 @@ int main(int argc, char *argv[])
 			fprintf(stderr, "NOTICE: Netlink socket buffer size "
 					"has been set to %zu bytes.\n", ret);
 		}
+
+		nfct_filter_init(family);
+
 		signal(SIGINT, event_sighandler);
 		signal(SIGTERM, event_sighandler);
 		nfct_callback_register(cth, NFCT_T_ALL, event_cb, tmpl.ct);
--=20
2.6.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
