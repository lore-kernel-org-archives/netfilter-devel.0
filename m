Return-Path: <SRS0=O/k4=YS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FDECA9EA0
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 16:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A72421872
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Oct 2019 16:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633107AbfJYQho (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:37:44 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:33142 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633105AbfJYQho (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 12:37:44 -0400
Received: from localhost ([::1]:46232 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iO2as-0003Au-1d; Fri, 25 Oct 2019 18:37:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xtables-arp: Use xtables_ipparse_multiple()
Date:   Fri, 25 Oct 2019 18:37:33 +0200
Message-Id: <20191025163733.28576-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the same code for parsing source and destination IP addresses as
iptables and drop all the local functions dealing with that.

While being at it, call free() for 'saddrs' and 'daddrs' unconditionally
(like iptables does), they are NULL if not used.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-arp.c | 243 +++++------------------------------------
 1 file changed, 30 insertions(+), 213 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index c2b44871c3842..2ab046c9bac5f 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -219,89 +219,10 @@ static int get16_and_mask(char *from, uint16_t *to, uint16_t *mask, int base)
 	return 0;
 }
 
-static int
-string_to_number(const char *s, unsigned int min, unsigned int max,
-		 unsigned int *ret)
-{
-	long number;
-	char *end;
-
-	/* Handle hex, octal, etc. */
-	errno = 0;
-	number = strtol(s, &end, 0);
-	if (*end == '\0' && end != s) {
-		/* we parsed a number, let's see if we want this */
-		if (errno != ERANGE && min <= number && number <= max) {
-			*ret = number;
-			return 0;
-		}
-	}
-	return -1;
-}
-
 /*********************************************/
 /* ARPTABLES SPECIFIC NEW FUNCTIONS END HERE */
 /*********************************************/
 
-static struct in_addr *
-dotted_to_addr(const char *dotted)
-{
-	static struct in_addr addr;
-	unsigned char *addrp;
-	char *p, *q;
-	unsigned int onebyte;
-	int i;
-	char buf[20];
-
-	/* copy dotted string, because we need to modify it */
-	strncpy(buf, dotted, sizeof(buf) - 1);
-	addrp = (unsigned char *) &(addr.s_addr);
-
-	p = buf;
-	for (i = 0; i < 3; i++) {
-		if ((q = strchr(p, '.')) == NULL)
-			return (struct in_addr *) NULL;
-
-		*q = '\0';
-		if (string_to_number(p, 0, 255, &onebyte) == -1)
-			return (struct in_addr *) NULL;
-
-		addrp[i] = (unsigned char) onebyte;
-		p = q + 1;
-	}
-
-	/* we've checked 3 bytes, now we check the last one */
-	if (string_to_number(p, 0, 255, &onebyte) == -1)
-		return (struct in_addr *) NULL;
-
-	addrp[3] = (unsigned char) onebyte;
-
-	return &addr;
-}
-
-static struct in_addr *
-network_to_addr(const char *name)
-{
-	struct netent *net;
-	static struct in_addr addr;
-
-	if ((net = getnetbyname(name)) != NULL) {
-		if (net->n_addrtype != AF_INET)
-			return (struct in_addr *) NULL;
-		addr.s_addr = htonl((unsigned long) net->n_net);
-		return &addr;
-	}
-
-	return (struct in_addr *) NULL;
-}
-
-static void
-inaddrcpy(struct in_addr *dst, struct in_addr *src)
-{
-	/* memcpy(dst, src, sizeof(struct in_addr)); */
-	dst->s_addr = src->s_addr;
-}
-
 static void
 exit_tryhelp(int status)
 {
@@ -434,127 +355,6 @@ check_inverse(const char option[], int *invert, int *optidx, int argc)
 	return false;
 }
 
-static struct in_addr *
-host_to_addr(const char *name, unsigned int *naddr)
-{
-	struct in_addr *addr;
-	struct addrinfo hints = {
-		.ai_flags	= AI_CANONNAME,
-		.ai_family	= AF_INET,
-		.ai_socktype	= SOCK_RAW,
-	};;
-	struct addrinfo *res, *p;
-	int err;
-	unsigned int i;
-
-	*naddr = 0;
-	err = getaddrinfo(name, NULL, &hints, &res);
-	if (err != 0)
-		return NULL;
-	else {
-		for (p = res; p != NULL; p = p->ai_next)
-			(*naddr)++;
-		addr = xtables_calloc(*naddr, sizeof(struct in_addr));
-		for (i = 0, p = res; p != NULL; p = p->ai_next)
-			memcpy(&addr[i++],
-			       &((const struct sockaddr_in *)p->ai_addr)->sin_addr,
-			       sizeof(struct in_addr));
-		freeaddrinfo(res);
-		return addr;
-	}
-
-	return (struct in_addr *) NULL;
-}
-
-/*
- *	All functions starting with "parse" should succeed, otherwise
- *	the program fails.
- *	Most routines return pointers to static data that may change
- *	between calls to the same or other routines with a few exceptions:
- *	"host_to_addr", "parse_hostnetwork", and "parse_hostnetworkmask"
- *	return global static data.
-*/
-
-static struct in_addr *
-parse_hostnetwork(const char *name, unsigned int *naddrs)
-{
-	struct in_addr *addrp, *addrptmp;
-
-	if ((addrptmp = dotted_to_addr(name)) != NULL ||
-	    (addrptmp = network_to_addr(name)) != NULL) {
-		addrp = xtables_malloc(sizeof(struct in_addr));
-		inaddrcpy(addrp, addrptmp);
-		*naddrs = 1;
-		return addrp;
-	}
-	if ((addrp = host_to_addr(name, naddrs)) != NULL)
-		return addrp;
-
-	xtables_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
-}
-
-static struct in_addr *
-parse_mask(char *mask)
-{
-	static struct in_addr maskaddr;
-	struct in_addr *addrp;
-	unsigned int bits;
-
-	if (mask == NULL) {
-		/* no mask at all defaults to 32 bits */
-		maskaddr.s_addr = 0xFFFFFFFF;
-		return &maskaddr;
-	}
-	if ((addrp = dotted_to_addr(mask)) != NULL)
-		/* dotted_to_addr already returns a network byte order addr */
-		return addrp;
-	if (string_to_number(mask, 0, 32, &bits) == -1)
-		xtables_error(PARAMETER_PROBLEM,
-			      "invalid mask `%s' specified", mask);
-	if (bits != 0) {
-		maskaddr.s_addr = htonl(0xFFFFFFFF << (32 - bits));
-		return &maskaddr;
-	}
-
-	maskaddr.s_addr = 0L;
-	return &maskaddr;
-}
-
-static void
-parse_hostnetworkmask(const char *name, struct in_addr **addrpp,
-		      struct in_addr *maskp, unsigned int *naddrs)
-{
-	struct in_addr *addrp;
-	char buf[256];
-	char *p;
-	int i, j, k, n;
-
-	strncpy(buf, name, sizeof(buf) - 1);
-	if ((p = strrchr(buf, '/')) != NULL) {
-		*p = '\0';
-		addrp = parse_mask(p + 1);
-	} else
-		addrp = parse_mask(NULL);
-	inaddrcpy(maskp, addrp);
-
-	/* if a null mask is given, the name is ignored, like in "any/0" */
-	if (maskp->s_addr == 0L)
-		strcpy(buf, "0.0.0.0");
-
-	addrp = *addrpp = parse_hostnetwork(buf, naddrs);
-	n = *naddrs;
-	for (i = 0, j = 0; i < n; i++) {
-		addrp[j++].s_addr &= maskp->s_addr;
-		for (k = 0; k < j - 1; k++) {
-			if (addrp[k].s_addr == addrp[j - 1].s_addr) {
-				(*naddrs)--;
-				j--;
-				break;
-			}
-		}
-	}
-}
-
 static void
 parse_interface(const char *arg, char *vianame, unsigned char *mask)
 {
@@ -647,8 +447,10 @@ append_entry(struct nft_handle *h,
 	     int rulenum,
 	     unsigned int nsaddrs,
 	     const struct in_addr saddrs[],
+	     const struct in_addr smasks[],
 	     unsigned int ndaddrs,
 	     const struct in_addr daddrs[],
+	     const struct in_addr dmasks[],
 	     bool verbose, bool append)
 {
 	unsigned int i, j;
@@ -656,8 +458,10 @@ append_entry(struct nft_handle *h,
 
 	for (i = 0; i < nsaddrs; i++) {
 		cs->arp.arp.src.s_addr = saddrs[i].s_addr;
+		cs->arp.arp.smsk.s_addr = smasks[i].s_addr;
 		for (j = 0; j < ndaddrs; j++) {
 			cs->arp.arp.tgt.s_addr = daddrs[j].s_addr;
+			cs->arp.arp.tmsk.s_addr = dmasks[j].s_addr;
 			if (append) {
 				ret = nft_rule_append(h, chain, table, cs, NULL,
 						      verbose);
@@ -677,11 +481,15 @@ replace_entry(const char *chain,
 	      struct iptables_command_state *cs,
 	      unsigned int rulenum,
 	      const struct in_addr *saddr,
+	      const struct in_addr *smask,
 	      const struct in_addr *daddr,
+	      const struct in_addr *dmask,
 	      bool verbose, struct nft_handle *h)
 {
 	cs->arp.arp.src.s_addr = saddr->s_addr;
 	cs->arp.arp.tgt.s_addr = daddr->s_addr;
+	cs->arp.arp.smsk.s_addr = smask->s_addr;
+	cs->arp.arp.tmsk.s_addr = dmask->s_addr;
 
 	return nft_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
@@ -692,8 +500,10 @@ delete_entry(const char *chain,
 	     struct iptables_command_state *cs,
 	     unsigned int nsaddrs,
 	     const struct in_addr saddrs[],
+	     const struct in_addr smasks[],
 	     unsigned int ndaddrs,
 	     const struct in_addr daddrs[],
+	     const struct in_addr dmasks[],
 	     bool verbose, struct nft_handle *h)
 {
 	unsigned int i, j;
@@ -701,8 +511,10 @@ delete_entry(const char *chain,
 
 	for (i = 0; i < nsaddrs; i++) {
 		cs->arp.arp.src.s_addr = saddrs[i].s_addr;
+		cs->arp.arp.smsk.s_addr = smasks[i].s_addr;
 		for (j = 0; j < ndaddrs; j++) {
 			cs->arp.arp.tgt.s_addr = daddrs[j].s_addr;
+			cs->arp.arp.tmsk.s_addr = dmasks[j].s_addr;
 			ret = nft_rule_delete(h, chain, table, cs, verbose);
 		}
 	}
@@ -752,7 +564,8 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 	};
 	int invert = 0;
 	unsigned int nsaddrs = 0, ndaddrs = 0;
-	struct in_addr *saddrs = NULL, *daddrs = NULL;
+	struct in_addr *saddrs = NULL, *smasks = NULL;
+	struct in_addr *daddrs = NULL, *dmasks = NULL;
 
 	int c, verbose = 0;
 	const char *chain = NULL;
@@ -1118,12 +931,12 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 	}
 
 	if (shostnetworkmask)
-		parse_hostnetworkmask(shostnetworkmask, &saddrs,
-				      &(cs.arp.arp.smsk), &nsaddrs);
+		xtables_ipparse_multiple(shostnetworkmask, &saddrs,
+					 &smasks, &nsaddrs);
 
 	if (dhostnetworkmask)
-		parse_hostnetworkmask(dhostnetworkmask, &daddrs,
-				      &(cs.arp.arp.tmsk), &ndaddrs);
+		xtables_ipparse_multiple(dhostnetworkmask, &daddrs,
+					 &dmasks, &ndaddrs);
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
 	    (cs.arp.arp.invflags & (ARPT_INV_SRCIP | ARPT_INV_TGTIP)))
@@ -1162,12 +975,14 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 	switch (command) {
 	case CMD_APPEND:
 		ret = append_entry(h, chain, *table, &cs, 0,
-				   nsaddrs, saddrs, ndaddrs, daddrs,
+				   nsaddrs, saddrs, smasks,
+				   ndaddrs, daddrs, dmasks,
 				   options&OPT_VERBOSE, true);
 		break;
 	case CMD_DELETE:
 		ret = delete_entry(chain, *table, &cs,
-				   nsaddrs, saddrs, ndaddrs, daddrs,
+				   nsaddrs, saddrs, smasks,
+				   ndaddrs, daddrs, dmasks,
 				   options&OPT_VERBOSE, h);
 		break;
 	case CMD_DELETE_NUM:
@@ -1175,11 +990,13 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 		break;
 	case CMD_REPLACE:
 		ret = replace_entry(chain, *table, &cs, rulenum - 1,
-				    saddrs, daddrs, options&OPT_VERBOSE, h);
+				    saddrs, smasks, daddrs, dmasks,
+				    options&OPT_VERBOSE, h);
 		break;
 	case CMD_INSERT:
 		ret = append_entry(h, chain, *table, &cs, rulenum - 1,
-				   nsaddrs, saddrs, ndaddrs, daddrs,
+				   nsaddrs, saddrs, smasks,
+				   ndaddrs, daddrs, dmasks,
 				   options&OPT_VERBOSE, false);
 		break;
 	case CMD_LIST:
@@ -1228,10 +1045,10 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 		exit_tryhelp(2);
 	}
 
-	if (nsaddrs)
-		free(saddrs);
-	if (ndaddrs)
-		free(daddrs);
+	free(saddrs);
+	free(smasks);
+	free(daddrs);
+	free(dmasks);
 
 	if (cs.target)
 		free(cs.target->t);
-- 
2.23.0

