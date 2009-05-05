From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] make thread-safe iface resolution in libnfnetlink
Date: Tue, 05 May 2009 15:23:30 +0200
Message-ID: <4A003DD2.7000905@trash.net>
References: <1240955127-13723-1-git-send-email-eric@inl.fr> <49F798EB.3050203@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41528 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZEENXb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 May 2009 09:23:31 -0400
In-Reply-To: <49F798EB.3050203@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
>> Hi,
>>
>> I've encountered some problems with libnfnetlink iface resolution on a
>> system where some interfaces are getting up and down: NuFW which uses
>> this feature has crashed during a down/up of an interfaces. One of
>> the reason seems that nufw uses one thread is used for iface related
>> event treatment and another thread is doing iface name resolution.
>>
>> As the hash can be modified or read without any lock, I think the
>> problem can be linked with this issue. I thus propose a patch that
>> modifies the iface resolution subsystem to make it thread-safe.
> 
> Better do the locking in your application. You can define the lock in
> NuFW and protect the calls to libnfnetlink's interface API. Adding this
> locking to a library does not seem to me like the right thing, see that
> other non-threaded clients will have to live with the overhead of this
> lock that is completely useless for them. Of course, we can document
> that the interface API is not thread-safe.

I agree, it should be a user decision whether to use this.
Of course they need the information which callbacks need
protection.
