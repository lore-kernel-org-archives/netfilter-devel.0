From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/2] Fix compile with NAT but without modules
Date: Tue, 25 Jan 2005 14:35:19 +1100
Message-ID: <1106624119.19186.27.camel@localhost.localdomain>
References: <1106440732.20995.48.camel@tux.rsn.bth.se>
	<41F4426B.3040204@trash.net>
	<20050123201517.56619591.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	gandalf@wlug.westbo.se, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050123201517.56619591.davem@davemloft.net>
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

On Sun, 2005-01-23 at 20:15 -0800, David S. Miller wrote:
> On Mon, 24 Jan 2005 01:33:47 +0100
> Patrick McHardy <kaber@trash.net> wrote:
> 
> > I'll apply your patches and push them to Dave tomorrow, bkbkits.com
> > is unreachable currently so I can't resync my tree.
> 
> To be frank, this is one of several severe fallouts from
> Rusty's patches.  I really think they were not ready for
> submission when he sent them to me.

Yes.  Harald NAKed some of them, and I did nowhere near enough testing
after I shuffled and reworked them to remove the ones he didn't like.
That's entirely my fault, because I needed to get back to IBM work and
rushed it.  Some of these patches had been sitting around for over a
year, and I know that if I didn't push now it would be another year 8(

> It even broke the build if you had modules enabled in any
> way.
> 
> I'm only mentioning this because it appears that nfsim is
> becomming partially a crutch, because I know this is what
> Rusty and others use heavily for testing.  Which is fine,
> but if your patches break the build in many ways in the
> real kernel tree you're relying too heavily on the userland
> simulator IMHO.

True, nfsim sucks for build testing (eg. you only need one #include),
and you always need "real life" testing (eg. races, complex routing,
etc).  But the worst build breakage was because my .config didn't
include some things, which is my the "real" build test also failed to
find them.

OTOH, without nfsim those patches would never have been completed at
all, due to untestability.  That's why major NAT changes were not done
much earlier: there are too many nasty complex scenarios for someone to
test them all, especially such "unnecessary" cleanup work.

I will admit that I'm learning the hard way when to use nfsim, and when
not to.  For example, looks like the IRC nat helper is broken.  Guess
what: no tests in the testsuite.  (I'm writing one now, expect a "boot
tested" patch RSN).

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
