From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH 0/7]: ct_extend
Date: Tue, 08 May 2007 11:46:40 +0200
Message-ID: <46404700.40609@trash.net>
References: <200705071200.l47C0UoM006287@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, kadlec@blackhole.kfki.hu
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200705071200.l47C0UoM006287@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> I'm re-writing ct_extend patchset. This patchset is a snapshot.
> Like Rusty's original one, it allocates memory area by kmem_cache_alloc()
> to store basic informations about a connection, but it uses kmalloc() to
> allocate memory area for extension (currently helper and NAT).
> 
> Some concepts are following.
> - 'struct ct_extend' keeps offsets to each area and the total size of them,
>   instead of identifiers of extensions. This scheme can eliminate loops and
>   make codes simple, but limits the total size of area to 256 bytes. Is it
>   too small ? If so, we can be back to the original ct_extend.


I think this will do, I believe we're somewhere in the 40-50 byte range
now with both NAT and helpers.

> - To add a new area, it reallocates ct_extend. To fix the pointer to it from
>   other objects, the 'move' operation defined by extension is used.
>   
> - It does not have the operation to remove a memory area from
>   ct_extend. Because it causes reallocating and restructuring ct_extend.
>   It is complicated operation.  And removing extension from all conntracks
>   would require heavy processing. I prefer to leave unused area.


Agreed.

> - I added 'destroy' operation which is called in destroy_conntrack(). It
>   can kill global operation 'nf_conntrack_destroyed' used by NAT.


Nice work :)

> The issues I noticed are following.
> - This patchset does not consider locking. The places calling nfct_help() or
>   nfct_nat() must be protected with new read-write lock. It will add
>   some processing time and complexities.


This will add quite some overhead since at least nfct_help is looked at
for every packet (we might avoid this using a status flag though).
I'm guessing the locks are needed to protect against concurrent
reallocations. Maybe we can avoid this by adding the limitation that
only unconfirmed entries may add new extensions?

> - ct_extend_add() reallocates memory area for all extensions. All helpers
>   and NAT codes are necessary to take care that the pointer nfct_help(ct)
>   and nfct_nat(ct) might be changed. It would make difficult to find bugs
>   caused by this issue.


Thats something we'll have to live with I guess. The same is true for
the skb reallocation functions, maybe we can get a sparse check for
this some day.

> And some improvements can be considered/are necessary.
> - Introducing new locking
> - 'move' operation might be better to have a argument 'struct nf_conn *ct'.
> - Moving other stuff in 'struct nf_conn' to ct_extend
> - Spliting nf_conn_nat into helper parts and others
> - Fixes of function names (nf_ct_ext_, nfct_ext_, nf_cte_, or ?)


I prefer nf_ct_ext_ or nfct_ext_.

> Comments are welcome.


I'm thinking we could probably avoid some reallocations by doing
a more accurate CT_EXTEND_MIN_SIZE calculation by taking
nf_nat_module_is_loaded into account. Only makes sense if it
currently is smaller than the space needed for NAT+MASQUERADE
of course.
