From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [Cybr.rdsw] [Cy.rdsw] serious problem with 2.4.24 combined
	with KVM switch (fwd)
Date: Thu, 05 Feb 2004 13:41:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1075984865.3101.5.camel@bzorp.balabit>
References: <Pine.LNX.4.58L.0401271021230.9958@logos.cnet>
	 <20040127124259.GP11761@sunbeam.de.gnumonks.org>
	 <1075825496.23902.9.camel@tammuz>
	 <20040203220020.GC25175@obroa-skai.de.gnumonks.org>
	 <1075903552.8033.17.camel@tammuz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1075903552.8033.17.camel@tammuz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2004-02-04 at 15:05, Oliver Kurth wrote:
> On Tue, 2004-02-03 at 23:00, Harald Welte wrote:
> > On Tue, Feb 03, 2004 at 05:24:57PM +0100, Oliver Kurth wrote:
> > > Hi Harald,
> > > 
> > > > > We are having a problem with 2.4.24 on cyclades germany, the box
> > > > > (firewall) is crashing in the netfilter code.
> > > 
> > > Anything new about that problem? Do you need more information?
> > 
> > sorry, I lost that issue because I'm extremely overloaded at the moment.
> > 
> > It seems like it crashes in the following piece of code (from
> > ip_conntrack_core.c)
> > 
> >         /* If the expectation is dying, then this is a looser. */
> >         if (expected
> >             && expected->expectant->helper->timeout
> >             && !del_timer(&expected->timeout))
> >                 expected = NULL;
> > 
> > 
> > To be more precise, it cannot dereference helper->timeout, since helper
> > is NULL.  I am extremely puzzled how you would end up with a conntrack
> > expectation (which can only be caused by a helper) that has not assigned
> > a helper.

I've encountered the same oops back in September 2003, you might be
interested in the information I posted back then:

http://lists.netfilter.org/pipermail/netfilter-devel/2003-September/012590.html

It must be some kind of race condition, but I could not figure out what
it could be.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
