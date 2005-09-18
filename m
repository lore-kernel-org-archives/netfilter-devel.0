From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Sat, 17 Sep 2005 23:46:59 -0700 (PDT)
Message-ID: <20050917.234659.93303900.davem@davemloft.net>
References: <20050916225131.GS8413@sunbeam.de.gnumonks.org>
	<432C443C.5010101@trash.net>
	<20050917183321.GF8413@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050917183321.GF8413@sunbeam.de.gnumonks.org>
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
Date: Sat, 17 Sep 2005 20:33:21 +0200

> I've noticed that Dave's tree already contains my original pptp patch.
> Dave: Do you want me to submit one big incremental patch to your tree,
> or rather a patch against current torvalds/linux-2.6.git ?

Please recheck my tree, I rebased and didn't put it back in.
So you should be able to just create a clean "add pptp" diff
against that tree.

Thanks a lot.
