From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Remove redundant TCP header checks from xt_TCPOPTSTRIP
Date: Sun, 9 Jun 2013 23:59:48 -0400
Message-ID: <20130610035948.GA2742@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58712 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3FJR7M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:59:12 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld11so1795151pab.8
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jun 2013 10:59:12 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In commit bc6bcb59 ("netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond
packet boundary"), a check for short TCP header or malformed packet was added.
This check is unnecessary, as these packets are already handled in the tcp_error
function of nf_conntrack_proto_tcp.c (see /* Not whole TCP header or malformed
packet */).  In addition, there was an error in the check which was added (len
is being calculated incorrectly).  In my testing, ALL packets are being dropped
by the TCPOPTSTRIP target at present.  Revert the unnecessary/incorrect checks.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-revert-bc6bcb59d

diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 1eb1a44..2d43be9f 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -38,7 +38,6 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 	struct tcphdr *tcph;
 	u_int16_t n, o;
 	u_int8_t *opt;
-	int len;
 
 	/* This is a fragment, no TCP header is available */
 	if (par->fragoff != 0)
@@ -47,11 +46,6 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 	if (!skb_make_writable(skb, skb->len))
 		return NF_DROP;
 
-	len = skb->len - tcphoff;
-	if (len < (int)sizeof(struct tcphdr) ||
-	    tcp_hdr(skb)->doff * 4 > len)
-		return NF_DROP;
-
 	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
 	opt  = (u_int8_t *)tcph;
 

--nFreZHaLTZJo0R7j--
