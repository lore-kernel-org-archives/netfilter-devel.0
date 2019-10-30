Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 167FACA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C96272087E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfJ3R1Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 13:27:16 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45114 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbfJ3R1Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 13:27:16 -0400
Received: from localhost ([::1]:58204 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iPrkY-0007m7-Sr; Wed, 30 Oct 2019 18:27:15 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 12/12] nft: bridge: Rudimental among extension support
Date:   Wed, 30 Oct 2019 18:27:01 +0100
Message-Id: <20191030172701.5892-13-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030172701.5892-1-phil@nwl.cc>
References: <20191030172701.5892-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support among match as far as possible given the limitations of nftables
sets, namely limited to homogeneous MAC address only or MAC and IP
address only matches.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v2:
- Move call to add_nft_among() here from previous patch.
- Large code review, simplify parsing code and share common bits between
  extension and nft-bridge.c.

Changes since v1:
- Fix for overlong lines.
- Use nftnl_set_list_lookup_byname() from libnftnl.
---
 extensions/libebt_among.c | 243 ++++++++++++++++++++++++++++++++++++++
 extensions/libebt_among.t |  16 +++
 iptables/ebtables-nft.8   |  66 ++++++-----
 iptables/nft-bridge.c     | 210 ++++++++++++++++++++++++++++++++
 iptables/nft-bridge.h     |  56 +++++++++
 iptables/nft.c            | 149 +++++++++++++++++++++++
 iptables/xtables-eb.c     |   1 +
 7 files changed, 710 insertions(+), 31 deletions(-)
 create mode 100644 extensions/libebt_among.c
 create mode 100644 extensions/libebt_among.t

diff --git a/extensions/libebt_among.c b/extensions/libebt_among.c
new file mode 100644
index 0000000000000..2e87db3bc06fa
--- /dev/null
+++ b/extensions/libebt_among.c
@@ -0,0 +1,243 @@
+/* ebt_among
+ *
+ * Authors:
+ * Grzegorz Borowiak <grzes@gnu.univ.gda.pl>
+ *
+ * August, 2003
+ */
+
+#include <ctype.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <xtables.h>
+#include <arpa/inet.h>
+#include <netinet/ether.h>
+#include <netinet/in.h>
+#include <linux/if_ether.h>
+#include <linux/netfilter_bridge/ebt_among.h>
+#include <sys/mman.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include "iptables/nft.h"
+#include "iptables/nft-bridge.h"
+
+#define AMONG_DST '1'
+#define AMONG_SRC '2'
+#define AMONG_DST_F '3'
+#define AMONG_SRC_F '4'
+
+static const struct option bramong_opts[] = {
+	{"among-dst", required_argument, 0, AMONG_DST},
+	{"among-src", required_argument, 0, AMONG_SRC},
+	{"among-dst-file", required_argument, 0, AMONG_DST_F},
+	{"among-src-file", required_argument, 0, AMONG_SRC_F},
+	{0}
+};
+
+static void bramong_print_help(void)
+{
+	printf(
+"`among' options:\n"
+"--among-dst      [!] list      : matches if ether dst is in list\n"
+"--among-src      [!] list      : matches if ether src is in list\n"
+"--among-dst-file [!] file      : obtain dst list from file\n"
+"--among-src-file [!] file      : obtain src list from file\n"
+"list has form:\n"
+" xx:xx:xx:xx:xx:xx[=ip.ip.ip.ip],yy:yy:yy:yy:yy:yy[=ip.ip.ip.ip]"
+",...,zz:zz:zz:zz:zz:zz[=ip.ip.ip.ip][,]\n"
+"Things in brackets are optional.\n"
+"If you want to allow two (or more) IP addresses to one MAC address, you\n"
+"can specify two (or more) pairs with the same MAC, e.g.\n"
+" 00:00:00:fa:eb:fe=153.19.120.250,00:00:00:fa:eb:fe=192.168.0.1\n"
+	);
+}
+
+static void
+parse_nft_among_pair(char *buf, struct nft_among_pair *pair, bool have_ip)
+{
+	char *sep = index(buf, '=');
+	struct ether_addr *ether;
+
+	if (have_ip ^ !!sep)
+		xtables_error(PARAMETER_PROBLEM,
+			      "among: Mixed MAC and MAC=IP not allowed.");
+
+	if (sep) {
+		*sep = '\0';
+
+		if (!inet_aton(sep + 1, &pair->in))
+			xtables_error(PARAMETER_PROBLEM,
+				      "Invalid IP address '%s'\n", sep + 1);
+	}
+	ether = ether_aton(buf);
+	if (!ether)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Invalid MAC address '%s'\n", buf);
+	memcpy(&pair->ether, ether, sizeof(*ether));
+}
+
+static void
+parse_nft_among_pairs(struct nft_among_pair *pairs, char *buf,
+		      size_t cnt, bool have_ip)
+{
+	size_t tmpcnt = 0;
+
+	buf = strtok(buf, ",");
+	while (buf) {
+		struct nft_among_pair pair = {};
+
+		parse_nft_among_pair(buf, &pair, have_ip);
+		nft_among_insert_pair(pairs, &tmpcnt, &pair);
+		buf = strtok(NULL, ",");
+	}
+}
+
+static size_t count_nft_among_pairs(char *buf)
+{
+	size_t cnt = 0;
+	char *p = buf;
+
+	if (!*buf)
+		return 0;
+
+	do {
+		cnt++;
+		p = index(++p, ',');
+	} while (p);
+
+	return cnt;
+}
+
+static bool nft_among_pairs_have_ip(char *buf)
+{
+	return !!index(buf, '=');
+}
+
+static int bramong_parse(int c, char **argv, int invert,
+		 unsigned int *flags, const void *entry,
+		 struct xt_entry_match **match)
+{
+	struct nft_among_data *data = (struct nft_among_data *)(*match)->data;
+	struct xt_entry_match *new_match;
+	bool have_ip, dst = false;
+	size_t new_size, cnt;
+	struct stat stats;
+	int fd = -1, poff;
+	long flen = 0;
+
+	switch (c) {
+	case AMONG_DST_F:
+		dst = true;
+		/* fall through */
+	case AMONG_SRC_F:
+		if ((fd = open(optarg, O_RDONLY)) == -1)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Couldn't open file '%s'", optarg);
+		fstat(fd, &stats);
+		flen = stats.st_size;
+		/* use mmap because the file will probably be big */
+		optarg = mmap(0, flen, PROT_READ | PROT_WRITE,
+			      MAP_PRIVATE, fd, 0);
+		if (optarg == MAP_FAILED)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Couldn't map file to memory");
+		if (optarg[flen-1] != '\n')
+			xtables_error(PARAMETER_PROBLEM,
+				      "File should end with a newline");
+		if (strchr(optarg, '\n') != optarg+flen-1)
+			xtables_error(PARAMETER_PROBLEM,
+				      "File should only contain one line");
+		optarg[flen-1] = '\0';
+		/* fall through */
+	case AMONG_DST:
+		if (c == AMONG_DST)
+			dst = true;
+		/* fall through */
+	case AMONG_SRC:
+		break;
+	default:
+		return 0;
+	}
+
+	cnt = count_nft_among_pairs(optarg);
+	if (cnt == 0)
+		return 0;
+
+	new_size = data->src.cnt + data->dst.cnt + cnt;
+	new_size *= sizeof(struct nft_among_pair);
+	new_size += XT_ALIGN(sizeof(struct xt_entry_match)) +
+			sizeof(struct nft_among_data);
+	new_match = xtables_calloc(1, new_size);
+	memcpy(new_match, *match, (*match)->u.match_size);
+	new_match->u.match_size = new_size;
+
+	data = (struct nft_among_data *)new_match->data;
+	have_ip = nft_among_pairs_have_ip(optarg);
+	poff = nft_among_prepare_data(data, dst, cnt, invert, have_ip);
+	parse_nft_among_pairs(data->pairs + poff, optarg, cnt, have_ip);
+
+	free(*match);
+	*match = new_match;
+
+	if (c == AMONG_DST_F || c == AMONG_SRC_F) {
+		munmap(argv, flen);
+		close(fd);
+	}
+	return 1;
+}
+
+static void __bramong_print(struct nft_among_pair *pairs,
+			    int cnt, bool inv, bool have_ip)
+{
+	const char *isep = inv ? "! " : "";
+	int i;
+
+	for (i = 0; i < cnt; i++) {
+		printf("%s", isep);
+		isep = ",";
+
+		printf("%s", ether_ntoa(&pairs[i].ether));
+		if (have_ip)
+			printf("=%s", inet_ntoa(pairs[i].in));
+	}
+	printf(" ");
+}
+
+static void bramong_print(const void *ip, const struct xt_entry_match *match,
+			  int numeric)
+{
+	struct nft_among_data *data = (struct nft_among_data *)match->data;
+
+	if (data->src.cnt) {
+		printf("--among-src ");
+		__bramong_print(data->pairs,
+				data->src.cnt, data->src.inv, data->src.ip);
+	}
+	if (data->dst.cnt) {
+		printf("--among-dst ");
+		__bramong_print(data->pairs + data->src.cnt,
+				data->dst.cnt, data->dst.inv, data->dst.ip);
+	}
+}
+
+static struct xtables_match bramong_match = {
+	.name		= "among",
+	.revision	= 0,
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_BRIDGE,
+	.size		= XT_ALIGN(sizeof(struct nft_among_data)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nft_among_data)),
+	.help		= bramong_print_help,
+	.parse		= bramong_parse,
+	.print		= bramong_print,
+	.extra_opts	= bramong_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&bramong_match);
+}
diff --git a/extensions/libebt_among.t b/extensions/libebt_among.t
new file mode 100644
index 0000000000000..56b299161ff31
--- /dev/null
+++ b/extensions/libebt_among.t
@@ -0,0 +1,16 @@
+:INPUT,FORWARD,OUTPUT
+--among-dst de:ad:0:be:ee:ff,c0:ff:ee:0:ba:be;--among-dst c0:ff:ee:0:ba:be,de:ad:0:be:ee:ff;OK
+--among-dst ! c0:ff:ee:0:ba:be,de:ad:0:be:ee:ff;=;OK
+--among-src be:ef:0:c0:ff:ee,c0:ff:ee:0:ba:be,de:ad:0:be:ee:ff;=;OK
+--among-src de:ad:0:be:ee:ff=10.0.0.1,c0:ff:ee:0:ba:be=192.168.1.1;--among-src c0:ff:ee:0:ba:be=192.168.1.1,de:ad:0:be:ee:ff=10.0.0.1;OK
+--among-src ! c0:ff:ee:0:ba:be=192.168.1.1,de:ad:0:be:ee:ff=10.0.0.1;=;OK
+--among-src de:ad:0:be:ee:ff --among-dst c0:ff:ee:0:ba:be;=;OK
+--among-src de:ad:0:be:ee:ff=10.0.0.1 --among-dst c0:ff:ee:0:ba:be=192.168.1.1;=;OK
+--among-src ! de:ad:0:be:ee:ff --among-dst c0:ff:ee:0:ba:be;=;OK
+--among-src de:ad:0:be:ee:ff=10.0.0.1 --among-dst ! c0:ff:ee:0:ba:be=192.168.1.1;=;OK
+--among-src ! de:ad:0:be:ee:ff --among-dst c0:ff:ee:0:ba:be=192.168.1.1;=;OK
+--among-src de:ad:0:be:ee:ff=10.0.0.1 --among-dst ! c0:ff:ee:0:ba:be=192.168.1.1;=;OK
+--among-src;=;FAIL
+--among-src 00:11=10.0.0.1;=;FAIL
+--among-src de:ad:0:be:ee:ff=10.256.0.1;=;FAIL
+--among-src de:ad:0:be:ee:ff,c0:ff:ee:0:ba:be=192.168.1.1;=;FAIL
diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index db8b2ab28cca5..a91f0c1aacb0f 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -522,35 +522,39 @@ If the 802.3 DSAP and SSAP values are 0xaa then the SNAP type field must
 be consulted to determine the payload protocol.  This is a two byte
 (hexadecimal) argument.  Only 802.3 frames with DSAP/SSAP 0xaa are
 checked for type.
-.\" .SS among
-.\" Match a MAC address or MAC/IP address pair versus a list of MAC addresses
-.\" and MAC/IP address pairs.
-.\" A list entry has the following format:
-.\" .IR xx:xx:xx:xx:xx:xx[=ip.ip.ip.ip][,] ". Multiple"
-.\" list entries are separated by a comma, specifying an IP address corresponding to
-.\" the MAC address is optional. Multiple MAC/IP address pairs with the same MAC address
-.\" but different IP address (and vice versa) can be specified. If the MAC address doesn't
-.\" match any entry from the list, the frame doesn't match the rule (unless "!" was used).
-.\" .TP
-.\" .BR "--among-dst " "[!] \fIlist\fP"
-.\" Compare the MAC destination to the given list. If the Ethernet frame has type
-.\" .IR IPv4 " or " ARP ,
-.\" then comparison with MAC/IP destination address pairs from the
-.\" list is possible.
-.\" .TP
-.\" .BR "--among-src " "[!] \fIlist\fP"
-.\" Compare the MAC source to the given list. If the Ethernet frame has type
-.\" .IR IPv4 " or " ARP ,
-.\" then comparison with MAC/IP source address pairs from the list
-.\" is possible.
-.\" .TP
-.\" .BR "--among-dst-file " "[!] \fIfile\fP"
-.\" Same as
-.\" .BR --among-dst " but the list is read in from the specified file."
-.\" .TP
-.\" .BR "--among-src-file " "[!] \fIfile\fP"
-.\" Same as
-.\" .BR --among-src " but the list is read in from the specified file."
+.SS among
+Match a MAC address or MAC/IP address pair versus a list of MAC addresses
+and MAC/IP address pairs.
+A list entry has the following format:
+.IR xx:xx:xx:xx:xx:xx[=ip.ip.ip.ip][,] ". Multiple"
+list entries are separated by a comma, specifying an IP address corresponding to
+the MAC address is optional. Multiple MAC/IP address pairs with the same MAC address
+but different IP address (and vice versa) can be specified. If the MAC address doesn't
+match any entry from the list, the frame doesn't match the rule (unless "!" was used).
+.TP
+.BR "--among-dst " "[!] \fIlist\fP"
+Compare the MAC destination to the given list. If the Ethernet frame has type
+.IR IPv4 " or " ARP ,
+then comparison with MAC/IP destination address pairs from the
+list is possible.
+.TP
+.BR "--among-src " "[!] \fIlist\fP"
+Compare the MAC source to the given list. If the Ethernet frame has type
+.IR IPv4 " or " ARP ,
+then comparison with MAC/IP source address pairs from the list
+is possible.
+.TP
+.BR "--among-dst-file " "[!] \fIfile\fP"
+Same as
+.BR --among-dst " but the list is read in from the specified file."
+.TP
+.BR "--among-src-file " "[!] \fIfile\fP"
+Same as
+.BR --among-src " but the list is read in from the specified file."
+.PP
+Note that in this implementation of ebtables, among lists uses must be
+internally homogeneous regarding whether IP addresses are present or not. Mixed
+use of MAC addresses and MAC/IP address pairs is not supported yet.
 .SS arp
 Specify (R)ARP fields. The protocol must be specified as
 .IR ARP " or " RARP .
@@ -1108,8 +1112,8 @@ arp message and the hardware address length in the arp header is 6 bytes.
 The version of ebtables this man page ships with does not support the
 .B broute
 table. Also there is no support for
-.BR among " and " string
-matches. And finally, this list is probably not complete.
+.B string
+match. And finally, this list is probably not complete.
 .SH SEE ALSO
 .BR xtables-nft "(8), " iptables "(8), " ip (8)
 .PP
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 20ce92a6d5242..3f85cbbf5e4cf 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -17,8 +17,11 @@
 #include <libiptc/libxtc.h>
 #include <linux/netfilter/nf_tables.h>
 
+#include <libnftnl/set.h>
+
 #include "nft-shared.h"
 #include "nft-bridge.h"
+#include "nft-cache.h"
 #include "nft.h"
 
 void ebt_cs_clean(struct iptables_command_state *cs)
@@ -291,6 +294,212 @@ static void nft_bridge_parse_immediate(const char *jumpto, bool nft_goto,
 	cs->jumpto = jumpto;
 }
 
+/* return 0 if saddr, 1 if daddr, -1 on error */
+static int
+lookup_check_ether_payload(uint32_t base, uint32_t offset, uint32_t len)
+{
+	if (base != 0 || len != ETH_ALEN)
+		return -1;
+
+	switch (offset) {
+	case offsetof(struct ether_header, ether_dhost):
+		return 1;
+	case offsetof(struct ether_header, ether_shost):
+		return 0;
+	default:
+		return -1;
+	}
+}
+
+/* return 0 if saddr, 1 if daddr, -1 on error */
+static int
+lookup_check_iphdr_payload(uint32_t base, uint32_t offset, uint32_t len)
+{
+	if (base != 1 || len != 4)
+		return -1;
+
+	switch (offset) {
+	case offsetof(struct iphdr, daddr):
+		return 1;
+	case offsetof(struct iphdr, saddr):
+		return 0;
+	default:
+		return -1;
+	}
+}
+
+/* Make sure previous payload expression(s) is/are consistent and extract if
+ * matching on source or destination address and if matching on MAC and IP or
+ * only MAC address. */
+static int lookup_analyze_payloads(const struct nft_xt_ctx *ctx,
+				   bool *dst, bool *ip)
+{
+	int val, val2 = -1;
+
+	if (ctx->flags & NFT_XT_CTX_PREV_PAYLOAD) {
+		val = lookup_check_ether_payload(ctx->prev_payload.base,
+						 ctx->prev_payload.offset,
+						 ctx->prev_payload.len);
+		if (val < 0) {
+			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
+			       ctx->prev_payload.base, ctx->prev_payload.offset,
+			       ctx->prev_payload.len);
+			return -1;
+		}
+		if (!(ctx->flags & NFT_XT_CTX_PAYLOAD)) {
+			DEBUGP("Previous but no current payload?\n");
+			return -1;
+		}
+		val2 = lookup_check_iphdr_payload(ctx->payload.base,
+						  ctx->payload.offset,
+						  ctx->payload.len);
+		if (val2 < 0) {
+			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
+			       ctx->payload.base, ctx->payload.offset,
+			       ctx->payload.len);
+			return -1;
+		} else if (val != val2) {
+			DEBUGP("mismatching payload match offsets\n");
+			return -1;
+		}
+	} else if (ctx->flags & NFT_XT_CTX_PAYLOAD) {
+		val = lookup_check_ether_payload(ctx->payload.base,
+						 ctx->payload.offset,
+						 ctx->payload.len);
+		if (val < 0) {
+			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
+			       ctx->payload.base, ctx->payload.offset,
+			       ctx->payload.len);
+			return -1;
+		}
+	} else {
+		DEBUGP("unknown LHS of lookup expression\n");
+		return -1;
+	}
+
+	if (dst)
+		*dst = (val == 1);
+	if (ip)
+		*ip = (val2 != -1);
+	return 0;
+}
+
+static int set_elems_to_among_pairs(struct nft_among_pair *pairs,
+				    const struct nftnl_set *s, int cnt)
+{
+	struct nftnl_set_elems_iter *iter = nftnl_set_elems_iter_create(s);
+	struct nftnl_set_elem *elem;
+	size_t tmpcnt = 0;
+	const void *data;
+	uint32_t datalen;
+	int ret = -1;
+
+	if (!iter) {
+		fprintf(stderr, "BUG: set elems iter allocation failed\n");
+		return ret;
+	}
+
+	while ((elem = nftnl_set_elems_iter_next(iter))) {
+		data = nftnl_set_elem_get(elem, NFTNL_SET_ELEM_KEY, &datalen);
+		if (!data) {
+			fprintf(stderr, "BUG: set elem without key\n");
+			goto err;
+		}
+		if (datalen > sizeof(*pairs)) {
+			fprintf(stderr, "BUG: overlong set elem\n");
+			goto err;
+		}
+		nft_among_insert_pair(pairs, &tmpcnt, data);
+	}
+	ret = 0;
+err:
+	nftnl_set_elems_iter_destroy(iter);
+	return ret;
+}
+
+static struct nftnl_set *set_from_lookup_expr(struct nft_xt_ctx *ctx,
+					      const struct nftnl_expr *e)
+{
+	const char *set_name = nftnl_expr_get_str(e, NFTNL_EXPR_LOOKUP_SET);
+	struct nftnl_set_list *slist;
+
+	slist = nft_set_list_get(ctx->h, ctx->table, set_name);
+	if (slist)
+		return nftnl_set_list_lookup_byname(slist, set_name);
+
+	return NULL;
+}
+
+static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,
+				    struct nftnl_expr *e, void *data)
+{
+	struct xtables_match *match = NULL;
+	struct nft_among_data *among_data;
+	bool is_dst, have_ip, inv;
+	struct ebt_match *ematch;
+	struct nftnl_set *s;
+	size_t poff, size;
+	uint32_t cnt;
+
+	if (lookup_analyze_payloads(ctx, &is_dst, &have_ip))
+		return;
+
+	s = set_from_lookup_expr(ctx, e);
+	if (!s)
+		xtables_error(OTHER_PROBLEM,
+			      "BUG: lookup expression references unknown set");
+
+	cnt = nftnl_set_get_u32(s, NFTNL_SET_DESC_SIZE);
+
+	for (ematch = ctx->cs->match_list; ematch; ematch = ematch->next) {
+		if (!ematch->ismatch || strcmp(ematch->u.match->name, "among"))
+			continue;
+
+		match = ematch->u.match;
+		among_data = (struct nft_among_data *)match->m->data;
+
+		size = cnt + among_data->src.cnt + among_data->dst.cnt;
+		size *= sizeof(struct nft_among_pair);
+
+		size += XT_ALIGN(sizeof(struct xt_entry_match)) +
+			sizeof(struct nft_among_data);
+
+		match->m = xtables_realloc(match->m, size);
+		break;
+	}
+	if (!match) {
+		match = xtables_find_match("among", XTF_TRY_LOAD,
+					   &ctx->cs->matches);
+
+		size = cnt * sizeof(struct nft_among_pair);
+		size += XT_ALIGN(sizeof(struct xt_entry_match)) +
+			sizeof(struct nft_among_data);
+
+		match->m = xtables_calloc(1, size);
+		strcpy(match->m->u.user.name, match->name);
+		match->m->u.user.revision = match->revision;
+		xs_init_match(match);
+
+		if (ctx->h->ops->parse_match != NULL)
+			ctx->h->ops->parse_match(match, ctx->cs);
+	}
+	if (!match)
+		return;
+
+	match->m->u.match_size = size;
+
+	inv = !!(nftnl_expr_get_u32(e, NFTNL_EXPR_LOOKUP_FLAGS) &
+				    NFT_LOOKUP_F_INV);
+
+	among_data = (struct nft_among_data *)match->m->data;
+	poff = nft_among_prepare_data(among_data, is_dst, cnt, inv, have_ip);
+	if (set_elems_to_among_pairs(among_data->pairs + poff, s, cnt))
+		xtables_error(OTHER_PROBLEM,
+			      "ebtables among pair parsing failed");
+
+	ctx->flags &= ~(NFT_XT_CTX_PAYLOAD | NFT_XT_CTX_PREV_PAYLOAD);
+}
+
 static void parse_watcher(void *object, struct ebt_match **match_list,
 			  bool ismatch)
 {
@@ -742,6 +951,7 @@ struct nft_family_ops nft_family_ops_bridge = {
 	.parse_meta		= nft_bridge_parse_meta,
 	.parse_payload		= nft_bridge_parse_payload,
 	.parse_immediate	= nft_bridge_parse_immediate,
+	.parse_lookup		= nft_bridge_parse_lookup,
 	.parse_match		= nft_bridge_parse_match,
 	.parse_target		= nft_bridge_parse_target,
 	.print_table_header	= nft_bridge_print_table_header,
diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
index d90066f1030a2..eb1b3928b6543 100644
--- a/iptables/nft-bridge.h
+++ b/iptables/nft-bridge.h
@@ -122,4 +122,60 @@ void ebt_add_watcher(struct xtables_target *watcher,
                      struct iptables_command_state *cs);
 int ebt_command_default(struct iptables_command_state *cs);
 
+struct nft_among_pair {
+	struct ether_addr ether;
+	struct in_addr in __attribute__((aligned (4)));
+};
+
+struct nft_among_data {
+	struct {
+		size_t cnt;
+		bool inv;
+		bool ip;
+	} src, dst;
+	/* first source, then dest pairs */
+	struct nft_among_pair pairs[0];
+};
+
+/* initialize fields, return offset into pairs array to write pairs to */
+static inline size_t
+nft_among_prepare_data(struct nft_among_data *data, bool dst,
+		       size_t cnt, bool inv, bool ip)
+{
+	size_t poff;
+
+	if (dst) {
+		data->dst.cnt = cnt;
+		data->dst.inv = inv;
+		data->dst.ip = ip;
+		poff = data->src.cnt;
+	} else {
+		data->src.cnt = cnt;
+		data->src.inv = inv;
+		data->src.ip = ip;
+		poff = 0;
+		memmove(data->pairs + cnt, data->pairs,
+			data->dst.cnt * sizeof(*data->pairs));
+	}
+	return poff;
+}
+
+static inline void
+nft_among_insert_pair(struct nft_among_pair *pairs,
+		      size_t *pcount, const struct nft_among_pair *new)
+{
+	int i;
+
+	/* nftables automatically sorts set elements from smallest to largest,
+	 * insert sorted so extension comparison works */
+
+	for (i = 0; i < *pcount; i++) {
+		if (memcmp(new, &pairs[i], sizeof(*new)) < 0)
+			break;
+	}
+	memmove(&pairs[i + 1], &pairs[i], sizeof(*pairs) * (*pcount - i));
+	memcpy(&pairs[i], new, sizeof(*new));
+	(*pcount)++;
+}
+
 #endif
diff --git a/iptables/nft.c b/iptables/nft.c
index 111d4982b1181..8c0088b46c45d 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -944,6 +944,153 @@ static int add_nft_limit(struct nftnl_rule *r, struct xt_entry_match *m)
 	return 0;
 }
 
+static struct nftnl_set *add_anon_set(struct nft_handle *h, const char *table,
+				      uint32_t flags, uint32_t key_type,
+				      uint32_t key_len, uint32_t size)
+{
+	static uint32_t set_id = 0;
+	struct nftnl_set *s;
+
+	s = nftnl_set_alloc();
+	if (!s)
+		return NULL;
+
+	nftnl_set_set_u32(s, NFTNL_SET_FAMILY, h->family);
+	nftnl_set_set_str(s, NFTNL_SET_TABLE, table);
+	nftnl_set_set_str(s, NFTNL_SET_NAME, "__set%d");
+	nftnl_set_set_u32(s, NFTNL_SET_ID, ++set_id);
+	nftnl_set_set_u32(s, NFTNL_SET_FLAGS,
+			  NFT_SET_ANONYMOUS | NFT_SET_CONSTANT | flags);
+	nftnl_set_set_u32(s, NFTNL_SET_KEY_TYPE, key_type);
+	nftnl_set_set_u32(s, NFTNL_SET_KEY_LEN, key_len);
+	nftnl_set_set_u32(s, NFTNL_SET_DESC_SIZE, size);
+
+	return batch_set_add(h, NFT_COMPAT_SET_ADD, s) ? s : NULL;
+}
+
+static struct nftnl_expr *
+gen_payload(uint32_t base, uint32_t offset, uint32_t len, uint32_t dreg)
+{
+	struct nftnl_expr *e = nftnl_expr_alloc("payload");
+
+	if (!e)
+		return NULL;
+	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_BASE, base);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_OFFSET, offset);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_LEN, len);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_PAYLOAD_DREG, dreg);
+	return e;
+}
+
+static struct nftnl_expr *
+gen_lookup(uint32_t sreg, const char *set_name, uint32_t set_id, uint32_t flags)
+{
+	struct nftnl_expr *e = nftnl_expr_alloc("lookup");
+
+	if (!e)
+		return NULL;
+	nftnl_expr_set_u32(e, NFTNL_EXPR_LOOKUP_SREG, sreg);
+	nftnl_expr_set_str(e, NFTNL_EXPR_LOOKUP_SET, set_name);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_LOOKUP_SET_ID, set_id);
+	nftnl_expr_set_u32(e, NFTNL_EXPR_LOOKUP_FLAGS, flags);
+	return e;
+}
+
+/* simplified nftables:include/netlink.h, netlink_padded_len() */
+#define NETLINK_ALIGN		4
+
+/* from nftables:include/datatype.h, TYPE_BITS */
+#define CONCAT_TYPE_BITS	6
+
+/* from nftables:include/datatype.h, enum datatypes */
+#define NFT_DATATYPE_IPADDR	7
+#define NFT_DATATYPE_ETHERADDR	9
+
+static int __add_nft_among(struct nft_handle *h, const char *table,
+			   struct nftnl_rule *r, struct nft_among_pair *pairs,
+			   int cnt, bool dst, bool inv, bool ip)
+{
+	uint32_t set_id, type = NFT_DATATYPE_ETHERADDR, len = ETH_ALEN;
+	/* { !dst, dst } */
+	static const int eth_addr_off[] = {
+		offsetof(struct ether_header, ether_shost),
+		offsetof(struct ether_header, ether_dhost)
+	};
+	static const int ip_addr_off[] = {
+		offsetof(struct iphdr, saddr),
+		offsetof(struct iphdr, daddr)
+	};
+	struct nftnl_expr *e;
+	struct nftnl_set *s;
+	int idx = 0;
+
+	if (ip) {
+		type = type << CONCAT_TYPE_BITS | NFT_DATATYPE_IPADDR;
+		len += sizeof(struct in_addr) + NETLINK_ALIGN - 1;
+		len &= ~(NETLINK_ALIGN - 1);
+	}
+
+	s = add_anon_set(h, table, 0, type, len, cnt);
+	if (!s)
+		return -ENOMEM;
+	set_id = nftnl_set_get_u32(s, NFTNL_SET_ID);
+
+	for (idx = 0; idx < cnt; idx++) {
+		struct nftnl_set_elem *elem = nftnl_set_elem_alloc();
+
+		if (!elem)
+			return -ENOMEM;
+		nftnl_set_elem_set(elem, NFTNL_SET_ELEM_KEY,
+				   &pairs[idx], len);
+		nftnl_set_elem_add(s, elem);
+	}
+
+	e = gen_payload(NFT_PAYLOAD_LL_HEADER,
+			eth_addr_off[dst], ETH_ALEN, NFT_REG_1);
+	if (!e)
+		return -ENOMEM;
+	nftnl_rule_add_expr(r, e);
+
+	if (ip) {
+		e = gen_payload(NFT_PAYLOAD_NETWORK_HEADER, ip_addr_off[dst],
+				sizeof(struct in_addr), NFT_REG32_02);
+		if (!e)
+			return -ENOMEM;
+		nftnl_rule_add_expr(r, e);
+	}
+
+	e = gen_lookup(NFT_REG_1, "__set%d", set_id, inv);
+	if (!e)
+		return -ENOMEM;
+	nftnl_rule_add_expr(r, e);
+
+	return 0;
+}
+
+static int add_nft_among(struct nft_handle *h,
+			 struct nftnl_rule *r, struct xt_entry_match *m)
+{
+	struct nft_among_data *data = (struct nft_among_data *)m->data;
+	const char *table = nftnl_rule_get(r, NFTNL_RULE_TABLE);
+
+	if ((data->src.cnt && data->src.ip) ||
+	    (data->dst.cnt && data->dst.ip)) {
+		uint16_t eth_p_ip = htons(ETH_P_IP);
+
+		add_meta(r, NFT_META_PROTOCOL);
+		add_cmp_ptr(r, NFT_CMP_EQ, &eth_p_ip, 2);
+	}
+
+	if (data->src.cnt)
+		__add_nft_among(h, table, r, data->pairs, data->src.cnt,
+				false, data->src.inv, data->src.ip);
+	if (data->dst.cnt)
+		__add_nft_among(h, table, r, data->pairs + data->src.cnt,
+				data->dst.cnt, true, data->dst.inv,
+				data->dst.ip);
+	return 0;
+}
+
 int add_match(struct nft_handle *h,
 	      struct nftnl_rule *r, struct xt_entry_match *m)
 {
@@ -952,6 +1099,8 @@ int add_match(struct nft_handle *h,
 
 	if (!strcmp(m->u.user.name, "limit"))
 		return add_nft_limit(r, m);
+	else if (!strcmp(m->u.user.name, "among"))
+		return add_nft_among(h, r, m);
 
 	expr = nftnl_expr_alloc("match");
 	if (expr == NULL)
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index fd7d601f6136a..15b971da3d425 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -594,6 +594,7 @@ void ebt_load_match_extensions(void)
 	ebt_load_match("pkttype");
 	ebt_load_match("vlan");
 	ebt_load_match("stp");
+	ebt_load_match("among");
 
 	ebt_load_watcher("log");
 	ebt_load_watcher("nflog");
-- 
2.23.0

