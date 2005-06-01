From: Pablo Neira <pablo@eurodev.net>
Subject: Re: l7-filter patch for p-o-m
Date: Wed, 01 Jun 2005 12:11:55 +0200
Message-ID: <429D89EB.5000605@eurodev.net>
References: <Pine.LNX.4.61.0505312259080.6304@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matthew Strait <quadong@users.sourceforge.net>
In-Reply-To: <Pine.LNX.4.61.0505312259080.6304@localhost.localdomain>
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

Matthew Strait wrote:
> Done, done, and done.

it seems that you've been working :)

this is just a quick look at it, i'd need more time to review this thing 
in deep...

>> - Consider using a slab cache instead of kmalloc for your dat_len 
>> allocations
> 
> 
> Considered strongly, but I couldn't get it to work.  Hopefully that's 
> not fatal...

consider it interesting to catch up memory leaks.

> +/* Initialize the match. */
> +static void init(struct ipt_entry_match *m, unsigned int *nfcache)
> +{
> +    *nfcache |= NFC_UNKNOWN;
> +}

kill that nfcache thing, it's obsolete.

> patch-o-matic-ng-20050531-orig/l7-filter/linux-2.6/net/ipv4/netfilter/regexp/regexp.c    
> 1969-12-31 18:00:00.000000000 -0600
> +++ 
> patch-o-matic-ng-20050531/l7-filter/linux-2.6/net/ipv4/netfilter/regexp/regexp.c    
> 2005-05-31 19:48:59.000000000 -0500
> @@ -0,0 +1,1195 @@
> +/*
> + * regcomp and regexec -- regsub and regerror are elsewhere
> + * @(#)regexp.c    1.3 of 18 April 87

a string matching infrastructure in kernel is on the way. I strongly 
recomment you to port your works on top on it. If you're interested I'll 
let you know once Thomas and I get something ready to use.

BTW, you could combine your regexp stuff together with more efficient 
string matching algorithms like Boyer-Moore and Knuth-Pratt-Morris. That 
would be an interesting tradeoff. Of course, the upcoming kernel 
infrastructure will support that, so you won't need to worry about.

> diff -Nurp patch-o-matic-ng-20050531-orig/l7-filter/linux-2.6.patch 
> patch-o-matic-ng-20050531/l7-filter/linux-2.6.patch
> --- patch-o-matic-ng-20050531-orig/l7-filter/linux-2.6.patch    
> 1969-12-31 18:00:00.000000000 -0600
> +++ patch-o-matic-ng-20050531/l7-filter/linux-2.6.patch    2005-05-31 
> 19:48:59.000000000 -0500
> @@ -0,0 +1,49 @@
> +--- linux-2.6.11.3-stock/include/linux/netfilter_ipv4/ip_conntrack.h    
> 2005-03-13 00:44:41.000000000 -0600
> ++++ 
> linux-2.6.11.3-layer7/include/linux/netfilter_ipv4/ip_conntrack.h    
> 2005-03-13 20:30:01.000000000 -0600
> +@@ -177,6 +177,15 @@ struct ip_conntrack
> +     /* Traversed often, so hopefully in different cacheline to top */
> +     /* These are my tuples; original and reply */
> +     struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
> ++
> ++#if defined(CONFIG_IP_NF_MATCH_LAYER7) || 
> defined(CONFIG_IP_NF_MATCH_LAYER7_MODULE)
> ++        struct {
> ++                char * app_proto; /* e.g. "http". NULL before 
> decision. "unknown" after decision if no match */
> ++                char * app_data;  /* application layer data so far.  
> NULL after match decision */
> ++                unsigned int app_data_len;
> ++        } layer7;
> ++#endif

ick, I don't like this. Well, leave it there until we come up with a 
better idea. My proposition: You could use a private hash table similar 
to the conntrack table that stores this information instead. Other 
choice could be Rusty's conntrack extension infrastructure but it's not 
in kernel mainline, it still needs some benchmarking.

--
Pablo
