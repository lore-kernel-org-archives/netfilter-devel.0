From: Patrick Schaaf <bof@bof.de>
Subject: Re: ip_conntrack performance issues - also semantic issues
Date: Sun, 19 Jan 2003 10:55:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030119095505.GH12401@oknodo.bof.de>
References: <20030118232752.26497.32589.Mailman@kashyyyk> <15914.20503.476455.344137@isis.cs3-inc.com> <20030119075102.GF12401@oknodo.bof.de> <15914.25470.189261.168220@isis.cs3-inc.com> <20030119091656.GG12401@oknodo.bof.de> <1042969247.28675.57.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, Don Cohen <don-netf@isis.cs3-inc.com>,
  Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1042969247.28675.57.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Jan 19, 2003 at 10:40:47AM +0100, Martin Josefsson wrote:
> 
> > I'm pretty sure that the allocation is the main cost, putting into
> > the hashes is not performance critical per se (if the lists are short). 
> 
> My small unscientific tests (performed quite some time ago) say that the
> allocation isn't the most costly operation performed.
> The test was a simple SYN-flood (random source ip's and ports) beeing
> forwarded by a router. If I didn't load ip_conntrack at all everything
> was fine and I had lots of cpu left. When I loaded ip_conntrack the cpu
> usage went to 100%. Then I tried blocking the flood in filter/FORWARD
> and that helped _a lot_ and in this case the allocation is still
> happening for each packet.

OK, thanks for that information. Still the cost won't be in the
operation of putting the conntrack into the hashes, but in the
consequences of that: each hashed contrack contributes to future
lookup cost (you may have head significant hash bucket chain lengths),

Also, at the same point where the conntrack enters the hashes,
it is also add_timer()ed for the first time. That touches kernel
locks, IIRC, and may contribute significantly to the cost you saw.

Such a test, IFF it also performed significant egress DROPping
of the SYNs (somehow), should clearly show the benefit of Don's
proposal of delaying hash (and timer) update until egress dequeueing.

> My point is that until someone really profiles ip_conntrack I'm not sure
> I'll believe that the allocation is the most costly operation.
> We need good profiles for a lot of diffrent situations.

One or two, for common situations, would already be a good start :)
Maybe I should update my TSC based netfilter hook profiling patch,
as it provides good, low impact, and precise facility for that.
If somebody wants to give it a run & has problems extracting it
from the dated patch posted below, please mail me directly.

best regards
  Patrick

[1] http://lists.netfilter.org/pipermail/netfilter-devel/2002-August/008876.html
