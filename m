From: "David S. Miller" <davem@davemloft.net>
Subject: Re: skb_ip_make_writable and skbs not owned by a socket
Date: Thu, 13 Jan 2005 22:08:20 -0800
Message-ID: <20050113220820.320ae4f4.davem@davemloft.net>
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

> I think the checks for skb_shared || skb_clones should already
> catch all cases where copying is necessary, and the additional cases
> could be removed.

You're probably right, let me think about this some more.
