From: Willy Tarreau <willy@w.ods.org>
Subject: Re: netfilter IPv6 support
Date: Fri, 27 Aug 2004 00:05:01 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040826220501.GA564@alpha.home.local>
References: <1093546367.3497.23.camel@hostmaster.org>
	<20040826130024.6ff83dff.davem@redhat.com>
	<1093555510.3497.33.camel@hostmaster.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Zehetbauer <thomasz@hostmaster.org>
Content-Disposition: inline
In-Reply-To: <1093555510.3497.33.camel@hostmaster.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Aug 26, 2004 at 11:25:10PM +0200, Thomas Zehetbauer wrote:
> On Don, 2004-08-26 at 13:00 -0700, David S. Miller wrote:
> > Stateful netfilter is not there because it's a total waste
> > to completely duplicate all of the connection tracking et al.
> > code into ipv6 counterparts when %80 of the code is roughly
> > the same.  People are working on a consolidation of these
> > things so that there is no code duplication but it is a lot
> > of work and there are bigger fires to put out at the moment.
> 
> Of course it's a waste to duplicate the code but as far as I remember
> the status of netfilter for IPv6 has not changed for almost a year. As
> said there is still not even the basic REJECT target available.

These features are available in patch-o-matic-ng. They're not in mainline
because the netfilter team only pushes well tested and non-intrusive changes.
But there are lots of people using features from patch-o-matic in production.
You can get those here :

    ftp://ftp.netfilter.org/pub/patch-o-matic-ng/

Please also take a look at the mailing list archives since it's an area
which is currently moving :
 
    http://marc.theaimsgroup.com/?l=netfilter-devel

Regards,
Willy
