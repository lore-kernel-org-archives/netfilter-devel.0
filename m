Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0CABC88CB2
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jun 2023 13:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbjFLNvx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jun 2023 09:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235916AbjFLNvu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2023 09:51:50 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E32010D8;
        Mon, 12 Jun 2023 06:51:42 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id 9FF4223DAB;
        Mon, 12 Jun 2023 16:51:39 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id 86C4C23DAA;
        Mon, 12 Jun 2023 16:51:39 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id E67A83C0440;
        Mon, 12 Jun 2023 16:51:32 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 35CDpT40102565;
        Mon, 12 Jun 2023 16:51:30 +0300
Date:   Mon, 12 Jun 2023 16:51:29 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Terin Stock <terin@cloudflare.com>
cc:     horms@verge.net.au, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, kernel-team@cloudflare.com,
        pablo@netfilter.org, hengqing.hu@gmail.com, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, fw@strlen.de,
        coreteam@netfilter.org, davem@davemloft.net, kadlec@netfilter.org,
        pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH v2] ipvs: align inner_mac_header for encapsulation
In-Reply-To: <20230609205842.2333727-1-terin@cloudflare.com>
Message-ID: <ad564469-c999-3658-d94c-07301702ad27@ssi.bg>
References: <20230609205842.2333727-1-terin@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Fri, 9 Jun 2023, Terin Stock wrote:

> When using encapsulation the original packet's headers are copied to the
> inner headers. This preserves the space for an inner mac header, which
> is not used by the inner payloads for the encapsulation types supported
> by IPVS. If a packet is using GUE or GRE encapsulation and needs to be
> segmented, flow can be passed to __skb_udp_tunnel_segment() which
> calculates a negative tunnel header length. A negative tunnel header
> length causes pskb_may_pull() to fail, dropping the packet.
> 
> This can be observed by attaching probes to ip_vs_in_hook(),
> __dev_queue_xmit(), and __skb_udp_tunnel_segment():
> 
>     perf probe --add '__dev_queue_xmit skb->inner_mac_header \
>     skb->inner_network_header skb->mac_header skb->network_header'
>     perf probe --add '__skb_udp_tunnel_segment:7 tnl_hlen'
>     perf probe -m ip_vs --add 'ip_vs_in_hook skb->inner_mac_header \
>     skb->inner_network_header skb->mac_header skb->network_header'
> 
> These probes the headers and tunnel header length for packets which
> traverse the IPVS encapsulation path. A TCP packet can be forced into
> the segmentation path by being smaller than a calculated clamped MSS,
> but larger than the advertised MSS.
> 
>     probe:ip_vs_in_hook: inner_mac_header=0x0 inner_network_header=0x0 mac_header=0x44 network_header=0x52
>     probe:ip_vs_in_hook: inner_mac_header=0x44 inner_network_header=0x52 mac_header=0x44 network_header=0x32
>     probe:dev_queue_xmit: inner_mac_header=0x44 inner_network_header=0x52 mac_header=0x44 network_header=0x32
>     probe:__skb_udp_tunnel_segment_L7: tnl_hlen=-2
> 
> When using veth-based encapsulation, the interfaces are set to be
> mac-less, which does not preserve space for an inner mac header. This
> prevents this issue from occurring.
> 
> In our real-world testing of sending a 32KB file we observed operation
> time increasing from ~75ms for veth-based encapsulation to over 1.5s
> using IPVS encapsulation due to retries from dropped packets.
> 
> This changeset modifies the packet on the encapsulation path in
> ip_vs_tunnel_xmit() and ip_vs_tunnel_xmit_v6() to remove the inner mac
> header offset. This fixes UDP segmentation for both encapsulation types,
> and corrects the inner headers for any IPIP flows that may use it.
> 
> Fixes: 84c0d5e96f3a ("ipvs: allow tunneling with gue encapsulation")
> Signed-off-by: Terin Stock <terin@cloudflare.com>

	Looks good to me for nf/net tree, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
>  net/netfilter/ipvs/ip_vs_xmit.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index c7652da78c88..9193e109e6b3 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -1207,6 +1207,7 @@ ip_vs_tunnel_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
>  	skb->transport_header = skb->network_header;
>  
>  	skb_set_inner_ipproto(skb, next_protocol);
> +	skb_set_inner_mac_header(skb, skb_inner_network_offset(skb));
>  
>  	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
>  		bool check = false;
> @@ -1349,6 +1350,7 @@ ip_vs_tunnel_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
>  	skb->transport_header = skb->network_header;
>  
>  	skb_set_inner_ipproto(skb, next_protocol);
> +	skb_set_inner_mac_header(skb, skb_inner_network_offset(skb));
>  
>  	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GUE) {
>  		bool check = false;
> -- 
> 2.40.1

Regards

--
Julian Anastasov <ja@ssi.bg>

