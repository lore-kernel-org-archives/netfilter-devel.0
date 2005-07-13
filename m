From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 1/*] nfnetlink updates
Date: Wed, 13 Jul 2005 09:04:14 +0100
Message-ID: <42D4CAFE.90802@ufomechanic.net>
References: <42D42975.8070303@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42D42975.8070303@eurodev.net>
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
> Hi,
> 
> This patch introduces the following changes to nfnetlink:
> 
> a) nfnetlink groups: Up to 32 maximum.
> 
> +#define NF_NETLINK_CONNTRACK_NEW       0x1
> +#define NF_NETLINK_CONNTRACK_UPDATE    0x2
> +#define NF_NETLINK_CONNTRACK_DESTROY   0x4
> +#define NF_NETLINK_CONNTRACK_EXPECT    0x8
> 
> I think that those four groups are enough to group events.

Currently there are about 3 netlink packets sent when a connection comes
up and three when it goes down.

I wonder if it is worth being able to filter on the ctstate as well,
under heavy load it is quite a benefit to reduce the netlink throughput
by 3 times. An application might be interested in ESTABLISHED and CLOSE
or TIMEOUT states.

These are subsets of CONNTRACK_UPDATE

I don't feel _very_ strongly about this, but I do think it is worth
mentioning.

Amin
