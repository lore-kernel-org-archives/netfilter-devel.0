From: Patrick McHardy <kaber@trash.net>
Subject: Re: skb_ip_make_writable and skbs not owned by a socket
Date: Tue, 18 Jan 2005 00:13:35 +0100
Message-ID: <41EC469F.6010605@trash.net>
References: <41D86571.6070501@trash.net>	<20050113213122.7e70c3c2.davem@davemloft.net>	<41E75FA4.907@trash.net>
	<20050117135029.04e6580f.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050117135029.04e6580f.davem@davemloft.net>
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

David S. Miller wrote:

>This code is doing something different.  Even if we unclone and
>unshare the SKB, the packet header portion can still be non-linear.
>
>It will be possible for devices to create this situation on receive.
>That's why we have all the pskb_may_pull() checks in all the major
>ipv4 protocol input paths.
>
The patch already calls pskb_may_pull for unshared/uncloned skbs, so it
linearizes them up to the requested size. It just replaces skb_copy by
pskb_may_pull when the data area of unshared/uncloned skbs needs to be
mangled.

Regards
Patrick
