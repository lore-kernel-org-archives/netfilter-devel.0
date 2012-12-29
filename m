From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH] netfilter: add include file to nf_conntrack_snmp.c
Date: Fri, 28 Dec 2012 20:17:08 -0800
Message-ID: <20121228201708.77f1c376@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:41219 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab2L2ESb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Dec 2012 23:18:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prototype for nf_nat_snmp_hook is in nf_conntrack_snmp.h therefore
it should be included to get type checking. Found by sparse.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/net/netfilter/nf_conntrack_snmp.c	2012-10-25 09:11:15.711271681 -0700
+++ b/net/netfilter/nf_conntrack_snmp.c	2012-12-28 20:09:04.666030725 -0800
@@ -16,6 +16,7 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <linux/netfilter/nf_conntrack_snmp.h>
 
 #define SNMP_PORT	161
 
