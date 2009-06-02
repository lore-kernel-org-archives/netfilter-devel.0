From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] TCP simultaneous open support
Date: Tue, 02 Jun 2009 13:53:59 +0200
Message-ID: <4A2512D7.8010806@trash.net>
References: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu> <4A250DDA.1010406@trash.net> <alpine.DEB.2.00.0906021336080.11925@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Saatvik Agarwal <saatvik.agarwal@stanford.edu>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37495 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760318AbZFBLyA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 07:54:00 -0400
In-Reply-To: <alpine.DEB.2.00.0906021336080.11925@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> Hi Patrick,
> 
> On Tue, 2 Jun 2009, Patrick McHardy wrote:
> 
>> Thanks Jozsef. Just one question:
>>
>>> -	TCP_CONNTRACK_LISTEN,
>>> +	TCP_CONNTRACK_SYN_SENT2,
>> is this constant already used in userspace? From your conntrack
>> output above I'd assume the answer is yes, so we should keep it
>> around as an alias to avoid compilation errors.
> 
> libnetfilter_conntrack has got it's own header file which defines 
> TCP_CONNTRACK_LISTEN and it's string interpretation as "LISTEN" state. 
> 'conntrack' relies on libnetfilter_conntrack when translating the 
> numerical id received from the kernel to the string value, that is the 
> reason for the "misinterpretation" of the state. So from 
> libnetfilter_conntrack and conntrack-tools point of view we can safely 
> remove TCP_CONNTRACK_LISTEN.
> 
> I'm not aware of any project which would use the kernel header file 
> directly, but that does not mean there isn't any. We might keep the 
> symbol, of course. Shall I resend the patch with TCP_CONNTRACK_LISTEN 
> preserved?

Thanks for the explanation. I think we should keep it around just
to make sure. No need to resend though, I'll just add it myself.

Thanks.
