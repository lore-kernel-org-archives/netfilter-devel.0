From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/10] nf_nat: Moves NAT declarations from
 nf_conntrack_ipv4.h to nf_nat.h
Date: Mon, 25 Jun 2007 20:14:49 +0200
Message-ID: <46800619.3030102@trash.net>
References: <200706251721.l5PHLAj4003973@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706251721.l5PHLAj4003973@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> ---
>  include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   23 +----------------------
>  include/net/netfilter/nf_conntrack.h           |    1 +
>  include/net/netfilter/nf_nat.h                 |   16 ++++++++++++++++
>  include/net/netfilter/nf_nat_core.h            |    1 +
>  4 files changed, 19 insertions(+), 22 deletions(-)


Applied, thanks.
