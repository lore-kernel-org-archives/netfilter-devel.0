From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] trivial CONNMARK typo
Date: Wed, 4 Aug 2004 15:04:59 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0408041504410.14280-100000@filer.marasystems.com>
References: <20040803045826.GA22598@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040803045826.GA22598@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Please apply

Regards
Henrik

On Mon, 2 Aug 2004, Phil Oester wrote:

> The below fixes bugzilla #207...
> 
> Phil
> 
> 
> 
> diff -ru pom-orig/CONNMARK/linux/Documentation/Configure.help.ladd pom-new/CONNMARK/linux/Documentation/Configure.help.ladd
> --- pom-orig/CONNMARK/linux/Documentation/Configure.help.ladd   2004-02-19 06:30:07.000000000 -0500
> +++ pom-new/CONNMARK/linux/Documentation/Configure.help.ladd    2004-07-30 18:30:19.000000000 -0400
> @@ -17,7 +17,7 @@
>    ipt_CONNMARK.o.  If unsure, say `N'.
>  
>  connmark match support
> -CONFIP_IP_NF_MATCH_CONNMARK
> +CONFIG_IP_NF_MATCH_CONNMARK
>    This option adds a `connmark' match, which allows you to match the
>    connection mark value previously set for the session by `CONNMARK'. 
>  
> 
> 
