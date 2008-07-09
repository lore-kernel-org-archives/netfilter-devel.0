From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix a range check in netfilter IP NAT for SNMP
Date: Wed, 09 Jul 2008 12:53:17 +0100
Message-ID: <20080709115317.13290.93539.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, netfilter-devel@vger.kernel.org
To: kaber@trash.net, akpm@linux-foundation.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYGILxY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:53:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix a range check in netfilter IP NAT for SNMP to always use a big enough size
variable that the compiler won't moan about comparing it to ULONG_MAX/8 on a
64-bit platform.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/ipv4/netfilter/nf_nat_snmp_basic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index 7750c97..ffeaffc 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -439,8 +439,8 @@ static unsigned char asn1_oid_decode(struct asn1_ctx *ctx,
 				     unsigned int *len)
 {
 	unsigned long subid;
-	unsigned int  size;
 	unsigned long *optr;
+	size_t size;
 
 	size = eoc - ctx->pointer + 1;
 

