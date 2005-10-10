From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Mon, 10 Oct 2005 14:15:18 -0700 (PDT)
Message-ID: <20051010.141518.60492651.davem@davemloft.net>
References: <20051010164141.GG5627@rama>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051010164141.GG5627@rama>
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
Date: Mon, 10 Oct 2005 18:41:41 +0200

> This is my proposed patch for the problem you've described.  Please test
> and submit.  If it works, I'll also prepare a patch for {arp,ip6}_tables.

Ebtables needs it too.  "git grep num_possible_cpus" shows all
of the users in the whole tree, %80 of which are the netfilter
cases we're fixing here :-)

Why don't any of the existing interfaces on cpumasks and numbers
provide what you need here?  Perhaps this routine you are adding
(highest_processor_id()) belongs in linux/cpumask.h?  Perhaps
named something like "highest_possible_processor_id()" to be
consistent with the "num_possible_cpus()" naming?

Otherwise the patch looks fine, thanks for following up on this
Harald.  I'll push the rest of the netfilter fixes once you cook
up the final patch for this, thanks.

Thanks.
