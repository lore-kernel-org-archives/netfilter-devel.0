From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 1/2, libnftnl] tests: Consolidate printing error utilities
Date: Fri, 12 Aug 2016 22:16:10 +0200
Message-ID: <33ee9cda-a08f-8e70-ed06-4c01a37c1fbe@riseup.net>
References: <20160811132507.17842-1-carlosfg@riseup.net>
 <20160811232623.GA5108@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:49932 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbcHLUQO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 16:16:14 -0400
In-Reply-To: <20160811232623.GA5108@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/12/2016 01:26 AM, Pablo Neira Ayuso wrote:
> On Thu, Aug 11, 2016 at 03:25:06PM +0200, Carlos Falgueras García wrote:
>> diff --git a/tests/libtest.c b/tests/libtest.c
>> new file mode 100644
>> index 0000000..91f2d5e
>> --- /dev/null
>> +++ b/tests/libtest.c
>> @@ -0,0 +1,49 @@
>> +#include <libtest.h>
>> +
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <stdarg.h>
>> +#include <string.h>
>> +#include <errno.h>
>> +#include <stdbool.h>
>> +
>> +#define COLOR_RED     "\x1b[31m"
>> +#define COLOR_GREEN   "\x1b[32m"
>> +#define COLOR_RESET   "\x1b[0m"
>> +
>> +static bool test_ok = true;
>
> I don't like this internal test_ok.

I will get rid of this at the next patch. Doing it here means change a 
lot of code that I will delete in the next patch.

>>  static void cmp_nftnl_chain(struct nftnl_chain *a, struct nftnl_chain *b)
>>  {
>> @@ -73,7 +67,7 @@ int main(int argc, char *argv[])
>>  	a = nftnl_chain_alloc();
>>  	b = nftnl_chain_alloc();
>>  	if (a == NULL || b == NULL)
>> -		print_err("OOM");
>> +		oom(argv[0]);
>
> You can replace this above by:
>
>         test_assert(a != NULL);
>         test_assert(b != NULL);

I have changed this to 'oom_assert()' to distinguish it from a future 
'test_assert' that will replace current 'print_err'.
