From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: Re: Some questions about using heavy iptables rules in a Linux box
	....
Date: Tue, 09 May 2006 19:14:09 -0400
Message-ID: <1147216449.2848.44.camel@localhost>
References: <4460B502.4080903@lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: hbchen <hbchen@lanl.gov>
In-Reply-To: <4460B502.4080903@lanl.gov>
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

On Tue, 2006-05-09 at 09:28 -0600, hbchen wrote:
> Hi,
> I have some questions about using heavy iptables rules in a Linux box.
> 1. Has anyone done a comparison of latency and throughput on traffic 
> through an
>     Linux node with and without IPtables (using lots of filtering rules)?
> 2. How much CPU time is spending on iptables (heavy filtering rules)?
> 3. Any significant impact (latency and throughput) on 10G ethernet link?
<snip>
I cannot help you much with measurements but I can relate some
production experiences we have had using the ISCS network security
management project with iptables to implement intra-perimeter security.
In these cases, we needed to deal with massive rule sets (>150,000
rules).  As a result, we are successfully running this installation on
low end, off-the-shelf iptables appliances from CyberGuard (SG series).
Obviously, these are not handling 10Gbps traffic streams!

The ISCS (http://iscs.sourceforge.net) paradigm uses standard iptables
in a slightly different way to reduce the overhead associated with very
large rule sets such as those needed for interior security.  We still
answer the question who has access to what but evaluate who separately
from what.  The result is a modular rather than monolithic rule set.
Instead of needing a separate rule for every possible combination of who
and what, we need a single rule for each who and a single rule for each
what and then mix and match them.

In this particular installation, the 150,000 monolithic rules were
reduced to about 13,000 modular rules.  I suppose we could do much
better if we implemented ipset.  Not only that, but the traversal of the
rules is effectively indexed by "who" thus dramatically improving
performance.  And the entire rule set took only a few hours to
automatically create and distribute using ISCS.

Hopefully, you can use a similar approach to reduce the load and
increase processing efficiency in your environment - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

Financially sustainable open source development
http://www.opensourcedevel.com
