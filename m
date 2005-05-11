From: David S. Miller <davem@davemloft.net>
Subject: Re: Netfilter socket hooks
Date: Tue, 10 May 2005 17:04:20 -0700 (PDT)
Message-ID: <20050510.170420.78493043.davem@davemloft.net>
References: <20050427114926.45a91b5e.davem@davemloft.net>
	<426FE9DD.80201@trash.net> <4280DA51.8090201@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, rusty@rustcorp.com.au,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4280DA51.8090201@trash.net>
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
Subject: Netfilter socket hooks (was: Re: Status of owner-socketlookup)
Date: Tue, 10 May 2005 17:59:13 +0200

> Here is a first shot at socket hooks. Nothing uses them yet,
> and at least two things are still missing:
> 
> - conntrack reference should not be dropped before socket hooks
> - conntrack should be confirmed in socket hooks
> 
> Comments?

No major objections here, in fact it's actually kind of nice.  :-)

I'd like to go over the TCP input changes with a very fine toothed
comb before integration, but that's it.
