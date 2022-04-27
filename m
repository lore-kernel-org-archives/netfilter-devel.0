Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9763BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 15:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240013AbiD0Plp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 11:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239792AbiD0Plp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 11:41:45 -0400
X-Greylist: delayed 588 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 27 Apr 2022 08:38:23 PDT
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9A8F329C85
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 08:38:21 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:52588.987386712
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-101.229.163.22 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id CA6C528009F;
        Wed, 27 Apr 2022 23:28:28 +0800 (CST)
X-189-SAVE-TO-SEND: wenxu@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id c270346b438b42a5ba29139fc5006161 for pablo@netfilter.org;
        Wed, 27 Apr 2022 23:28:29 CST
X-Transaction-ID: c270346b438b42a5ba29139fc5006161
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
Message-ID: <42afa9bb-e265-33e7-c0dc-75d40689ade1@chinatelecom.cn>
Date:   Wed, 27 Apr 2022 23:28:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH nf-next] nf_flow_table_offload: offload the vlan encap in
 the flowtable
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1649169515-4337-1-git-send-email-wenx05124561@163.com>
 <YmlO009uqhJNnBq7@salvia>
From:   wenxu <wenxu@chinatelecom.cn>
In-Reply-To: <YmlO009uqhJNnBq7@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 2022/4/27 22:10, Pablo Neira Ayuso wrote:
> On Tue, Apr 05, 2022 at 10:38:35AM -0400, wenx05124561@163.com wrote:
>> From: wenxu <wenxu@chinatelecom.cn>
>>
>> This patch put the vlan dev process in the FLOW_OFFLOAD_XMIT_DIRECT
>> mode. Xmit the packet with vlan can offload to the real dev directly.
>>
>> It can support all kinds of VLAN dev path:
>> br0.100-->br0(vlan filter enable)-->eth
>> br0(vlan filter enable)-->eth
>> br0(vlan filter disable)-->eth.100-->eth
> I assume this eth is a bridge port.

Yes it is. And it also can support the case without bridge as following.

eth.100-->eth.

>
>> The packet xmit and recv offload to the 'eth' in both original and
>> reply direction.
> This is an enhancement or fix?
It's an enhancement and  it make the vlan packet can offload through the real dev.
>
> Is this going to work for VLAN + PPP?
>
> Would you update tools/testing/selftests/netfilter/nft_flowtable.sh to
> cover bridge filtering usecase? It could be done in a follow up patch.
I will do for both  if this patch reivew ok .
>
>> Signed-off-by: wenxu <wenxu@chinatelecom.cn>
>> ---
>>  net/netfilter/nf_flow_table_ip.c | 19 +++++++++++++++++++
>>  net/netfilter/nft_flow_offload.c |  7 +++++--
>>  2 files changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
>> index 32c0eb1..99ae2550 100644
>> --- a/net/netfilter/nf_flow_table_ip.c
>> +++ b/net/netfilter/nf_flow_table_ip.c
>> @@ -282,6 +282,23 @@ static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
>>  	return false;
>>  }
>>  
>> +static void nf_flow_encap_push(struct sk_buff *skb,
>> +			       struct flow_offload_tuple_rhash *tuplehash)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < tuplehash->tuple.encap_num; i++) {
>> +		switch (tuplehash->tuple.encap[i].proto) {
>> +		case htons(ETH_P_8021Q):
>> +		case htons(ETH_P_8021AD):
>> +			skb_vlan_push(skb,
>> +				      tuplehash->tuple.encap[i].proto,
>> +				      tuplehash->tuple.encap[i].id);
>> +			break;
>> +		}
>> +	}
>> +}
>> +
>>  static void nf_flow_encap_pop(struct sk_buff *skb,
>>  			      struct flow_offload_tuple_rhash *tuplehash)
>>  {
>> @@ -403,6 +420,7 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
>>  		ret = NF_STOLEN;
>>  		break;
>>  	case FLOW_OFFLOAD_XMIT_DIRECT:
>> +		nf_flow_encap_push(skb, &flow->tuplehash[!dir]);
>>  		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
>>  		if (ret == NF_DROP)
>>  			flow_offload_teardown(flow);
>> @@ -659,6 +677,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
>>  		ret = NF_STOLEN;
>>  		break;
>>  	case FLOW_OFFLOAD_XMIT_DIRECT:
>> +		nf_flow_encap_push(skb, &flow->tuplehash[!dir]);
>>  		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
>>  		if (ret == NF_DROP)
>>  			flow_offload_teardown(flow);
>> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
>> index 900d48c..f9837c9 100644
>> --- a/net/netfilter/nft_flow_offload.c
>> +++ b/net/netfilter/nft_flow_offload.c
>> @@ -119,12 +119,15 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
>>  				info->indev = NULL;
>>  				break;
>>  			}
>> -			info->outdev = path->dev;
>>  			info->encap[info->num_encaps].id = path->encap.id;
>>  			info->encap[info->num_encaps].proto = path->encap.proto;
>>  			info->num_encaps++;
>> -			if (path->type == DEV_PATH_PPPOE)
>> +			if (path->type == DEV_PATH_PPPOE) {
>> +				info->outdev = path->dev;
>>  				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
>> +			}
>> +			if (path->type == DEV_PATH_VLAN)
>> +				info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
>>  			break;
>>  		case DEV_PATH_BRIDGE:
>>  			if (is_zero_ether_addr(info->h_source))
>> -- 
>> 1.8.3.1
>>
