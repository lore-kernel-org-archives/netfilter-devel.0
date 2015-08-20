From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH] netfilter: Remove the duplicated word "see" in the
 comment when set the IPS_ASSURED_BIT in tcp_packet
Date: Thu, 20 Aug 2015 08:49:58 +0800
Message-ID: <CA+6hz4rKrDePk=CcjOFfpkwe0+qS73Y2WgyoEKmUBft0agVaQA@mail.gmail.com>
References: <CA+6hz4o4TbcAhgnC8sbN6utxAR=wWOMkd_=k+hGVqW+tZZxuZw@mail.gmail.com>
	<20150819192537.GA4636@salvia>
	<CA+6hz4rB=QDD8Ei39ieothtf+kyuv9h6VJXeFJD2R78RM94G0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33971 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbbHTAt7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 20:49:59 -0400
Received: by obbfr1 with SMTP id fr1so19411812obb.1
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2015 17:49:58 -0700 (PDT)
In-Reply-To: <CA+6hz4rB=QDD8Ei39ieothtf+kyuv9h6VJXeFJD2R78RM94G0Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I don't know how to send the patch, "add the patch in the email text"
or "commit the patch as the attachment".
So I did both of them in the last email.

Actually I prefer to use the attachment, because it could keep the
original format.

Best Regards
Feng


On Thu, Aug 20, 2015 at 8:47 AM, Feng Gao <gfree.wind@gmail.com> wrote:
> Hi Pablo,
>
> Thanks your reply and advice.
> Now I have updated the patch according to your advice.
>
> From 8844279c5e8966b57251c20c003e896f49f768ee Mon Sep 17 00:00:00 2001
> From: Feng Gao <gfree.wind@gmail.com>
> Date: Thu, 20 Aug 2015 08:43:26 +0800
> Subject: [PATCH] netfilter: nf_ct_tcp: Remove the duplicated word in comment
>
> Signed-off-by: Feng Gao <gfree.wind@gmail.com>
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
> b/net/netfilter/nf_conntrack_proto_tcp.c
> index 70383de..cf7b18a 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1088,9 +1088,9 @@ static int tcp_packet(struct nf_conn *ct,
>            && (old_state == TCP_CONNTRACK_SYN_RECV
>                || old_state == TCP_CONNTRACK_ESTABLISHED)
>            && new_state == TCP_CONNTRACK_ESTABLISHED) {
> -       /* Set ASSURED if we see see valid ack in ESTABLISHED
> -          after SYN_RECV or a valid answer for a picked up
> -          connection. */
> +       /* Set ASSURED if we see valid ack in ESTABLISHED after
> +        * SYN_RECV or a valid answer for a picked up connection.
> +        */
>         set_bit(IPS_ASSURED_BIT, &ct->status);
>         nf_conntrack_event_cache(IPCT_ASSURED, ct);
>     }
> --
>
>
> On Thu, Aug 20, 2015 at 3:25 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Thu, Aug 13, 2015 at 04:22:28PM +0800, Feng Gao wrote:
>>> Hi Pablo,
>>>
>>> There is one duplicated word "see" in the comment when set the
>>> IPS_ASSURED_BIT in tcp_packet.
>>>
>>> The attachment is the patch file.
>>>
>>> The following is the change.
>>>
>>> From d092aaa3dc847ed08b27081a467e39727d6627cb Mon Sep 17 00:00:00 2001
>>> From: Feng Gao <gfree.wind@gmail.com>
>>> Date: Thu, 13 Aug 2015 16:14:36 +0800
>>> Subject: [PATCH 1/1] netfilter: Remove the duplicated word "see" in the
>>>  comment when set the IPS_ASSURED_BIT in tcp_packet
>>>
>>> Signed-off-by: Feng Gao <gfree.wind@gmail.com>
>>> ---
>>>  net/netfilter/nf_conntrack_proto_tcp.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
>>> b/net/netfilter/nf_conntrack_proto_tcp.c
>>> index 70383de..697210f 100644
>>> --- a/net/netfilter/nf_conntrack_proto_tcp.c
>>> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
>>> @@ -1088,7 +1088,7 @@ static int tcp_packet(struct nf_conn *ct,
>>>            && (old_state == TCP_CONNTRACK_SYN_RECV
>>>                || old_state == TCP_CONNTRACK_ESTABLISHED)
>>>            && new_state == TCP_CONNTRACK_ESTABLISHED) {
>>> -       /* Set ASSURED if we see see valid ack in ESTABLISHED
>>> +       /* Set ASSURED if we see valid ack in ESTABLISHED
>>>            after SYN_RECV or a valid answer for a picked up
>>>            connection. */
>>
>> I think this is a good chance to fix the comment style, this should
>> be:
>>
>>         /* Set ASSURED if we see valid ack in ESTABLISHED after
>>          * SYN_RECV or a valid answer for a picked up connection.
>>          */
>>
>> Would you update the comment style in the same patch and resubmit,
>> please?
>>
>> I'd also suggest a smaller patch title, eg.
>>
>> netfilter: nf_ct_tcp: Remove the duplicated word in comment
>>
>> Thanks!
