From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables release plans
Date: Mon, 21 Mar 2011 23:44:07 +0100
Message-ID: <4D87D4B7.5000404@trash.net>
References: <4D879D96.2000904@trash.net> <alpine.DEB.2.00.1103212207450.23334@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37984 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab1CUWoO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:44:14 -0400
In-Reply-To: <alpine.DEB.2.00.1103212207450.23334@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21.03.2011 22:09, Jozsef Kadlecsik wrote:
> On Mon, 21 Mar 2011, Patrick McHardy wrote:
> 
>> About a potential iptables release for 2.6.38 - we don't have any
>> new features in the kernel that would require a new release.
>> However we've had a lot of other changes that would be good to
>> get out for wider testing.
>>
>> Unfortunately due some confusion at the time of the last kernel
>> release, all patches for the upcoming feature in 2.6.39 have been
>> added to the master branch. I don't want to release extensions
>> for new kernel features while we're in the -rc phase since we
>> might still decide to change the userspace API.
>>
>> So the options basically are:
>>
>> - branch off the current HEAD, remove all new extension for upcoming
>>   features and release that branch
>>
>> - skip the release for 2.6.38
>>
>> Any opinions?
> 
> I don't really like either one, but if we have to choose then the first 
> one seems better. At least the release will contain the bugfixes.

Yeah, it certainly was a mistake, but to me the first option
seems better as well.

Thanks!
