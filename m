From: "David S. Miller" <davem@davemloft.net>
Subject: num_possible_cpus() usage in iptables
Date: Sun, 09 Oct 2005 20:47:34 -0700 (PDT)
Message-ID: <20051009.204734.30319051.davem@davemloft.net>
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


Guys, you can't use this interface like that.

It's a _COUNT_ of the number of possible processors, not the number of
the higest PHYSICAL cpu index.

So you can have cpu's numbered "0" and "2", but num_possible_cpus()
will return 2.  This is not just theoretical, Ultra60 sparc64 systems
have this exact physical cpu numbering.   And as a result, when the
changes went into iptables to use num_possible_cpus() instead of NR_CPUS
it broke iptables.  It OOPS's when you load the module, in fact.

So, on such a system, this loop:

	/* And one copy for every other CPU */
	for (i = 1; i < num_possible_cpus(); i++) {
		memcpy(newinfo->entries + SMP_ALIGN(newinfo->size)*i,
		       newinfo->entries,
		       SMP_ALIGN(newinfo->size));
	}

would initialize the wrong entries.

We need to fix this.
