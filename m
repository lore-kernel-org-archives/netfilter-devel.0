From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Tue, 2 Jul 2002 16:24:47 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702142447.GI18333@naboo.rchrd.phub.net.cable.rogers.com>
References: <3D1D81F8.9080309@trash.net> <200206291236.36997@henrik.marasystems.com> <20020701075018.GA440@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20020701075018.GA440@balabit.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 01, 2002 at 09:50:18AM +0200, Balazs Scheidler wrote:
> On Sat, Jun 29, 2002 at 12:36:36PM +0200, Henrik Nordstrom wrote:
> > On Saturday 29 June 2002 11.46, Patrick McHardy wrote:
> > So the question to the Netfilter core team is if it would be OK to add 
> > a new option and "module class" to the userspace tools, and have the 
> > existing IPT_CONTINUE targets dual-register as both a target and a 
> > match. I can try to whip something together if this is seen as 
> > something acceptable. Should be fully backwards/forward compatible 
> > with existing rulesets with only a minimal amount of code 
> > duplication. The only compability issue is that if you make use the 
> > new feature then you cannot go back to a older userspace or kernel..
> 
> I for one would second a feature like this. I see a good number of places
> where it could be used (the long standing missing -l option is one example)

It is definitely useful.  I'd love to have this additional flexibility.
A couple of issues, though:

1) definitely 2.5.x thing - thus it should wait until pkt_tables becomes
   more apparent
2) I think this heavily confuses users, since a target can now be used
   as a 'match'.  The current concept of netfilter/iptables is very
   clear and well-defined.  Adding kludges like this sort-of breaks this
   concept...  

> Bazsi

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
