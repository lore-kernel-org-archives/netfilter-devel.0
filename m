From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Transparent web proxiing stops working in linux-2.4.22
Date: Fri, 5 Sep 2003 09:08:19 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0309050851560.6603-100000@filer.marasystems.com>
References: <20030904215231.GD6909@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Raivis Bucis <raivis@mt.lv>, <netfilter-devel@lists.netfilter.org>,
   <cieciwa@alpha.zarz.agh.edu.pl>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030904215231.GD6909@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 4 Sep 2003, Harald Welte wrote:

> +	struct ip_conntrack_tuple tuple;
> +
> +	memset(&tuple, 0, sizeof(tuple));
> +	tuple = { { sk->rcv_saddr, { .tcp = { sk->sport } } },
> +		  { sk->daddr, { .tcp = { sk->dport } }, IPPROTO_TCP } };

This construct looks dangerous to me, relying on the compiler to optimize 
the assignment in order to fix the bug..

The above is in principle semantically equivalent to

   struct ip_conntract_tuple tuple;
   
   memset(&tuple, 0, sizeof(tuple));
   {
      struct ip_conntrac_tuple newtuple = { { sk->rcv_saddr, {
		  .tcp = { sk->sport } } },
                  { sk->daddr, { .tcp = { sk->dport } }, IPPROTO_TCP } };
      tuple = newtuple;
   }

Which obviously still has the bug..


Regards
Henrik
