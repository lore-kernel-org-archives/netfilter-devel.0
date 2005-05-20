From: Damon Gray <dgray@internap.com>
Subject: Re: EXPORT_SYMBOL(hash_conntrack)
Date: Fri, 20 May 2005 11:18:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0505201115010.24626@dgray-test.acs.internap.com>
References: <Pine.LNX.4.62.0505181743480.16841@dgray-test.acs.internap.com>
	<428C03C2.5000105@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <428C03C2.5000105@eurodev.net>
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


Understood, would it be more appropriate to change it to a static inline 
in ip_conntrack_core.h? It seems like a good candidate for inlining 
anyways.

Thanks

-Damon-

On Thu, 19 May 2005, Pablo Neira wrote:

> Damon Gray wrote:
>> I have a need to be able to use hash_conntrack in a kernel module. Does 
>> anyone see a problem if hash_conntrack was exported? I'd prefer to use the 
>> function instead of duplicating it with jhash_3words just so I don't have 
>> to keep track of how hash_conntrack does the hashing.
>
> Well, all the current exported symbols are used by other modules in kernel 
> mainline and pom-ng. So you'll have to justify such exportation with some 
> kind of candidate client (maybe your module) that could be useful for 
> everyone.
>
> --
> Pablo
>
>
