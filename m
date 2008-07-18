From: "Jan Beulich" <jbeulich@novell.com>
Subject: [PATCH] nf_nat_snmp_basic: fix compiler warning on 64-bit
	arch-s
Date: Fri, 18 Jul 2008 13:17:53 +0100
Message-ID: <4880A611.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: <linux-kernel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
To: <kaber@trash.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758002AbYGRMRj@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 net/ipv4/netfilter/nf_nat_snmp_basic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.26/net/ipv4/netfilter/nf_nat_snmp_basic.c	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-netfilter-warning/net/ipv4/netfilter/nf_nat_snmp_basic.c	2008-07-15 14:51:28.000000000 +0200
@@ -445,7 +445,7 @@ static unsigned char asn1_oid_decode(str
 	size = eoc - ctx->pointer + 1;
 
 	/* first subid actually encodes first two subids */
-	if (size < 2 || size > ULONG_MAX/sizeof(unsigned long))
+	if (size < 2 || size > UINT_MAX/sizeof(unsigned long))
 		return 0;
 
 	*oid = kmalloc(size * sizeof(unsigned long), GFP_ATOMIC);
