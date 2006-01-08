From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Sun, 08 Jan 2006 23:08:55 +0100
Message-ID: <43C18D77.501@trash.net>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> Hi!
> 
> It's been some time since I last released a version of the x_tables
> patch.  This is mainly due to the reason that 2.6.15 has only been
> released recently, and x_tables was clearly 2.6.16 work.
> 
> I've modified nfsim and the nfsim-testsuite to work with an x_tables
> kernel, and all tests now pass without any problem (using an old
> iptables binary that was compiled against a non-xtables kernel). This,
> in addition to my manual tests, give me enough confidence that I didn't
> break something significant.
> 
> I'm planning to submit x_tables eatly next week, so this is assumed to
> be the final review phase.
> 
> So if you have any issues, please comment now before it's too late :)

The patch looks great. It clashes with the policy match however, which
is already in Dave's net-2.6 tree. I have an updated patch (trivial
change) I can send you if you want.

For now just one question, I need some time to read through the patch:

  static int
  icmp6_checkentry(const char *tablename,
-          const struct ip6t_ip6 *ipv6,
+          const void *entry,

Why do you change struct ip6t_ip6 * to void * for IPv6 matches,
but keep ipt_ip for IPv4 matches? Shouldn't the old API be
unaffected by moving some matches and targets to x_tables?
