From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 10/10] nf_nat: merge nf_conn and nf_nat_info
Date: Mon, 25 Jun 2007 20:31:07 +0200
Message-ID: <468009EB.2050801@trash.net>
References: <200706251722.l5PHMsZA004963@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706251722.l5PHMsZA004963@toshiba.co.jp>
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
>  include/net/netfilter/nf_nat.h     |   17 ++++++-----------
>  net/ipv4/netfilter/nf_nat_core.c   |   25 ++++++++++++-------------
>  net/ipv4/netfilter/nf_nat_helper.c |   11 +++++------
>  3 files changed, 23 insertions(+), 30 deletions(-)


All applied, thanks a lot for doing this work Yasuyuki.
