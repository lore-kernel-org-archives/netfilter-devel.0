From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Thu, 04 Nov 2004 23:36:58 +0100
Message-ID: <418AAF0A.4000201@trash.net>
References: <20041102210440.GA1851@linuxace.com> <418999B2.3070600@trash.net>
	<20041104154355.GA8553@linuxace.com> <418A6D29.60004@trash.net>
	<Pine.LNX.4.61.0411042254020.18136@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0411042254020.18136@filer.marasystems.com>
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

Henrik Nordstrom wrote:

> On Thu, 4 Nov 2004, Patrick McHardy wrote:
>
>> Ok, I agree it is still useful, but using the inetaddr_notifier gives
>> false positives when more than one IP address is added to the interface.
>
>
> Which is not an environment MASQUERADE is designed for, so it should 
> be acceptable.

But we do try to handle such an environment gracefully by using
rt_gateway for the inet_select_addr call.

> There is always the fallback to plain SNAT with ctnetlink for cleaning 
> up stale connections when needed.

The problem is the opposite, living conntracks are killed
when more than one IP address is added to the interface.

Phil mentioned Router/switch/dslmodem/cablemodem power cycles.
Contrary to what I said earlier, I don't see what value this
optimization might have. Router/switch powercycle doesn't matter
The optimization doesn't work for dslmodems (ppp devices), with
cablemodems you don't loose your IP, except in the very unlucky
situation that your DHCP lease times out while you are disconnected
and you get a different one afterwards.

Regards
Patrick
