From: Jan Engelhardt <jengelh@medozas.de>
Subject: rfc: reject use of drop in nat table
Date: Mon, 4 Aug 2008 12:54:12 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808041252270.27953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49937 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbYHDQyN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:54:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



This just happened to be within my thoughts. Comments, declinations?

commit 344a4b52b8484460727ed605e042583dbc73ac83
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Jul 3 19:06:22 2008 +0200

    Reject use of DROP in nat table
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/iptables.c b/iptables.c
index 41e1836..6e7242d 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1917,6 +1917,12 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 		invert = FALSE;
 	}
 
+	if (strcmp(*table, "nat") == 0) {
+		if ((policy != NULL && strcmp(policy, "DROP") == 0) ||
+		    (jumpto != NULL && strcmp(jumpto, "DROP") == 0))
+			exit_error(OTHER_PROBLEM, "The nat table is not for filtering");
+	}
+
 	for (matchp = matches; matchp; matchp = matchp->next)
 		if (matchp->match->final_check != NULL)
 			matchp->match->final_check(matchp->match->mflags);
