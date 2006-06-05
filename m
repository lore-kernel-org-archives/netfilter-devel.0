From: Patrick Schaaf <bof@bof.de>
Subject: Re: POSTROUTING hooks
Date: Mon, 5 Jun 2006 18:01:05 +0200
Message-ID: <20060605160105.GE8333@oknodo.bof.de>
References: <0633E0EDB4F25F43A2D7179CA11FAFAB25544B@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
Content-Disposition: inline
In-Reply-To: <0633E0EDB4F25F43A2D7179CA11FAFAB25544B@xavier.staff.greatlakes.net>
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

> Where in the kernel's packet delivery process does the POSTROUTING chain
> hook in? 

You can get a pretty accurate answer, for any kernel version, by doing
	grep NF_HOOK /usr/src/linux-whatever/net/ipv?/*.c

For the 2.4.18 kernel I'm looking at, there are three calls to
NF_IP_POST_ROUTING in net/ipv4/ip_output.c. Two of them are
obviously concerned with multicast, leaving one call in
ip_finish_output.

So, POST_ROUTING is called when the packet leaves the IP stack.

As you can see there, only after POST_ROUTING is the packet queued
to some network device. And only after that is ARP done, and only
then is a destination MAC known (temporarily, until ARP changes
something under your feet).

> I'm trying to figure out how to write a module to allow matching on the
> destination MAC address.

Impossible with the current setup, it seems. Which is probably the reason why
none of the 50 people who wanted to do that before, succeeded.

> What would it take to modify the Netfilter code to make the POSTROUTING
> chain hook in AFTER the destination MAC is set, but BEFORE it gets sent
> out the interface?

It would take a very brave person, with a masochistic streak, and
a burning desire to maintain his own Linux networking stack, device
drivers, and iptables derivate.

best regards
  Patrick
