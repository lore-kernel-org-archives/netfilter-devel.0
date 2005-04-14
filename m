From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: About matching (also was: Multiple Targets)
Date: Thu, 14 Apr 2005 13:43:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504141340130.28938@filer.marasystems.com>
References: <20050413152307.0312.LARK@linux.net.cn> <425CEFE3.2010200@rtij.nl>
	<20050413182822.0317.LARK@linux.net.cn> <425CFFE0.1000803@rtij.nl>
	<20050413112518.GB22865@oknodo.bof.de>
	<Pine.LNX.4.61.0504140315010.16405@filer.marasystems.com>
	<7174b1e40504140101b5138e0@mail.gmail.com>
	<425E3032.2060409@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, Ben La Monica <ben.lamonica@gmail.com>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <425E3032.2060409@outerspace.dyndns.org>
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

On Thu, 14 Apr 2005, Jonas Berlin wrote:

> Interesting idea.. but I think I would still prefer to just write
> support for multiple targets, e.g.
>
> iptables ... -j MARK --set-mark 10 -j LOG --log-prefix "foo" -j ACCEPT

All which is technically required for this while keeping full binary 
copatibility is to modify non-terminal targets to register themselves as 
matches in addition to targets.

The only thing holding this back is a conceptual design question if you 
should be allowed to mix non-terminal targets and matches freely, but this 
can be addressed in userspace if desired to force all non-terminal targets 
last in the match list.

Having more than one terminal target is nonsense ihmo.

Regards
Henrik
