From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 2.4 1/1]: Handle NAT module load race
Date: Tue, 06 Sep 2005 20:01:27 -0700 (PDT)
Message-ID: <20050906.200127.106024905.davem@davemloft.net>
References: <431E3CFC.7060303@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <431E3CFC.7060303@trash.net>
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
Date: Wed, 07 Sep 2005 03:06:04 +0200

> This is the backport of the NAT race fix which prevents
> a crash with CONFIG_NETFILTER_DEBUG when conntracks
> are established before the nat module is loaded.

Applied, thanks Patrick.
