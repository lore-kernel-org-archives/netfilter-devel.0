From: Matthew Strait <quadong@users.sourceforge.net>
Subject: Re: l7-filter patch for p-o-m
Date: Wed, 22 Jun 2005 13:16:39 -0500 (CDT)
Message-ID: <Pine.LNX.4.62.0506221258490.9129@localhost.localdomain>
References: <Pine.LNX.4.61.0505312259080.6304@localhost.localdomain>
	<429D89EB.5000605@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <429D89EB.5000605@eurodev.net>
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

> kill that nfcache thing, it's obsolete.

Will do.

> a string matching infrastructure in kernel is on the way. I strongly 
> recomment you to port your works on top on it. If you're interested I'll 
> let you know once Thomas and I get something ready to use.

Please do.

>> ++#if defined(CONFIG_IP_NF_MATCH_LAYER7) || defined(CONFIG_IP_NF_MATCH_LAYER7_MODULE)
>> ++        struct {
>> ++                char * app_proto; /* e.g. "http". NULL before decision. 
>> ++                char * app_data;  /* application layer data so far.  NULL 
>> ++                unsigned int app_data_len;
>> ++        } layer7;
>> ++#endif
>
> ick, I don't like this. Well, leave it there until we come up with a better 
> idea. My proposition: You could use a private hash table similar to the 
> conntrack table that stores this information instead. Other choice could be 
> Rusty's conntrack extension infrastructure but it's not in kernel mainline, 
> it still needs some benchmarking.

Using a separate table sounds overly complicated.  I'd rather leave it 
where it is, as you say, until there's an elegant replacement.

Please let me know what the requirements for acceptance are.  Removing 
nfcache is trivial, so I will do it, but your other suggestions are not 
(and several of them aren't really possible yet).  The current state of 
the patch is stable and fairly well tested, so I'd like to get it into 
p-o-m more or less as-is, if that is possible.

-matthew
