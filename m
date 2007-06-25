From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 05/10] nf_nat: Use extension infrastructure
Date: Mon, 25 Jun 2007 20:20:05 +0200
Message-ID: <46800755.2090406@trash.net>
References: <200706251721.l5PHLwlX004434@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706251721.l5PHLwlX004434@toshiba.co.jp>
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
>  include/net/netfilter/nf_conntrack.h           |   17 -------
>  include/net/netfilter/nf_conntrack_extend.h    |    2 +
>  include/net/netfilter/nf_nat.h                 |    6 ++
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    3 -
>  net/ipv4/netfilter/nf_nat_core.c               |   59 ++++++++++++++++++++++--
>  net/ipv4/netfilter/nf_nat_standalone.c         |   21 ++++-----
>  6 files changed, 72 insertions(+), 36 deletions(-)

Applied, thanks.
