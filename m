Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D34FC432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 12:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 669222089D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 12:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfKUMiK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 07:38:10 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:4083 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfKUMiK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 07:38:10 -0500
Received: from [192.168.1.4] (unknown [116.237.146.20])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id BE90541AB5;
        Thu, 21 Nov 2019 20:38:02 +0800 (CST)
Subject: Re: [PATCH nf-next v2 3/4] netfilter: nf_flow_table_offload: add
 tunnel match offload support
From:   wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org,
        "paulb@mellanox.com >> Paul Blakey" <paulb@mellanox.com>
References: <1574330056-5377-1-git-send-email-wenxu@ucloud.cn>
 <1574330056-5377-4-git-send-email-wenxu@ucloud.cn>
Message-ID: <a255b14c-788a-16b0-4214-ff539d34e2ff@ucloud.cn>
Date:   Thu, 21 Nov 2019 20:37:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <1574330056-5377-4-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEpJS0tLS0hNSUhCTUlZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OC46ESo5GDg*Fw8PSTc6TU8p
        PUtPChdVSlVKTkxPSEhCQ0NMQ05NVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SExVSk9NVUlLWVdZCAFZQU1ITEs3Bg++
X-HM-Tid: 0a6e8df838e32086kuqybe90541ab5
To:     unlisted-recipients:; (no To-header on input)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2019/11/21 17:54, wenxu@ucloud.cn 写道:
> From: wenxu <wenxu@ucloud.cn>
>
> This patch support both ipv4 and ipv6 tunnel_id, tunnel_src and
> tunnel_dst match for flowtable offload
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v2: add ecn_control to match outer addr
>
>  net/netfilter/nf_flow_table_offload.c | 67 +++++++++++++++++++++++++++++++++--
>  1 file changed, 65 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 653866f..656095c 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -26,10 +26,16 @@ struct flow_offload_work {
>  
>  struct nf_flow_key {
>  	struct flow_dissector_key_control		control;
> +	struct flow_dissector_key_control               enc_control;
>  	struct flow_dissector_key_basic			basic;
>  	union {
>  		struct flow_dissector_key_ipv4_addrs	ipv4;
>  	};
> +	struct flow_dissector_key_keyid			enc_key_id;
> +	union {
> +		struct flow_dissector_key_ipv4_addrs	enc_ipv4;
> +		struct flow_dissector_key_ipv6_addrs	enc_ipv6;
> +	};
>  	struct flow_dissector_key_tcp			tcp;
>  	struct flow_dissector_key_ports			tp;
>  } __aligned(BITS_PER_LONG / 8); /* Ensure that we can do comparisons as longs. */
> @@ -49,11 +55,61 @@ struct nf_flow_rule {
>  	(__match)->dissector.offset[__type] =		\
>  		offsetof(struct nf_flow_key, __field)
>  
> +static void nf_flow_rule_lwt_match(struct nf_flow_match *match,
> +				   struct ip_tunnel_info *tun_info)
> +{
> +	struct nf_flow_key *mask = &match->mask;
> +	struct nf_flow_key *key = &match->key;
> +	unsigned int enc_keys;
> +
> +	if (!tun_info || !(tun_info->mode & IP_TUNNEL_INFO_TX))
> +		return;
> +
> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_CONTROL, enc_control);
> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_KEYID, enc_key_id);
> +	key->enc_key_id.keyid = tunnel_id_to_key32(tun_info->key.tun_id);
> +	mask->enc_key_id.keyid = 0xffffffff;
> +	enc_keys = BIT(FLOW_DISSECTOR_KEY_ENC_KEYID) |
> +		   BIT(FLOW_DISSECTOR_KEY_ENC_CONTROL);
> +
> +	if (ip_tunnel_info_af(tun_info) == AF_INET) {
> +		NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS,
> +				  enc_ipv4);
> +		key->enc_ipv4.src = tun_info->key.u.ipv4.dst;
> +		key->enc_ipv4.dst = tun_info->key.u.ipv4.src;
> +		if (key->enc_ipv4.src)
> +			mask->enc_ipv4.src = 0xffffffff;
> +		if (key->enc_ipv4.dst)
> +			mask->enc_ipv4.dst = 0xffffffff;
> +		enc_keys |= BIT(FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS);
> +		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> +	} else {
> +		memcpy(&key->enc_ipv6.src, &tun_info->key.u.ipv6.dst,
> +		       sizeof(struct in6_addr));
> +		memcpy(&key->enc_ipv6.dst, &tun_info->key.u.ipv6.src,
> +		       sizeof(struct in6_addr));
> +		if (memcmp(&key->enc_ipv6.src, &in6addr_any,
> +			   sizeof(struct in6_addr)))
> +			memset(&key->enc_ipv6.src, 0xff,
> +			       sizeof(struct in6_addr));
> +		if (memcmp(&key->enc_ipv6.dst, &in6addr_any,
> +			   sizeof(struct in6_addr)))
> +			memset(&key->enc_ipv6.dst, 0xff,
> +			       sizeof(struct in6_addr));
> +		enc_keys |= BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS);
> +		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
> +	}
> +
> +	match->dissector.used_keys |= enc_keys;
> +}
> +
>  static int nf_flow_rule_match(struct nf_flow_match *match,
> -			      const struct flow_offload_tuple *tuple)
> +			      const struct flow_offload_tuple *tuple,
> +			      struct dst_entry *other_dst)
>  {
>  	struct nf_flow_key *mask = &match->mask;
>  	struct nf_flow_key *key = &match->key;
> +	struct ip_tunnel_info *tun_info;
>  
>  	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
>  	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
> @@ -61,6 +117,11 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>  	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
>  	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
>  
> +	if (other_dst->lwtstate) {
> +		tun_info = lwt_tun_info(other_dst->lwtstate);
> +		nf_flow_rule_lwt_match(match, tun_info);
> +	}
> +
>  	switch (tuple->l3proto) {
>  	case AF_INET:
>  		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> @@ -468,6 +529,7 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
>  	const struct flow_offload *flow = offload->flow;
>  	const struct flow_offload_tuple *tuple;
>  	struct nf_flow_rule *flow_rule;
> +	struct dst_entry *other_dst;
>  	int err = -ENOMEM;
>  
>  	flow_rule = kzalloc(sizeof(*flow_rule), GFP_KERNEL);
> @@ -483,7 +545,8 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
>  	flow_rule->rule->match.key = &flow_rule->match.key;
>  
>  	tuple = &flow->tuplehash[dir].tuple;
> -	err = nf_flow_rule_match(&flow_rule->match, tuple);
> +	other_dst = flow->tuplehash[!dir].tuple.dst_cache;
> +	err = nf_flow_rule_match(&flow_rule->match, tuple, other_dst);
>  	if (err < 0)
>  		goto err_flow_match;
>  
