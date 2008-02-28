From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 10/32]: nf_conntrack_sip: fix some off-by-ones
Date: Thu, 28 Feb 2008 13:00:10 +0100 (MET)
Message-ID: <20080228120001.29267.81917.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49985 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157AbYB1MAL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:11 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: fix some off-by-ones

"limit" marks the first character outside the bounds.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2b495a3c3db1a1e4149e5d8d7b26868660c9d9dd
tree 63961796393c19fbba790fab098e12adbd34429b
parent 2d4b798a4a54565722b4022ab08d1d97f01badbc
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:17 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:17 +0100

 net/netfilter/nf_conntrack_sip.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index b6848b7..d3aaeab 100644
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
@@ -311,13 +311,13 @@ static int skp_epaddr_len(const struct nf_conn *ct, const char *dptr,
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
@@ -341,7 +341,7 @@ int ct_sip_get_info(const struct nf_conn *ct,
 
 	limit = dptr + (dlen - hnfo->lnlen);
 
-	while (dptr <= limit) {
+	while (dptr < limit) {
 		if ((strncmp(dptr, hnfo->lname, hnfo->lnlen) != 0) &&
 		    (hnfo->sname == NULL ||
 		     strncmp(dptr, hnfo->sname, hnfo->snlen) != 0)) {
