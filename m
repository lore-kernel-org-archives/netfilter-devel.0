From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Any known issues with iptables-1.3.0 from cvs/svn ?
Date: Sat, 23 Oct 2004 15:43:29 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1098510164.12103.81.camel@localhost.localdomain>
References: <20041022080913.GV3551@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0410221020590.17044@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0410221020590.17044@tux.rsn.bth.se>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2004-10-22 at 18:28, Martin Josefsson wrote:
> On Fri, 22 Oct 2004, Harald Welte wrote:
> 
> > Hi!
> >
> > I want to release iptables-1.3.0 (including the libiptc speedup rewrite)
> > soon.
> >
> > If anyone has any issues (bugs, changed functionality from 1.2.11, ...)
> > with the current svn code or a recent snapshot, this is the time to step
> > up :)
> 
> I've been running it for a while and havn't noticed any problems except
> this:
> delete-by-specifying-the-complete-rule doesn't work.
> 
> I think Rusty did some work on that in Erlangen (libiptc internals worked
> but the rule-management was a bit screwed up back then). Rusty, did you
> finish something or should I take a look at it?

Shit, I did too.  But I've blown it away since then, with my old CVS
tree.  Sorry.

Rusty.
-- 
Anyone who quotes me in their signature is an idiot -- Rusty Russell
