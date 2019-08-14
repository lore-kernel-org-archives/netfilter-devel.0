Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21062C0650F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 012162054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfHNHyI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 03:54:08 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:23486 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfHNHyI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 03:54:08 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id C676941B0F;
        Wed, 14 Aug 2019 15:54:04 +0800 (CST)
Subject: Re: [PATCH nf-next v3 5/9] netfilter: nft_tunnel: support
 NFT_TUNNEL_SRC/DST_IP match
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
References: <1564668086-16260-1-git-send-email-wenxu@ucloud.cn>
 <1564668086-16260-6-git-send-email-wenxu@ucloud.cn>
 <20190813181930.ljrisiq2iszcddlk@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <ba98af8c-fcd3-50dd-770d-ddb85a887031@ucloud.cn>
Date:   Wed, 14 Aug 2019 15:54:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813181930.ljrisiq2iszcddlk@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSE9DS0tLS09CTkJKS01ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MT46FBw4ATgyCzkdHEMcCR06
        NR0aCz1VSlVKTk1OTE1CSU9OSk9KVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT05NTDcG
X-HM-Tid: 0a6c8f1ea1572086kuqyc676941b0f
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 8/14/2019 2:19 AM, Pablo Neira Ayuso wrote:
> On Thu, Aug 01, 2019 at 10:01:22PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Add new two NFT_TUNNEL_SRC/DST_IP match in nft_tunnel
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>> v3: no change
>>
>>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>>  net/netfilter/nft_tunnel.c               | 46 +++++++++++++++++++++++++-------
>>  2 files changed, 38 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
>> index 82abaa1..173690a 100644
>> --- a/include/uapi/linux/netfilter/nf_tables.h
>> +++ b/include/uapi/linux/netfilter/nf_tables.h
>> @@ -1765,6 +1765,8 @@ enum nft_tunnel_key_attributes {
>>  enum nft_tunnel_keys {
>>  	NFT_TUNNEL_PATH,
>>  	NFT_TUNNEL_ID,
>> +	NFT_TUNNEL_SRC_IP,
>> +	NFT_TUNNEL_DST_IP,
>>  	__NFT_TUNNEL_MAX
>>  };
>>  #define NFT_TUNNEL_MAX	(__NFT_TUNNEL_MAX - 1)
>> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
>> index 3d4c2ae..e218163 100644
>> --- a/net/netfilter/nft_tunnel.c
>> +++ b/net/netfilter/nft_tunnel.c
>> @@ -18,6 +18,18 @@ struct nft_tunnel {
>>  	enum nft_tunnel_mode	mode:8;
>>  };
>>  
>> +bool nft_tunnel_mode_validate(enum nft_tunnel_mode priv_mode, u8 tun_mode)
>> +{
>> +	if (priv_mode == NFT_TUNNEL_MODE_NONE ||
>> +	    (priv_mode == NFT_TUNNEL_MODE_RX &&
>> +	     !(tun_mode & IP_TUNNEL_INFO_TX)) ||
>> +	    (priv_mode == NFT_TUNNEL_MODE_TX &&
>> +	     (tun_mode & IP_TUNNEL_INFO_TX)))
>> +		return true;
>> +
>> +	return false;
>> +}
> Make an initial patch to add nft_tunnel_mode_validate().
>
>>  static void nft_tunnel_get_eval(const struct nft_expr *expr,
>>  				struct nft_regs *regs,
>>  				const struct nft_pktinfo *pkt)
>> @@ -34,11 +46,7 @@ static void nft_tunnel_get_eval(const struct nft_expr *expr,
>>  			nft_reg_store8(dest, false);
>>  			return;
>>  		}
>> -		if (priv->mode == NFT_TUNNEL_MODE_NONE ||
>> -		    (priv->mode == NFT_TUNNEL_MODE_RX &&
>> -		     !(tun_info->mode & IP_TUNNEL_INFO_TX)) ||
>> -		    (priv->mode == NFT_TUNNEL_MODE_TX &&
>> -		     (tun_info->mode & IP_TUNNEL_INFO_TX)))
>> +		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
>>  			nft_reg_store8(dest, true);
>>  		else
>>  			nft_reg_store8(dest, false);
> [...]
>> +	case NFT_TUNNEL_DST_IP:
>> +		if (!tun_info) {
>> +			regs->verdict.code = NFT_BREAK;
>> +			return;
>> +		}
>> +		if (nft_tunnel_mode_validate(priv->mode, tun_info->mode))
>> +			*dest = ntohl(tun_info->key.u.ipv4.dst);
> No need to convert this from network to host endianess.
>
>> +		else
>> +			regs->verdict.code = NFT_BREAK;
>> +		break;
>>  	default:
>>  		WARN_ON(1);
>>  		regs->verdict.code = NFT_BREAK;
>> @@ -86,6 +110,8 @@ static int nft_tunnel_get_init(const struct nft_ctx *ctx,
>>  		len = sizeof(u8);
>>  		break;
>>  	case NFT_TUNNEL_ID:
>> +	case NFT_TUNNEL_SRC_IP:
>> +	case NFT_TUNNEL_DST_IP:
> Missing policy updates, ie. nft_tunnel_key_policy.

I don't understand why it need update nft_tunnel_key_policy
which is used for tunnel_obj action. This NFT_TUNNEL_SRC/DST_IP is used
for tunnel_expr

>
