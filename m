From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: patch for iptables
Date: Tue, 22 Aug 2006 16:53:18 +0200
Message-ID: <44EB1A5E.9050304@netfilter.org>
References: <200608221634.13559.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200608221634.13559.max@nucleus.it>
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

Massimiliano Hofer wrote:
> I was so careful testing my new version of condition for binary compatiblity 
> that I didnt't notice it breaks recompilation of the userspace utilities. :)
> 
> Here is a patch that uses the new include for the XT version. While I was at 
> it, I updated the sanity checks in order to match the module ones.
> 
> One caveat: I break compatibility with older kernels that don't have XT. 
> What's the policy for backward compatibility in iptables? Shall I put a few 
> #ifdefs?

The official policy is "do not break backward" :). IHMO, if we want to 
go further with iptables we need to think about providing a netlink API.

For out-of-tree stuff the thing can be different, I have seen breakages 
if it really required it. For example, the string match is not 
compatible with the old and broken match for 2.4.

Please see below a comment about your patch:

> ------------------------------------------------------------------------
> 
> diff -Nru iptables-1.3.5-20060820.orig/extensions/.condition-test iptables-1.3.5-20060820/extensions/.condition-test
> --- iptables-1.3.5-20060820.orig/extensions/.condition-test	2006-08-21 02:22:24.000000000 +0200
> +++ iptables-1.3.5-20060820/extensions/.condition-test	2006-08-21 02:39:15.000000000 +0200
> @@ -1,3 +1,3 @@
>  #!/bin/sh
>  # True if condition is applied.
> -[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h ] && echo condition
> +[ -f $KERNEL_DIR/include/linux/netfilter/xt_condition.h ] && echo condition

You don't need to break it. Just put a dummy ipt_condition.h file that 
points to xt_condition.h

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
