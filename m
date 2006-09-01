From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH -mm] lib/ts_fsm.c: constify structs
Date: Fri, 1 Sep 2006 15:50:16 +0200
Message-ID: <20060901135016.GJ3470@postel.suug.ch>
References: <20060831182734.GA26228@rhlx01.fht-esslingen.de>
	<20060901113137.GI3470@postel.suug.ch>
	<20060901125158.GA17752@rhlx01.fht-esslingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Content-Disposition: inline
In-Reply-To: <20060901125158.GA17752@rhlx01.fht-esslingen.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

* Andreas Mohr <andi@rhlx01.fht-esslingen.de> 2006-09-01 14:51
> Hi,
> 
> On Fri, Sep 01, 2006 at 01:31:37PM +0200, Thomas Graf wrote:
> > * Andreas Mohr <andi@rhlx01.fht-esslingen.de> 2006-08-31 20:27
> > > @@ -44,7 +44,7 @@
> > >  #define _W		0x200 /* wildcard */
> > >  
> > >  /* Map to _ctype flags and some magic numbers */
> > > -static u16 token_map[TS_FSM_TYPE_MAX+1] = {
> > > +static const u16 token_map[TS_FSM_TYPE_MAX+1] = {
> > >  	[TS_FSM_SPECIFIC] = 0,
> > >  	[TS_FSM_WILDCARD] = _W,
> > >  	[TS_FSM_CNTRL]	  = _C,
> > > @@ -61,7 +61,7 @@
> > >  	[TS_FSM_ASCII]	  = _A,
> > >  };
> > >  
> > > -static u16 token_lookup_tbl[256] = {
> > > +static const u16 token_lookup_tbl[256] = {
> > >  _W|_A|_C,      _W|_A|_C,     _W|_A|_C,     _W|_A|_C,		/*   0-  3 */
> > >  _W|_A|_C,      _W|_A|_C,     _W|_A|_C,     _W|_A|_C,		/*   4-  7 */
> > >  _W|_A|_C,      _W|_A|_C|_S,  _W|_A|_C|_S,  _W|_A|_C|_S,		/*   8- 11 */
> > 
> > You could mark them __read_mostly at this opportunity.
> 
> Thanks for the review!
> 
> However being const already implies __read_mostly if I'm not mistaken,
> due to its const nature which doesn't allow any modification. ;)

Right, not sure what I was thinking. ;) However, gcc probably already
put it into rodata for being static and only referenced for reading
so it probably doesn't make any difference.
