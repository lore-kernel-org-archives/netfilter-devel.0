From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack tree
Date: Wed, 16 Mar 2005 15:31:07 +0100
Message-ID: <4238432B.5030004@trash.net>
References: <42377F54.8070408@trash.net>
	<200503160648.j2G6mXVT014699@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200503160648.j2G6mXVT014699@toshiba.co.jp>
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
>>In my opinion the most important issue at this time is making
>>ip_conntrack matches and targets work properly with nf_conntrack and
>>adding their IPv6 equivalents. Before doing the IPv6 part, I would like
>>to get sorted out if we can share the IPv4 matches/targets between
>>ip_conntrack and nf_conntrack.
> 
> 
> There are issues to do this.
> 	1. conflicting symbols when including ip_conntrack.h and nf_conntrack.
> 	   -> easy work. We can change symbols in nf_conntrack_*.h.

Yes. We could also move users of the ip_conntrack.h symbols over to the
nf_conntrack.h symbols. This would allow to kill a lot of them.

> 	2. I would not like to change UI. If ip_conntrack isn't loaded when
> 	   these matches/targets are loaded, I want kernel to load ip_conntrack
> 	   automatically. I suggests changes in init() as following.
> 
> 		int ret = -1;	   
> 
> 		if (get_symbols(need_ip_conntrack) != NULL) {
> 			ret = ip_register_match(match_func_with_ip_conntrack);
> 
> 		} else if (get_symbols(need_nf_conntrack) != NULL) {
> 			ret = ip_register_match(match_func_with_nf_conntrack);
> 		} else
> 			return -1;
> 
> 		return ret;
> 
> 	  I don't know this usage of get_symbols() is right or not.
> 	  If right, ip_conntrack will be loaded automatically in the case that
> 	  ip_conntrack and nf_conntrack are not loaded.
> 	  If either of them is loaded, it will be used.

Not sure if it works, but that would be a possibility.

> 	3. The symbol "ip_conntrack_untracked" which depends on ip_conntrack.
> 	   state, conntrack, NOTRACK use this symbol. How about defining
> 	   "void *nf_ct_untracked" in net/core/netfilter.c and
> 	   set &ip_conntrack_untracked.general/&nf_conntrack_untracked.general
> 	   to it when initializing ip_conntrack/nf_conntrack ?

I was thinking about creating a struct nf_conntrack_common that is
used in both struct ip_conntrack and nf_conntrack for things like
mark, flags, ... We could then simply use a status flag for untracked.
It would also help connmark/CONNMARK and a couple of others, the
main problem are the tuples (needed by ipt_conntrack), the ip_conntrack
tuples don't match the nf_conntrack tuples.

Regards
Patrick
