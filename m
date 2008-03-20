From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: nf_conntrack_h323: logical-bitwise & confusion
 in process_setup()
Date: Thu, 20 Mar 2008 18:54:54 +0100
Message-ID: <47E2A4EE.7070109@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070106000807080300030207"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:61130 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756035AbYCTRy7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Mar 2008 13:54:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070106000807080300030207
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------070106000807080300030207
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit 3e760ed979f6dbf063ced2117328ffee56620bbd
Author: Roel Kluin <12o3l@tiscali.nl>
Date:   Thu Mar 20 18:34:39 2008 +0100

    [NETFILTER]: nf_conntrack_h323: logical-bitwise & confusion in process_setup()
    
    logical-bitwise & confusion
    
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 6213787..898f192 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -842,7 +842,7 @@ static int process_setup(struct sk_buff *skb, struct nf_conn *ct,
 
 	set_h225_addr = rcu_dereference(set_h225_addr_hook);
 	if ((setup->options & eSetup_UUIE_destCallSignalAddress) &&
-	    (set_h225_addr) && ct->status && IPS_NAT_MASK &&
+	    (set_h225_addr) && ct->status & IPS_NAT_MASK &&
 	    get_h225_addr(ct, *data, &setup->destCallSignalAddress,
 			  &addr, &port) &&
 	    memcmp(&addr, &ct->tuplehash[!dir].tuple.src.u3, sizeof(addr))) {

--------------070106000807080300030207--
