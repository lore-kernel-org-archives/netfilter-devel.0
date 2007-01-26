From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 3/3] some xtables changes (xt_table)
Date: Fri, 26 Jan 2007 15:21:45 +0100
Message-ID: <45BA0E79.3070307@trash.net>
References: <Pine.LNX.4.61.0701252210090.15753@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701252314580.17844@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0701252314580.17844@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> [PATCH 3/3] XT: xt_table
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>, 2007-01-17
> 
> Index: linux-2.6.20-rc6/include/linux/netfilter_ipv4/ip_tables.h
> ===================================================================
> --- linux-2.6.20-rc6.orig/include/linux/netfilter_ipv4/ip_tables.h
> +++ linux-2.6.20-rc6/include/linux/netfilter_ipv4/ip_tables.h
> @@ -29,7 +29,6 @@
>  
>  #define IPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
>  #define IPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
> -#define ipt_table xt_table
>  #define ipt_get_revision xt_get_revision

Applied, again without the part above. Thanks Jan.
