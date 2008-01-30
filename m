From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 24/69]: nf_nat_snmp: sparse warning
Date: Wed, 30 Jan 2008 21:17:31 +0100 (MET)
Message-ID: <20080130201729.29874.80214.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60704 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764023AbYA3URd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:33 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat_snmp: sparse warning

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1ba99fa44b76ee7a7dddffc965a296d46c70fd40
tree 8d6c2f8042f36119de85fdba76d46dfca177ac80
parent c1e9e8f11d30d54eb79e53ca02f0fd17a60407ef
author Stephen Hemminger <shemminger@vyatta.com> Tue, 29 Jan 2008 16:22:04 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:18 +0100

 net/ipv4/netfilter/nf_nat_snmp_basic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index 07f2a49..540ce6a 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -260,7 +260,7 @@ static unsigned char asn1_eoc_decode(struct asn1_ctx *ctx, unsigned char *eoc)
 {
 	unsigned char ch;
 
-	if (eoc == 0) {
+	if (eoc == NULL) {
 		if (!asn1_octet_decode(ctx, &ch))
 			return 0;
 
