From: Michael Shuey <shuey@fmepnet.org>
Subject: Re: NAT and locally bound sockets
Date: Mon, 1 Jul 2002 11:32:32 -0500
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020701163232.GB7090@lucky>
References: <20020529164926.GA9003@gort.ecn.purdue.edu> <20020530153247.I7658@sunbeam.de.gnumonks.org>
Reply-To: shuey@purdue.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020530153247.I7658@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 30, 2002 at 03:32:47PM +0200, Harald Welte wrote:
> Interestingly I don't remember this bug.  I (and nobody else) has added
> something to the TODO list about this either. Maybe it somehow got lost :(

I can't fault that; heck, I just took a month to reply to this email.

I looked up the previous comment about this issue:

http://lists.samba.org/pipermail/netfilter-devel/2002-January/003041.html

> Are you aware thet netfilter/iptables NAT is [in IETF terms] 'symmetric nat',
> which means that we can use the same port on the NAT gw multiple times, as
> long as the tuple (consisting out of srcip,dstip,srcport,dstport,l4proto) is
> unique.

Yes, I am aware that netfilter provides symmetric nat.  Unfortunately, its
port selection can provide a tuple that is _not_ unique.

> Could you please try to describe the scenario of this alleged bug? 

I ran into this when I had 100 hosts behind a single NAT box, all trying to
reach the same NFS file server at the same time the NAT box itself was
mounting the NFS server.  At the time I was using the default SNAT options
(not specifying a port range for the translations) so any traffic originating
at a port below 1024 would be mapped to natbox:<something under 1024>.  That
was working as expected.

In this scenario, think about the tuple for a moment.  Since all clients and
the natbox are mounting the same NFS server, selecting the same port by
default, using UDP across the board, the connection tuples are (after SNAT)
going to be very similar - they only differ in srcport.  Normally that would
be just fine; however, with a high level of traffic the NAT system would
occaisionally select a srcport that was already in use by the NFS client local
to natbox.  That's not fine - it causes quite a few NFS timeouts, retransmits,
etc. on natbox.

This is hard to observe (unless you have lots of NAT clients or a very
restricted range of possible srcports for translations), but lsof on the
natbox and a packet sniffer showed that this was, in fact, occurring.  I
ended up setting up an IP alias on the natbox just to route all translated
traffic through.  When I did that everything worked normally again - no NFS
problems at all on natbox (which is to be expected, since the translated
connections' tuples are now different from the local NFS client).

To fix this the NAT code needs to check to see what, if any, ports are
locally bound (and not use them, of course!)  The original poster for this
bug had a bit of code that tried to address this, but it was limited to UDP.
A proper fix would have to involve TCP as well (as a similar problem most
likely exists there, it just crops up much less frequently).

-- 
Mike Shuey
