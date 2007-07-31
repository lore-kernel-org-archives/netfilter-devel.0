From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 05/**] Remove empty option structs
Date: Tue, 31 Jul 2007 09:34:56 +0900 (JST)
Message-ID: <200707310034.l6V0YvJm014443@toshiba.co.jp>
References: <Pine.LNX.4.64.0707241221270.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707241221270.18990@fbirervta.pbzchgretzou.qr>
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

From: Jan Engelhardt <jengelh@computergmbh.de>

> Save the structs.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>



> Index: iptables/ip6tables.c
> ===================================================================
> --- iptables.orig/ip6tables.c
> +++ iptables/ip6tables.c
> @@ -815,6 +815,9 @@ merge_options(struct option *oldopts, co
>  	unsigned int num_old, num_new, i;
>  	struct option *merge;
>  
> +	if (newopts == NULL)
> +		return oldopts;
> +
>  	for (num_old = 0; oldopts[num_old].name; num_old++);
>  	for (num_new = 0; newopts[num_new].name; num_new++);

Applied. This can prevent merge_options() copying array of option
if match/target needs no option.

-- Yasuyuki Kozakai.
