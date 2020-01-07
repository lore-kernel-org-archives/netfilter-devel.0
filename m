Return-Path: <SRS0=BUQT=24=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03C5C32771
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 00:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACB27206F0
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 00:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgAGAh2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 19:37:28 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:45807 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgAGAh2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 19:37:28 -0500
Received: from [192.168.1.7] (unknown [101.86.134.13])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 4DD224116F;
        Tue,  7 Jan 2020 08:37:25 +0800 (CST)
Subject: Re: [PATCH nf] netfilter: flowtable: restrict flow dissector match on
 meta ingress device
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200106114753.7765-1-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <f0bee708-d351-382c-d260-740ad4cef591@ucloud.cn>
Date:   Tue, 7 Jan 2020 08:36:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200106114753.7765-1-pablo@netfilter.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSE9IS0tLSkxITk1DTEhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBw6LTo4Qzg2Gj8zNxEQMA0p
        LhhPFA9VSlVKTkxDSE5MT09OT01JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVD
        TVVKSE9VSkhZV1kIAVlBSE9MSTcG
X-HM-Tid: 0a6f7d6f53092086kuqy4dd224116f
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Acked-by: wenxu <wenxu@ucloud.cn>


This can avoid the wrong flow install in hardware if there are more than two

forward devices in the flowtables. Because all the devices shared the same

block.

ÔÚ 2020/1/6 19:47, Pablo Neira Ayuso Ð´µÀ:
> Set on FLOW_DISSECTOR_KEY_META meta key using flow tuple ingress interface.
>
> Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>   net/netfilter/nf_flow_table_offload.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 4d1e81e2880f..b879e673953f 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -24,6 +24,7 @@ struct flow_offload_work {
>   };
>   
>   struct nf_flow_key {
> +	struct flow_dissector_key_meta			meta;
>   	struct flow_dissector_key_control		control;
>   	struct flow_dissector_key_basic			basic;
>   	union {
> @@ -55,6 +56,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>   	struct nf_flow_key *mask = &match->mask;
>   	struct nf_flow_key *key = &match->key;
>   
> +	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_META, meta);
>   	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
>   	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
>   	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
> @@ -62,6 +64,9 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>   	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
>   	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
>   
> +	key->meta.ingress_ifindex = tuple->iifidx;
> +	mask->meta.ingress_ifindex = 0xffffffff;
> +
>   	switch (tuple->l3proto) {
>   	case AF_INET:
>   		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
> @@ -105,7 +110,8 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
>   	key->tp.dst = tuple->dst_port;
>   	mask->tp.dst = 0xffff;
>   
> -	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL) |
> +	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_META) |
> +				      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
>   				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
>   				      BIT(FLOW_DISSECTOR_KEY_PORTS);
>   	return 0;
