From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Sun, 16 Oct 2005 21:18:27 -0700 (PDT)
Message-ID: <20051016.211827.11464881.davem@davemloft.net>
References: <20051011174556.GA13415@rama.de.gnumonks.org>
	<20051011.155733.05623834.davem@davemloft.net>
	<434ED929.4030207@cosmosbay.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	hno@marasystems.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dada1@cosmosbay.com
In-Reply-To: <434ED929.4030207@cosmosbay.com>
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

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Fri, 14 Oct 2005 00:01:13 +0200

> Hi David, sorry for being late, I was traveling these last two days.

No problem, I'm about to go traveling for 2 weeks :-)

We put in a slightly different, arguably simpler/safer fix,
in for 2.6.14, but I invite you to submit this patch of
your's once the vmalloc_node() stuff goes into 2.6.15

Thanks!
