From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] please kill santa-claus
Date: Wed, 05 Jul 2006 17:49:04 +0200
Message-ID: <44ABDF70.2010705@netfilter.org>
References: <20060630153802.GA27351@phoenix.home.spootnik.org>
	<44ABDBB4.5010605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pierre-Yves Ritschard <pierre-yves@spootnik.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44ABDBB4.5010605@trash.net>
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

Patrick McHardy wrote:
> Pierre-Yves Ritschard wrote:
> 
>>While running our home-brewed firewall scripts the output was broken by
>>a weird message spewed by the libipt_iprange extension:
>>	"hoho" (sic)
>>I wonder why that is, it seems not too many people noticed or use
>>src-range inversion which is the feature that triggers this friendly yet
>>surprising message.
>>If there's a specific reason (which I haven't found in TFA or google)
>>please let me know, otherwise please consider this one-liner:
>>
>>--- extensions/libipt_iprange.c.orig    Fri Jun 30 17:34:05 2006
>>+++ extensions/libipt_iprange.c Fri Jun 30 17:34:21 2006
>>@@ -73,7 +73,6 @@
>>                check_inverse(optarg, &invert, &optind, 0);
>>                if (invert) {
>>                        info->flags |= IPRANGE_SRC_INV;
>>-                       printf("hoho\n");
>>                }
>>                parse_iprange(optarg, &info->src);              
> 
> 
> LOL :) Applied, thanks.

This is Jozsef's :D

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
