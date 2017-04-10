From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH iptables] extensions: libxt_hashlimit: fix 64-bit printf
 formats
Date: Mon, 10 Apr 2017 17:59:07 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1704101749480.27401@n3.vanv.qr>
References: <1491565649-16679-1-git-send-email-James.Cowgill@imgtec.com> <20170408202917.GA3568@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: James Cowgill <James.Cowgill@imgtec.com>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:37902 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754241AbdDJP7J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 11:59:09 -0400
In-Reply-To: <20170408202917.GA3568@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2017-04-08 22:29, Pablo Neira Ayuso wrote:
>> @@ -262,7 +262,7 @@ static uint64_t parse_burst(const char *burst, int revision)
>>  	if (v > max)
>>  		xtables_error(PARAMETER_PROBLEM, "bad value for option "
>>  			"\"--hashlimit-burst\", value \"%s\" too large "
>> -				"(max %lumb).", burst, max/1024/1024);
>> +				"(max %" PRIu64 "mb).", burst, max/1024/1024);
>                                        ^      ^
>
>I can remove this whitespaces, right?

With my distro hat on:

Clumping these together like "foo"BAR"baz" has already caused compile failures
in the broader scope of distributions (thousands of packages) because languages
introduced new tokenization rules. Admittedly, this occurred in C++ (namely,
user-defined string literals), but it does show that tokens which logically are
separate should stay separate.
