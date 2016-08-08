From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 1/4, libnftnl] rule: Implement internal expression
 iterator
Date: Mon, 8 Aug 2016 13:49:05 +0200
Message-ID: <753c537a-fae5-8cf0-f053-8892a51ff676@riseup.net>
References: <20160808111758.4062-1-carlosfg@riseup.net>
 <20160808112502.GA11574@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:57285 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbcHHLtJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 07:49:09 -0400
In-Reply-To: <20160808112502.GA11574@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/08/2016 01:25 PM, Pablo Neira Ayuso wrote:
> On Mon, Aug 08, 2016 at 01:17:55PM +0200, Carlos Falgueras García wrote:
>> With 'nftnl_expr_iter_init' we can create an expression iterator without
>> dynamic memory allocation.
>
> I'd suggest this description:
>
> Introduce nftnl_expr_iter_init() to allow stack allocated iterators
> for internal use.
>
> Another comment below.

Ok, I'll change it at v2, thanks.

>> Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
>> ---
>>  include/internal.h |  1 +
>>  include/rule.h     | 15 +++++++++++++++
>>  src/rule.c         | 23 ++++++++++++-----------
>>  3 files changed, 28 insertions(+), 11 deletions(-)
>>  create mode 100644 include/rule.h
>>
>> diff --git a/include/internal.h b/include/internal.h
>> index c74e2bf..f1b6511 100644
>> --- a/include/internal.h
>> +++ b/include/internal.h
>> @@ -12,6 +12,7 @@
>>  #include "set.h"
>>  #include "set_elem.h"
>>  #include "expr.h"
>> +#include "rule.h"
>>  #include "expr_ops.h"
>>  #include "buffer.h"
>>
>> diff --git a/include/rule.h b/include/rule.h
>> new file mode 100644
>> index 0000000..e2ea578
>> --- /dev/null
>> +++ b/include/rule.h
>> @@ -0,0 +1,15 @@
>> +#ifndef _LIBNFTNL_RULE_INTERNAL_H_
>> +#define _LIBNFTNL_RULE_INTERNAL_H_
>> +
>> +#include <libnftnl/rule.h>
>> +#include <libnftnl/expr.h>
>> +
>> +struct nftnl_expr_iter {
>> +	const struct nftnl_rule	*r;
>> +	struct nftnl_expr	*cur;
>> +};
>> +
>> +void nftnl_expr_iter_init(const struct nftnl_rule *r,
>> +			  struct nftnl_expr_iter *iter);
>
> If nftnl_expr_iter_init() is only used from src/rule.c, then there is
> no need to expose this rule include/rule.h
>

Ok.
