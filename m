From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Sat, 2 Jun 2007 16:25:18 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706021619120.5076@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0705100832050.32349@yvahk01.tjqt.qr> <46431C0D.5080507@trash.net>
 <Pine.LNX.4.61.0705101521570.32349@yvahk01.tjqt.qr> <464325EA.8040303@trash.net>
 <Pine.LNX.4.61.0705101605020.32349@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0705292336050.11140@yvahk01.tjqt.qr> <465CA950.403@trash.net>
 <4661687F.6040302@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: sparclinux@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	Dmitry Mishin <dim@openvz.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <4661687F.6040302@trash.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Jun 2 2007 14:54, Patrick McHardy wrote:
>Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>> 
>>>This is fixed in 2.6.21, thanks.
>> 
>> Yes, the hashlimit compat issue is. But the underlying problem still
>> persists, I'll send you a patch for testing soon.
>
>Here it is, could you please test whether it fixes the crash by
>backing out the hashlimit compat patch and triggering the size
>error again? Thanks.
[connlimit compat]

Kernel built, rebooted, no panics or thelike.
So to sum it up, hashlimit works, connlimit works. Seems all nice.


Thanks,
	Jan
-- 
