From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/10] nf_conntrack: Use extension infrastructure for
 helper
Date: Mon, 25 Jun 2007 20:18:39 +0200
Message-ID: <468006FF.4010001@trash.net>
References: <200706251721.l5PHLegZ002188@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706251721.l5PHLegZ002188@toshiba.co.jp>
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
>  include/net/netfilter/nf_conntrack.h        |   26 ---------
>  include/net/netfilter/nf_conntrack_core.h   |    3 +
>  include/net/netfilter/nf_conntrack_extend.h |    3 +
>  include/net/netfilter/nf_conntrack_helper.h |    5 ++
>  net/ipv4/netfilter/nf_nat_standalone.c      |   10 ---
>  net/netfilter/nf_conntrack_core.c           |   80 +++++++++++++++++----------
>  net/netfilter/nf_conntrack_helper.c         |   27 ++++++---
>  net/netfilter/nf_conntrack_netlink.c        |   37 +++++++-----
>  8 files changed, 99 insertions(+), 92 deletions(-)


I removed a few left-over likely(ptr != NULL) and unlikely(ptr == NULL)
and applied it, thanks.
