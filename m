From: Jagdish Motwani <jagdish.motwani@elitecore.com>
Subject: Re: [PATCH] netfilter conntrack helper: nf_ct_h323: fix bug in rtcp
 natting
Date: Wed, 06 Jun 2012 10:48:26 +0530
Message-ID: <4FCEE822.6050007@elitecore.com>
References: <4FBB2B7B.6060907@elitecore.com> <1337668101.3361.54.camel@edumazet-glaptop> <4FBB51D9.1020602@elitecore.com> <20120605234416.GA27212@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	'Patrick McHardy' <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:36030 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750935Ab2FFFNA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Jun 2012 01:13:00 -0400
In-Reply-To: <20120605234416.GA27212@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/06/2012 05:14 AM, Pablo Neira Ayuso wrote:
> On Tue, May 22, 2012 at 02:14:09PM +0530, Jagdish Motwani wrote:
> [...]
>> Thanks. Updating the patch
> Applied, thanks.
>
> Please, next time don't forget to include the patch description (even
> if you already in the previous version of your patch).
>
> I cannot apply this with `git am' and that's annoying.
Thanks, will keep this in mind next time.
>> --
>>
>> diff --git a/net/netfilter/nf_conntrack_h323_main.c
>> b/net/netfilter/nf_conntrack_h323_main.c
>> index 46d69d7..31f50bc 100644
>> --- a/net/netfilter/nf_conntrack_h323_main.c
>> +++ b/net/netfilter/nf_conntrack_h323_main.c
>> @@ -270,9 +270,8 @@ static int expect_rtp_rtcp(struct sk_buff *skb,
>> struct nf_conn *ct,
>>                  return 0;
>>
>>          /* RTP port is even */
>> -       port&= htons(~1);
>> -       rtp_port = port;
>> -       rtcp_port = htons(ntohs(port) + 1);
>> +       rtp_port = port&  ~htons(1);
>> +       rtcp_port = port | htons(1);
>>
>>          /* Create expect for RTP */
>>          if ((rtp_exp = nf_ct_expect_alloc(ct)) == NULL)
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

