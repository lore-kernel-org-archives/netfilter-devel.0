From: "Mohammad Mohsenzadeh" <mmohsenz@gmail.com>
Subject: Re: [RFC][PATCH 0/7]: ct_extend
Date: Wed, 30 May 2007 19:43:46 -0400
Message-ID: <e6af3bc80705301643w37922773ge6beab27d229718b@mail.gmail.com>
References: <200705071200.l47C0UoM006287@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	pablo@netfilter.org, kadlec@blackhole.kfki.hu
To: "Yasuyuki KOZAKAI" <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200705071200.l47C0UoM006287@toshiba.co.jp>
Content-Disposition: inline
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

Thanks for the patches, applied and works just fine. I was just
wondering if you would ever consider including these in the main
release of netfilter??

Thanks again
Mohammad

On 5/7/07, Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> wrote:
>
> Hi all,
>
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
>
> - To add a new area, it reallocates ct_extend. To fix the pointer to it from
>   other objects, the 'move' operation defined by extension is used.
>
> - It does not have the operation to remove a memory area from
>   ct_extend. Because it causes reallocating and restructuring ct_extend.
>   It is complicated operation.  And removing extension from all conntracks
>   would require heavy processing. I prefer to leave unused area.
>
> - I added 'destroy' operation which is called in destroy_conntrack(). It
>   can kill global operation 'nf_conntrack_destroyed' used by NAT.
>
> The issues I noticed are following.
> - This patchset does not consider locking. The places calling nfct_help() or
>   nfct_nat() must be protected with new read-write lock. It will add
>   some processing time and complexities.
>
> - ct_extend_add() reallocates memory area for all extensions. All helpers
>   and NAT codes are necessary to take care that the pointer nfct_help(ct)
>   and nfct_nat(ct) might be changed. It would make difficult to find bugs
>   caused by this issue.
>
> And some improvements can be considered/are necessary.
> - Introducing new locking
> - 'move' operation might be better to have a argument 'struct nf_conn *ct'.
> - Moving other stuff in 'struct nf_conn' to ct_extend
> - Spliting nf_conn_nat into helper parts and others
> - Fixes of function names (nf_ct_ext_, nfct_ext_, nf_cte_, or ?)
>
> Comments are welcome.
>
> -- Yasuyuki Kozakai
>
>
