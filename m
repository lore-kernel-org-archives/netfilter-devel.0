From: "David S. Miller" <davem@redhat.com>
Subject: Re: [PATCH 2.6] new iptables modules (iprange, CLASSIFY, SAME,
 NETMAP)
Date: Sun, 24 Aug 2003 17:21:13 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824172113.3e41f94f.davem@redhat.com>
References: <20030824143828.GE10987@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030824143828.GE10987@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 24 Aug 2003 16:38:28 +0200
Harald Welte <laforge@netfilter.org> wrote:

> The following patch against 2.6.0-test4 adds four more iptables modules.
> They are adding the following functionality
> - iprange: matching against an arbitrary contiguous range of ip addresses
> - CLASSIFY: setting skb->priority from iptables (so you can skip tc filter)
> - NETMAP: SNAT a whole network 1:1 to another network
> - SAME: tries to keep the assigned ip per client the same within an SNAT
>   pool

Applied, thanks.
