From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] src: proto: Add missing packet type
Date: Tue, 1 Mar 2016 19:21:28 +0530
Message-ID: <CAKHNQQEA74vCr8pq-reDkQu3kSc66hOseUOTzMcYArqsWVcX8Q@mail.gmail.com>
References: <20160301123912.GA6905@gmail.com> <20160301131740.GD22817@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33574 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbcCANwJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 08:52:09 -0500
Received: by mail-wm0-f47.google.com with SMTP id l68so36391063wml.0
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2016 05:52:08 -0800 (PST)
In-Reply-To: <20160301131740.GD22817@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 1, 2016 at 6:47 PM, Florian Westphal <fw@strlen.de> wrote:
> Shivani Bhardwaj <shivanib134@gmail.com> wrote:
>> Add missing packet type "invalid" for DCCP.
>>
>> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
>> ---
>>  src/proto.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/src/proto.c b/src/proto.c
>> index 0ed98ed..4d049f5 100644
>> --- a/src/proto.c
>> +++ b/src/proto.c
>> @@ -443,6 +443,7 @@ static const struct symbol_table dccp_pkttype_tbl = {
>>               SYMBOL("reset",         DCCP_PKT_RESET),
>>               SYMBOL("sync",          DCCP_PKT_SYNC),
>>               SYMBOL("syncack",       DCCP_PKT_SYNCACK),
>> +             SYMBOL("invalid",       DCCP_PKT_INVALID),
>
> I don't think this is a good idea -- when user asks to match
> 'invalid' then this will check type == DCCP_PKT_INVALID; however
> the correct way would be to ask for type '> synack' (i.e.,
> outside of the range of types specified).

OK. So, should this be removed from the enum dccp_pkt_type as well?

And, if following iptables rules, one tries to get code corresponding
to dccp type invalid using iptables-translate utility, then the
corresponding nft rule should be "dccp type gt syncack". Please
correct me if I'm wrong here.
