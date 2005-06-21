From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 8/7]: Drop conntrack reference in
 ip_call_ra_chain()/ip_mr_input()
Date: Tue, 21 Jun 2005 14:06:36 -0700 (PDT)
Message-ID: <20050621.140636.03113280.davem@davemloft.net>
References: <42B83605.5020902@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42B83605.5020902@trash.net>
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
Date: Tue, 21 Jun 2005 17:45:09 +0200

> [NETFILTER]: Drop conntrack reference in ip_call_ra_chain()/ip_mr_input()
> 
> Drop reference before handing the packets to raw_rcv()
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks Patrick.
