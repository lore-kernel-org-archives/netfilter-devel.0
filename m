From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] /proc/net/ip_conntrack_expect on module removal
Date: Thu, 28 Oct 2004 20:20:20 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41813864.6040107@eurodev.net>
References: <20041027163559.GA8502@wsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Josh Samuelson <josamue1@wsc.edu>
In-Reply-To: <20041027163559.GA8502@wsc.edu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Josh Samuelson wrote:

>Greetings,
>
>On module removal "/proc/net/ip_conntrack_exp" is the proc entry that
>is attempted to proc_net_remove() instead of "/proc/net/ip_conntrack_expect".
>
>Attached diff fixes this issue.
>  
>

already fixed in 2.6.10-rc1

regards,
Pablo

>-Josh
>  
>
>------------------------------------------------------------------------
>
>--- orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-21 15:08:44.000000000 -0500
>+++ patch/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-27 11:25:57.000000000 -0500
>@@ -816,7 +816,7 @@
> #ifdef CONFIG_PROC_FS
> 	proc_net_remove("ip_conntrack_stat");
> cleanup_proc_exp:
>-	proc_net_remove("ip_conntrack_exp");
>+	proc_net_remove("ip_conntrack_expect");
>  cleanup_proc:
> 	proc_net_remove("ip_conntrack");
>  cleanup_init:
>  
>
