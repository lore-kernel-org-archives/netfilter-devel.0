From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Any known issues with iptables-1.3.0 from cvs/svn ?
Date: Fri, 22 Oct 2004 10:28:13 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0410221020590.17044@tux.rsn.bth.se>
References: <20041022080913.GV3551@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Rusty Russell <rusty@rustcorp.com.au>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041022080913.GV3551@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 22 Oct 2004, Harald Welte wrote:

> Hi!
>
> I want to release iptables-1.3.0 (including the libiptc speedup rewrite)
> soon.
>
> If anyone has any issues (bugs, changed functionality from 1.2.11, ...)
> with the current svn code or a recent snapshot, this is the time to step
> up :)

I've been running it for a while and havn't noticed any problems except
this:
delete-by-specifying-the-complete-rule doesn't work.

I think Rusty did some work on that in Erlangen (libiptc internals worked
but the rule-management was a bit screwed up back then). Rusty, did you
finish something or should I take a look at it?

/Martin
