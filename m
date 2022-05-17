Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F96C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 01:57:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbiEQB5N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 21:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiEQB5M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 21:57:12 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90E5E13E9F
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 18:57:08 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:46164.1237796334
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-101.229.165.117 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 4A5DD280133;
        Tue, 17 May 2022 09:57:00 +0800 (CST)
X-189-SAVE-TO-SEND: wenxu@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id a752b084050c42f689a77c0ff887f990 for pablo@netfilter.org;
        Tue, 17 May 2022 09:57:05 CST
X-Transaction-ID: a752b084050c42f689a77c0ff887f990
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
Message-ID: <abf35fe1-f581-8f53-b654-c4b434d4a972@chinatelecom.cn>
Date:   Tue, 17 May 2022 09:56:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [nf-next PATCH] nf_flow_table_offload: offload the PPPoE encap in
 the flowtable
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
References: <1652189176-49750-1-git-send-email-wenxu@chinatelecom.cn>
 <YoIx8zglMHjb4Gi7@salvia>
From:   wenxu <wenxu@chinatelecom.cn>
In-Reply-To: <YoIx8zglMHjb4Gi7@salvia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The patch “netfilter: nft_flow_offload: fix offload with pppoe + vlan”

Currently the nf flow table can't offload pppoe encap. So this patch

fix the pppoe + vlan  problem for no encap offload logic in the nf tree,  the

outdev should be the pppoe device but not vlan device.


My patch provide a feature with pppoe encap offload. I think that the difference

and maybe I can repost the three patch rebase  to this series?


Any ideas?


On 2022/5/16 19:13, Pablo Neira Ayuso wrote:
> Hi,
>
> This is likely clashing with Felix's fixes:
>
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220509122616.65449-1-nbd@nbd.name/
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220509122616.65449-2-nbd@nbd.name/
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220509122616.65449-3-nbd@nbd.name/
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220509122616.65449-4-nbd@nbd.name/
>
> On Tue, May 10, 2022 at 09:26:16AM -0400, wenxu@chinatelecom.cn wrote:
>> From: wenxu <wenxu@chinatelecom.cn>
>>
>> This patch put the pppoe process in the FLOW_OFFLOAD_XMIT_DIRECT
>> mode. Xmit the packet with PPPoE can offload to the underlay device
>> directly.
>>
>> It can support all kinds of VLAN dev path:
>> pppoe-->eth
>> pppoe-->br0.100-->br0(vlan filter enable)-->eth
>> pppoe-->eth.100-->eth
>>
>> The packet xmit and recv offload to the 'eth' in both original and
>> reply direction.
>>
>> Signed-off-by: wenxu <wenxu@chinatelecom.cn>
>> ---
>> This patch based on the following one: nf_flow_table_offload: offload the vlan encap in the flowtable
>> http://patchwork.ozlabs.org/project/netfilter-devel/patch/1649169515-4337-1-git-send-email-wenx05124561@163.com/
>>
>>  include/net/netfilter/nf_flow_table.h | 34 ++++++++++++++++++++++++++++++++++
>>  net/netfilter/nf_flow_table_ip.c      |  3 +++
>>  net/netfilter/nft_flow_offload.c      | 10 +++-------
>>  3 files changed, 40 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
>> index 64daafd..8be369c 100644
>> --- a/include/net/netfilter/nf_flow_table.h
>> +++ b/include/net/netfilter/nf_flow_table.h
>> @@ -319,6 +319,40 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
>>  int nf_flow_table_offload_init(void);
>>  void nf_flow_table_offload_exit(void);
>>  
>> +static inline int nf_flow_ppoe_push(struct sk_buff *skb, u16 id)
>> +{
>> +	struct ppp_hdr {
>> +		struct pppoe_hdr hdr;
>> +		__be16 proto;
>> +	} *ph;
>> +	int data_len = skb->len + 2;
>> +	__be16 proto;
>> +
>> +	if (skb_cow_head(skb, PPPOE_SES_HLEN))
>> +		return -1;
>> +
>> +	if (skb->protocol == htons(ETH_P_IP))
>> +		proto = htons(PPP_IP);
>> +	else if (skb->protocol == htons(ETH_P_IPV6))
>> +		proto = htons(PPP_IPV6);
>> +	else
>> +		return -1;
>> +
>> +	__skb_push(skb, PPPOE_SES_HLEN);
>> +	skb_reset_network_header(skb);
>> +
>> +	ph = (struct ppp_hdr *)(skb->data);
>> +	ph->hdr.ver  = 1;
>> +	ph->hdr.type = 1;
>> +	ph->hdr.code = 0;
>> +	ph->hdr.sid  = htons(id);
>> +	ph->hdr.length = htons(data_len);
>> +	ph->proto = proto;
>> +	skb->protocol = htons(ETH_P_PPP_SES);
>> +
>> +	return 0;
>> +}
>> +
>>  static inline __be16 nf_flow_pppoe_proto(const struct sk_buff *skb)
>>  {
>>  	__be16 proto;
>> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
>> index 99ae2550..d1c0d95 100644
>> --- a/net/netfilter/nf_flow_table_ip.c
>> +++ b/net/netfilter/nf_flow_table_ip.c
>> @@ -295,6 +295,9 @@ static void nf_flow_encap_push(struct sk_buff *skb,
>>  				      tuplehash->tuple.encap[i].proto,
>>  				      tuplehash->tuple.encap[i].id);
>>  			break;
>> +		case htons(ETH_P_PPP_SES):
>> +			nf_flow_ppoe_push(skb, tuplehash->tuple.encap[i].id);
>> +			break;
>>  		}
>>  	}
>>  }
>> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
>> index f9837c9..eea8637 100644
>> --- a/net/netfilter/nft_flow_offload.c
>> +++ b/net/netfilter/nft_flow_offload.c
>> @@ -122,12 +122,9 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
>>  			info->encap[info->num_encaps].id = path->encap.id;
>>  			info->encap[info->num_encaps].proto = path->encap.proto;
>>  			info->num_encaps++;
>> -			if (path->type == DEV_PATH_PPPOE) {
>> -				info->outdev = path->dev;
>> +			if (path->type == DEV_PATH_PPPOE)
>>  				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
>> -			}
>> -			if (path->type == DEV_PATH_VLAN)
>> -				info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
>> +			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
>>  			break;
>>  		case DEV_PATH_BRIDGE:
>>  			if (is_zero_ether_addr(info->h_source))
>> @@ -155,8 +152,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
>>  			break;
>>  		}
>>  	}
>> -	if (!info->outdev)
>> -		info->outdev = info->indev;
>> +	info->outdev = info->indev;
>>  
>>  	info->hw_outdev = info->indev;
>>  
>> -- 
>> 1.8.3.1
>>
