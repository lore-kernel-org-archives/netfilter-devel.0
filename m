From: "Robert Iakobashvili" <coroberti@gmail.com>
Subject: Re: netfilter performance on low-end embedded systems
Date: Mon, 12 Feb 2007 18:22:12 +0200
Message-ID: <7e63f56c0702120822v4d4d27cble4d9c07afc40741d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: demiurg@metalinkbb.com
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Alexander,


> From: Alexander Sirotkin <demiurg@metalinkBB.com>

> I'm trying to evaluate the feasibility of using netfilter on low-end
> embedded processors, such as MIPS 4K or 24K. Basicly what I'm trying to
> understand is whether we can do 100Bps with netfilter enabled (firewall
> and NAT) on such a CPU or should we check hardware acceleration solution.
>
> If anybody did any similar benchmarks and can share results (does not
> have to be on MIPS) or just has any opinion on the subject - I'd be very
> grateful.

With reference to the low-end arm processors, high traffic is not a
problem, unless
you are not using a large number of iptables rules, which traversal by packets
is linear.
If you need lots many rules, e.g. hundreds, thousands, etc, consider
using various
flavors of ipset, nf-hypac, connection tracking, wise rules arrangement, etc.


Sincerely,
Robert Iakobashvili,
coroberti %x40 gmail %x2e com
...................................................................
Navigare necesse est, vivere non est necesse
...................................................................
http://sourceforge.net/projects/curl-loader
A powerful open-source HTTP/S, FTP/S traffic
generating, loading and testing tool.
