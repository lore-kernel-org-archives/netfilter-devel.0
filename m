From: Jeho-Park <jhpark-nf@kernelproject.org>
Subject: Re: [RFC,ANNOUNCE] conntrack daemon (stateful replication)
Date: Mon, 29 May 2006 13:46:07 +0900
Message-ID: <447A7C8F.20206@kernelproject.org>
References: <447A1FB7.5080709@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <447A1FB7.5080709@netfilter.org>
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

good job !

it looks so interesting ~ thanks


jeho park


Pablo Neira Ayuso wrote:

> Hi,
>
> I've been working on a pet project during the last months. Part of 
> this stuff is related with my works in the university.
>
> The project is called `conntrackd' that is the conntrack userspace 
> daemon.
>
> Features:
> ---------
>
> - Stateful replication: the daemon keeps a cache of internal events 
> via libnetfilter_conntrack and a cache of external event received from 
> the other node.
> - Support for classical Primary/Backup settings
> - Support for Active/Active settings (two machines max. per VRRP 
> instance)
> - Support for NAT: It recognizes NAT'ed connections and handles them 
> properly.
> - UDP traffic ignore facility
> - ICMP traffic ignore facility
> - Ignore loopback traffic (not customizable at the moment)
> - Ignore traffic for certain set of machines: Useful to ignore traffic 
> for the firewall since we just want to replicate conntracks that 
> represent forwarded connections.
> - Dump internal and external caches via UNIX sockets
> - Flush internal, external caches and conntrack table
> - The communication between daemons is done in NETLINK format, so the 
> protocol used is based on NETLINK over IP, to ensure backward 
> compatibility.
> - Configuration via file
> - Log file support
>
> I'm still generalizing this a bit so it can be also used for 
> statistics purposes: since a replica of the conntrack table (cache) is 
> kept in userspace, the dumping process would not need to request the 
> information to the kernel.
>
> The software is released under GPLv2 and it is available at:
>
> http://people.netfilter.org/pablo/conntrackd/
>
> The remaining issues are:
> -------------------------
>
> - Support for IPv6.
>
> - Evaluation: I'll be getting some results to evaluate the 
> *performance drop* that could suppose to enable replication in linux 
> firewall based on this solution. Expect results soon.
> - Better integration with keepalived: This is the most important issue 
> and my major concern now. I'm happy with keepalived, but the interface 
> provided to communicate events (based on shell scripts) is not so much.
> - Checksum messages going through the network.
> - Security: A dedicated link is required to communicate nodes that 
> conform the cluster, otherwise third parties could pick up information 
> about the connections processed by the firewall.
> - More testing
>
> Requirements:
> -------------
>
> - linux kernel >= 2.6.16 with [ip|nf]_conntrack_netlink support
> - libnfnetlink from SVN
> - libnetfilter_conntrack from SVN + plus patch inside the doc/ directory.
> - keepalived (tested here with 1.1.11 available in debian)
>
> Installation:
> -------------
>
> - make sure that multicast traffic sent by conntrackd is received in 
> the dedicated interfaces:
> iptables -I INPUT -d 225.0.0.50 -j ACCEPT
> iptables -I OUTPUT -d 225.0.0.50 -j ACCEPT
>
> - install libnfnetlink and libnetfilter_conntrack from SVN (and apply 
> the patch available in doc/)
> - classical ./configure; make; make install
> - copy doc/conntrackd.conf to /etc/conntrackd/, this directory can be 
> overrided with the -C option.
> - copy doc/script_*.sh where keepalived can find them.
>
>
> Running:
> --------
>
> # conntrackd -d
> # conntrackd -i # dump internal events cache
> # conntrackd -e # dump external cache
> # conntrackd -k # kill conntrackd
> # conntrackd -f # flush internal, external caches and conntrack table
>
> I am going to write some docs at the same time that I improve the daemon.
>
> BTW, I sent a PDF file to netfilter-core but exceeded maximum size a 
> bit, could you accept it? I wrote a small article for USENIX's :LOGIN; 
> about the connection tracking system that will be released in June. I 
> can't release it for public before that date but I sent you a copy in 
> private. Although all that it contains is well known by you ;) but at 
> least have a look at the acknowledgement section.
>
> Hope that you like it.
>


-- 
--
Jeho-Park <jhpark-nf@kernelproject.org> or <linuxpark@infnis.com>
