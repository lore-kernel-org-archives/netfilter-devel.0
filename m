From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Outgoing interface selection by source address
Date: Thu, 27 Nov 2003 17:15:39 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311271701570.26866-100000@filer.marasystems.com>
References: <Pine.GSO.4.33.0311271653330.23073-100000@horus.imag.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pawel Hadam <Pawel.Hadam@imag.fr>
In-Reply-To: <Pine.GSO.4.33.0311271653330.23073-100000@horus.imag.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 Nov 2003, Pawel Hadam wrote:

> And what does "IP6 tables support -> EUI64 address check" option in the
> kernel ??? Cannot it be used to select the route by source address? In
> help I can read:

It can match, but it can not select the route..

For this policy routing really should be used, but it might also be 
possible to implement at ROUTE target like in IPv4 iptables 
extra/ROUTE.patch if implementing policy routing is too hard.

Regards
Henrik
