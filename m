From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/02: nf_nat_snmp_basic: fix a range check in NAT for
 SNMP
Date: Wed, 09 Jul 2008 18:46:30 +0200
Message-ID: <4874EB66.70902@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060701050107040403040809"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33215 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYGIQqc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:46:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060701050107040403040809
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------060701050107040403040809
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

netfilter: nf_nat_snmp_basic: fix a range check in NAT for SNMP

Fix a range check in netfilter IP NAT for SNMP to always use a big enough size
variable that the compiler won't moan about comparing it to ULONG_MAX/8 on a
64-bit platform.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d2992a61a9c281b7414b0a4dc15cd28eef4d808e
tree 84919cc1b91c8954c859127b8bd652400a1cc3b1
parent baa04a1fb3dbef550ed1dc5acd15e21e7dde3b85
author David Howells <dhowells@redhat.com> Wed, 09 Jul 2008 18:34:22 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 09 Jul 2008 18:34:22 +0200

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
 

--------------060701050107040403040809--
