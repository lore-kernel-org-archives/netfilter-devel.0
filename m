From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: use of vmalloc within netfilter (was Re: [ANNOUNCE] IP sets)
Date: Thu, 26 Feb 2004 11:43:41 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0402261140590.25110-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0402261131580.12937@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0402261131580.12937@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 26 Feb 2004, Martin Josefsson wrote:

> It's adding some extra overhead in some places.
> The chunk below will call ip_conntrack_hash_elem() with the same argument
> for each iteration of the linked list.
>
> @@ -1145,7 +1150,7 @@
>
>         /* Get rid of expecteds, set helpers to NULL. */
>         for (i = 0; i < ip_conntrack_htable_size; i++)
> -               LIST_FIND_W(&ip_conntrack_hash[i], unhelp,
> +               LIST_FIND_W(ip_conntrack_hash_elem(i), unhelp,
>                             struct ip_conntrack_tuple_hash *, me);
>         WRITE_UNLOCK(&ip_conntrack_lock);
>
>
> We've removed lots of these things earlier.
>
> for (i = 0; i < ip_conntrack_htable_size; i++) {
> 	struct list_head *bucket = ip_conntrack_hash_elem(i);
> 	LIST_FIND_W(bucket, unhelp, struct ip_conntrack_tuple_hash *, me);
> }

That's not in 2.6.3-bk5. Sigh.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
