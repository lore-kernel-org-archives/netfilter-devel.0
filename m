From: Patrick McHardy <kaber@trash.net>
Subject: Re: [iptables 1.3.0 / libiptc patch] sort chains by hooknum/names
Date: Sat, 05 Mar 2005 00:04:02 +0100
Message-ID: <4228E962.8090005@trash.net>
References: <20050304212114.130e2a7c@coruscant>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Olaf Rempel <razzor@kopf-tisch.de>
In-Reply-To: <20050304212114.130e2a7c@coruscant>
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

Olaf Rempel wrote:
> OK, why two patches? 
> The first one need some preconditions: 
> *all* buildin chains need to be "in order" and in front of *any* user chain 
> when parsing the kernel-list.
> 
> I was not sure about this, so I made a second patch, that does not need these
> preconditions. 

I assume with "in order", you mean it relies on the current numbering of
the hooks:

/* After promisc drops, checksum checks. */
#define NF_IP_PRE_ROUTING       0
/* If the packet is destined for this box. */
#define NF_IP_LOCAL_IN          1
/* If the packet is destined for another interface. */
#define NF_IP_FORWARD           2
/* Packets coming from a local process. */
#define NF_IP_LOCAL_OUT         3
/* Packets about to hit the wire. */
#define NF_IP_POST_ROUTING      4

This seems fine to me. I'm going to apply your first patch, thanks.

Regards
Patrick
