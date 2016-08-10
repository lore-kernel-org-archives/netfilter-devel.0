From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 1/4, V3, libnftnl] rule: Implement internal expression
 iterator
Date: Wed, 10 Aug 2016 13:56:32 +0200
Message-ID: <d506f397-8795-4966-6408-c7d3caa4b082@riseup.net>
References: <20160808144834.GB6264@salvia>
 <20160810094857.14227-1-carlosfg@riseup.net> <20160810114140.GA9639@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:59023 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767AbcHJVMS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 17:12:18 -0400
In-Reply-To: <20160810114140.GA9639@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/10/2016 01:41 PM, Pablo Neira Ayuso wrote:
> On Wed, Aug 10, 2016 at 11:48:54AM +0200, Carlos Falgueras García wrote:
>> Introduce nftnl_expr_iter_init() to allow stack allocated iterators for
>> internal use.
>
> Applied with minor changes, see below.
>>
>> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
>> ---
>>  src/rule.c | 30 +++++++++++++++++++-----------
>>  1 file changed, 19 insertions(+), 11 deletions(-)
>>
>> diff --git a/src/rule.c b/src/rule.c
>> index 11fceca..69ffc7e 100644
>> --- a/src/rule.c
>> +++ b/src/rule.c
>> @@ -29,6 +29,14 @@
>>  #include <libnftnl/set.h>
>>  #include <libnftnl/expr.h>
>>
>> +struct nftnl_expr_iter {
>> +	const struct nftnl_rule	*r;
>> +	struct nftnl_expr	*cur;
>> +};
>> +
>> +static void nftnl_expr_iter_init(const struct nftnl_rule *r,
>> +				 struct nftnl_expr_iter *iter);
>
> No need for this forward declaration. I have removed this.
>
>> +
>>  struct nftnl_rule {
>>  	struct list_head head;
>>
>> @@ -1025,10 +1033,16 @@ int nftnl_expr_foreach(struct nftnl_rule *r,
>>  }
>>  EXPORT_SYMBOL_ALIAS(nftnl_expr_foreach, nft_rule_expr_foreach);
>>
>> -struct nftnl_expr_iter {
>> -	const struct nftnl_rule	*r;
>> -	struct nftnl_expr	*cur;
>> -};
>
> I have kept this structure definition here, we don't have to scroll up
> and down to get the context when looking at the iterators code.
>
> After my change, the patch looks even smaller.
>

But we will need it at the next patch, so I will include these changes 
in the patch : 2/4 - "Implement rule comparison". It is ok?
