From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Last vestiges of NFC
Date: Fri, 31 Aug 2007 11:38:42 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708311137250.8423@x2>
References: <46D06522.2090509@hotpop.com> <46D06FF8.5090004@hotpop.com>
	<46D5A5B9.2030107@trash.net> <46D6DEAF.9010009@hotpop.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Peter Riley <Peter.Riley@hotpop.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D6DEAF.9010009@hotpop.com>
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

On Thu, 30 Aug 2007, Peter Riley wrote:

> Patrick McHardy wrote:
>>
>> I count 132 occurences of nfcache (a few are in headers that must stay
>> though). I'll happily apply a patch that kills them all.
>>
>
> Patrick, yes I get 134 occurrences on 132 lines in current svn.
> The breakdown appears to me to be:
>
> 51   init() function declarations in match and target extensions
>
> 52   parse() function declarations in match extensions only
>     (not counting connlimit and multiport which are more complicated than
>     one declaration per file)
>
> 2    parse related function declarations in connlimit
> 4    parse related function declarations in multiport
>
> 5+5  calls in iptables.c & ip6tables.c to ->init() or ->parse() members above
>
> 3    occurrences in xtables.h that prototype the above:
>
>     struct xtables_match
>     {...
>         void (*init)(struct xt_entry_match *m, unsigned int *nfcache);
>
>         int (*parse)(int c, char **argv, int invert, unsigned int *flags,
>             const void *entry, unsigned int *nfcache, struct xt_entry_match **match);
>
>     struct xtables_target
>     {...
>         void (*init)(struct xt_entry_target *t, unsigned int *nfcache);
>
> 3+3  occurrences in dump_entry() in libip4tc.c and libip4tc.c for debugging:
>
> 	printf("Cache: %08X ", e->nfcache);
> 	if (e->nfcache & NFC_ALTERED) printf("ALTERED ");
> 	if (e->nfcache & NFC_UNKNOWN) printf("UNKNOWN ");
>
>     It seems that there is good reason for printing out nfcache contents as long as
>     those bits are still present in structs ipt_entry/ip6t_entry defined in headers
>     on the kernel side.  After all, this is how I tracked down the problem I am
>     reporting to begin with!
>
>
> What all this leaves remaining are the occurrences I mentioned in previous message
> whose removal doesn't break anything:
>
>
> 1+1  in libipt_policy.c and libip6t_policy.c init() functions where NFC bits are
>     still being set:
>
>          *nfcache |= NFC_UNKNOWN;
>
>     These (among similar others that have already been removed) crept in
>     subsequent to Pablo Neira's NFC-killer patches that I mentioned in original
>     post.
>
> 2+2  occurrences in the libip4tc.c and libip4tc.c  is_same()  comparisons:
>
>          if (a->nfcache != b->nfcache
>              ...) return NULL;
>
>     These are the occurrences causing problems. As mentioned, this prevents
>     iptables from being able to delete-by-match any rules created by old
>     userspace tools that still set nfcache bits in entries -- the entries are
>     not considered "same" because (only) the nfcache bits differ (modulo the
>     match mask of course).
>
> -----
> =134 Total
>
>
> Please let me know if I can do anything more regarding this.


Basically all of them can go except those in include/linux/*.h files.
