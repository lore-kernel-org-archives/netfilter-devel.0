From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Thu, 13 Oct 2005 12:11:25 -0700 (PDT)
Message-ID: <20051013.121125.01272781.davem@davemloft.net>
References: <20051011175457.GC13415@rama.de.gnumonks.org>
	<20051012.155419.36023860.davem@davemloft.net>
	<20051013071851.GA2526@frankengul.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, bdschuym@pandora.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: seb@frankengul.org
In-Reply-To: <20051013071851.GA2526@frankengul.org>
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

From: seb@frankengul.org
Date: Thu, 13 Oct 2005 09:18:51 +0200

> Just one little point: Should the cpu_possible_map be an exported symbol
> for all smp arch or not ?

Several, like sparc64, definite it to something else.
I audited the whole tree to make sure it would work
on every SMP platform.
