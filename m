From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.6.11]: Clear NAT status bits on module unload
Date: Sun, 6 Feb 2005 22:13:08 -0800
Message-ID: <20050206221308.3cb13f6b.davem@davemloft.net>
References: <4204351C.8010701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4204351C.8010701@trash.net>
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

On Sat, 05 Feb 2005 03:53:16 +0100
Patrick McHardy <kaber@trash.net> wrote:

> another patch which I think should go in 2.6.11, it fixes a crash
> when unloading, then reloading iptable_nat.

Applied, thanks Patrick.
