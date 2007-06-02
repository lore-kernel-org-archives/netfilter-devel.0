From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Sat, 02 Jun 2007 15:53:07 +0200
Message-ID: <46617643.3090102@trash.net>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr> <Pine.LNX.4.61.0705100832050.32349@yvahk01.tjqt.qr> <46431C0D.5080507@trash.net> <Pine.LNX.4.61.0705101521570.32349@yvahk01.tjqt.qr> <464325EA.8040303@trash.net> <Pine.LNX.4.61.0705101605020.32349@yvahk01.tjqt.qr> <Pine.LNX.4.61.0705292336050.11140@yvahk01.tjqt.qr> <465CA950.403@trash.net> <4661687F.6040302@trash.net> <Pine.LNX.4.61.0706021529090.21057@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: sparclinux@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	Dmitry Mishin <dim@openvz.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0706021529090.21057@yvahk01.tjqt.qr>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Jun 2 2007 14:54, Patrick McHardy wrote:
> 
>>>>This is fixed in 2.6.21, thanks.
>>>
>>>Yes, the hashlimit compat issue is. But the underlying problem still
>>>persists, I'll send you a patch for testing soon.
>>
>>Here it is, could you please test whether it fixes the crash by
>>backing out the hashlimit compat patch and triggering the size
>>error again? Thanks.
> 
> 
> Do you mean conntrack compat?
> http://lists.netfilter.org/pipermail/netfilter-devel/2007-May/027763.html


Right, I confused them.
