From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 07:58:55 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <876ef97a0409280458228a7509@mail.gmail.com>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
	<1096290473.1075.64.camel@jzny.localdomain>
	<20040927133904.GP3236@sunbeam.de.gnumonks.org>
	<1096339276.8660.30.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: nf-devel <netfilter-devel@lists.netfilter.org>,
	netfilter-failover@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 28 Sep 2004 08:46:25 +0200 (CEST), Henrik Nordstrom
<hno@marasystems.com> wrote:
> No, this is about a different issue entirely.
> 
> Lets assume you have two Active-Active gateways G and H, two clients A and
> B and one server S. On the gateway NAT is used to masquerade all traffic
> to a single external IP address.
> 
> Due to the Active-Active setup traffic from A goes via the gateway G and
> traffic from B goes via H.
> 
> Now you have a SYN from A,31285 to S,80 and also a SYN sent by B,31285 to
> S,80. You then end up with two identical NAT assignments and the two
> connections will conflict with each other.

Why use NAT at all for active-active? Its pretty slow in comparison to
the shared MAC/IP schema delineated at UltraMonkey.org:

http://www.ultramonkey.org/papers/active_active/active_active.shtml

Am I missing something? Is NAT required for some reason?

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
