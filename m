From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] proto: use bitmask_type for comp flags
Date: Fri,  5 Jun 2015 17:31:57 +0200
Message-ID: <1433518317-9901-2-git-send-email-pablo@netfilter.org>
References: <1433518317-9901-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58205 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbbFEP1I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 11:27:08 -0400
In-Reply-To: <1433518317-9901-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I think flags should be displayed in hexadecimal and should be handled as a
bitmask.

inet/comp.t: WARNING: line: 15: 'nft add rule ip test-ip4 input comp flags 0x00': 'comp flags 0x00' mismatches 'comp flags 0'
inet/comp.t: WARNING: line: 16: 'nft add rule ip test-ip4 input comp flags != 0x23': 'comp flags != 0x23' mismatches 'comp flags != 35'
inet/comp.t: WARNING: line: 17: 'nft add rule ip test-ip4 input comp flags 0x33-0x45': 'comp flags 0x33-0x45' mismatches 'comp flags 51-69'
inet/comp.t: WARNING: line: 18: 'nft add rule ip test-ip4 input comp flags != 0x33-0x45': 'comp flags != 0x33-0x45' mismatches 'comp flags != 51-69'
inet/comp.t: WARNING: line: 19: 'nft add rule ip test-ip4 input comp flags {0x33, 0x55, 0x67, 0x88}': 'comp flags {0x33, 0x55, 0x67, 0x88}' mismatches 'comp flags { 103, 85, 51, 136}'
inet/comp.t: WARNING: line: 21: 'nft add rule ip test-ip4 input comp flags { 0x33-0x55}': 'comp flags { 0x33-0x55}' mismatches 'comp flags { 51-85}'

rfc3173 says that this is unused for future use, but I think this should be
printed as hexadecimal in any case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/proto.c                  |    2 +-
 tests/regression/inet/comp.t |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/proto.c b/src/proto.c
index 7dc7b3e..6302016 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -272,7 +272,7 @@ const struct proto_desc proto_comp = {
 	},
 	.templates	= {
 		[COMPHDR_NEXTHDR]	= INET_PROTOCOL("nexthdr", struct ip_comp_hdr, nexthdr),
-		[COMPHDR_FLAGS]		= COMPHDR_FIELD("flags", flags),
+		[COMPHDR_FLAGS]		= HDR_TEMPLATE("flags", &bitmask_type, struct ip_comp_hdr, flags),
 		[COMPHDR_CPI]		= COMPHDR_FIELD("cpi", cpi),
 	},
 };
diff --git a/tests/regression/inet/comp.t b/tests/regression/inet/comp.t
index afdc63f..f4753bb 100644
--- a/tests/regression/inet/comp.t
+++ b/tests/regression/inet/comp.t
@@ -12,7 +12,7 @@ comp nexthdr != esp;ok;comp nexthdr != 50
 # comp flags ## 8-bit field.  Reserved for future use.  MUST be set to zero.
 
 # Bug comp flags: to list. List the decimal value.
-comp flags 0x00;ok
+comp flags 0x0;ok
 comp flags != 0x23;ok
 comp flags 0x33-0x45;ok
 comp flags != 0x33-0x45;ok
-- 
1.7.10.4

