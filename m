From: "David S. Miller" <davem@davemloft.net>
Subject: Re: skb_ip_make_writable and skbs not owned by a socket
Date: Thu, 13 Jan 2005 21:31:22 -0800
Message-ID: <20050113213122.7e70c3c2.davem@davemloft.net>
References: <41D86571.6070501@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41D86571.6070501@trash.net>
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

On Sun, 02 Jan 2005 22:19:45 +0100
Patrick McHardy <kaber@trash.net> wrote:

> skb_ip_make_writable copies the packet as soon as the data area needs
> to be touched. This is of course necessary for packets generated locally,
> but can't we mangle the data area of skbs with skb->sk == NULL without
> copying them ?

Not if they are cloned.  tcpdump can still share access to the
packet.
