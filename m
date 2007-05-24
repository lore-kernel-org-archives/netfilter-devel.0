From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 05/07]: nf_conntrack_h323: remove unnecessary
 process of Information signal
Date: Thu, 24 May 2007 16:43:50 -0700 (PDT)
Message-ID: <20070524.164350.00947834.davem@davemloft.net>
References: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
	<20070524215840.14308.13646.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070524215840.14308.13646.sendpatchset@localhost.localdomain>
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
Date: Fri, 25 May 2007 00:02:13 +0200 (MEST)

> [NETFILTER]: nf_conntrack_h323: remove unnecessary process of Information signal
> 
> According to the implementation of H.323, it's not necessary to check the
> addresses in Information signals.
> 
> Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
