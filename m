From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: filter for adding/checking TCP MD5 option
Date: Fri, 23 Jan 2004 21:12:55 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401232102090.23528-100000@filer.marasystems.com>
References: <Pine.LNX.4.58.0401232037420.22515@biereco.slashme.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Remco van Mook <remco@virtu.nl>
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

On Fri, 23 Jan 2004, Remco van Mook wrote:

> ...which is precisely something I'm not too happy about. A box running tcpmd5
> would typically be a router handling positively *huge* amounts of data.
> Filtering is kept to an absolute minimum, and for the filtering I'm currently
> using nf-hipac, not netfilter. Adding a dependency on conntrack would, correct
> me if I'm wrong, require any connection that comes through the box to be
> tracked. Tens of thousands of connections would wind up in conntrack and eat
> loads of cpu.

If not conntrack you will need something else which defragments packets, 
or assume that the tcpmd5 packets will never arrive fragmented.

> The way BGP is organised, fragmented BGP packets would be horribly braindead
> and should not ever occur in the wild. I know that this doesn't fix the
> problem you described, but I would also very much like to see how a box from
> Vendor C or Vendor J would behave if it would get its BGP session handed to
> it in fragments, with MD5 enabled.

They should not really care if it is fragmented or not at the BGP layer.  
Fragmented packets is an issue for the IP layer, not TCP. If BGP is run
over TCP then the participating routers should all be running IP with a
TCP implementation.  Normally IP will defragment the packet before handing
it to TCP where the MD5 option is then processed.

But I hope these TCP channels all have MTU Discovery enabled in which case
there should not be any fragmented packets. In such case support for
fragmented packets may be disabled in the IP kernel as a DoS security
measure unless there is other services requiring it.

Regards
Henrik
