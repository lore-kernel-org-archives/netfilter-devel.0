From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables: handle cidr notation more sanely
Date: Mon, 10 Jul 2006 08:43:50 +0200
Message-ID: <44B1F726.1070001@trash.net>
References: <20060709222818.GA23200@linuxace.com> <44B1D6FE.6080208@trash.net>
	<20060710055902.GA832@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20060710055902.GA832@oknodo.bof.de>
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

Patrick Schaaf wrote:
>>>	iptables -A foo -s 10.10/16
>>>
>>>will interpret 10.10/16 as 10.0.0.10/16, and after applying the mask end
>>>up with 10.0.0.0/16, which likely isn't what the user intended.  Yet
>>>some people do expect 10.10 (without the cidr notation) to end up as
>>>10.0.0.10.
> 
> ...
> 
>>Applied, thanks Phil. Hope all those lazy typers are happy now :)
> 
> 
> Better hope the past lazy typers' boot time iptables scripts will not break
> in any critical way by such a radical interpretation change.
> 
> Of course, it's all their own fault when that happens, lazy bastards.

Please don't put words in my mouth. If they rely on undocumented,
clearly illogical (10.10/16 == 10/16) behaviour, then yes, they
are at fault, but its not because of beeing lazy typers. Anyway,
if I'd believe that this is something more than a handful of
people were actually using and that _anyone_ would actually rely
on the old behaviour, I wouldn't have accepted that patch. So if
anyone does report breakage until the next iptables release, I'll
most likely revert the patch.

> Methinks that it would be better to make non-3-dots IP addresses
> a syntax error, period.

I can understand your position about breaking compatibility, but
this seems unreasonable to me. You're saying we should do something
that has even more problems (breaking compatibility for shortcuts
without masks as well), but less value to the user?
