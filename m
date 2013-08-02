From: Henry Lee <henryronlee@gmail.com>
Subject: Re: PROBLEM: Netfilter time matching matches all packets when time
 start and time stop is the same
Date: Fri, 02 Aug 2013 11:18:54 +0800
Message-ID: <51FB251E.9040605@gmail.com>
References: <CAK+MRYuFUCvkker9sq7LFa42t=vQ7FhWwzz37Mtw3sLMZTJ+EQ@mail.gmail.com> <20130801112444.GE21352@unicorn.suse.cz> <CAHo-Ooz+Wz23kMBL-LgWw6HxpzQr7hJYJZNWkinOyCB1w+41zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Michal Kubecek <mkubecek@suse.cz>, pablo@netfilter.org,
	kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37857 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3HBDTH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Aug 2013 23:19:07 -0400
In-Reply-To: <CAHo-Ooz+Wz23kMBL-LgWw6HxpzQr7hJYJZNWkinOyCB1w+41zw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/02/2013 09:35 AM, Maciej =C5=BBenczykowski wrote:
> Does having timestart =3D=3D timestop make any sense?
> Why would you want to do that?
>
> Perhaps make iptables reject such input?
>
> On Thu, Aug 1, 2013 at 4:24 AM, Michal Kubecek <mkubecek@suse.cz> wro=
te:
>> On Wed, Jul 31, 2013 at 04:42:15PM +0800, Henry Lee wrote:
>>> diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
>>> index 0ae55a3..753573c 100644
>>> --- a/net/netfilter/xt_time.c
>>> +++ b/net/netfilter/xt_time.c
>>> @@ -192,7 +192,7 @@ time_mt(const struct sk_buff *skb, struct
>>> xt_action_param *par)
>>>
>>>       packet_time =3D localtime_1(&current_time, stamp);
>>>
>>> -   if (info->daytime_start < info->daytime_stop) {
>>> +   if (info->daytime_start <=3D info->daytime_stop) {
>>>           if (packet_time < info->daytime_start ||
>>>               packet_time > info->daytime_stop)
>>>               return false;
>>>
>> As far as I can see, this would cause only packets arriving at midni=
ght
>> to match by default (i.e. without both --timestart and --timestop).
>>
>>                                                           Michal Kub=
ecek
>>
Dear Mr Kubecek,
I can see that iptables uses 00:00:00 and 23:59:59 as the default value=
=20
of timestart and timestop. In this case, even if both timestart and=20
timestop are not defined by user, it still works correctly.
Of cause, if some other tools use 00:00:00 and 00:00:00 as the default,=
=20
your concern will become a problem.

Dear Mr =C5=BBenczykowski,
I wouldn't use a timestart =3D=3D timestop rule manually. But if I crea=
te=20
iptables rules in a program or a script, this case may happen.
Rejecting this rule seems a little bit harsh, in my opinion, since it=20
doesn't look so unacceptable.

Thank you both for your time.


Yours faithfully,
Henry Lee

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
