From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] iptables: handle cidr notation more sanely
Date: Mon, 10 Jul 2006 07:59:02 +0200
Message-ID: <20060710055902.GA832@oknodo.bof.de>
References: <20060709222818.GA23200@linuxace.com> <44B1D6FE.6080208@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <44B1D6FE.6080208@trash.net>
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

> > 	iptables -A foo -s 10.10/16
> > 
> > will interpret 10.10/16 as 10.0.0.10/16, and after applying the mask end
> > up with 10.0.0.0/16, which likely isn't what the user intended.  Yet
> > some people do expect 10.10 (without the cidr notation) to end up as
> > 10.0.0.10.
...
> 
> Applied, thanks Phil. Hope all those lazy typers are happy now :)

Better hope the past lazy typers' boot time iptables scripts will not break
in any critical way by such a radical interpretation change.

Of course, it's all their own fault when that happens, lazy bastards.

Methinks that it would be better to make non-3-dots IP addresses
a syntax error, period.

best regards
  Patrick
