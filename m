From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] rework of userspace expectation support
Date: Thu, 21 Apr 2011 15:14:20 +0200
Message-ID: <4DB02DAC.1070406@netfilter.org>
References: <20110412215458.3145.40830.stgit@decadence> <4DA58AE2.7000204@trash.net> <4DA58D48.4010307@netfilter.org> <4DA58F41.9080603@trash.net> <4DA592F3.1090201@netfilter.org> <4DA59700.9000400@trash.net> <4DAECD42.9080006@netfilter.org> <4DAEE86A.6070800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60831 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab1DUNOY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Apr 2011 09:14:24 -0400
In-Reply-To: <4DAEE86A.6070800@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/04/11 16:06, Patrick McHardy wrote:
> Am 20.04.2011 14:10, schrieb Pablo Neira Ayuso:
>> I missed one point. We don't seem to increase the refcnt for unfulfilled
>> expectations.
> 
> Yes, that's not necessary since unfulfilled expectations are cleaned
> up once the master is destroyed. Its just the ct->master pointer of
> an expected connection that takes a reference.
> 
> I thought this is what your patches try to fix?

Yes, my patches add the helper extension to the conntrack by means of
the CT target. Thus, in the case of userspace helpers, the master
conntrack can store the list of unfulfilled expectations that it owns.

Sorry, I misunderstood your previous email, I thought you were telling
that we bump master's refcnt for unfulfilled expectation, you were
telling the opposite :-).

>> The following example shows a unfulfilled FTP expectation:
>>
>> # conntrack -L exp
>> 262 proto=6 src=192.168.1.128 dst=130.89.149.226 sport=0 dport=20412
>> conntrack v1.0.0 (conntrack-tools): 1 expectations have been shown.
>>
>> # conntrack -L
>> tcp      6 431979 ESTABLISHED src=192.168.1.128 dst=130.89.149.226
>> sport=37348 dport=21 packets=9 bytes=503 src=130.89.149.226
>> dst=192.168.1.128 sport=21 dport=37348 packets=8 bytes=564 [ASSURED]
>> mark=0 delta-time=29 use=1
>>
>> The use field of the master conntrack shows 1.
>>
>> So, I think that these patches are still the way to fix the problem with
>> the expectations created through ctnetlink.
> 
> Just for my understanding, why not simply take the reference for
> the master conntrack for "fulfilled" expectations (IOW conntracks
> that have a master assigned), which is necessary anyways since
> destroy_conntrack() attempts to release that reference again, and
> clean up userspace expectations once the master conntrack vanishes?

That's fine to me.

> This would match what we do for kernel expectations and I don't
> really see why we would want to keep an unfulfilled userspace
> expectation without the corresponding master.

Agreed.

Then, we need to allocate the conntrack helper extension to store the
list of unfulfilled expectations, which is what my patches do.
