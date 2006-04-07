From: "David S. Miller" <davem@davemloft.net>
Subject: Re: Huge impact of the conntrack mechanism on routing performance
 (30% with a single conntrack entry)
Date: Fri, 07 Apr 2006 14:28:29 -0700 (PDT)
Message-ID: <20060407.142829.87870703.davem@davemloft.net>
References: <20060405140305.9637.qmail@web33801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: robert.olsson@data.slu.se, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: eddy_kvetny@yahoo.com
In-Reply-To: <20060405140305.9637.qmail@web33801.mail.mud.yahoo.com>
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

From: Eddy Kvetny <eddy_kvetny@yahoo.com>
Date: Wed, 5 Apr 2006 07:03:05 -0700 (PDT)

> Right after "insmod ip_conntrack.ko" the throughput
> drastically falls to 28 kpps (-12 kpps or -30% !!!).

Yes, this is pretty much what the cost of netfilter is for a router.

This has been known and well understood for a long time, and solutions
to this problem are not easy which is why there hasn't been any
progress in this area to date.
