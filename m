From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Quota on SMP AGAIN
Date: Mon, 31 Dec 2007 01:54:33 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712310151110.2093@fbirervta.pbzchgretzou.qr>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net>
 <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr>
 <477520C3.8040501@trash.net> <Pine.LNX.4.64.0712281716350.29013@fbirervta.pbzchgretzou.qr>
 <47752958.3010601@trash.net> <Pine.LNX.4.64.0712302228490.15993@bizon.gios.gov.pl>
 <4778358E.2070506@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Krzysztof Oledzki <ole@ans.pl>, gpf <gpf@simm.ru>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46789 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbXLaAye (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Dec 2007 19:54:34 -0500
In-Reply-To: <4778358E.2070506@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 31 2007 01:19, Patrick McHardy wrote:
>> On Fri, 28 Dec 2007, Patrick McHardy wrote:
>> <CUT>
>> > > And my bigtime question would be: where is the other counter actually?
>> > > struct xt_quota_info only has one counter! Does netfilter secretly
>> > > allocate matchinfos per-cpu?
>> > >
>> >
>> > Not secretly, but yes, the entire ruleset exists once per CPU. That
>> > also seems to be the problem, at the time the master idea was thought
>> > of we always dumped entries from CPU 0, today its from the current
>> > CPU, but the only one that actually has correct counters is CPU 0.
>>
>> What happens when CPU#0 is disabled (CPU hotplug)?
>
> Nothing, its simply unused except for counter synchronization and
> the ->master thing this thread is about.
>

01:57 ccgmbh:~ # taskset 1 iptables -I OUTPUT -m quota --quota 123456

Now suppose CPU#0 was deactivated (taskset only to show what's meant).
Then iptables would always show the wrong quota.
