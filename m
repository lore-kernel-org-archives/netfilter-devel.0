From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH 2/2, libnftnl] Use libnftnl comparators in all tests
Date: Fri, 12 Aug 2016 22:16:17 +0200
Message-ID: <fea97d91-a7b1-6287-e368-0615eb8b94b5@riseup.net>
References: <20160811132507.17842-1-carlosfg@riseup.net>
 <20160811132507.17842-2-carlosfg@riseup.net> <20160811233222.GB5108@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:49948 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbcHLUQV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 16:16:21 -0400
In-Reply-To: <20160811233222.GB5108@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/12/2016 01:32 AM, Pablo Neira Ayuso wrote:
> On Thu, Aug 11, 2016 at 03:25:07PM +0200, Carlos Falgueras García wrote:
>> -	cmp_nftnl_expr(rule_a,rule_b);
>> +	if (!nftnl_expr_cmp(rule_a, rule_b))
>> +		print_err("expressions mismatches:\n\texpr 1: %s\n\texpr 2: %s",
>> +			  expr2str(rule_a), expr2str(rule_b));
>
> Better, add something like
>
>                 print_expr_mismatch(rule_a, rule_b);

I have called this 'test_assert_{expr,rule}()' for consistency with 
'test_assert()'.
