From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] - ip_conntrack_netlink update.
Date: Thu, 01 Dec 2005 21:05:04 +0100
Message-ID: <438F5770.90601@netfilter.org>
References: <200512011457.jB1EvbA18747@webserver5.arnet.com.ar>
	<438F5449.3010801@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: chentschel@arnet.com.ar
In-Reply-To: <438F5449.3010801@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Hi Christian,
> 
> chentschel@arnet.com.ar wrote:
> 
>>--- ./ip_conntrack_netlink.c	2005-12-01 11:26:02.275924750 -0300
>>+++ /tmp/ip_conntrack_netlink.c	2005-12-01 11:25:49.651135750 -0300
> 
> 
> This won't apply with -p1. See that the header must look like:
> 
> -- a/net/ipv4/netfilter/ip_conntrack_netlink.c      2005-11-
> 22 20:18:21.000000000 +0100
> +++ b/net/netfilter/nf_conntrack_netlink.c   2005-11-22 20:11
> :02.000000000 +0100
> 
> 
>>@@ -371,9 +371,12 @@
>> 		goto nfattr_failure;
>> 
>> 	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
>>-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
>>-		goto nfattr_failure;
>>-
>>+	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0 ||
> 
> 
> where's the if checking? it's missing. Please compile your changes
> before sending them ;)

oops, I'm stupid. Sorry, forget about this part, it is OK. I need some
sleep. Please just fix the header and resend. Thanks.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
