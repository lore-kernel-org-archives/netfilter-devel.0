From: Remco van Mook <remco@virtu.nl>
Subject: Re: filter for adding/checking TCP MD5 option
Date: Fri, 23 Jan 2004 20:59:24 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0401232037420.22515@biereco.slashme.org>
References: <Pine.LNX.4.44.0401231248320.12080-100000@filer.marasystems.com>
Reply-To: remco@virtu.nl
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0401231248320.12080-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 23 Jan 2004, Henrik Nordstrom wrote:

> On Tue, 20 Jan 2004, Remco van Mook wrote:
>
> > The first line would do something as follows:
> > - decrease MSS to make the extra option fit (a staggering 18 bytes extra in
> > the TCP header)
> > - calculate the MD5 based on the key and the information contained in the
> > packet
> > - insert the TCP MD5 option field, recalculate checksum and send the packet
> > on its way
> >
> > The second line would:
> > - check whether the MD5 matches the key
> > - DROP the packet if it doesn't match
> > - if the MD5 matches, strip off the MD5 option field, recalculate checksum
> > and treat the packet as if nothing happened
>
> Some conceptual changes to make this more in line with iptables:
>
> 1. a match which can verify the MD5 option. The same match should also be
> able to check if a MD5 option exists or not, allowing differentiation into
> the following packet classes:
>    - Has valid TCPMD5 option
>    - Has invalid TCPMD5 option
>    - Does not have TCPMD5 option
>
> 2. a target which can add/delete/modify the MD5 option.
>

Thanks very much for that. That was indeed a flaw in my thinking. I started
from the point that I'm not really interested in what the MD5 on incoming
packets looks like anyway, because I don't believe in the security properties
that some people attribute to it. My only concern was to fool the other side
into thinking that I'm actually using this security mechanism as well. Not a
very decent thing to do, I agree.

>
> Note: As this is TCP payload dependent you need to make sure packets are
> defragmented before processed. This is most easily accomplished by
> depending on conntrack.
>

...which is precisely something I'm not too happy about. A box running tcpmd5
would typically be a router handling positively *huge* amounts of data.
Filtering is kept to an absolute minimum, and for the filtering I'm currently
using nf-hipac, not netfilter. Adding a dependency on conntrack would, correct
me if I'm wrong, require any connection that comes through the box to be
tracked. Tens of thousands of connections would wind up in conntrack and eat
loads of cpu.

The way BGP is organised, fragmented BGP packets would be horribly braindead
and should not ever occur in the wild. I know that this doesn't fix the
problem you described, but I would also very much like to see how a box from
Vendor C or Vendor J would behave if it would get its BGP session handed to
it in fragments, with MD5 enabled.

This still leaves a hole, where things might go horribly wrong, I agree. Any
other suggestions are more than welcome.

Thanks for your comments so far.

Regards,

Remco
