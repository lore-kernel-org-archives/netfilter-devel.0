From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 04/19] [NETFILTER]: annotate rest of nf_conntrack_* with
 const
Date: Tue, 4 Mar 2008 17:30:54 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041730330.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40660 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765477AbYCDQaz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:55 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 18f903b716553f4dda61cc5f936323698b98e29b
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Fri Jan 25 20:52:56 2008 +0100

    [NETFILTER]: annotate rest of nf_conntrack_* with const
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c |    8 ++++----
 net/netfilter/nf_conntrack_amanda.c     |    2 +-
 net/netfilter/nf_conntrack_ftp.c        |    5 +++--
 net/netfilter/nf_conntrack_helper.c     |    2 +-
 net/netfilter/nf_conntrack_irc.c        |   14 ++++++++------
 5 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 2a0d698..d4a42f0 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -103,8 +103,8 @@ struct ctl_table nf_ct_ipv6_sysctl_table[] = {
 };
 #endif
 
-static unsigned int ip6qhashfn(__be32 id, struct in6_addr *saddr,
-			       struct in6_addr *daddr)
+static unsigned int ip6qhashfn(__be32 id, const struct in6_addr *saddr,
+                               const struct in6_addr *daddr)
 {
 	u32 a, b, c;
 
@@ -132,7 +132,7 @@ static unsigned int ip6qhashfn(__be32 id, struct in6_addr *saddr,
 
 static unsigned int nf_hashfn(struct inet_frag_queue *q)
 {
-	struct nf_ct_frag6_queue *nq;
+	const struct nf_ct_frag6_queue *nq;
 
 	nq = container_of(q, struct nf_ct_frag6_queue, q);
 	return ip6qhashfn(nq->id, &nq->saddr, &nq->daddr);
@@ -220,7 +220,7 @@ oom:
 
 
 static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
-			     struct frag_hdr *fhdr, int nhoff)
+			     const struct frag_hdr *fhdr, int nhoff)
 {
 	struct sk_buff *prev, *next;
 	int offset, end;
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 7b8239c..572eedf 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -53,7 +53,7 @@ enum amanda_strings {
 };
 
 static struct {
-	char			*string;
+	const char		*string;
 	size_t			len;
 	struct ts_config	*ts;
 } search[] __read_mostly = {
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 6770baf..e0a2877 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -350,8 +350,9 @@ static int help(struct sk_buff *skb,
 		enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff, datalen;
-	struct tcphdr _tcph, *th;
-	char *fb_ptr;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
+	const char *fb_ptr;
 	int ret;
 	u32 seq;
 	int dir = CTINFO2DIR(ctinfo);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b1fd21c..367e23c 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -125,7 +125,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_expect *exp;
-	struct hlist_node *n, *next;
+	const struct hlist_node *n, *next;
 	unsigned int i;
 
 	mutex_lock(&nf_ct_helper_mutex);
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index c336b07..37a5ae5 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -50,7 +50,7 @@ MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels per "
 module_param(dcc_timeout, uint, 0400);
 MODULE_PARM_DESC(dcc_timeout, "timeout on for unestablished DCC channels");
 
-static const char *dccprotos[] = {
+static const char *const dccprotos[] = {
 	"SEND ", "CHAT ", "MOVE ", "TSEND ", "SCHAT "
 };
 
@@ -65,7 +65,7 @@ static const char *dccprotos[] = {
  *	ad_beg_p	returns pointer to first byte of addr data
  *	ad_end_p	returns pointer to last byte of addr data
  */
-static int parse_dcc(char *data, char *data_end, u_int32_t *ip,
+static int parse_dcc(char *data, const char *data_end, u_int32_t *ip,
 		     u_int16_t *port, char **ad_beg_p, char **ad_end_p)
 {
 	/* at least 12: "AAAAAAAA P\1\n" */
@@ -93,9 +93,11 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 		struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff;
-	struct iphdr *iph;
-	struct tcphdr _tcph, *th;
-	char *data, *data_limit, *ib_ptr;
+	const struct iphdr *iph;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
+	const char *data_limit;
+	char *data, *ib_ptr;
 	int dir = CTINFO2DIR(ctinfo);
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple *tuple;
@@ -159,7 +161,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 			/* we have at least
 			 * (19+MINMATCHLEN)-5-dccprotos[i].matchlen bytes valid
 			 * data left (== 14/13 bytes) */
-			if (parse_dcc((char *)data, data_limit, &dcc_ip,
+			if (parse_dcc(data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
 				pr_debug("unable to parse dcc command\n");
 				continue;
