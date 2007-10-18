From: lizf <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] netfilter: fix - mistake to pass a pointer where
 array is required
Date: Thu, 18 Oct 2007 17:14:49 +0800
Message-ID: <47172409.9000709@cn.fujitsu.com>
References: <470F09EF.9080606@cn.fujitsu.com> <47130392.60902@trash.net> <47133A5B.2020407@cn.fujitsu.com> <471720D9.5030901@trash.net> <471721EA.4020602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:62137 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755540AbXJRJQa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:16:30 -0400
In-Reply-To: <471721EA.4020602@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Patrick McHardy wrote:
>> lizf wrote:
>>> Sorry for the noise, I've configed my mailer according to a kernel doc,
>>> but i'm still not sure whether it works. So here's the attachment.
>>>
>>
>> Thanks, the attachment applies fine, but does not compile:
>>
>>
>>   CC [M]  net/netfilter/xt_sctp.o
>> net/netfilter/xt_sctp.c: In function 'match_packet':
>> net/netfilter/xt_sctp.c:60: error: 'chunkmap' undeclared (first use in
>> this function)
>> net/netfilter/xt_sctp.c:60: error: (Each undeclared identifier is
>> reported only once
>> net/netfilter/xt_sctp.c:60: error: for each function it appears in.)
>> make[1]: *** [net/netfilter/xt_sctp.o] Error 1
>> make: *** [net/netfilter/xt_sctp.o] Error 2
>>
>> The SCTP_CHUNKMAP_COPY uses "chunkmap" internally. What tree did
>> you base this patch on?
> 
> 
> Never mind, I figured out that both patches combined compile,
> so I've combined them in one. For the future: each patch should
> always compile on its own without errors.
> 
> 
> 

I just thought out why it doesn't compile. I should have been more
careful. Thanks for your patience.
