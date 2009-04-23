From: Patrick McHardy <kaber@trash.net>
Subject: Re: IMQ bug: kernel reboot immediately
Date: Thu, 23 Apr 2009 12:20:24 +0200
Message-ID: <49F040E8.80402@trash.net>
References: <20090423084323.GA5696@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Y. D." <duyuyang@gmail.com>, netdev <netdev@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jarek Poplawski <jarkao2@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46268 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbZDWKUb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:20:31 -0400
In-Reply-To: <20090423084323.GA5696@ff.dom.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jarek Poplawski wrote:
> On 22-04-2009 17:27, Y. D. wrote:
>> Hi,
>>
>> Is IMQ still maintained? I am using IMQ to shape ingress traffic.
>> But the application is a streaming server (VLC). However, the kernel
>> reboots immediately as quick as can hardly been seen what is
>> wrong with it.
>>
>> Any help with this kinda problem?
> 
> IMQ isn't a part of kernel/netfilter, so you should try at its own
> site/mailing list.

I'd rather suggest to get rid of it and use ifb, AFAIK there hasn't
been a single version in all those years that didn't cause this kind
of problems.
