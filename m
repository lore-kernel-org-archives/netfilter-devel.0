From: Harald Welte <laforge@gnumonks.org>
Subject: Re: NAT and locally bound sockets
Date: Tue, 2 Jul 2002 16:21:36 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702142136.GG18333@naboo.rchrd.phub.net.cable.rogers.com>
References: <20020529164926.GA9003@gort.ecn.purdue.edu> <20020530153247.I7658@sunbeam.de.gnumonks.org> <20020701163232.GB7090@lucky>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: shuey@purdue.edu
Content-Disposition: inline
In-Reply-To: <20020701163232.GB7090@lucky>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 01, 2002 at 11:32:32AM -0500, Michael Shuey wrote:
> On Thu, May 30, 2002 at 03:32:47PM +0200, Harald Welte wrote:
> > Interestingly I don't remember this bug.  I (and nobody else) has added
> > something to the TODO list about this either. Maybe it somehow got lost :(
> 
> I can't fault that; heck, I just took a month to reply to this email.
> 
> I looked up the previous comment about this issue:
> 
> http://lists.samba.org/pipermail/netfilter-devel/2002-January/003041.html
> 
> > Are you aware thet netfilter/iptables NAT is [in IETF terms] 'symmetric nat',
> > which means that we can use the same port on the NAT gw multiple times, as
> > long as the tuple (consisting out of srcip,dstip,srcport,dstport,l4proto) is
> > unique.
> 
> Yes, I am aware that netfilter provides symmetric nat.  Unfortunately, its
> port selection can provide a tuple that is _not_ unique.

mmh... not exactly.  I understand that there is a problem, but the tuple is
always unique - as long as there is any tuple!

In the case where you just bind to an udp port, but haven't sent any
packets yet, somebody else can use a tuple including that port - which
of course clashes if the local port then starts sending packets to the
same destip/destport as the now-used tuple -> boom.

> In this scenario, think about the tuple for a moment.  Since all clients and
> the natbox are mounting the same NFS server, selecting the same port by
> default, using UDP across the board, the connection tuples are (after SNAT)
> going to be very similar - they only differ in srcport.  Normally that would
> be just fine; however, with a high level of traffic the NAT system would
> occaisionally select a srcport that was already in use by the NFS client local
> to natbox.  That's not fine - it causes quite a few NFS timeouts, retransmits,
> etc. on natbox.

so you need to include your nat box itself into the SNAT rule. 

> A proper fix would have to involve TCP as well (as a similar problem most
> likely exists there, it just crops up much less frequently).

mh. the issue with TCP is the same: if you bind to a socket and not use
it for quite some time, before you actually innitiate any connection.

> Mike Shuey

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
