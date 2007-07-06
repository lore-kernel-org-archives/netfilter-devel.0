From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER]: nf_conntrack_h323: add checking of out-of-range
 on choices' index values
Date: Thu, 05 Jul 2007 17:05:37 -0700 (PDT)
Message-ID: <20070705.170537.98389406.davem@davemloft.net>
References: <468D3B86.5020308@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: security@kernel.org, netfilter-devel@lists.netfilter.org, stable@kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468D3B86.5020308@trash.net>
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
Date: Thu, 05 Jul 2007 20:42:14 +0200

> Fix a remotely triggerable crash in the netfilter H.323 connection
> tracking helper. Patch applies to stable 2.6.20/2.6.21 and current
> -git.

Applied, thanks Patrick.
