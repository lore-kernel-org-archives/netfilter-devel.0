From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] Fix hang on netfilter module unload
Date: Tue, 15 Mar 2005 13:57:02 +0100
Message-ID: <4236DB9E.2020003@eurodev.net>
References: <20050315050641.GA334@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050315050641.GA334@linuxace.com>
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

Hi Phil,

Phil Oester wrote:
> Unfortunately, conntracks occasionally get pinned by an skb which for
> some reason or another won't go away.  So ct_general->use never reduces
> to 1 for these conntracks

So we are leaking conntracks for some reason that we must diagnose.


> @@ -1019,8 +1021,11 @@
>  	if (!h)
>  		h = LIST_FIND_W(&unconfirmed, do_iter,
>  				struct ip_conntrack_tuple_hash *, iter, data);
> +	if (!h)
> +		h = LIST_FIND_W(&cleaned, do_iter,
> +				struct ip_conntrack_tuple_hash *, iter, data);
>  	if (h)
> -		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
> +		atomic_set(&tuplehash_to_ctrack(h)->ct_general.use, 1);

But this is cheating, of course that the module will unload if we set 
all refcounts to 1 we won't spin forever in the i_see_dead_people loop 
but we are leaking somewhere anyway.

--
Pablo
