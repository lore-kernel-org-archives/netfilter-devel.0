From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH V2] ipvs: disable inline net_ipvs function with
 CONFIG_IP_VS not being set
Date: Wed, 25 Mar 2015 12:08:53 +0100
Message-ID: <CACna6rwMOJqRusrooUXKFk9HbVA4NqOY18fCTkqHyTvQA6O_bA@mail.gmail.com>
References: <1427273637-29151-1-git-send-email-zajec5@gmail.com>
	<1427275043-1192-1-git-send-email-zajec5@gmail.com>
	<55128D32.50201@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@verge.net.au>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37178 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbbCYLIy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 07:08:54 -0400
Received: by igcxg11 with SMTP id xg11so22229752igc.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2015 04:08:53 -0700 (PDT)
In-Reply-To: <55128D32.50201@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25 March 2015 at 11:25, Nicolas Dichtel <nicolas.dichtel@6wind.com> =
wrote:
> Le 25/03/2015 10:17, Rafa=C5=82 Mi=C5=82ecki a =C3=A9crit :
>>
>> Including net/ip_vs.h without CONFIG_IP_VS was causing:
>> include/net/ip_vs.h: In function 'net_ipvs':
>> include/net/ip_vs.h:35:12: error: 'struct net' has no member named '=
ipvs'
>>
>> Fixes: 8b4d14d8eb368 ("netns: exclude ipvs from struct net when IPVS
>> disabled")
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
>> ---
>> V2: Disable function totally instead of returning NULL.
>> ---
>>   include/net/ip_vs.h | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
>> index 615b20b..e6f2f2a 100644
>> --- a/include/net/ip_vs.h
>> +++ b/include/net/ip_vs.h
>> @@ -29,11 +29,13 @@
>>   #endif
>>   #include <net/net_namespace.h>                /* Netw namespace */
>>
>> +#if IS_ENABLED(CONFIG_IP_VS)
>>   /* Generic access of ipvs struct */
>>   static inline struct netns_ipvs *net_ipvs(struct net* net)
>>   {
>>         return net->ipvs;
>>   }
>> +#endif
>
> Ok, but this fix nothing, there is no bug upstream. This file is only
> included
> by ipvs module files.

So maybe it should be moved to net/netfilter/ipvs/?


> For me, it's a bit strange to have '#ifdef CONFIG_IP_VS' in a file sp=
ecific
> to
> this module. This just fix your third party module.

Will do. I was just thinking this header doesn't follow headers logic
well and wanted to help.

--=20
Rafa=C5=82
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
