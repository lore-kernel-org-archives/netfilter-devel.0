From: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.dk>
Subject: [PATCH 1/3] conntrack: add support for netmask filtering
Date: Tue, 13 Jan 2015 11:55:10 +0000
Message-ID: <1421150112-3836-2-git-send-email-ast@fiberby.dk>
References: <1421150112-3836-1-git-send-email-ast@fiberby.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([81.7.185.110]:33024 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbbAML5L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:57:11 -0500
In-Reply-To: <1421150112-3836-1-git-send-email-ast@fiberby.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch extends --mask-src and --mask-dst to also work
with the conntrack table, with commands -L, -D and -E.

Signed-off-by: Asbj=C3=B8rn Sloth T=C3=B8nnesen <ast@fiberby.dk>
---
 conntrack.8     |   7 ++-
 src/conntrack.c | 148 ++++++++++++++++++++++++++++++++++++++++++++++++=
+++-----
 2 files changed, 142 insertions(+), 13 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index abc26c5..4bb8bfe 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -183,10 +183,13 @@ Specify the tuple source address of an expectatio=
n.
 Specify the tuple destination address of an expectation.
 .TP
 .BI "--mask-src " IP_ADDRESS
-Specify the source address mask of an expectation.
+Specify the source address mask.
+For conntrack this option is only available in conjunction with "\-L, =
\-\-dump", "\-E, \-\-event", or "\-D \-\-delete".
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
index 1e45ca8..ceafb0c 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -366,13 +366,13 @@ static char commands_v_options[NUMBER_OF_CMD][NUM=
BER_OF_OPT] =3D
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
           /*   s d r q p t u z e [ ] { } a m i f n g o c b j w l < > *=
/
-/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,0,0,0,2,0,2,2,2,2,2,0,2,2,2,0,0},
+/*CT_LIST*/   {2,2,2,2,2,0,2,2,0,0,0,2,2,0,2,0,2,2,2,2,2,0,2,2,2,0,0},
 /*CT_CREATE*/ {3,3,3,3,1,1,2,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,0,2,0,2,0},
 /*CT_UPDATE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,2,2,2},
-/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,2,2,0,0},
+/*CT_DELETE*/ {2,2,2,2,2,2,2,0,0,0,0,2,2,0,2,2,2,2,2,2,0,0,0,2,2,0,0},
 /*CT_GET*/    {3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0,2,0,0},
 /*CT_FLUSH*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
-/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,0,0,0,2,0,0,2,2,2,2,2,2,2,2,0,0},
+/*CT_EVENT*/  {2,2,2,2,2,0,0,0,2,0,0,2,2,0,2,0,0,2,2,2,2,2,2,2,2,0,0},
 /*VERSION*/   {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 /*HELP*/      {0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
 /*EXP_LIST*/  {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,2,0,0,0,0,0,0,0},
@@ -446,6 +446,27 @@ static const int opt2attr[] =3D {
 	['>']	=3D ATTR_CONNLABELS,
 };
=20
+enum direction {
+	DIR_SRC =3D 0,
+	DIR_DST =3D 1,
+};
+
+union ct_address {
+	uint32_t v4;
+	uint32_t v6[4];
+};
+
+static struct network {
+	union ct_address netmask;
+	union ct_address network;
+} dir2network[2];
+
+
+static const int famdir2attr[2][2] =3D {
+	{ ATTR_ORIG_IPV4_SRC, ATTR_ORIG_IPV4_DST },
+	{ ATTR_ORIG_IPV6_SRC, ATTR_ORIG_IPV6_DST }
+};
+
 static char exit_msg[NUMBER_OF_CMD][64] =3D {
 	[CT_LIST_BIT] 		=3D "%d flow entries have been shown.\n",
 	[CT_CREATE_BIT]		=3D "%d flow entries have been created.\n",
@@ -487,9 +508,7 @@ static const char usage_conntrack_parameters[] =3D
 static const char usage_expectation_parameters[] =3D
 	"Expectation parameters and options:\n"
 	"  --tuple-src ip\tSource address in expect tuple\n"
-	"  --tuple-dst ip\tDestination address in expect tuple\n"
-	"  --mask-src ip\t\tSource mask address\n"
-	"  --mask-dst ip\t\tDestination mask address\n";
+	"  --tuple-dst ip\tDestination address in expect tuple\n";
=20
 static const char usage_update_parameters[] =3D
 	"Updating parameters and options:\n"
@@ -508,6 +527,8 @@ static const char usage_parameters[] =3D
 	"  -u, --status status\t\tSet status, eg. ASSURED\n"
 	"  -w, --zone value\t\tSet conntrack zone\n"
 	"  -b, --buffer-size\t\tNetlink socket buffer size\n"
+	"  --mask-src ip\t\t\tSource mask address\n"
+	"  --mask-dst ip\t\t\tDestination mask address\n"
 	;
=20
 #define OPTION_OFFSET 256
@@ -515,6 +536,7 @@ static const char usage_parameters[] =3D
 static struct nfct_handle *cth, *ith;
 static struct option *opts =3D original_opts;
 static unsigned int global_option_offset =3D 0;
+static int global_family;
=20
 #define ADDR_VALID_FLAGS_MAX   2
 static unsigned int addr_valid_flags[ADDR_VALID_FLAGS_MAX] =3D {
@@ -985,11 +1007,6 @@ parse_inetaddr(const char *cp, struct addr_parse =
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
@@ -1187,6 +1204,50 @@ filter_nat(const struct nf_conntrack *obj, const=
 struct nf_conntrack *ct)
 	return 0;
 }
=20
+static int
+filter_network_direction(const struct nf_conntrack *ct, enum direction=
 dir)
+{
+	const int family =3D global_family;
+	const union ct_address *address;
+	enum nf_conntrack_attr attr;
+	int i;
+	struct network *net =3D &dir2network[dir];
+
+	if (nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO) !=3D family)
+		return 1;
+
+	attr =3D famdir2attr[family =3D=3D AF_INET6][dir];
+
+	address =3D nfct_get_attr(ct, attr);
+
+	if (family =3D=3D AF_INET) {
+		if ((address->v4 & net->netmask.v4) !=3D net->network.v4)
+			return 1;
+	} else if (family =3D=3D AF_INET6) {
+		for (i=3D0;i<4;i++)
+			if ((address->v6[i] & net->netmask.v6[i])
+			     !=3D net->network.v6[i])
+				return 1;
+	}
+
+	return 0;
+}
+
+static int
+filter_network(const struct nf_conntrack *ct)
+{
+	if (options & CT_OPT_MASK_SRC) {
+		if (filter_network_direction(ct, DIR_SRC))
+			return 1;
+	}
+
+	if (options & CT_OPT_MASK_DST) {
+		if (filter_network_direction(ct, DIR_DST))
+			return 1;
+	}
+	return 0;
+}
+
 static int counter;
 static int dump_xml_header_done =3D 1;
=20
@@ -1236,6 +1297,9 @@ static int event_cb(enum nf_conntrack_msg_type ty=
pe,
 	if (filter_label(ct))
 		return NFCT_CB_CONTINUE;
=20
+	if (filter_network(ct))
+		return NFCT_CB_CONTINUE;
+
 	if (options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return NFCT_CB_CONTINUE;
@@ -1291,6 +1355,9 @@ static int dump_cb(enum nf_conntrack_msg_type typ=
e,
 	if (filter_label(ct))
 		return NFCT_CB_CONTINUE;
=20
+	if (filter_network(ct))
+		return NFCT_CB_CONTINUE;
+
 	if (options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return NFCT_CB_CONTINUE;
@@ -1334,6 +1401,9 @@ static int delete_cb(enum nf_conntrack_msg_type t=
ype,
 	if (filter_mark(ct))
 		return NFCT_CB_CONTINUE;
=20
+	if (filter_network(ct))
+		return NFCT_CB_CONTINUE;
+
 	if (options & CT_COMPARISON &&
 	    !nfct_cmp(obj, ct, NFCT_CMP_ALL | NFCT_CMP_MASK))
 		return NFCT_CB_CONTINUE;
@@ -1907,6 +1977,52 @@ static void labelmap_init(void)
 		perror("nfct_labelmap_new");
 }
=20
+static void
+network_attr_prepare(enum direction dir)
+{
+	const int family =3D global_family;
+	const union ct_address *address, *netmask;
+	enum nf_conntrack_attr attr;
+	int i;
+	struct network *net =3D &dir2network[dir];
+
+	attr =3D famdir2attr[family =3D=3D AF_INET6][dir];
+
+	address =3D nfct_get_attr(tmpl.ct, attr);
+	netmask =3D nfct_get_attr(tmpl.mask, attr);
+
+	if (family =3D=3D AF_INET) {
+		net->network.v4 =3D address->v4 & netmask->v4;
+	} else if (family =3D=3D AF_INET6) {
+		for (i=3D0;i<4;i++)
+			net->network.v6[i] =3D address->v6[i] & netmask->v6[i];
+	}
+
+	memcpy(&net->netmask, netmask, sizeof(union ct_address));
+
+	/* avoid exact source matching */
+	if (nfct_attr_unset(tmpl.ct, attr) =3D=3D -1)
+		perror("nfct_attr_unset");
+}
+
+static void
+network_prepare(void)
+{
+	if (options & CT_OPT_MASK_SRC) {
+		if (!(options & CT_OPT_ORIG_SRC))
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't use --mask-src without --src");
+		network_attr_prepare(DIR_SRC);
+	}
+
+	if (options & CT_OPT_MASK_DST) {
+		if (!(options & CT_OPT_ORIG_DST))
+			exit_error(PARAMETER_PROBLEM,
+			           "Can't use --mask-dst without --dst");
+		network_attr_prepare(DIR_DST);
+	}
+}
+
 static void merge_bitmasks(struct nfct_bitmask **current,
 			  struct nfct_bitmask *src)
 {
@@ -2201,6 +2317,9 @@ int main(int argc, char *argv[])
 	if (family =3D=3D AF_UNSPEC)
 		family =3D AF_INET;
=20
+	/* store family */
+	global_family =3D family;
+
 	/* we cannot check this combination with generic_opt_check. */
 	if (options & CT_OPT_ANY_NAT &&
 	   ((options & CT_OPT_SRC_NAT) || (options & CT_OPT_DST_NAT))) {
@@ -2264,6 +2383,8 @@ int main(int argc, char *argv[])
 			exit_error(PARAMETER_PROBLEM, "Can't use -z with "
 						      "filtering parameters");
=20
+		network_prepare();
+
 		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, tmpl.ct);
=20
 		filter_dump =3D nfct_filter_dump_create();
@@ -2363,6 +2484,8 @@ int main(int argc, char *argv[])
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
=20
+		network_prepare();
+
 		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, tmpl.ct);
=20
 		filter_dump =3D nfct_filter_dump_create();
@@ -2464,6 +2587,9 @@ int main(int argc, char *argv[])
 			fprintf(stderr, "NOTICE: Netlink socket buffer size "
 					"has been set to %zu bytes.\n", ret);
 		}
+
+		network_prepare();
+
 		signal(SIGINT, event_sighandler);
 		signal(SIGTERM, event_sighandler);
 		nfct_callback_register(cth, NFCT_T_ALL, event_cb, tmpl.ct);
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
