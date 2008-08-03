From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Fix save of negated dscp match rules
Date: Sun, 3 Aug 2008 08:31:32 -0700
Message-ID: <20080803153132.GA10808@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:44843
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755915AbYHCPbd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:31:33 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As pointed out by Vyacheslav Garashchenko, iptables-save does not
save negated dscp matches properly.  Fix below.

This closes bugzilla #533.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-dscp-save

--- iptables/extensions/libxt_dscp.c	2008-06-24 13:58:46.000000000 -0700
+++ iptables-1.4.1.1/extensions/libxt_dscp.c	2008-08-03 08:26:36.000000000 -0700
@@ -119,7 +119,7 @@
 print_dscp(u_int8_t dscp, int invert, int numeric)
 {
 	if (invert)
-		fputc('!', stdout);
+		printf("! ");
 
  	printf("0x%02x ", dscp);
 }

--n8g4imXOkfNTN/H1--
