From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/02]: nf_conntrack_ipv4: fix "Frag of proto ..."
 messages
Date: Tue, 11 Sep 2007 02:27:33 -0700 (PDT)
Message-ID: <20070911.022733.112625116.davem@davemloft.net>
References: <20070909221736.25157.46398.sendpatchset@localhost.localdomain>
	<20070909221738.25157.79830.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070909221738.25157.79830.sendpatchset@localhost.localdomain>
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
Date: Mon, 10 Sep 2007 00:20:39 +0200 (MEST)

> [NETFILTER]: nf_conntrack_ipv4: fix "Frag of proto ..." messages
> 
> Since we're now using a generic tuple decoding function in ICMP
> connection tracking, ipv4_get_l4proto() might get called with a
> fragmented packet from within an ICMP error. Remove the error
> message we used to print when this happens.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks.
