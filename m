From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH libnftnl] expr: imm: Fix immediate verdict comparison
Date: Thu, 25 Aug 2016 17:27:00 +0200
Message-ID: <38860437-7479-6b49-7641-e104cb6dbc19@riseup.net>
References: <20160825145658.29391-1-carlosfg@riseup.net>
 <20160825151930.GA3482@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:44218 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756985AbcHYP1F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 11:27:05 -0400
In-Reply-To: <20160825151930.GA3482@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/25/2016 05:19 PM, Pablo Neira Ayuso wrote:
> On Thu, Aug 25, 2016 at 04:56:58PM +0200, Carlos Falgueras García wrote:
>> An immediate expression of type 'DATA_VERDICT' can have set a chain (jump
>> or goto), in this cases we must compare its 'union nftnl_data_reg' using
>> 'DATA_CHAIN' flag instead of 'DATA_VERDICT'
>>
>> Before this patch compare expressions "jump -> chain_a" and
>> "jump -> chain_b" returns they are equals.
>>
>> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
>> ---
>>  src/expr/immediate.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/src/expr/immediate.c b/src/expr/immediate.c
>> index cb8a81b..b26fc8d 100644
>> --- a/src/expr/immediate.c
>> +++ b/src/expr/immediate.c
>> @@ -329,10 +329,16 @@ static bool nftnl_expr_immediate_cmp(const struct nftnl_expr *e1,
>>
>>  	if (e1->flags & (1 << NFTNL_EXPR_IMM_DREG))
>>  		eq &= (i1->dreg == i2->dreg);
>> -	if (e1->flags & (1 << NFTNL_EXPR_IMM_VERDICT))
>> -		eq &= nftnl_data_reg_cmp(&i1->data, &i2->data, DATA_VERDICT);
>> -	else if (e1->flags & (1 << NFTNL_EXPR_IMM_DATA))
>> +	if (e1->flags & (1 << NFTNL_EXPR_IMM_VERDICT)) {
>> +		if (e1->flags & (1 << NFTNL_EXPR_IMM_CHAIN))
>> +			eq &= nftnl_data_reg_cmp(&i1->data, &i2->data,
>> +						 DATA_CHAIN);
>> +		else
>> +			eq &= nftnl_data_reg_cmp(&i1->data, &i2->data,
>> +						 DATA_VERDICT);
>
> Probably better with this patch below? You don't need to split the
> lines.
>
> No need to resend, just review and confirm this change is OK and I'll
> apply this here.

Yes, thanks Pablo. It is equivalent but more clean. Maybe DATA_VALUE can be consolidated too?
