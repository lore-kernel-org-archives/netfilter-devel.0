From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 18:30:00 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <876ef97a04092815306fa270f@mail.gmail.com>
References: <1096374273.7192.27.camel@nienna.balabit>
	<1096376252.7192.47.camel@nienna.balabit>
	<1096377276.8661.252.camel@jzny.localdomain>
	<1096379957.1026.5.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409281642500.32737@filer.marasystems.com>
	<1096383406.7192.165.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281658330.32737@filer.marasystems.com>
	<20040928180425.GA21097@zion.homelinux.com>
	<Pine.LNX.4.61.0409282042150.2167@filer.marasystems.com>
	<20040928205723.GA23352@zion.homelinux.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
	KOVACS Krisztian <hidden@balabit.hu>, Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	Jamal Hadi Salim <hadi@znyx.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Schuster <schuster.sven@gmx.de>
In-Reply-To: <20040928205723.GA23352@zion.homelinux.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 28 Sep 2004 22:57:23 +0200, Sven Schuster <schuster.sven@gmx.de> wrote:
> And if one of the nodes
> goes down for some reason, the other nodes will also take over this
> nodes' traffic as soon as they realize this nodes' failure and so one of
> the hashing function's parameters is adjusted to represent the new
> situation...!?

This is exactly what Saru does.

Also, I'm not exactly sure how you can do active-active without either
multicast or multicast-by-way-of-MAC-address-cloning. This is because
of the fact that I'm not really sure how you can do active-active
without all of the nodes having the same IP address. (otherwise, what
would it be?)

Henrik?

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
