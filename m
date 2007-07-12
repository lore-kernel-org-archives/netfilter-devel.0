From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] support --physdev-out for routed packets
Date: Thu, 12 Jul 2007 14:45:18 +0200
Message-ID: <4696225E.3000606@trash.net>
References: <4695CCF8.1010202@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4695CCF8.1010202@snapgear.com>
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

Philip Craig wrote:
> My most common use of bridging is a transparent firewall between
> the LAN and the WAN.  This requires the ability to filter based on
> the outgoing port, which the current physdev match supports.
> 
...
> 
> So here is an ugly, inefficient, flawed, and barely tested patch
> which lets me do this.  I have no expectation of this being suitable
> for mainline kernels, but maybe someone else is interested in it or
> wants to comment on the approach.
> 
> The patch digs into the bridge internals too much, causes an extra
> bridge fdb lookup, ignores some const attributes, and probably has
> broken locking.  And if there are no ARP or bridge fdb entries, then
> it doesn't match any ports.


Its probably also racy wrt. fdb changes. The thing I still don't get
is .. if you combine a bunch of devices in a bridge, why would you
care which port a packet will leave through? If you already know
behind which port something is reachable, why use a bridge? And if
you don't know I suppose you have nothing to filter by.
