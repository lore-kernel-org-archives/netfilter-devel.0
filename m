From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] netfilter: nf_nat_snmp_basic: snmp_version() can be
 static
Date: Tue, 26 Dec 2017 11:25:57 +0800
Message-ID: <20171226032557.GA27398@lkp-wsm-ep2>
References: <20171225150046.4227-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, ap420073@gmail.com
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:44616 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbdLZD3q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Dec 2017 22:29:46 -0500
Content-Disposition: inline
In-Reply-To: <20171225150046.4227-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Fixes: 499b2f89cea8 ("netfilter: nf_nat_snmp_basic: use asn1 decoder library")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 nf_nat_snmp_basic_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
index b6e2770..b16d3ad 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic_main.c
@@ -101,8 +101,8 @@ static void fast_csum(struct snmp_ctx *ctx, unsigned char offset)
 					     ~csum_unfold(*ctx->check)));
 }
 
-int snmp_version(void *context, size_t hdrlen, unsigned char tag,
-		 const void *data, size_t datalen)
+static int snmp_version(void *context, size_t hdrlen, unsigned char tag,
+			const void *data, size_t datalen)
 {
 	if (*(unsigned char *)data > 1)
 		return -ENOTSUPP;
