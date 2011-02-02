From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/13] IP set core support
Date: Wed, 02 Feb 2011 07:50:46 +0100
Message-ID: <4D48FEC6.5080701@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu> <4D482817.7090407@trash.net> <alpine.DEB.2.00.1102012002430.24267@blackhole.kfki.hu> <alpine.DEB.2.00.1102012154130.24580@blackhole.kfki.hu> <alpine.DEB.2.00.1102012225080.24657@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61115 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1BBGvA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 01:51:00 -0500
In-Reply-To: <alpine.DEB.2.00.1102012225080.24657@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01.02.2011 22:28, Jozsef Kadlecsik wrote:
> On Tue, 1 Feb 2011, Jozsef Kadlecsik wrote:
> 
>>>> I guess you're relying on that the original message is appended to a
>>>> nlmsgerr message. That doesn't seem right though, if you want to return
>>>> something to userspace, you should construct a new message.
>>>
>>> The message we are processing here carried multiple commands (each having 
>>> an attribute with the line number of the given command) and one failed 
>>> from some reason. We have to notify the userspace which command, at what 
>>> line failed. For this reason the multi-command messages have got an 
>>> attribute, which can be filled out with the line number - that happens 
>>> here. The attribute is already there, the message is not enlarged, just
>>> the empty value is overwritten with the proper value.
>>>
>>> The line number reporting works this way, tested in the testsuite too.
>>>
>>> If I had to construct a completely new message and sent it, that'd be more 
>>> or less the duplication of netlink_ack. Additionally I had to suppress 
>>> netlink from sending an errmsg/ack too.
>>
>> Hm, if I lie -EINTR to netlink, then I can construct and send the error 
>> message manually and keep NLM_F_ACK at the same time. What do you think?
>> Please have a look at the attached patch.
> 
> Oops, mistypeing fixed, here follow the hopefully good version.

This looks fine to me. A comment about why it returns -EINTR would
probably be a good idea though.
