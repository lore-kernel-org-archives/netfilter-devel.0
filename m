From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: iptables-xml segfault if missing -A
Date: Thu, 23 Jan 2014 22:06:58 -0800
Message-ID: <20140124060658.GA25711@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60427 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaAXGG6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jan 2014 01:06:58 -0500
Received: by mail-pa0-f47.google.com with SMTP id kp14so2848046pab.34
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jan 2014 22:06:58 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As pointed out by Bernhard Reutner-Fischer, a malformed line fed to
iptables-xml such as the below with a missing space after the -A:

	-APOSTROUTING -d 1.1.1.1/32 -p tcp -j MASQUERADE

causes a segfault.  Patch attached.

This closes netfilter bugzilla #886.

Signed-off-by: Phil Oester <kernel@linuxace.com>



--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-iptables-xml

diff --git a/iptables/iptables-xml.c b/iptables/iptables-xml.c
index 9628447..c7615ab 100644
--- a/iptables/iptables-xml.c
+++ b/iptables/iptables-xml.c
@@ -845,6 +845,11 @@ iptables_xml_main(int argc, char *argv[])
 			for (a = 0; a < newargc; a++)
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
+			if (!chain) {
+				fprintf(stderr, "%s: line %u failed - no chain found\n",
+					prog_name, line);
+				exit(1);
+			}
 			needChain(chain);// Should we explicitly look for -A
 			do_rule(pcnt, bcnt, newargc, newargv, newargvattr);
 

--VbJkn9YxBvnuCH5J--
