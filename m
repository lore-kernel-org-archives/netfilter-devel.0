From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/13] IP set core support
Date: Wed, 02 Feb 2011 07:45:26 +0100
Message-ID: <4D48FD86.2040008@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu> <4D482817.7090407@trash.net> <alpine.DEB.2.00.1102012002430.24267@blackhole.kfki.hu> <4D48FC48.3000807@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61059 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1BBGpj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 01:45:39 -0500
In-Reply-To: <4D48FC48.3000807@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02.02.2011 07:40, Patrick McHardy wrote:
> On 01.02.2011 20:43, Jozsef Kadlecsik wrote:
>> On Tue, 1 Feb 2011, Patrick McHardy wrote:
>>
>>> I guess you're relying on that the original message is appended to a
>>> nlmsgerr message. That doesn't seem right though, if you want to return
>>> something to userspace, you should construct a new message.
>>
>> The message we are processing here carried multiple commands (each having 
>> an attribute with the line number of the given command) and one failed 
>> from some reason. We have to notify the userspace which command, at what 
>> line failed. For this reason the multi-command messages have got an 
>> attribute, which can be filled out with the line number - that happens 
>> here. The attribute is already there, the message is not enlarged, just
>> the empty value is overwritten with the proper value.
>>
>> The line number reporting works this way, tested in the testsuite too.
> 
> I'm still not really clear how this works since the message contents
> have been copied from userspace, so modifying the contents seems
> useless. I'll have a closer look at userspace to understand how this
> works.
> 
>> If I had to construct a completely new message and sent it, that'd be more 
>> or less the duplication of netlink_ack. Additionally I had to suppress 
>> netlink from sending an errmsg/ack too.
>>
>> If one can't rely on the modifiable message and nlmsgerr, then the error 
>> reporting in netlink is, hm, not really useful :-(
> 
> I'm mainly not clear about how this works at all, will have a closer
> look at userspace :)

OK, it does what I expected initially, rely on the contents to be
appended to the nlmsgerr and decode that message in userspace.

It's somewhat creative use, but I guess there's nothing fundamentally
wrong doing this.
