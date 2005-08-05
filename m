From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Remove ip_conntrack <-> nfnetlink dependency
Date: Fri, 05 Aug 2005 12:26:47 +0200
Message-ID: <42F33EE7.4060405@trash.net>
References: <42F2B521.2050408@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42F2B521.2050408@eurodev.net>
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

Pablo Neira wrote:
> @Patrick: This patch is related to one of the patches that you submitted
> some time ago.
> 
> Currently there's a dependency between nfnetlink and ip_conntrack. If
> the second if loaded, the first will be too because needs ip_conntrack
> needs the symbol __nfa_fill.
> 
> The following patch resolves such dependency by inlining __nfa_fill, I
> don't know if this solution is the best though since this could increase
> the size of the ip_conntrack_netlink binary. Anyway we could leave it
> that way until the generic netlink layer comes (I mean RTA_* and NFA_*
> unification).

I don't care much, either way is fine with me.

> BTW, just an observation, maybe those CONFIG_IP_NF_CONNTRACK_NETLINK in
> ip_conntrack_core.c should be CONFIG_NETFILTER_NETLINK instead since the
> dependency is __nfa_fill.

ctnetlink depends on nfnetlink, so I guess it doesn't matter.
