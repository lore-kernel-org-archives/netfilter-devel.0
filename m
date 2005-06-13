From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [RFC][PATCH] ipt_expire - expiring iptables rules
Date: Mon, 13 Jun 2005 19:49:11 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506131942350.23546@yvahk01.tjqt.qr>
References: <20050610145248.GA3201@rover.pcbi.upenn.edu>
	<Pine.LNX.4.61.0506121745400.6693@yvahk01.tjqt.qr>
	<42AD1213.9050203@outerspace.dyndns.org>
	<20050613173656.GB19351@home.seas.upenn.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bryan Cardillo <dillo@seas.upenn.edu>
In-Reply-To: <20050613173656.GB19351@home.seas.upenn.edu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


>        this is exactly how it works now, basically a timer based,
>        in-kernel version of `iptables -D ...'.

Ok, I took a deeper logical comparison between ipt_expire and ipt_recent.
Put it into pom, might be useful. After all, replacing a ton of ipt_recent 
matches by user-space triggered "iptables -A ... -m ipt_expire" might give me 
back some performance.

Though, with [already released] the upcoming version of my fw scripts, I will 
probably hardly need any of {recent,expire} anymore :(
Keep it in pom.


Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
