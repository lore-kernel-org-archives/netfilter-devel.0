From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6] NETFILTER: tcp window tracking
Date: Sun, 25 Jul 2004 11:02:14 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040725110214.057d3919.davem@redhat.com>
References: <20040724153427.GV2848@obroa-skai.de.gnumonks.org>
	<20040724232239.29bd3ee3.davem@redhat.com>
	<20040725131249.GA10342@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040725131249.GA10342@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 25 Jul 2004 09:12:49 -0400
Harald Welte <laforge@netfilter.org> wrote:

> Now let's see how many people complain about some breakage before
> 2.6.9 gets released.

I'll be the first, it doesn't even build :-)
Missing some linux/sysctl.h changes perhaps in the
window tracking diff?

net/ipv4/netfilter/ip_conntrack_standalone.c:644: error: `NET_IPV4_NF_CONNTRACK_LOG_INVALID' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_standalone.c:655: error: `NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_MAX_RETRANS' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_standalone.c:663: error: `NET_IPV4_NF_CONNTRACK_TCP_LOOSE' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_standalone.c:671: error: `NET_IPV4_NF_CONNTRACK_TCP_BE_LIBERAL' undeclared here (not in a function)
net/ipv4/netfilter/ip_conntrack_standalone.c:679: error: `NET_IPV4_NF_CONNTRACK_TCP_MAX_RETRANS' undeclared here (not in a function)

Just send me the necessary sysctl.h diff so I can fix this up.
Thanks.
