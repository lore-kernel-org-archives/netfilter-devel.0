From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: iptables u32 match patch-o-matic (attempt)
Date: Sat, 1 Feb 2003 01:23:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030201012305.B27624@linux.karinthy.hu>
References: <20030128234654.29362.28104.Mailman@kashyyyk> <15927.22044.618895.821767@isis.cs3-inc.com> <20030129090945.A880@linux.karinthy.hu> <15927.62265.746506.765623@isis.cs3-inc.com> <20030131101645.GC9073@naboo.cybercafe42>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Don Cohen <don-netf@isis.cs3-inc.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Content-Disposition: inline
In-Reply-To: <20030131101645.GC9073@naboo.cybercafe42>; from laforge@gnumonks.org on Fri, Jan 31, 2003 at 11:16:45AM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jan 31, 2003 at 11:16:45AM +0100, Harald Welte wrote:
> On Wed, Jan 29, 2003 at 07:28:57AM -0800, Don Cohen wrote:
> I also disagree with Laszlo. We don't need cross-architecture
> compatibility of those structures anyway. 
> 
> >  > > +struct ipt_u32_test
> >  > > +{
> >  > > +	u_int8_t nnums;
> >  > > +	struct ipt_u32_location_element location[U32MAXSIZE+1];
> >  > > +	u_int8_t nvalues;
> >  > > +	struct ipt_u32_value_element value[U32MAXSIZE+1];
> >  > > +};
> > 
> > In this one case at least it might help to put the two 8's together,
> > right? 
> 
> yes, it should. depending on compiler and archtiecture, though.

Ok, but please understand that gcc will not do any packing on x86 or
any RISC platforms by default. And since this is part of the platform ABI,
the default behaviour is a fairly stable thing.
This boils down to saying that whatever you use (u_int8_t or u_int32_t),
it will not matter, the compiler will generate the same structure for
all major platforms of Linux (x86, alpha, sparc for sure).

Of course, this whole debate is akin to splitting a hair into two... :)

Regards,
Laszlo



> -- 
> Live long and prosper
> - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
> ============================================================================
> GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
> V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
