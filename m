From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER]: Fix {ip,ip6,arp}_tables hook validation
Date: Tue, 21 Nov 2006 17:42:59 -0800 (PST)
Message-ID: <20061121.174259.11600997.davem@davemloft.net>
References: <4562D55A.4060004@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <4562D55A.4060004@trash.net>
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
Date: Tue, 21 Nov 2006 11:30:50 +0100

> This patch fixes a regression from the "[NETFILTER]: Missed and
> reordered checks in iptables" patch. I'll send a new backport
> to the -stable guys as well.
> 
> Please apply, thanks.

Applied, thanks Patrick.
