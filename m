From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: why every time that a rule is inserted/appended....
Date: Tue, 27 May 2003 12:29:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030527102929.GB5138@balabit.hu>
References: <3ED2887B.5050807@linux.org.ar> <Pine.LNX.4.33.0305270242360.5707-100000@fantomas.insite.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: diegows <diegows@linux.org.ar>,
	"netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andre Uratsuka Manoel <andre@insite.com.br>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0305270242360.5707-100000@fantomas.insite.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, May 27, 2003 at 02:49:43AM -0300, Andre Uratsuka Manoel wrote:
> On Mon, 26 May 2003, diegows wrote:
> 
> > ...the entire table is replaced?
> > 
> > I read the code, and i don't undertand why this design....
> > 
> > If this could be better, advise me and i try to patch that.
> 
> 	Because that is the way libiptc works. After a rule is inserted,
> the table is a complete and valid one. That would not be necessary,
> actually.
> 
> 	I want to have that changed, too... when I can find time for it.  
> It has to happen in the next 4 weeks, though, since I need to do some
> things that depend on iptables-restore complexity not being quadratic.
> 
> 	What I thought of doing is, instead of rewriting all the table, to
> rewrite only the chain on which the rule was inserted, and have that chain
> outside of the table. When needed, the table is rebuilt, such as when
> iptc_commit is called.

I think you should check out the iptables2 module in CVS and the
corresponding nfnetlink patch.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
