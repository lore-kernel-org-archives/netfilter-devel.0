From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Tue, 23 Nov 2004 13:16:23 -0800
Message-ID: <20041123211623.GA20289@linuxace.com>
References: <20041107181825.GA3522@linuxace.com>
	<1101005908.18919.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <1101005908.18919.11.camel@localhost.localdomain>
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

On Sun, Nov 21, 2004 at 01:58:28PM +1100, Rusty Russell wrote:
> The MASQUERADE target use to destroy connections when an interface
> went down.  We changed this to merely remove the ASSURED bit, and
> destroy them if the same interface came up with a different IP
> address.  Unfortunately, as Phil Oester pointed out, that code was
> crap for PPP connections, since we (1) compared ifa_address instead of
> ifa_local, (2) identified interfaces by ifindex, which increments as a
> PPP device downs and ups, and (3) caused all connections to be flushed
> when we added an IP address.
> 
> So that code was reverted after 2.6.10-rc2.
> 
> This code stores the interface name, rather than trying to use the
> ifindex, and only deletes connections if *no* ifa_local on the
> interface matches the connection, so simply adding a new IP address is
> a NOOP.

But even using the interface name is unreliable.  Consider the user who
uses multiple PPP connections.  Both go down at the same time, and
come back with the 'old' ppp1 now named ppp0.  Or consider a PopTop
PPTP server which has dozens of ppp interfaces (although using masq here
is admittedly unlikely).

Perhaps my original patch which special-cased ppp would be better?

http://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017294.html

Phil
