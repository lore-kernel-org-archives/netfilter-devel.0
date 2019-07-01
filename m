Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C356DC0650E
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 15:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7446220B7C
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 15:46:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="MfMA/FW1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbfGAPqd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 11:46:33 -0400
Received: from outback4j.mail.yandex.net ([95.108.130.78]:46946 "EHLO
        outback4j.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbfGAPqd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 11:46:33 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2019 11:46:29 EDT
Received: from outback4j.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by outback4j.mail.yandex.net (Yandex) with ESMTP id 9EE5B394168D;
        Mon,  1 Jul 2019 18:41:21 +0300 (MSK)
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:401:eef4:bbff:fe29:83c4])
        by outback4j.mail.yandex.net (nwsmtp/Yandex) with ESMTPS id q84ZgeiRFs-fKE0PHJF;
        Mon, 01 Jul 2019 18:41:20 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Front: outback4j.mail.yandex.net
X-Yandex-TimeMark: 1561995680.318
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1561995680; bh=tMtkuSweWJwcVsrQULlej9wH/57btEujTKlowYXiBCs=;
        h=Cc:References:Date:Message-ID:In-Reply-To:From:To:Subject;
        b=MfMA/FW1UgJwK37NMeo7+wD7qjK9GjX0IIMyGRauuyBqYMU7+TpXBwabKiXp0Bm/z
         u8KVPU+kfYIyLyCl2bZdXKw18v7g7YwpBp0PG1octoMf/p6wyDrCUcTwn2RpPJGQza
         nf6yNkA5wG7IM0M43ExOdUrpKc2zjDCIUa8ayRrc=
X-Yandex-Suid-Status: 1 0,1 0,1 0,1 0,1 0
X-Yandex-Spam: 1
X-Yandex-Envelope: aGVsbz1bSVB2NjoyYTAyOjZiODowOjQwMTplZWY0OmJiZmY6ZmUyOTo4M2M0XQptYWlsX2Zyb209dmZlZG9yZW5rb0B5YW5kZXgtdGVhbS5ydQpyY3B0X3RvPW5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcKcmNwdF90bz1wYWJsb0BuZXRmaWx0ZXIub3JnCnJjcHRfdG89a2hsZWJuaWtvdkB5YW5kZXgtdGVhbS5ydQpyY3B0X3RvPWphQHNzaS5iZwpyY3B0X3RvPWhvcm1zQHZlcmdlLm5ldC5hdQpyZW1vdGVfaG9zdD1keW5hbWljLXJlZC5kaGNwLnluZHgubmV0CnJlbW90ZV9pcD0yYTAyOjZiODowOjQwMTplZWY0OmJiZmY6ZmUyOTo4M2M0Cg==
X-Yandex-Hint: bGFiZWw9U3lzdE1ldGthU086cGVvcGxlCmxhYmVsPVN5c3RNZXRrYVNPOnRydXN0XzYKbGFiZWw9U3lzdE1ldGthU086dF9wZW9wbGUKc2Vzc2lvbl9pZD1xODRaZ2VpUkZzLWZLRTBQSEpGCmxhYmVsPXN5bWJvbDplbmNyeXB0ZWRfbGFiZWwKaXBmcm9tPTJhMDI6NmI4OjA6NDAxOmVlZjQ6YmJmZjpmZTI5OjgzYzQK
Subject: Re: [PATCH v2] ipvs: allow tunneling with gre encapsulation
To:     Simon Horman <horms@verge.net.au>
Cc:     Julian Anastasov <ja@ssi.bg>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <1561933729-5333-1-git-send-email-vfedorenko@yandex-team.ru>
 <20190701152917.vdkzakj4vhvbl3lw@verge.net.au>
From:   Vadim Fedorenko <vfedorenko@yandex-team.ru>
Message-ID: <d8a6e53a-1bda-4803-1e6b-559f31ae8907@yandex-team.ru>
Date:   Mon, 1 Jul 2019 18:41:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190701152917.vdkzakj4vhvbl3lw@verge.net.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Simon,

Thanks for review. I'll send v3 patch with 'else if' statement.
Converting it to case statement seems to be overkill until adding
another type of encapsulation

On 01.07.2019 18:29, Simon Horman wrote:
> On Mon, Jul 01, 2019 at 01:28:49AM +0300, Vadim Fedorenko wrote:
>> windows real servers can handle gre tunnels, this patch allows
>> gre encapsulation with the tunneling method, thereby letting ipvs
>> be load balancer for windows-based services
>>
>> Signed-off-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>
>> ---
>>   include/uapi/linux/ip_vs.h      |  1 +
>>   net/netfilter/ipvs/ip_vs_ctl.c  |  1 +
>>   net/netfilter/ipvs/ip_vs_xmit.c | 76 +++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 78 insertions(+)
>>
>> diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
>> index e4f1806..4102ddc 100644
>> --- a/include/uapi/linux/ip_vs.h
>> +++ b/include/uapi/linux/ip_vs.h
>> @@ -128,6 +128,7 @@
>>   enum {
>>   	IP_VS_CONN_F_TUNNEL_TYPE_IPIP = 0,	/* IPIP */
>>   	IP_VS_CONN_F_TUNNEL_TYPE_GUE,		/* GUE */
>> +	IP_VS_CONN_F_TUNNEL_TYPE_GRE,		/* GRE */
>>   	IP_VS_CONN_F_TUNNEL_TYPE_MAX,
>>   };
>>   
>> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
>> index 84384d8..998353b 100644
>> --- a/net/netfilter/ipvs/ip_vs_ctl.c
>> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
>> @@ -525,6 +525,7 @@ static void ip_vs_rs_hash(struct netns_ipvs *ipvs, struct ip_vs_dest *dest)
>>   			port = dest->tun_port;
>>   			break;
>>   		case IP_VS_CONN_F_TUNNEL_TYPE_IPIP:
>> +		case IP_VS_CONN_F_TUNNEL_TYPE_GRE:
>>   			port = 0;
>>   			break;
>>   		default:
>> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
>> index 71fc6d6..37cc674 100644
>> --- a/net/netfilter/ipvs/ip_vs_xmit.c
>> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
>> @@ -29,6 +29,7 @@
>>   #include <linux/tcp.h>                  /* for tcphdr */
>>   #include <net/ip.h>
>>   #include <net/gue.h>
>> +#include <net/gre.h>
>>   #include <net/tcp.h>                    /* for csum_tcpudp_magic */
>>   #include <net/udp.h>
>>   #include <net/icmp.h>                   /* for icmp_send */
>> @@ -389,6 +390,13 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
>>   			    skb->ip_summed == CHECKSUM_PARTIAL)
>>   				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
>>   		}
>> +		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
> 
> Hi Vadim,
> 
> The previous conditional also checks the value of dest->tun_type,
> so I think that it would be nicer if this was changed to either else if or
> to use a case statement. Likewise elsewhere in this patch.
> 
>> +			__be16 tflags = 0;
>> +
>> +			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
>> +				tflags |= TUNNEL_CSUM;
>> +			mtu -= gre_calc_hlen(tflags);
>> +		}
>>   		if (mtu < 68) {
>>   			IP_VS_DBG_RL("%s(): mtu less than 68\n", __func__);
>>   			goto err_put;
> 
> ...
> 
