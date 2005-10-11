From: "David S. Miller" <davem@davemloft.net>
Subject: Re: num_possible_cpus() usage in iptables
Date: Tue, 11 Oct 2005 13:00:23 -0700 (PDT)
Message-ID: <20051011.130023.81783359.davem@davemloft.net>
References: <434A08DF.5090402@cosmosbay.com>
	<20051010.172728.72244069.davem@davemloft.net>
	<20051011143554.GD4756@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net, dada1@cosmosbay.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051011143554.GD4756@rama.de.gnumonks.org>
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

From: Harald Welte <laforge@netfilter.org>
Date: Tue, 11 Oct 2005 16:35:54 +0200

> Mh.  The problem is that I know a number of people who were running out
> of RAM with moderate ruleset sizes (in the tens of thousands rules), and
> the sole reason for switching from 2.4.x to 2.6.x  was the NR_CPU to cpu
> number change.

I totally agree, using NR_CPUS has a lot of very bad side effects.
Although the simplest, it is an undesirable version of the fix due
to the bloat.

I'm going to put some brain power into this today since it's the
only big issue on my radar wrt. networking in 2.6.14
