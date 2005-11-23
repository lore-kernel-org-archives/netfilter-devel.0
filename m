From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH 2.4] TCP window tracking: core implementation
Date: Wed, 23 Nov 2005 22:54:29 +0100
Message-ID: <20051123215429.GA19518@alpha.home.local>
References: <43819E72.5060704@tac.ch> <20051122165631.GA13716@alpha.home.local>
	<438466C4.5040701@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <438466C4.5040701@tac.ch>
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

Hi Roberto,

On Wed, Nov 23, 2005 at 01:55:32PM +0100, Roberto Nibali wrote:
> Salut Willy,
> 
> >>A former version of this patch has been in production on a dozen nodes
> >>for about 8 months now, and besides unmotivated DROPs invoked by
> >>"non-RFC-comformant" applications, it works reasonably well.
> >  
> > Seconded !
> > I've had it in production for 18 months now, handling between 1.2 and 1.8
> > billions of sessions a month, and it still works like a charm.
> 
> Could you batch my patchset for your next -hf series, please? I'll try
> to get you a tcpdump with erroneous behaviour regarding window tracking,
> so you can verify this as well.

No, and I'm sorry to insist in this direction : the -hf tree is only a
*selection* of patches from next mainline version(s). It's targetted at
the users who cannot risk an upgrade to the next -pre-something, but who
still need security or stability fixes. Under no circumstance should I
add new features to this tree.

I'm currently thinking about another tree (something like 2.4-enterprise)
which would host those patches absolutely needed for people with higher
expectations than "normal" users. Nflog, window-tracking, epoll, and
jiffies64 immediately come to mind, but possibly a small bunch of others
too. And I hope to count you among the patch contributors ;-)

> >>We'd hoped to overcome remaining "broken" applications by using the
> >>NOTRACK flag to a filter rule. This would allow one to have a general
> >>stateful packet filter with a few stateless rules for "broken"
> >>applications; a feature most commercial firewall suites don't offer.
> >>Unfortunately there is still an issue with regard to SMP and rmmod'ing
> >>ip_conntrack while having NOTRACK rules loaded and network traffic
> >>hitting NOTRACK and conntrack. Otherwise it works flawlessly. Patch will
> >>follow shortly.
> > 
> > another possibility would be to add something like a "reason" code to the
> > INVALID state, so that we could tell which types of invalids we still want
> > to let go and which ones we definitely want to block.
> 
> This is of course possible but could potentially lead to a lot of
> exception code. I reckon that it's safe enough to fallback to classic
> packet filtering when dealing with non-RFC conform TCP clients or
> applications. Meanwhile I've found the problem with the NOTRACK hanging
> and will propose a fix in another thread I've started.

OK, I don't have much idea about how to proceed with the NOTRACK yet
because in the past I could not get it to work along with window-tracking.
So of course I'm interested :-)

Cheers,
Willy
