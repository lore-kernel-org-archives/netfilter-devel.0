From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] Versioning (aka release) stuff for iptables
Date: Mon, 03 Jan 2005 20:47:23 +1100
Message-ID: <1104745643.14092.7.camel@localhost.localdomain>
References: <41CDDC3F.2060708@eurodev.net>
	<1104301816.8383.14.camel@localhost.localdomain>
	<41D71C82.7060101@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41D71C82.7060101@eurodev.net>
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

On Sat, 2005-01-01 at 22:56 +0100, Pablo Neira wrote:
> multiport-remove-late-check.patch:
> Remove a checking in kernel space which makes sures that the parameters 
> passed are correct, that's already done in user space where this thing 
> really belongs.

I've rolled this into the other kernel patch, after some thought.  The
previous policy was that iptables should not be able to crash the
kernel, however that means a lot of gratuitous checking in the kernel
that is far more useful if done in userspace (where the error messages
can be more informative).

> multiport_v2.patch:
> the revision 1 of multiport. Actually this merges current mport in the 
> SVN repository to multiport.

I've put this in my patch collection.

> iptables-multiport_v2.patch:
> iptables user space part.

Applied and committed.

> multiport.sim:
> a testsuite to check that new version works fine (incomplete).

I reworked this to be thorough and test one thing at a time, and split
the test into revision 0 things, and revision 1 things.  As a result, I
found a bug in the userspace part (checks protocol, but not that it
isn't inverted), and in the kernel part (--ports only examined
destination ports, not source).

Fixed, and thanks!

> BTW, if you need this. Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

Please read part (11) of Documentation/SubmittingPatches in the kernel
source tree.  If you're fine by that, attach it to future patches.

Thanks!
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
