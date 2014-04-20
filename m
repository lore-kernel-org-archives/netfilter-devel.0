From: Vasily Averin <vvs@parallels.com>
Subject: Re: [PATCH 1/1] superfluous skb->nfct check in
	br_nf_dev_queue_xmit
Date: Sun, 20 Apr 2014 09:33:41 +0400
Message-ID: <53535C35.7070108@parallels.com>
References: <534FB7D2.3020705@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Vasily Averin <vvs@parallels.com>, Patrick McHardy <kaber@trash.net>
Return-path: <bridge-bounces@lists.linux-foundation.org>
In-Reply-To: <534FB7D2.3020705@parallels.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/bridge/>
List-Post: <mailto:bridge@lists.linux-foundation.org>
List-Help: <mailto:bridge-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=subscribe>
Sender: bridge-bounces@lists.linux-foundation.org
Errors-To: bridge-bounces@lists.linux-foundation.org
List-Id: netfilter-devel.vger.kernel.org

Please do not apply my patch, probably it breaks processing of VLAN packets.

Dear Patrick,
could you please explain why fragmentation of packets requires enabled
connection tracking?

During old patch discussion you told "everything related to fragmenting
is only needed with NF_CONNTRACK". However before adding (skb->nfct) check
bridge worked well with fragments, and I cannot understand what exactly in 
ip_fragment should not work with disabled connection trackng.

>From my point of view its better to drop packets in ip_fragment(), 
where failcounters accounts these events instead silent dropping
in br_dev_queu_push_xmit().

So could you please explain, why we need to have skb->nfct check
in br_nf_dev_queue_xmit()?

Thank you,
	Vasily Averin

On 04/17/2014 03:15 PM, Vasily Averin wrote:
> skb->nfct check in br_nf_dev_queue_xmit() does not work if conntracks
> are not loaded on the node. This check does not allow to fragment skb
> combined from incoming fragments, as results this skb will be dropped
> silently in br_dev_queue_push_xmit()
> 
> This check was added in commit c197facc8ea08062f8f949aade6a33649ee06771
> netfilter: bridge: allow fragmentation of VLAN packets traversing a bridge
> 
> I believe this check is superfluous and should be removed.
> 
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
>  net/bridge/br_netfilter.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index 80e1b0f..6a8407c 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -864,7 +864,7 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
>  {
>  	int ret;
>  
> -	if (skb->nfct != NULL && skb->protocol == htons(ETH_P_IP) &&
> +	if (skb->protocol == htons(ETH_P_IP) &&
>  	    skb->len + nf_bridge_mtu_reduction(skb) > skb->dev->mtu &&
>  	    !skb_is_gso(skb)) {
>  		if (br_parse_ip_options(skb))
> 
