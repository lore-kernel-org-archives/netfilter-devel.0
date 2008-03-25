From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/32]: nf_conntrack_sip: fix some off-by-ones
Date: Tue, 25 Mar 2008 15:15:03 +0100 (MET)
Message-ID: <20080325141503.10539.18351.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32914 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYCYOPE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:04 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: fix some off-by-ones

"limit" marks the first character outside the bounds.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3e654acbb82002c6fdc57573c8167ade5608dbd3
tree e04d2649131a18732f66d253366d9d3962a5d1bc
parent b76b0afe5818cb9aac50d57e0be319935f58ed64
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:44:50 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:54 +0100

 net/netfilter/nf_conntrack_sip.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 0021d5b..016e1c1 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -192,10 +192,10 @@ int ct_sip_lnlen(const char *line, const char *limit)
 {
 	const char *k = line;
 
-	while ((line <= limit) && (*line == '\r' || *line == '\n'))
+	while ((line < limit) && (*line == '\r' || *line == '\n'))
 		line++;
 
-	while (line <= limit) {
+	while (line < limit) {
 		if (*line == '\r' || *line == '\n')
 			break;
 		line++;
@@ -211,7 +211,7 @@ const char *ct_sip_search(const char *needle, const char *haystack,
 {
 	const char *limit = haystack + (haystack_len - needle_len);
 
-	while (haystack <= limit) {
+	while (haystack < limit) {
 		if (case_sensitive) {
 			if (strncmp(haystack, needle, needle_len) == 0)
 				return haystack;
@@ -229,7 +229,7 @@ static int digits_len(const struct nf_conn *ct, const char *dptr,
 		      const char *limit, int *shift)
 {
 	int len = 0;
-	while (dptr <= limit && isdigit(*dptr)) {
+	while (dptr < limit && isdigit(*dptr)) {
 		dptr++;
 		len++;
 	}
@@ -240,7 +240,7 @@ static int digits_len(const struct nf_conn *ct, const char *dptr,
 static int skp_digits_len(const struct nf_conn *ct, const char *dptr,
 			  const char *limit, int *shift)
 {
-	for (; dptr <= limit && *dptr == ' '; dptr++)
+	for (; dptr < limit && *dptr == ' '; dptr++)
 		(*shift)++;
 
 	return digits_len(ct, dptr, limit, shift);
@@ -302,13 +302,13 @@ static int skp_epaddr_len(const struct nf_conn *ct, const char *dptr,
 	/* Search for @, but stop at the end of the line.
 	 * We are inside a sip: URI, so we don't need to worry about
 	 * continuation lines. */
-	while (dptr <= limit &&
+	while (dptr < limit &&
 	       *dptr != '@' && *dptr != '\r' && *dptr != '\n') {
 		(*shift)++;
 		dptr++;
 	}
 
-	if (dptr <= limit && *dptr == '@') {
+	if (dptr < limit && *dptr == '@') {
 		dptr++;
 		(*shift)++;
 	} else {
@@ -332,7 +332,7 @@ int ct_sip_get_info(const struct nf_conn *ct,
 
 	limit = dptr + (dlen - hnfo->lnlen);
 
-	while (dptr <= limit) {
+	while (dptr < limit) {
 		if ((strncmp(dptr, hnfo->lname, hnfo->lnlen) != 0) &&
 		    (hnfo->sname == NULL ||
 		     strncmp(dptr, hnfo->sname, hnfo->snlen) != 0)) {
