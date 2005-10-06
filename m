From: "David S. Miller" <davem@davemloft.net>
Subject: BUG() in ip_ct_event_cache_flush()?
Date: Wed, 05 Oct 2005 23:40:46 -0700 (PDT)
Message-ID: <20051005.234046.88863607.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


I've seen an OOPS backtrace with current 2.6.x kernels
that seems to be in ip_ct_event_cache_flush().

This loop there is suspect:

	for_each_cpu(cpu) {
		ecache = &per_cpu(ip_conntrack_ecache, cpu);
		if (ecache->ct)
			ip_conntrack_put(ecache->ct);
	}

This should use "for_each_online_cpu()" I think.  Non-possible
cpus end up with percpu pointers being NULL or undefined.

Comments?
