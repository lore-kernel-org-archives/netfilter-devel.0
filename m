From: Taehee Yoo <ap420073@gmail.com>
Subject: Re: [PATCH] netfilter: xt_ecn: Add missing hotdrop mark.
Date: Tue, 1 Aug 2017 11:57:03 +0900
Message-ID: <CAMArcTUK_VT2fZP-gfdx4mabQ4aymktxZq4pDkZ73uQ_kK0s0w@mail.gmail.com>
References: <20170729103300.30447-1-ap420073@gmail.com> <20170731182015.GA15201@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35042 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751769AbdHAC5F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 22:57:05 -0400
Received: by mail-yw0-f196.google.com with SMTP id l82so250687ywc.2
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:57:05 -0700 (PDT)
In-Reply-To: <20170731182015.GA15201@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-08-01 3:20 GMT+09:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Sat, Jul 29, 2017 at 07:33:00PM +0900, Taehee Yoo wrote:
>> If the netfilter can't get L4 header, the netfilter
>> marks hotdrop value. then {ip, ip6, arp, eb}t_do_table() drops
>> that packet immediately. but xt_ecn doesn't mark hotdrop value.
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>> ---
>>  net/netfilter/xt_ecn.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/netfilter/xt_ecn.c b/net/netfilter/xt_ecn.c
>> index 3c831a8..c58db1d 100644
>> --- a/net/netfilter/xt_ecn.c
>> +++ b/net/netfilter/xt_ecn.c
>> @@ -37,8 +37,10 @@ static bool match_tcp(const struct sk_buff *skb, struct xt_action_param *par)
>>        * be good citizens.
>>        */
>>       th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
>> -     if (th == NULL)
>> +     if (!th) {
>> +             par->hotdrop = true;
>>               return false;
>> +     }
>
> Is it that we always - consistenly - drop packets that has no
> information that we need.
>

Below match modules are mark hotdrop value when they can not get L4 header.
xt_tcpudp, xt_dccp, xt_sctp, xt_multiport, xt_tcpmss, xt_esp,
xt_ipcomp, xt_hashlimit, ipt_ah,
ip6t_rt, ip6t_frag, ip6t_mh, ip6t_hbh.
And Below match modules are do not mark hotdrop value when they can
not get L4 header.
xt_l2tp, xt_ecn, xt_osf.
So, we do not always mark hotdrop value.

> I would say it's better to do this via policy, it's more flexible,
> rather than assuming that accessing a packet that doesn't contain the
> information that we need means a drop.
>

I agree with your mention.
Already target functions drop packets If they can not get what we need.
So, It's working well even now.

> Another concern for me regarding this is the fact that probably this
> has been the default behaviour for long time, if that's the case, I
> would be reluctant to change this at this point.
>

Yes, It has been the default for long time. so, I agree with your decision.


> Let me know, thanks!

Thank you for your review!
