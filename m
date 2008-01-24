From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 1/8] nf_nat_snmp: sparse warning
Date: Thu, 24 Jan 2008 10:15:37 -0800
Message-ID: <20080124181628.009087187@vyatta.com>
References: <20080124181536.446214111@vyatta.com>
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:48239 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbYAXSYU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:24:20 -0500
Content-Disposition: inline; filename=nf-snmp-sparse.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use of 0 as NULL causes sparse complaint.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c	2008-01-23 10:07:23.000000000 -0800
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c	2008-01-23 10:07:31.000000000 -0800
@@ -260,7 +260,7 @@ static unsigned char asn1_eoc_decode(str
 {
 	unsigned char ch;
 
-	if (eoc == 0) {
+	if (eoc == NULL) {
 		if (!asn1_octet_decode(ctx, &ch))
 			return 0;
 

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>

