From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [testsuite] ipt_iprange
Date: Fri, 17 Dec 2004 10:49:14 +1100
Message-ID: <1103240954.29545.6.camel@localhost.localdomain>
References: <41C213FB.2000101@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	nib@cookinglinux.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samuel Jean <sj-netfilter@cookinglinux.org>
In-Reply-To: <41C213FB.2000101@cookinglinux.org>
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

On Thu, 2004-12-16 at 18:02 -0500, Samuel Jean wrote:
> Hi rusty,
> 
> Here's a (probably complete) nfsim testsuite against ipt_iprange match.
> By now, 27ipt_iprange-bad-addr.sim is failing.. safe to add into 
> expected-failures.

Thanks!

BTW, "expects" expire immediately after the command they "expect" on,
so:

> # Input some junk ip range.
> # Obiously, this test must fail.
> expect iptables iptables: command failed
> iptables -A INPUT -m iprange --src-range 0.0.0.0-500.400.300.200
> iptables -A INPUT -m iprange --dst-range 0.0.0.0-500.400.300.200

This expect would not apply to the second one.

> # Check if inputing the same option twice override previous one.
> # This should ring the bell.
> # Side note: Fixed in SVN since Mon Jul 12 07:16:54 2004 UTC, Revision 1407
> 
> iptables -A INPUT -m iprange --src-range 0.0.0.0-1.1.1.1 --src-range 1.1.1.1-2.2.2.2
> iptables -A INPUT -m iprange --dst-range 0.0.0.0-1.1.1.1 --dst-range 1.1.1.1-2.2.2.2
> 
> # Giving a source and destination range should succeed.
> expect ! iptables iptables: command failed
> iptables -A INPUT -m iprange --src-range 0.0.0.0-1.1.1.1 --dst-range 1.1.1.1-2.2.2.2

When you run ./test-sh (or better, ./test-kernel-source), it runs nfsim
with the -e option, so any unexpected command failures always exit the
script with failure.

I'll fix these up.

Thanks!
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
