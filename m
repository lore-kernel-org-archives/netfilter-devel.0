From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 05/11] More __read_mostly
Date: Fri, 03 Nov 2006 13:04:15 +0100
Message-ID: <454B303F.2060407@trash.net>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210913.710751547@wlug.westbo.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <20061101210913.710751547@wlug.westbo.se>
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

Martin Josefsson wrote:
> Place rarely written variables in the read-mostly section by using __read_mostly
> 
> --- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_helper.c	2006-11-01 21:39:48.000000000 +0100
> +++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_helper.c	2006-11-01 21:39:51.000000000 +0100
> @@ -30,7 +30,7 @@
>  #include <net/netfilter/nf_conntrack_helper.h>
>  #include <net/netfilter/nf_conntrack_core.h>
>  
> -static LIST_HEAD(helpers);
> +static struct list_head helpers __read_mostly = { &(helpers), &(helpers) };

Applied, but I changed this to static __read_mostly LIST_HEAD(helpers).
