From: James Cowgill <James.Cowgill@imgtec.com>
Subject: Re: [PATCH iptables] extensions: libxt_hashlimit: fix 64-bit printf
 formats
Date: Mon, 10 Apr 2017 10:38:44 +0100
Message-ID: <e6f3b34b-eec5-77cf-abd6-66ce90a1e7f8@imgtec.com>
References: <1491565649-16679-1-git-send-email-James.Cowgill@imgtec.com>
 <20170408202917.GA3568@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:35701 "EHLO
        mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdDJJiq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 05:38:46 -0400
Received: from HHMAIL01.hh.imgtec.org (unknown [10.100.10.19])
        by Forcepoint Email with ESMTPS id 2E49C37A9CEB7
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 10:38:42 +0100 (IST)
In-Reply-To: <20170408202917.GA3568@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/04/17 21:29, Pablo Neira Ayuso wrote:
> On Fri, Apr 07, 2017 at 12:47:29PM +0100, James Cowgill wrote:
>> hashlimit was using "%lu" in a lot of printf format specifiers to print
>> 64-bit integers. This is incorrect on 32-bit architectures because
>> "long int" is 32-bits there. On MIPS, it was causing iptables to
>> segfault when printing these integers.
>>
>> Fix by using the correct format specifier.
> 
> One comment below...
> 
>> @@ -262,7 +262,7 @@ static uint64_t parse_burst(const char *burst, int revision)
>>  	if (v > max)
>>  		xtables_error(PARAMETER_PROBLEM, "bad value for option "
>>  			"\"--hashlimit-burst\", value \"%s\" too large "
>> -				"(max %lumb).", burst, max/1024/1024);
>> +				"(max %" PRIu64 "mb).", burst, max/1024/1024);
>                                         ^      ^
> 
> I can remove this whitespaces, right? I'm looking at other spots in
> the iptables code and I would like to keep this consistent.
> 
> No need to resent the patch, I can just mangle this here and apply.

Yes removing the spaces around PRIu64 should be fine.

James
