From: "David S. Miller" <davem@davemloft.net>
Subject: Re: skb_ip_make_writable and skbs not owned by a socket
Date: Mon, 17 Jan 2005 13:50:29 -0800
Message-ID: <20050117135029.04e6580f.davem@davemloft.net>
References: <41D86571.6070501@trash.net>
	<20050113213122.7e70c3c2.davem@davemloft.net>
	<41E75FA4.907@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41E75FA4.907@trash.net>
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

On Fri, 14 Jan 2005 06:59:00 +0100
Patrick McHardy <kaber@trash.net> wrote:

> I wasn't very clear in my question, it only makes sense if you look at
> skb_ip_make_writable :) It already checks for skb_shared || skb_cloned
> to decide when to copy, but additionally makes some guesses based on the
> protocol. I think the checks for skb_shared || skb_clones should already
> catch all cases where copying is necessary, and the additional cases
> could be removed.

This code is doing something different.  Even if we unclone and
unshare the SKB, the packet header portion can still be non-linear.

It will be possible for devices to create this situation on receive.
That's why we have all the pskb_may_pull() checks in all the major
ipv4 protocol input paths.
