From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 4/5, V2, nft] Simplify parser rule_spec tree
Date: Mon, 8 Aug 2016 19:02:37 +0200
Message-ID: <db0f87c2-a7ca-3980-71aa-82cd65ab09bb@riseup.net>
References: <20160808111758.4062-1-carlosfg@riseup.net>
 <20160808124235.11135-1-carlosfg@riseup.net>
 <20160808124235.11135-4-carlosfg@riseup.net> <20160808145409.GD6264@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:35314 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbcHHRCm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 13:02:42 -0400
In-Reply-To: <20160808145409.GD6264@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/08/2016 04:54 PM, Pablo Neira Ayuso wrote:
> On Mon, Aug 08, 2016 at 02:42:34PM +0200, Carlos Falgueras García wrote:
>> -position_spec		:	/* empty */
>> +rule_position		:	chain_spec
>>  			{
>> -				memset(&$$, 0, sizeof($$));
>> +				$$ = $1;
>>  			}
>> -			|	POSITION	NUM
>> +			|	chain_spec position_spec
>>  			{
>> -				memset(&$$, 0, sizeof($$));
>> -				$$.location	= @$;
>> -				$$.id		= $2;
>> +				$$ = $1;
>> +				handle_merge(&$$, &$2);
>> +			}
>> +			|	chain_spec error
>> +			{
>> +				erec_queue(error(&@2, "Expected `position' or nothing"),
>
> In what case we display this error message after this patch?

When user try to use 'handle' with CMD_INSERT or CMD_ADD. The error was 
"use only `position' instead"

> Please, include examples in your patch description.

Ok, I'll do.

> You can also explicitly indicate that tests pass succesfully.

At V3 all tests will pass succesfully.
