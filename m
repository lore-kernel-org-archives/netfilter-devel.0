From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] Release conntrack-tools 0.9.4
Date: Mon, 02 Jul 2007 15:27:58 +0200
Message-ID: <4688FD5E.9070709@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060107050909010603000400"
To: netfilter-announce@lists.netfilter.org,
	netfilter <netfilter@lists.netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	lwn@lwn.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------060107050909010603000400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi!

The netfilter project proudly presents another development release of
the conntrack-tools. The conntrack-tools are:

- The userspace daemon so-called conntrackd that covers the specific
aspects of stateful Linux firewalls to enable high availability
solutions. It can be used as statistics collector of the firewall use as
well. The daemon is highly configurable and easily extensible.

- The command line interface (CLI) conntrack that provides an interface
to add, delete and update flow entries, list current active flows in
plain text/XML, current IPv4 NAT'ed flows, reset counters, and flush the
complete connection tracking table among many other.

You can download it from:

http://www.netfilter.org/projects/conntrack-tools/downloads.html

Changelog is attached.

Ab alio expectes alteri quod feceris,
	Pablo (on behalf of the Netfilter Project)

-- 
"Países en desarrollo es el nombre con que los expertos designan a los
países arrollados por el desarrollo ajeno" -- Patas Arriba. La Escuela
del Mundo al Revés -- E. Galeano

--------------060107050909010603000400
Content-Type: text/plain;
 name="ChangeLog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog"

conntrack-tools version 0.9.4
-----------------------------

Changes from 0.9.3:

- fix error message in configure.in (Eric Leblond)
	[Eric Leblond]

- fix segfault with conntrack --output
	[Krzysztof Oledzky]

- use NFCT_SOPT_SETUP_* facilities: nfct_setobjopt
- remove bogus option to get a conntrack in test.sh example file
- add aliases --sport and --dport to make it more iptables-like
- add support for `-L --src-nat' and `-L --dst-nat' to show natted connections
- update conntrack(8) manpage
- remove dlopen infrastructure
- add library dependency checking to configure.in
- simplify checksum code: use UDP/multicast checksum facilities
- fix silly bug in build_network_message: out of bound memset
- remove useless backlog parameter in multicast sockets
- remove reminiscents of delay destroy message and relax transitions
- remove confusing StripNAT parameter: NAT support enabled by default
- relax event tracking: *_update callbacks use cache_update_force
- use wraparound-aware functions after/before/between
- commit phase: if conntrack exists, update it
- local requests return EXIT_FAILURE if it can't connect to the daemon
- remove several debug statements
- fork when internal/external dump and commit requests are received
- lots of cleanups
	[Pablo Neira Ayuso]

--------------060107050909010603000400--
