From: Willy Tarreau <willy@w.ods.org>
Subject: Re: filter for adding/checking TCP MD5 option
Date: Sat, 24 Jan 2004 09:37:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040124083730.GB19035@alpha.home.local>
References: <Pine.LNX.4.44.0401231248320.12080-100000@filer.marasystems.com> <Pine.LNX.4.58.0401232037420.22515@biereco.slashme.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Henrik Nordstrom <hno@marasystems.com>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Remco van Mook <remco@virtu.nl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0401232037420.22515@biereco.slashme.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jan 23, 2004 at 08:59:24PM +0100, Remco van Mook wrote:

> > Note: As this is TCP payload dependent you need to make sure packets are
> > defragmented before processed. This is most easily accomplished by
> > depending on conntrack.
> >
> 
> ...which is precisely something I'm not too happy about. A box running tcpmd5
> would typically be a router handling positively *huge* amounts of data.

For this you can play with the NOTRACK target to escape tracking for normally
routed packets.

> Filtering is kept to an absolute minimum, and for the filtering I'm currently
> using nf-hipac, not netfilter.

Unless I'm wrong, nf-hipac's goal is to allow to keep maximum performance with
*huge* amounts of rules.

> Adding a dependency on conntrack would, correct
> me if I'm wrong, require any connection that comes through the box to be
> tracked. Tens of thousands of connections would wind up in conntrack and eat
> loads of cpu.

For info, I have installed two netfilter boxes (P4/2.4 GHz) load-balanced
behind 30 Mbps traffic. Last time I checked, there were 60k sessions in
/proc/net/ip_conntrack and they received 1k sessions/second (all logged).
All this with less than 12% CPU usage. Admittedly, there only are about
one hundred rules.

> The way BGP is organised, fragmented BGP packets would be horribly braindead
> and should not ever occur in the wild. I know that this doesn't fix the
> problem you described, but I would also very much like to see how a box from
> Vendor C or Vendor J would behave if it would get its BGP session handed to
> it in fragments, with MD5 enabled.

So you can log and drop BGP fragments to ensure that there's no problem.
IIRC, the routers in front of the firewalls described above already block
all fragments, and use BGP without problem.

Cheers,
Willy
