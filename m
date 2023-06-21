Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41DB9EB64DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 10:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjFUKKn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 06:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjFUKJq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 06:09:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 427B42721;
        Wed, 21 Jun 2023 03:08:53 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 01/14] ipvs: align inner_mac_header for encapsulation
Date:   Wed, 21 Jun 2023 12:07:18 +0200
Message-Id: <20230621100731.68068-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230621100731.68068-1-pablo@netfilter.org>
References: <20230621100731.68068-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Terin Stock <terin@cloudflare.com>

When using encapsulation the original packet's headers are copied to the
inner headers. This preserves the space for an inner mac header, which
is not used by the inner payloads for the encapsulation types supported
by IPVS. If a packet is using GUE or GRE encapsulation and needs to be
segmented, flow can be passed to __skb_udp_tunnel_segment() which
calculates a negative tunnel header length. A negative tunnel header
length causes pskb_may_pull() to fail, dropping the packet.

This can be observed by attaching probes to ip_vs_in_hook(),
__dev_queue_xmit(), and __skb_udp_tunnel_segment():

    perf probe --add '__dev_queue_xmit skb->inner_mac_header \
    skb->inner_network_header skb->mac_header skb->network_header'
    perf probe --add '__skb_udp_tunnel_segment:7 tnl_hlen'
    perf probe -m ip_vs --add 'ip_vs_in_hook skb->inner_mac_header \
    skb->inner_network_header skb->mac_header skb->network_header'

These probes the headers and tunnel header length for packets which
traverse the IPVS encapsulation path. A TCP packet can be forced into
the segmentation path by being smaller than a calculated clamped MSS,
but larger than the advertised MSS.

    probe:ip_vs_in_hook: inner_mac_header=0x0 inner_network_header=0x0 mac_header=0x44 network_header=0x52
    probe:ip_vs_in_hook: inner_mac_header=0x44 inner_network_header=0x52 mac_header=0x44 network_header=0x32
    probe:dev_queue_xmit: inner_mac_header=0x44 inner_network_header=0x52 mac_header=0x44 network_header=0x32
    probe:__skb_udp_tunnel_segment_L7: tnl_hlen=-2

When using veth-based encapsulation, the interfaces are set to be
mac-less, which does not preserve space for an inner mac header. This
prevents this issue from occurring.

In our real-world testing of sending a 32KB file we observed operation
time increasing from ~75ms for veth-based encapsulation to over 1.5s
using IPVS encapsulation due to retries from dropped packets.

This changeset modifies the packet on the encapsulation path in
ip_vs_tunnel_xmit() and ip_vs_tunnel_xmit_v6() to remove the inner mac
header offset. This fixes UDP segmentation for both encapsulation types,
and corrects the inner headers for any IPIP flows that may use it.

Fixes: 84c0d5e96f3a ("ipvs: allow tunneling with gue encapsulation")
Signed-off-by: Terin Stock <terin@cloudflare.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index feb1d7fcb09f..a80b960223e1 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -1207,6 +1207,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 	skb->transport_header = skb->network_header;
 
 	skb_set_inner_ipproto(skb, next_protocol);
+	skb_set_inner_mac_header(skb, skb_inner_network_offset(skb));
 
 	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 		bool check = false;
@@ -1349,6 +1350,7 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 	skb->transport_header = skb->network_header;
 
 	skb_set_inner_ipproto(skb, next_protocol);
+	skb_set_inner_mac_header(skb, skb_inner_network_offset(skb));
 
 	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
 		bool check = false;
-- 
2.30.2

