From: Jan Engelhardt <jengelh@medozas.de>
Subject: libxt_TOS: make sure --set-tos value/mask is recognized
Date: Fri, 27 Jun 2008 22:09:03 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806272208540.12725@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58990 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbYF0UJE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:09:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit d30191dd6ea9e13a7a7340004872f027aa7d4d5c
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Jun 27 22:00:11 2008 +0200

    libxt_TOS: make sure --set-tos value/mask is recognized
    
    Only when a 'stop' pointer is passed, the string may consist of more
    than just a number.
    
    Reported-by: Anonymous
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/tos_values.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/extensions/tos_values.c b/extensions/tos_values.c
index 1630834..4c0b0bc 100644
--- a/extensions/tos_values.c
+++ b/extensions/tos_values.c
@@ -56,8 +56,9 @@ static bool tos_parse_symbolic(const char *str, struct tos_value_mask *tvm,
 {
 	const unsigned int max = 255;
 	const struct tos_symbol_info *symbol;
+	char *tmp;
 
-	if (strtonum(str, NULL, NULL, 0, max))
+	if (strtonum(str, &tmp, NULL, 0, max))
 		return tos_parse_numeric(str, tvm, max);
 
 	/* Do not consider ECN bits */

