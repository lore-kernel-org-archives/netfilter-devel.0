From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Fri, 5 Nov 2004 00:40:03 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411050036560.19958@filer.marasystems.com>
References: <20041102210440.GA1851@linuxace.com> <418999B2.3070600@trash.net>
	<20041104154355.GA8553@linuxace.com> <418A6D29.60004@trash.net>
	<Pine.LNX.4.61.0411042254020.18136@filer.marasystems.com>
	<418AAF0A.4000201@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <418AAF0A.4000201@trash.net>
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

On Thu, 4 Nov 2004, Patrick McHardy wrote:

>> There is always the fallback to plain SNAT with ctnetlink for cleaning up 
>> stale connections when needed.
>
> The problem is the opposite, living conntracks are killed
> when more than one IP address is added to the interface.

Which is when the fallback to SNAT with ctnetlink for more controller 
cleaning is suitable.. and also the fact that you have more than one IP 
also suggest that you quite likely are not in the scope of configurations 
MASQUREADE is designed for (dynamic IP).

I am not saying that the current code is correct, only that I see no 
reason why MASQUERADE should consider being overly friendly to people 
having multiple IP addresses on their dynamic IP interface.

Regards
Henrik
