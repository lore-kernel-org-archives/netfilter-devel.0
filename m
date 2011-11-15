From: Alex Bligh <alex@alex.org.uk>
Subject: Re: [PATCH] netfilter: fix ->nfnl NULL oops
Date: Tue, 15 Nov 2011 10:13:58 +0000
Message-ID: <61996646E807F2E67842E57F@nimrod.local>
References: <20111108221634.GA13261@p183.telecom.by>
 <20111109143423.GA24158@1984> <20111115095642.GA28944@1984>
Reply-To: Alex Bligh <alex@alex.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	Alex Bligh <alex@alex.org.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.avalus.com ([89.16.176.221]:41658 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab1KOKOD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Nov 2011 05:14:03 -0500
In-Reply-To: <20111115095642.GA28944@1984>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

Have you tried this patch (without the ->nfnl NULL check change) with
the perl program I wrote that reliably replicates the original bug?

https://bugs.launchpad.net/ubuntu/+source/linux-lts-backport-natty/+bug/843892

specifically the attachment in comment #6:

https://bugs.launchpad.net/ubuntu/+source/linux-lts-backport-natty/+bug/843892/+attachment/2382526/+files/testns.pl

Alex

--On 15 November 2011 10:56:42 +0100 Pablo Neira Ayuso 
<pablo@netfilter.org> wrote:

> On Wed, Nov 09, 2011 at 03:34:23PM +0100, Pablo Neira Ayuso wrote:
>> On Wed, Nov 09, 2011 at 01:16:35AM +0300, Alexey Dobriyan wrote:
>> > Sorry for delay.
>> >
>> > I recall myself writing that net->nfnl NULL check is racy or
>> > something like that (but I can't find this email in archives).
>> >
>> > I've read the code once again, and I'm quite sure,
>> > NULL ->nfnl check is correct if RCU precautions are made.
>> >
>> > Regarding ->report check, I think it's bogus.
>> >
>> > If there are no listeners, there are NO listeners
>> > and whether to report back to userspace doesn't matter.
>> >
>> > I'm sure I'm missing something obvious here.
>> >
>> > Please, review.
>>
>> Alexey. This is a workaround. We have to make ctnl_notifier
>> container-aware which is the real problem.
>
> I made this patch. It makes the ctnl_notifier container-aware.
>
> I'm trying to set some lxc container to test it (it's not that
> straight forward in debian).
>
> btw: if it's fine, i'll add the credits (reported-by and other tags
> before final submission, this is still a RFC).



-- 
Alex Bligh
