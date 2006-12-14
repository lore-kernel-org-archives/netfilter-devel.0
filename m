From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER]: bridge-netfilter: remove deferred hooks
Date: Wed, 13 Dec 2006 16:54:37 -0800 (PST)
Message-ID: <20061213.165437.110512157.davem@davemloft.net>
References: <457F8DBD.7050104@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, bdschuym@pandora.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <457F8DBD.7050104@trash.net>
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
Date: Wed, 13 Dec 2006 06:21:01 +0100

> This patch removes the bridge netfilter deferred hooks, a bit
> earlier than scheduled, but in January we'll probably already
> be to late in the release cycle for 2.6.20.
> 
> Tested in a purely bridged setup with VLAN and ethernet,
> brouter+DNAT setup is untested but should work fine.
> 
> Please apply, thanks.

Applied, thanks Patrick.
