From: Harald Welte <laforge@gnumonks.org>
Subject: Re: performance issues (nat / conntrack)
Date: Thu, 27 Jun 2002 13:24:48 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020627112448.GC9003@naboo.rchrd.phub.net.cable.rogers.com>
References: <Pine.LNX.4.33.0206251548230.539-100000@blackhole.kfki.hu> <38143.203.134.158.15.1025144505.squirrel@iw.k1k2.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Andrew Smith <nfml@k1k2.com>
Content-Disposition: inline
In-Reply-To: <38143.203.134.158.15.1025144505.squirrel@iw.k1k2.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 27, 2002 at 12:21:45PM +1000, Andrew Smith wrote:
> This gives a good example when being able to set the timeout dependant
> upon specific factors (e.g. port/protocol) would be good rather than a
> global timeout that suits specific cases and does not match many cases
> - and causes a severe problem for a limited set of cases

Sorry, but we've had this discussion over and over again. Go to the list
archives and look for tuneable timeouts.

The conclusion of this discussion was, that we need to cope with all
cases without any tuning being necessarry. 

btw: For the 'ping' case, the icmp echo reply is closing the connection
anyway.

conntrack is mostly about tracking layer 3+4 protocol state.  And this
should happen as transparent as possible, so assumptions about the
application are made.  [conntrack helpers are an exemption, and be sure
I would be much happier if we didn't need to have them].


> -Cheers
> -Andrew

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
