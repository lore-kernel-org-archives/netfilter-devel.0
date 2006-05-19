From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 3/*]: GRE conntrack: fix htons/htonl confusion
Date: Fri, 19 May 2006 02:18:15 -0700 (PDT)
Message-ID: <20060519.021815.18973248.davem@davemloft.net>
References: <446D1DA9.5000507@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <446D1DA9.5000507@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 19 May 2006 03:21:45 +0200

> following are three more fixes on top of the last two: the
> byteorder fixes from Alexey Dobriyan and Solar Designer's
> do_add_counters fix. Please also apply.

I've applied all of your fixes, thanks a lot Patrick.
