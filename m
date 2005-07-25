From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] 1 Wire drivers illegally overload NETLINK_NFLOG
Date: Sun, 24 Jul 2005 19:09:39 -0700 (PDT)
Message-ID: <20050724.190939.03085123.davem@davemloft.net>
References: <20050723125427.GA11177@rama>
	<20050722.230559.123762041.yoshfuji@linux-ipv6.org>
	<20050723133353.GB11177@rama>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: johnpol@2ka.mipt.ru, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050723133353.GB11177@rama>
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
Date: Sat, 23 Jul 2005 09:33:53 -0400

> I strongly disrecommend increasing NPROTO.  Maybe we should look into
> reusing NETLINK_FIREWALL (which was an old 2.2.x kernel interface).

That is how I will fix this 1-wire case, by reusing the NETLINK_FIREWALL
thing.

> But to be honest, I don't really care all that much as long as existing
> and still very actively used values are not just overloaded.

Absolutely.
