From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 1/3] Fix return values for LOG and ULOG
Date: Fri, 26 Jan 2007 15:03:57 +0100
Message-ID: <45BA0A4D.5020609@trash.net>
References: <Pine.LNX.4.61.0701252210090.15753@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0701252213280.15753@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0701252213280.15753@yvahk01.tjqt.qr>
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
> [PATCH 1/3] Fix return values for LOG and ULOG
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>, 2007-01-17
> 
> Index: linux-2.6.20-rc6/net/ipv4/netfilter/ipt_LOG.c
> ===================================================================
> --- linux-2.6.20-rc6.orig/net/ipv4/netfilter/ipt_LOG.c
> +++ linux-2.6.20-rc6/net/ipv4/netfilter/ipt_LOG.c
> @@ -471,8 +471,9 @@ static struct nf_logger ipt_log_logger =
>  
>  static int __init ipt_log_init(void)
>  {
> -	if (ipt_register_target(&ipt_log_reg))
> -		return -EINVAL;
> +	int ret;
> +	if ((ret = ipt_register_target(&ipt_log_reg)) < 0)
> +		return ret;

I've changed this to

ret = ...
if (ret < 0)
	...

since this is the prefered style. Thanks Jan.
