From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/04]: conntrack: don't use nfct in skb if conntrack
 is disabled
Date: Thu, 08 Mar 2007 19:04:44 +0100
Message-ID: <45F0503C.9030204@trash.net>
References: <200703081623.l28GNSiq005617@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703081623.l28GNSiq005617@toshiba.co.jp>
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
>  include/linux/netfilter.h |   12 ++++++++----
>  include/linux/skbuff.h    |   30 ++++++++++++++++++------------
>  net/core/skbuff.c         |    5 +++--
>  net/netfilter/core.c      |    3 +++
>  4 files changed, 32 insertions(+), 18 deletions(-)


I have a patch queued for 2.6.22 that removes ip_conntrack and
the related config options, which breaks this and the next
patch. I'll push everything to Dave today or tommorrow, please
resend this and the next patch once my patches are in Dave's
tree.

Thanks.
