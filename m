From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] iptables: xtables_ipmask_to_numeric incorrect with non-CIDR
 masks
Date: Thu, 26 Sep 2013 09:06:58 -0700
Message-ID: <20130926160658.GA12333@home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:41209 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3IZQHB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Sep 2013 12:07:01 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so1336261pbc.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2013 09:07:00 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As pointed out by Peter Hoelsken, rules created with non-standard masks such as
0.255.0.0, 0.0.255.0, etc. are displayed when output with iptables -L in CIDR
notation as -1.  This is because the cidr variable in xtables_ipmask_to_numeric
is unsigned, and the return value of -1 from xtables_ipmask_to_cidr is therefore
converted to 4294967295.  Add a cast to workaround the issue.

This closes netfilter bugzilla #854.

Signed-off-by: Phil Oester <kernel@linuxace.com>


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ipt-cidr

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index ef5bc07..8437baf 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1243,7 +1243,7 @@ const char *xtables_ipmask_to_numeric(const struct in_addr *mask)
 	uint32_t cidr;
 
 	cidr = xtables_ipmask_to_cidr(mask);
-	if (cidr < 0) {
+	if (cidr == (unsigned int)-1) {
 		/* mask was not a decent combination of 1's and 0's */
 		sprintf(buf, "/%s", xtables_ipaddr_to_numeric(mask));
 		return buf;

--X1bOJ3K7DJ5YkBrT--
