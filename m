From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] 1 Wire drivers illegally overload NETLINK_NFLOG
Date: Sun, 24 Jul 2005 19:17:56 -0700 (PDT)
Message-ID: <20050724.191756.105797967.davem@davemloft.net>
References: <20050723125427.GA11177@rama> <20050723091455.GA12015@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20050723091455.GA12015@2ka.mipt.ru>
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

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Date: Sat, 23 Jul 2005 13:14:55 +0400

> Andrew has no objection against connector and it lives in -mm

A patch sitting in -mm has zero significance.  A lot of junk
and useless things end up there as often Andrew incorporates
just about every single patch he sees posted to linux-kernel
unless he personally knows of some reason why the change might
be wrong.

So "it's in -mm" is not a metric to use.

> All objections against it was only type of - "I do not like it"
> Dmitry had some bugfixes which were added.

People like James Morris had very specific objections about it.

You are a control freak and in general very very difficult to work
with, so nobody wants to help you fix things up.
