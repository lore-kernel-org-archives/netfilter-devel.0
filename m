From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: [netfilter-core] bad performance: bug or missing optimisation?
Date: Fri, 29 Aug 2003 11:56:42 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0308291149090.22881@dns.toxicfilms.tv>
References: <20030829052521.57DA12C0BD@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Karlis Peisenieks <karlis@mt.lv>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20030829052521.57DA12C0BD@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
> Hi Maciej,
>
> 	Definitely a different problem.  ICMP errors are handled
> very differently from pings.  I assume you were actually doing NAT at
> the time?
No NAT rules, yet the nat modules were simply loaded because i used a copy
of a setup that just had:
# iptables -X -t nat
# iptables -F -t nat
For flushing all the tables. So iptable_nat was in memory. After unloading
that, the redirects were treated again by the conntrack mechanism as
valid and accepted by the by the ruleset.
After modprobing iptable_nat again, after a few minutes, the -m state
rules did not match the redirects, so they were DROPped by the ruleset
default policy.

I will re-examine the problem with the latest 2.4 kernel.

Regards,
Maciej
