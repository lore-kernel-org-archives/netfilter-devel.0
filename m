From: Michael Shuey <shuey@fmepnet.org>
Subject: Re: NAT and locally bound sockets
Date: Mon, 1 Jul 2002 13:46:15 -0500
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020701184615.GA13296@lucky>
References: <20020529164926.GA9003@gort.ecn.purdue.edu> <20020530153247.I7658@sunbeam.de.gnumonks.org> <20020701163232.GB7090@lucky> <200207011859.39589.hno@marasystems.com>
Reply-To: shuey@purdue.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <200207011859.39589.hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 01, 2002 at 06:59:39PM +0200, Henrik Nordstrom wrote:
> > would be just fine; however, with a high level of traffic the NAT system
> > would occaisionally select a srcport that was already in use by the NFS
> > client local to natbox.  That's not fine - it causes quite a few NFS
> 
> This is handled fine in all tests I have done provided your SNAT rule applies 
> to both forwarded and locally originating packets.

First, why would I want to SNAT locally originating packets?  Second, are
you telling me that netfilter _does_ check to see if a port is locally bound
before using it for a translation?

> If however your UDP nat entries times out from conntrack, which they can 
> easily do for a idle NFS mount, then all bets is off.. The default udp 
> timeout is only 180 seconds which is not by far sufficient for multi-client 
> NAT of NFS. A typical case where conntrack by default cannot easily know a 
> suitable timeout without additional information.

The problem is not that UDP NAT entries are timing out from conntrack.  The
problem is that SNAT'd NFS connections are stealing packets bound for the
nat host.  As near as I can tell the NAT code will occaisionally select a
srcport that's already in use by a client local to the natbox.  For more
information, check the posting at the URL I mailed to the list earlier.

If my problems were caused by UDP nat entried timing out from conntrack, why
did all my problems disappear when I SNAT'd the connections through an IP
alias?  I didn't change the timeout, so if your assumption were correct I
would still have NFS issues.

-- 
Mike Shuey
