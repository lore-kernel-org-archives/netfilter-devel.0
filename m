From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] kernel panic with rpc.patch
Date: Fri, 03 Sep 2004 03:52:13 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4137CE4D.7070702@trash.net>
References: <20040902232357.GA18422@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <netfilter@linuxace.com>
In-Reply-To: <20040902232357.GA18422@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>Some useless __MOD_INC_USE_COUNT macros make rpc patch panic on boot.
>The below removes them.  Boot tested.
>
>This fixes bugzilla #50
>  
>

Applied, but wondering on second thought. There are still two
__MOD_DEC_USE_COUNT left, and __MOD_INC_USE_COUNT does actually
do something :) Why are they useless ?

Regards
Patrick

>
>
>Phil
>
>
>  
>
>------------------------------------------------------------------------
>
>diff -ru pom-orig/rpc/linux/net/ipv4/netfilter/ipt_rpc.c pom-new/rpc/linux/net/ipv4/netfilter/ipt_rpc.c
>--- pom-orig/rpc/linux/net/ipv4/netfilter/ipt_rpc.c	2003-12-18 13:48:00.000000000 -0500
>+++ pom-new/rpc/linux/net/ipv4/netfilter/ipt_rpc.c	2004-09-02 19:09:56.599859208 -0400
>@@ -394,10 +394,6 @@
> {
> 	int port;
> 
>-	DEBUGP("incrementing usage counts\n");
>-	__MOD_INC_USE_COUNT(ip_conntrack_rpc_udp);
>-	__MOD_INC_USE_COUNT(ip_conntrack_rpc_tcp);
>-
> 	/* If no port given, default to standard RPC port */
> 	if (ports[0] == 0)
> 		ports[0] = RPC_PORT;
>  
>
