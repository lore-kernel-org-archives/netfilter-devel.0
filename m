From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 3/5]: Wait until all references to
 ip_conntrack_untracked are dropped on unload
Date: Fri, 22 Jul 2005 12:51:13 -0700 (PDT)
Message-ID: <20050722.125113.110015954.davem@davemloft.net>
References: <42E0A1D7.20601@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42E0A1D7.20601@trash.net>
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
Date: Fri, 22 Jul 2005 09:35:51 +0200

> [NETFILTER]: Wait until all references to ip_conntrack_untracked are dropped on unload
> 
> Fixes a crash when unloading ip_conntrack.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks.
