From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 07/10] nf_conntrack: Removes old memory allocator of
	conntrack
Date: Mon, 25 Jun 2007 20:22:13 +0200
Message-ID: <468007D5.3000402@trash.net>
References: <200706251722.l5PHMFbX009427@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706251722.l5PHMFbX009427@toshiba.co.jp>
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
> Now memory space for help and NAT are allocated by extension infrastructure.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> ---
>  include/net/netfilter/nf_conntrack.h           |   14 --
>  include/net/netfilter/nf_conntrack_l3proto.h   |    2 -
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    6 -
>  net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    6 -
>  net/netfilter/nf_conntrack_core.c              |  222 ++----------------------
>  net/netfilter/nf_conntrack_l3proto_generic.c   |    7 -
>  6 files changed, 15 insertions(+), 242 deletions(-)


Applied, thanks.
