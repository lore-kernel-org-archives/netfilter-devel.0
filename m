Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D531C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 May 2022 01:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiEZBXG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 May 2022 21:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241151AbiEZBXF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 May 2022 21:23:05 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EB0792D14
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 18:23:03 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:43954.2070394087
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-101.229.165.111 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 6C23F2800AB;
        Thu, 26 May 2022 09:22:58 +0800 (CST)
X-189-SAVE-TO-SEND: wenxu@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id c10c2005534642e88c07052a4cb98f3c for sven.auhagen@voleatech.de;
        Thu, 26 May 2022 09:23:01 CST
X-Transaction-ID: c10c2005534642e88c07052a4cb98f3c
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
Subject: Re: [PATCH nf-next] netfilter: flowtable: fix nft_flow_route use
 saddr for reverse route
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, sven.auhagen@voleatech.de
References: <1653495837-75877-1-git-send-email-wenxu@chinatelecom.cn>
 <Yo55KCPBfIk46hxv@salvia>
From:   wenxu <wenxu@chinatelecom.cn>
Message-ID: <a4a5cb61-b302-3894-733b-e94b5f8df84e@chinatelecom.cn>
Date:   Thu, 26 May 2022 09:22:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Yo55KCPBfIk46hxv@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


在 2022/5/26 2:44, Pablo Neira Ayuso 写道:
> On Wed, May 25, 2022 at 12:23:57PM -0400, wenxu@chinatelecom.cn wrote:
>> From: wenxu <wenxu@chinatelecom.cn>
>>
>> The nf_flow_tabel get route through ip_route_output_key which
>> the saddr should be local ones. For the forward case it always
>> can't get the other_dst and can't offload any flows
>>
>> Fixes: 3412e1641828 (netfilter: flowtable: nft_flow_route use more data for reverse route)
>> Signed-off-by: wenxu <wenxu@chinatelecom.cn>
>> ---
>>   net/netfilter/nft_flow_offload.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
>> index 40d18aa..742a494 100644
>> --- a/net/netfilter/nft_flow_offload.c
>> +++ b/net/netfilter/nft_flow_offload.c
>> @@ -230,7 +230,6 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
>>   	switch (nft_pf(pkt)) {
>>   	case NFPROTO_IPV4:
>>   		fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
>> -		fl.u.ip4.saddr = ct->tuplehash[dir].tuple.dst.u3.ip;
> I think this should be instead:
>
>                  fl.u.ip4.saddr = ct->tuplehash[!dir].tuple.src.u3.ip;
>
> to accordingly deal with snat and dnat.
Yes, This is another problem. I will also send a fix.
>>   		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
>>   		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
>>   		fl.u.ip4.flowi4_tos = RT_TOS(ip_hdr(pkt->skb)->tos);
>> @@ -238,7 +237,6 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
>>   		break;
>>   	case NFPROTO_IPV6:
>>   		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
>> -		fl.u.ip6.saddr = ct->tuplehash[dir].tuple.dst.u3.in6;
>                  fl.u.ip6.saddr = ct->tuplehash[!dir].tuple.src.u3.in6;
>
>>   		fl.u.ip6.flowi6_oif = nft_in(pkt)->ifindex;
>>   		fl.u.ip6.flowi6_iif = this_dst->dev->ifindex;
>>   		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
>> -- 
>> 1.8.3.1
>>
