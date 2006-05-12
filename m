From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] fix mem-leak in netfilter
Date: Fri, 12 May 2006 14:42:19 +0100
Message-ID: <446490BB.10801@ufomechanic.net>
References: <20060507093640.GF11191@w.ods.org>	
	<egts52hm2epfu4g1b9kqkm4s9cdiv3tvt9@4ax.com>	
	<20060508050748.GA11495@w.ods.org>	
	<20060507.224339.48487003.davem@davemloft.net>	
	<44643BFD.3040708@trash.net>
	<9a8748490605120409x3851ca4fn14fc9c52500701e4@mail.gmail.com>
	<44647280.1030602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: sfrost@snowman.net, gcoady.lk@gmail.com, laforge@netfilter.org,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, marcelo@kvack.org, willy@w.ods.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44647280.1030602@trash.net>
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
> Jesper Juhl wrote:
>> On 5/12/06, Patrick McHardy <kaber@trash.net> wrote:
>>
>>> I haven't seen any cleanup patches so far, so I think I'm
>>> going to start my nth try at cleaning up this mess.
>>> Unfortunately its even immune to Lindent ..
>>>
>> If you get too fed up with it, let me know, and I'll give it a go as well.
> 
> Thanks, I'm about half-way through (and about to kill someone),
> just started with the biggest pile of crap (the match function)
> and already noticed a possible endless loop within the first
> couple of lines.
> 
> Unfortunately this stuff is so unreadable that I'm not exactly
> sure if the loop really won't terminate, an extra pair of eyes
> would be appreciated.
> 
> ------------------------------------------------------------------------
> 
> diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
> index 1438432..b8850a2 100644
> --- a/net/ipv4/netfilter/ipt_recent.c
> +++ b/net/ipv4/netfilter/ipt_recent.c
> @@ -438,11 +438,15 @@ #endif
>  			(!r_list[hash_table[hash_result]].ttl || r_list[hash_table[hash_result]].ttl == ttl))) {
>  			/* Collision in hash table */
>  			hash_result = (hash_result + 1) % ip_list_hash_size;
> +			if (hash_result == orig_hash_result)
> +				break;
>  		}
>  	} else {
>  		while(hash_table[hash_result] != -1 && r_list[hash_table[hash_result]].addr != addr) {
>  			/* Collision in hash table */
>  			hash_result = (hash_result + 1) % ip_list_hash_size;
> +			if (hash_result == orig_hash_result)
> +				break;
>  		}
>  	}
>  

When I saw it I thought it would be better to follow the conntrack hash
method, where each hash bucket is a list head. The rabbit hole lark for
hash collisions in ipt_recent is a burden.

I also thought (and not for the first time) how nice it would be to have
some standard kernel data types like hashes, balanced trees, and so on.

ipt_recent is not an obvious beneficiary as here it also has a
time-based index into the hash for expiring old values, so we really
want multi-indexed collections in the kernel. hmmm.

Sam
