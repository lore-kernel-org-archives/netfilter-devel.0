From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] new match extension `flow'
Date: Sat, 06 Nov 2004 16:19:22 +0100
Message-ID: <418CEB7A.9080505@eurodev.net>
References: <20041028020550.GA10097@wsc.edu>
	<41829ADC.2090708@eurodev.net>	<20041031063813.GA29402@wsc.edu>
	<4184F9AD.9040902@eurodev.net> <20041104022039.GA25749@wsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Josh Samuelson <josamue1@wsc.edu>
In-Reply-To: <20041104022039.GA25749@wsc.edu>
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

Hi Josh,

Josh Samuelson wrote:

>You'll have to excuse my newness to the netfilter-devel scene and the
>list in general.  Thank you for pointing out the thread on the connection
>tracking events patch.  I had no idea work was being done there.
>Initial impression: Slick!
>
>I took your recommendations and changed the patch to use the connection
>tracking events API.  I also altered the flow match module to track
>the number of connections based on a network/mask option if one is
>specified.
>
>The kernel patch can only be applied after your CTE patch.  It should
>patch fine on 2.6.9, but 2.6.10-rc1 will reject a hunk for
>net/ipv4/netfilter/Kconfig because I added the lines necessary for
>IP_NF_CONNTRACK_EVENTS; easy enough to fix by hand though.
>
>The iptables patch should apply fine to vanilla iptables-1.2.11.
>  
>

nice work!

>I've only done some initial testing with this thus far: one machine
>routing through a patched machine.  Hopefully here in the next
>few days I can put this on a machine that routes a few hundred
>nodes to put some more load on it for testing purposes.
>  
>

please, don't forget that we are still discussing the event API. As this 
new match goes on top of it, we can hold this patch until the event API 
is pushed forward. Then we'll go back this point.

Some comments:

>diff -Pru linux-2.6.9/include/linux/netfilter_ipv4/ip_cte_flow.h linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_cte_flow.h
>--- linux-2.6.9/include/linux/netfilter_ipv4/ip_cte_flow.h	1969-12-31 18:00:00.000000000 -0600
>+++ linux-2.6.9-flow/include/linux/netfilter_ipv4/ip_cte_flow.h	2004-11-03 19:10:13.000000000 -0600
>  
>

I see two possibilities here:

a) move ip_cte_flow.[h|c] to ipt_flow.[h|c], matches always fit in a file.
b) rename ip_cte_flow to ip_conntrack_flow_stats, this could be a module 
which generates stats about current connections going through the firewall.

I need to give more spins to this issue.

Any comments?

Pablo
