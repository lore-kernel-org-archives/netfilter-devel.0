From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack tree
Date: Wed, 16 Mar 2005 15:48:33 +0900 (JST)
Message-ID: <200503160648.j2G6mXVT014699@toshiba.co.jp>
References: <42377F54.8070408@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
In-Reply-To: <42377F54.8070408@trash.net>
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


Hi, Patrick,

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 16 Mar 2005 01:35:32 +0100

> I'm working on getting nf_conntrack ready for submission. To make it
> easier for people to participate, I've exported my tree through
> bitkeeper and as plain patch. It currently contains nf_conntrack as
> found in pomng plus a couple of ported ip_conntrack fixes:
> 
> bk://numenor.coreworks.de/nf-2.6-nfct
> http://numenor.coreworks.de/~kaber
> 
> The tree and the diff will be kept up-to-date when changes are made.

Thanks. I'll look that.

> In my opinion the most important issue at this time is making
> ip_conntrack matches and targets work properly with nf_conntrack and
> adding their IPv6 equivalents. Before doing the IPv6 part, I would like
> to get sorted out if we can share the IPv4 matches/targets between
> ip_conntrack and nf_conntrack.

There are issues to do this.
	1. conflicting symbols when including ip_conntrack.h and nf_conntrack.
	   -> easy work. We can change symbols in nf_conntrack_*.h.

	2. I would not like to change UI. If ip_conntrack isn't loaded when
	   these matches/targets are loaded, I want kernel to load ip_conntrack
	   automatically. I suggests changes in init() as following.

		int ret = -1;	   

		if (get_symbols(need_ip_conntrack) != NULL) {
			ret = ip_register_match(match_func_with_ip_conntrack);

		} else if (get_symbols(need_nf_conntrack) != NULL) {
			ret = ip_register_match(match_func_with_nf_conntrack);
		} else
			return -1;

		return ret;

	  I don't know this usage of get_symbols() is right or not.
	  If right, ip_conntrack will be loaded automatically in the case that
	  ip_conntrack and nf_conntrack are not loaded.
	  If either of them is loaded, it will be used.

	3. The symbol "ip_conntrack_untracked" which depends on ip_conntrack.
	   state, conntrack, NOTRACK use this symbol. How about defining
	   "void *nf_ct_untracked" in net/core/netfilter.c and
	   set &ip_conntrack_untracked.general/&nf_conntrack_untracked.general
	   to it when initializing ip_conntrack/nf_conntrack ?

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
