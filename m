From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2]: conntrack: don't use nfct in skb if conntrack is
 disabled
Date: Tue, 20 Mar 2007 07:28:52 +0100
Message-ID: <45FF7F24.2000506@trash.net>
References: <200703200607.l2K67HAN028049@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703200607.l2K67HAN028049@toshiba.co.jp>
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
>  include/linux/netfilter.h |   11 +++++++----
>  include/linux/skbuff.h    |   24 +++++++-----------------
>  net/core/skbuff.c         |    4 +---
>  net/netfilter/core.c      |    2 ++
>  4 files changed, 17 insertions(+), 24 deletions(-)

Applied, thanks Yasuyuki.
