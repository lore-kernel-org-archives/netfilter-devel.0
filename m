From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [RFC,ANNOUNCE] conntrack daemon (stateful replication)
Date: Fri, 11 Aug 2006 11:30:20 +0300
Message-ID: <20060811083020.GW29423@edu.joroinen.fi>
References: <447A1FB7.5080709@netfilter.org>
	<20060530065804.GA24166@kruemel.my-eitzenberger.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <20060530065804.GA24166@kruemel.my-eitzenberger.de>
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

Hello!

Any updates to these projects? Files available somewhere? I think many
people from this list would like to test and help with these daemons..

- Pasi 

On Tue, May 30, 2006 at 08:58:05AM +0200, Holger Eitzenberger wrote:
> On Mon, May 29, 2006 at 12:09:59AM +0200, Pablo Neira Ayuso wrote:
> 
> > I've been working on a pet project during the last months. Part of this 
> > stuff is related with my works in the university.
> 
> Hi Pablo,
> 
> I am working on a daemon called 'ctsyncd', which for me started as a
> proof-of-concept and is now almost in a state where I can release it
> to the public.  My current objective is simple master/slave scenario
> without active/active, and I am almost done.
> 
> Hopefully I am able to look at your sources.  With your great knowledge
> of libnetfilter_conntrack and my programming skills we should consider
> joining our efforts.  But first I will release my code for public review
> within a few days.  
> 
> 
> Stay tuned.
> 
> /holger
> 
> 
> > - Stateful replication: the daemon keeps a cache of internal events via 
> > libnetfilter_conntrack and a cache of external event received from the 
> > other node.
> > - Support for classical Primary/Backup settings
> > - Support for Active/Active settings (two machines max. per VRRP instance)
> > - Support for NAT: It recognizes NAT'ed connections and handles them 
> > properly.
> > - UDP traffic ignore facility
> > - ICMP traffic ignore facility
> > - Ignore loopback traffic (not customizable at the moment)
> > - Ignore traffic for certain set of machines: Useful to ignore traffic 
> > for the firewall since we just want to replicate conntracks that 
> > represent forwarded connections.
> > - Dump internal and external caches via UNIX sockets
> > - Flush internal, external caches and conntrack table
> > - The communication between daemons is done in NETLINK format, so the 
> > protocol used is based on NETLINK over IP, to ensure backward compatibility.
> > - Configuration via file
> 
> 
> 
