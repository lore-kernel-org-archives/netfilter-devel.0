From: Willy Tarreau <w@1wt.eu>
Subject: Re: [NETFILTER 04/39]: ipt_TCPMSS: reformat
Date: Wed, 20 Sep 2006 23:11:41 +0200
Message-ID: <20060920211141.GB9122@1wt.eu>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
	<20060920082448.14636.28002.sendpatchset@localhost.localdomain>
	<4511200C.1040706@drugphish.ch>
	<20060920.111957.45154196.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, ratz@drugphish.ch
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20060920.111957.45154196.davem@davemloft.net>
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

Hi David,

On Wed, Sep 20, 2006 at 11:19:57AM -0700, David Miller wrote:
> From: Roberto Nibali <ratz@drugphish.ch>
> Date: Wed, 20 Sep 2006 13:03:40 +0200
> 
> > Would something like this be a candidate for 2.4 as well?
> 
> Like Patrick, I believe that 2.4.x is in such deep extreme
> maintainence mode that we should only ever consider pushing patches
> that users are actually hitting, or else we'll be backporting a lot of
> stuff and potentially causing more harm than good via potential
> regressions.

I'm not really fond of pure cleanups either. We're all humans and a
bug in trivial changes is likely to happen once in a while. Also, it
sometimes causes rejects to some external patches.

> I really don't like this trigger-happy "maybe backport this fix to
> 2.4.x" reaction some people have. :-/

I can understand why. It's often easier to compare identical code
sections, particularly when security fixes are needed, so the little
risk of introducing new bugs is really tempting. And I've been tempted
several times in the past too.

> Heck, for many of us 2.4.x is so old that we don't even have systems
> any longer that we can test them on since most distributions compile
> glibc in such a way that using kernels older than 2.6.x is basically
> impossible.

[OT]
It's interesting to see the shift between developpers (and desktop)
on one side, and production servers on the other side. Believe it or
not, I've not yet encountered 2.6 in places I work at. Mostly 2.4 and
some rare times 2.2. BTW, RHEL3 is supported till 2010 !

I predict that 2.4 quality will degrade again in a few years by lack
of testers for fixes. By this time, hopefully 2.6 will have reached
the same level of reliability.
[/OT]

Cheers,
Willy
