From: Patrick Schaaf <bof@bof.de>
Subject: Re: [NEW TARGET] MARKCB connection marking balancing
Date: Mon, 3 Mar 2003 10:12:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030303091231.GF25876@oknodo.bof.de>
References: <3E62AF18.8010000@zobniow.priv.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciek Zobniow <maciek@zobniow.priv.pl>
Content-Disposition: inline
In-Reply-To: <3E62AF18.8010000@zobniow.priv.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Maciek, hello Fabrice,

using the 'nth' match for load-balancing is only slightly better
than using statistical multiplexing by looking at the low bits
of the client IPs (my favourite). Both methods don't take any
history into account, giving a rather "rough" balancing.
So that would be an advantage of Maciek's solution.

There is already a full-fledged implementation of such a general,
good load-balancer. It is also using the netfilter framework, but
rather independant of iptables, it especially comes with its
own connection tracking. See http://www.linuxvirtualserver.org/
for code and docs. The quality of that product is HIGH, and,
although it is standalone, it fits together with iptables
quite fine.

While the intent of that project was loadbalancing of incoming
connections to a farm of web servers, you can also use it for
outgoing "default route" balancing: define an "fwmark" based
load balancer, mark the relevant packets at PREROUTING,
make the several available nexthops into a single server farm
of the "direct routing" type, and finally, use the 'nexthop'
match [1] at nat POSTROUTING to SNAT as needed.

best regards
  Patrick

[1] is there one? if not, it is trivial to write.
