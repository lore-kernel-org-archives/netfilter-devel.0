From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: iptables-xml: Fix various parsing bugs
Date: Thu, 20 Jun 2013 08:53:36 -0400
Message-ID: <20130620125336.GA15704@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:32936 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423052Ab3FUPGk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jun 2013 11:06:40 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr13so7870038pbb.6
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2013 08:06:39 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There are two bugs in iptables-xml do_rule_part parsing corrected by this patch:

1) Ignore "-A <chain>" instead of just "-A"
2) When checking to see if we need a <match> tag, inversion needs to be taken
   into account

This closes netfilter bugzilla #679.  

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-xml

diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 4b12bd4..99d7527 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -367,7 +367,8 @@ static void
 do_rule_part(char *leveltag1, char *leveltag2, int part, int argc,
 	     char *argv[], int argvattr[])
 {
-	int arg = 1;		// ignore leading -A
+	int i;
+	int arg = 2;		// ignore leading -A <chain>
 	char invert_next = 0;
 	char *spacer = "";	// space when needed to assemble arguments
 	char *level1 = NULL;
@@ -401,9 +402,14 @@ do_rule_part(char *leveltag1, char *leveltag2, int part, int argc,
 
 	/* Before we start, if the first arg is -[^-] and not -m or -j or -g 
 	   then start a dummy <match> tag for old style built-in matches.  
-	   We would do this in any case, but no need if it would be empty */
-	if (arg < argc && argv[arg][0] == '-' && !isTarget(argv[arg])
-	    && strcmp(argv[arg], "-m") != 0) {
+	   We would do this in any case, but no need if it would be empty 
+	   In the case of negation, we need to look at arg+1 */
+	if (arg < argc && strcmp(argv[arg], "!") == 0)
+		i = arg + 1;
+	else
+		i = arg;
+	if (i < argc && argv[i][0] == '-' && !isTarget(argv[i])
+	    && strcmp(argv[i], "-m") != 0) {
 		OPEN_LEVEL(1, "match");
 		printf(">\n");
 	}

--fUYQa+Pmc3FrFX/N--
