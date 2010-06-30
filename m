From: =?UTF-8?B?U2lpbSBQw7VkZXI=?= <siim@p6drad-teel.net>
Subject: Re: [Bug 16317] New: oops in nf_nat_setup_info
Date: Wed, 30 Jun 2010 23:22:01 +0300
Message-ID: <4C2BA769.6050101@p6drad-teel.net>
References: <bug-16317-4010@https.bugzilla.kernel.org/> <4C2B3FCA.9000505@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	bugzilla-daemon@bugzilla.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from p6drad-teel.net ([87.119.162.157]:51894 "EHLO p6drad-teel.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219Ab0F3Uaf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jun 2010 16:30:35 -0400
In-Reply-To: <4C2B3FCA.9000505@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> bugzilla-daemon@bugzilla.kernel.org wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=16317
>> [581172.269340] ------------[ cut here ]------------
>> [581172.280485] kernel BUG at net/ipv4/netfilter/nf_nat_core.c:300!
>>   
> 
> NAT is attempting to set up mappings a second time for an existing
> conntrack.
> 
> So the failover node is purely passive and is not synchronizing connections
> back to the one which is crashing? That would rule out a race condition
> between creating a new conntrack using ctnetlink and the lookup done during
> packet processing.

Syncing is done in both directions simultaneously so the described
race is not ruled out.

Coincidentally or not, but so far both crashes seemed to have occured
on the 6th second of a minute, which is around where conntrackd -c
usually finishes.

I'm a bit confused how the race might happen. It would mean that the
src/dst ip:port gets reused or packet tranmitted by client after the
conntrack has expired on the active box whilist the failover box
synchronizes it back to the active one?

> I can't spot the problem right now, but it would be interesting whether
> this still happens without running the (synchronizing) conntrack daemon.

I can't keep this running in production so will have to try to
reproduce it on a test setup. As I'm not sure about the scenario to
test, I'll just create lots of SNAT/DNAT connections while syncing
them with conntrackd (and conntrackd -c) running for a while hoping to
recreate whatever triggers it?

Siim
