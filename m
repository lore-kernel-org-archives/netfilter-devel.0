From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/10] nf_nat: Removes unused nf_nat_module_is_loaded
Date: Mon, 25 Jun 2007 20:21:07 +0200
Message-ID: <46800793.4010106@trash.net>
References: <200706251722.l5PHM8J1023549@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706251722.l5PHM8J1023549@toshiba.co.jp>
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
>  include/net/netfilter/nf_nat.h                 |    2 --
>  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    3 ---
>  net/ipv4/netfilter/nf_nat_standalone.c         |    2 --
>  3 files changed, 0 insertions(+), 7 deletions(-)

Applied.
