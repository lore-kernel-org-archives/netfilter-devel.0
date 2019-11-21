Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1C5C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 12:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DBD72075E
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 12:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfKUMix (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 07:38:53 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:4929 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfKUMix (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 07:38:53 -0500
Received: from [192.168.1.4] (unknown [116.237.146.20])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 60E7C41AAF;
        Thu, 21 Nov 2019 20:38:50 +0800 (CST)
Subject: Re: [PATCH nf-next v2 4/4] netfilter: nf_flow_table_offload: add
 tunnel encap/decap action offload support
From:   wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org, Paul Blakey <paulb@mellanox.com>
References: <1574330056-5377-1-git-send-email-wenxu@ucloud.cn>
 <1574330056-5377-5-git-send-email-wenxu@ucloud.cn>
Message-ID: <8d5790b8-8b65-8dc1-71a8-d331c600363f@ucloud.cn>
Date:   Thu, 21 Nov 2019 20:38:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1574330056-5377-5-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVT01NS0tLSEpDTklMSUlZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NCo6Nww*Szg0TA8SFDceTQE0
        Qj4wCRRVSlVKTkxPSEhCQkhLTk9MVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SExVSk9NVUlLWVdZCAFZQU9KTks3Bg++
X-HM-Tid: 0a6e8df8e95c2086kuqy60e7c41aaf
To:     unlisted-recipients:; (no To-header on input)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi paul,

encap in this patch.

在 2019/11/21 17:54, wenxu@ucloud.cn 写道:
> From: wenxu <wenxu@ucloud.cn>
>
> This patch add tunnel encap decap action offload in the flowtable
> offload.
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v2: put encap/decap action before redirect action
>
>  net/netfilter/nf_flow_table_offload.c | 47 +++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 656095c..36a5103 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -469,6 +469,45 @@ static void flow_offload_redirect(const struct flow_offload *flow,
>  	dev_hold(rt->dst.dev);
>  }
>  
> +static void flow_offload_encap_tunnel(const struct flow_offload *flow,
> +				      enum flow_offload_tuple_dir dir,
> +				      struct nf_flow_rule *flow_rule)
> +{
> +	struct flow_action_entry *entry;
> +	struct dst_entry *dst;
> +
> +	dst = flow->tuplehash[dir].tuple.dst_cache;
> +	if (dst->lwtstate) {
> +		struct ip_tunnel_info *tun_info;
> +
> +		tun_info = lwt_tun_info(dst->lwtstate);
> +		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX)) {
> +			entry = flow_action_entry_next(flow_rule);
> +			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
> +			entry->tunnel = tun_info;
> +		}
> +	}
> +}
> +
> +static void flow_offload_decap_tunnel(const struct flow_offload *flow,
> +				      enum flow_offload_tuple_dir dir,
> +				      struct nf_flow_rule *flow_rule)
> +{
> +	struct flow_action_entry *entry;
> +	struct dst_entry *dst;
> +
> +	dst = flow->tuplehash[!dir].tuple.dst_cache;
> +	if (dst->lwtstate) {
> +		struct ip_tunnel_info *tun_info;
> +
> +		tun_info = lwt_tun_info(dst->lwtstate);
> +		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX)) {
> +			entry = flow_action_entry_next(flow_rule);
> +			entry->id = FLOW_ACTION_TUNNEL_DECAP;
> +		}
> +	}
> +}
> +
>  int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
>  			    enum flow_offload_tuple_dir dir,
>  			    struct nf_flow_rule *flow_rule)
> @@ -489,6 +528,10 @@ int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
>  	    flow->flags & FLOW_OFFLOAD_DNAT)
>  		flow_offload_ipv4_checksum(net, flow, flow_rule);
>  
> +	flow_offload_encap_tunnel(flow, dir, flow_rule);
> +
> +	flow_offload_decap_tunnel(flow, dir, flow_rule);
> +
>  	flow_offload_redirect(flow, dir, flow_rule);
>  
>  	return 0;
> @@ -512,6 +555,10 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
>  		flow_offload_port_dnat(net, flow, dir, flow_rule);
>  	}
>  
> +	flow_offload_encap_tunnel(flow, dir, flow_rule);
> +
> +	flow_offload_decap_tunnel(flow, dir, flow_rule);
> +
>  	flow_offload_redirect(flow, dir, flow_rule);
>  
>  	return 0;
