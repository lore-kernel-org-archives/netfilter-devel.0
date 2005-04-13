From: Patrick Schaaf <bof@bof.de>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 13:25:18 +0200
Message-ID: <20050413112518.GB22865@oknodo.bof.de>
References: <20050413152307.0312.LARK@linux.net.cn> <425CEFE3.2010200@rtij.nl>
	<20050413182822.0317.LARK@linux.net.cn> <425CFFE0.1000803@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
Content-Disposition: inline
In-Reply-To: <425CFFE0.1000803@rtij.nl>
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

> iptables -A SOMECHAIN -m this -m that
> iptables -A SOMECHAIN --previous -j ACTION1
> iptables -A SOMECHAIN --previous -j ACTION2
> iptables -A SOMECHAIN --previous -j RETURN
> 
> But how is that different from:
> 
> iptables -A SOMECHAIN -m this -m that -j TMPCHAIN
> iptables -N TMPCHAIN
> iptables -A TMPCHAIN -j ACTION1
> iptables -A TMPCHAIN -j ACTION2

It RETURNs to different places, i.e. to the caller of SOMECHAIN in the
first case, and to the next rule in SOMECHAIN for the second case.

BTW, anybody ever thought about giving -j RETURN an --up N option?

iptables -A SOMECHAIN -m this -m that -j TMPCHAIN
iptables -N TMPCHAIN
iptables -A TMPCHAIN -j ACTION1
iptables -A TMPCHAIN -j ACTION2
iptables -A TMPCHAIN -j RETURN --up 2

best regards
  Patrick
