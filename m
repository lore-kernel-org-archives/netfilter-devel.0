From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: PROBLEM: Netfilter time matching matches all packets when time
 start and time stop is the same
Date: Thu, 1 Aug 2013 18:35:22 -0700
Message-ID: <CAHo-Ooz+Wz23kMBL-LgWw6HxpzQr7hJYJZNWkinOyCB1w+41zw@mail.gmail.com>
References: <CAK+MRYuFUCvkker9sq7LFa42t=vQ7FhWwzz37Mtw3sLMZTJ+EQ@mail.gmail.com>
	<20130801112444.GE21352@unicorn.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Henry Lee <henryronlee@gmail.com>, pablo@netfilter.org,
	kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: Michal Kubecek <mkubecek@suse.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:57550 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3HBBfX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:35:23 -0400
In-Reply-To: <20130801112444.GE21352@unicorn.suse.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Does having timestart == timestop make any sense?
Why would you want to do that?

Perhaps make iptables reject such input?

On Thu, Aug 1, 2013 at 4:24 AM, Michal Kubecek <mkubecek@suse.cz> wrote:
> On Wed, Jul 31, 2013 at 04:42:15PM +0800, Henry Lee wrote:
>> diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
>> index 0ae55a3..753573c 100644
>> --- a/net/netfilter/xt_time.c
>> +++ b/net/netfilter/xt_time.c
>> @@ -192,7 +192,7 @@ time_mt(const struct sk_buff *skb, struct
>> xt_action_param *par)
>>
>>      packet_time = localtime_1(&current_time, stamp);
>>
>> -   if (info->daytime_start < info->daytime_stop) {
>> +   if (info->daytime_start <= info->daytime_stop) {
>>          if (packet_time < info->daytime_start ||
>>              packet_time > info->daytime_stop)
>>              return false;
>>
>
> As far as I can see, this would cause only packets arriving at midnight
> to match by default (i.e. without both --timestart and --timestop).
>
>                                                          Michal Kubecek
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
