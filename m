From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ROUTE target
Date: Tue, 30 May 2006 00:40:32 +0200
Message-ID: <447B7860.7050106@trash.net>
References: <1148838285.2516.5.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1148838285.2516.5.camel@scaramouche.combox.de>
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

Torsten Luettgert wrote:
> Hi,
> 
> here's another simple patch for the ROUTE target. It fails to compile
> if CONFIG_NETFILTER_DEBUG is set, because there's no nf_debug member
> in skb any longer. The patch just removes the skb->nf_debug = 0;

Applied, thanks.
