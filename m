From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Thu, 29 May 2003 14:38:04 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305291422290.8961-100000@blackhole.kfki.hu>
References: <200305290113.58552.prez@srealm.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Preston A. Elder" <prez@srealm.net.au>
In-Reply-To: <200305290113.58552.prez@srealm.net.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 29 May 2003, Preston A. Elder wrote:

> Because every new connection to one of the systems 'behind' these systems need
> to be re-directed to a local port, which is achieved with the command:
> /sbin/iptables -t nat -A PREROUTING -j DNAT -i eth0 -p tcp -d <ip-range>
> - --destination-port 1024:65535 --to-destination <local_ip>:<local_port>
>
> Every inbound connection incurs an entry in the connection tracking table.  It
> seems, however, that we may be overloading the conntrack system.  I can
> telnet to a different port listening on a secondary (internal) interface (but
> the same application), that bypasses the above rule, and get an immediate
> connection, however establishing a connection 'to' a server behind this
> router can take a number of seconds, and sometimes may never establish.
> Whats more connecting directly to the port everything else is being
> re-directed to via. the 'public' interface itself can take some time (though
> not as long as connecting 'to' a system behind this box).

NAT tries hard to find a non-clashing connection entry on works on
remapping the ports.

> The conntrack table itself very quickly grows - but it does not clean itself
> up when the connection itself dissapears, instead it waits for some

But how those connections disappear? Normal TCP closing?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
