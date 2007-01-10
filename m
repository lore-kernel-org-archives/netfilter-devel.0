From: Patrick McHardy <kaber@trash.net>
Subject: Re: [gentuu@gmail.com: iptables static build bug]
Date: Wed, 10 Jan 2007 07:02:32 +0100
Message-ID: <45A48178.30903@trash.net>
References: <20061218094036.GI12198@(none)>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20061218094036.GI12198@(none)>
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

Harald Welte wrote:
> Hi all,
> 
> Please verify this bug report / patch, thanks!


The tryload stuff has always been a mystery for me, so someone else
should probably have a look at this ..


> ------------------------------------------------------------------------
> 
> Subject:
> iptables static build bug
> From:
> "Tux P" <gentuu@gmail.com>
> Date:
> Mon, 18 Dec 2006 11:29:10 +0200
> To:
> marc@mbsi.ca
> 
> [...]
> I found subj. Static iptables tries to load kernel modules
> (modprobe fails and shows pesky message about every iptables run)
> regardless their static present in the kernel.
> 
> and created a simple patch to fix this.
> Please look (also attached):
> 
> --- iptables-1.3.7/iptables.c.orig      2006-12-04 03:15:20.000000000 -0800
> +++ iptables-1.3.7/iptables.c   2006-12-18 00:50:51.000000000 -0800
> @@ -774,7 +774,7 @@
>        }
> #else
>        if (ptr && !ptr->loaded) {
> -               if (tryload != DONT_LOAD)
> +               if (tryload != DONT_LOAD && tryload != DURING_LOAD)
>                        ptr->loaded = 1;
>                else
>                        ptr = NULL;
> @@ -1093,7 +1093,7 @@
>        }
> #else
>        if (ptr && !ptr->loaded) {
> -               if (tryload != DONT_LOAD)
> +               if (tryload != DONT_LOAD && tryload != DURING_LOAD)
>                        ptr->loaded = 1;
>                else
>                        ptr = NULL;
> 
> 
> 
> Thanks
> 
> Nick
> 
