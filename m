From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] MASQUERADE not flushing conntracks on ip change
Date: Thu, 4 Nov 2004 14:47:13 -0800
Message-ID: <20041104224713.GA11255@linuxace.com>
References: <20041102210440.GA1851@linuxace.com> <418999B2.3070600@trash.net>
	<20041104154355.GA8553@linuxace.com> <418A6D29.60004@trash.net>
	<Pine.LNX.4.61.0411042254020.18136@filer.marasystems.com>
	<418AAF0A.4000201@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
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

On Thu, Nov 04, 2004 at 11:36:58PM +0100, Patrick McHardy wrote:
> The problem is the opposite, living conntracks are killed
> when more than one IP address is added to the interface.
> 
> Phil mentioned Router/switch/dslmodem/cablemodem power cycles.
> Contrary to what I said earlier, I don't see what value this
> optimization might have. Router/switch powercycle doesn't matter
> The optimization doesn't work for dslmodems (ppp devices), with
> cablemodems you don't loose your IP, except in the very unlucky
> situation that your DHCP lease times out while you are disconnected
> and you get a different one afterwards.

My dsl modem attaches to my pc via ethernet cable.  If I powercycle
the modem, ethx up/down, conntracks get lost.  Same goes for cablemodems.

Unconditionally flushing conntracks on dev down still doesn't seem
the right behaviour.  But I agree Patrick that the ip address add case
is problematic.

I'm investigating another possible solution at the moment...

Phil
