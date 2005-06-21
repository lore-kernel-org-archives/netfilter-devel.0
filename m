From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 9/7]: Fix ip6t_LOG sit tunnel logging
Date: Tue, 21 Jun 2005 14:07:36 -0700 (PDT)
Message-ID: <20050621.140736.102769775.davem@davemloft.net>
References: <42B83F55.909@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42B83F55.909@trash.net>
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
Date: Tue, 21 Jun 2005 18:24:53 +0200

> [NETFILTER]: Fix ip6t_LOG sit tunnel logging
> 
> Sit tunnel logging is currently broken:
> 
> MAC=01:23:45:67:89:ab->01:23:45:47:89:ac TUNNEL=123.123.  0.123-> 12.123.  6.123
> 
> Apart from the broken IP address, MAC addresses are printed differently
> for sit tunnels than for everything else.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied, thanks Patrick.
