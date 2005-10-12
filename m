From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Make hashsize ip_conntrack parameter writable
Date: Wed, 12 Oct 2005 20:29:18 +1000
Message-ID: <1129112959.8218.78.camel@localhost.localdomain>
References: <1128536584.9868.1.camel@localhost.localdomain>
	<200510071227.j97CRrgx027931@toshiba.co.jp>
	<1128979368.8218.8.camel@localhost.localdomain>
	<20051011143813.GE4756@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051011143813.GE4756@rama.de.gnumonks.org>
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

On Tue, 2005-10-11 at 16:38 +0200, Harald Welte wrote:
> > Just checking you were reading.  Well done, Yasuyuki!
> 
> I also noticed the missing inline when merging your patch, but I thought
> maybe gcc will do it automatically.

We usually suppress gcc's inline heuristics on kernel builds.  Not a
good idea these days IMHO, but...

> > We should use "u32", too, not those types I made the mistake of using
> > when I was young and foolish.
> 
> I'm still young and foolish, so all my code uses the u_intXX_t... and I
> ask myself why we shouldn't use the posix types?  I'm still puzzled...

Mainly because they're ugly: in the kernel u32 etc is the standard, and
the netfilter code should probably follow that.

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
