From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] [BRIDGE-NETFILTER] make IP DNAT work on bridged vlan/pppoe
 packets
Date: Sat, 24 Oct 2009 13:45:41 +0200
Message-ID: <4AE2E8E5.3040605@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010701070100020208010802"
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:59254 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbZJXLpj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Oct 2009 07:45:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010701070100020208010802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

The attached patch makes IP DNAT work on bridged IP packets encapsulated 
in a VLAN/PPoE packet. I only tested that it works for VLAN, but the 
PPoE case should be fixed too.
This bug was introduced by commit 
2948d2ebbb98747b912ac6d0c864b4d02be8a6f5 on January 12, 2008.
The patch also makes IP DNATing more transparent on a bridge: for 
bridged-and-dnated traffic, the source MAC address is no longer changed 
to the MAC address of the bridge port. If one wants, ebtables snat can 
be used to change the source MAC address in the POSTROUTING chain.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>

-- 
Bart De Schuymer
www.artinalgorithms.be


--------------010701070100020208010802
Content-Type: text/plain;
 name="vlan_nat_filtering.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vlan_nat_filtering.diff"

--- linux-2.6.31-uml/net/bridge/br_netfilter.c.ori	2009-10-03 17:17:37.000000000 +0200
+++ linux-2.6.31-uml/net/bridge/br_netfilter.c	2009-10-04 17:28:40.000000000 +0200
@@ -324,7 +324,10 @@ static int br_nf_pre_routing_finish_brid
 	if (skb->dev) {
 		struct dst_entry *dst = skb_dst(skb);
 
-		nf_bridge_pull_encap_header(skb);
+		/* the neigh functions below overwrite the MAC header, so we
+		 * save the Ethernet source address and protocol number */
+		skb_copy_from_linear_data_offset(skb, -8,
+						 skb->nf_bridge->data, 8);
 
 		if (dst->hh)
 			return neigh_hh_output(dst->hh, skb);
@@ -784,7 +787,7 @@ static unsigned int br_nf_local_out(unsi
 		skb->pkt_type = PACKET_OTHERHOST;
 		nf_bridge->mask ^= BRNF_PKT_TYPE;
 	}
-	nf_bridge_push_encap_header(skb);
+	skb_copy_to_linear_data_offset(skb, -8, skb->nf_bridge->data, 8);
 
 	NF_HOOK(PF_BRIDGE, NF_BR_FORWARD, skb, realindev, skb->dev,
 		br_forward_finish);

--------------010701070100020208010802--
