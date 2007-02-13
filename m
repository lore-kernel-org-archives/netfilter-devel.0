From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/7] remove nfnl_[lock|unlock] functions
Date: Tue, 13 Feb 2007 11:53:10 +0100
Message-ID: <45D19896.8020504@trash.net>
References: <45D0EE2B.5070004@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45D0EE2B.5070004@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Use nfnl_shlock instead
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> 
> ------------------------------------------------------------------------
> 
> [PATCH] remove nfnl_[lock|unlock] functions
> 
> Use nfnl_shlock instead

I would prefer to keep nfnl_lock/unlock and remove _shlock instead,
similar to rtnetlink.c.
