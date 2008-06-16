From: Patrick McHardy <kaber@trash.net>
Subject: Re: Support NAT-ed expect entries from user space
Date: Tue, 17 Jun 2008 00:43:37 +0200
Message-ID: <4856EC99.6070903@trash.net>
References: <20080616092148.GB2860@phoenix.home> <4856C8C6.3070309@netfilter.org> <4856D28C.3030302@trash.net> <20080616221759.GM2860@phoenix.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: BORBELY Zoltan <bozo@andrews.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45038 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbYFPW7f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2008 18:59:35 -0400
In-Reply-To: <20080616221759.GM2860@phoenix.home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

BORBELY Zoltan wrote:
> Hi,
>
> On Mon, Jun 16, 2008 at 10:52:28PM +0200, Patrick McHardy wrote:
>   
>> I'm wondering, how is this expectation creation working at all?
>> The NULL expectfn makes me think it will crash as soon as the
>> expectation arrives. This *needs* support from the helpers to
>> properly set the expectfn.
>>     
>
> The nf_nat_follow_master did the trick for me if I set the expectation
> entry from user space. With NULL expectfn it didn't work.
>   

Yes, so the kernel is broken.
>   
>> And more specific to this problem: back when Harald was working
>> on userspace helpers, the idea was to add a dummy helper specifically
>> so we have one to assign to the connection. The helper would (IIRC)
>> just queue the expected packets and userspace could take it from
>> there. Of course queuing could be made optional and (f.i.) it could
>> just use nf_nat_follow_master.
>>     
>
> I'd like to create a cross-platform user space ftp proxy, not a nf
> conntrack+nat helper module, so my goals are a bit different. The
> netfilter code contains everything I need, and the netlink interface
> is quite good to instruct the kernel code to do as the proxy wants.
>   

I understand that, the expectation part looks like a subset of what
a helper module does though, with the only differences that a helper
might want to queue the packet. And since expectfn setup also doesn't
belong in nf_conntrack_netlink.c (especially not NAT related expectfns),
this is how I think it should be done.



