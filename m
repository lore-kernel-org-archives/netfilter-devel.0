From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Wed, 29 Jun 2005 21:14:07 +0200
Message-ID: <42C2F2FF.1060408@eurodev.net>
References: <42C03F2E.30706@eurodev.net> <20050628234425.GA23662@wsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Josh Samuelson <josamue1@wsc.edu>
In-Reply-To: <20050628234425.GA23662@wsc.edu>
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

Hi Josh,

Josh Samuelson wrote:
> On Mon, Jun 27, 2005 at 08:02:22PM +0200, Pablo Neira wrote:
> 
>>o conntrack event API
> 
> 
>>- IPCT_DELIVERED bit. Loopback reports event are reported twice, this 
>>bit is set once event are delivered. I just came up with a better idea, 
>>reset nfcache once the events have been delivered, but I'll apply this 
>>change in the next patchset.
> 
> I noticed this with my flow module, any interface connecting to itself
> would create two IPCT_NEW events.  I had made my own patch to your
> linux-2.6.11.conntrack-event-api.patch to call
> ip_conntrack_event_cache_init() after the events were delivered.

Indeed, this is what I planned to fix this problem ;). Just killed the 
IPCT_DELIVERED bit, it will be included in next version of the 
ctevent-api. I'll post it soon.

> I was gonna send it your way but other things came up and there
> were other problems that I was trying to figure out that were not
> quite working the way I thought they should.  I investigated
> further and think I've found the problem, but I'm not sure
> how to move further on it, so now it's time to ask the list:
> 
> Can anyone explain why in ip_conntrack_proto_icmp.c
> we delete the conntrack of an ICMP packet as soon as all replies
> are seen instead of letting ip_conntrack_icmp_timeout take the
> conntrack like other protocol types?  As far as I can see, this
> breaks the conntrack event API because I get the following
> sequence of notifications for an ICMP echo request to the host
> (this is with the ip_conntrack_event_cache_init() patch after
> notifications have been delivered so I don't get two IPCT_NEW events):
> 
> IPCT_NEW
> IPCT_DESTROY
> IPCT_STATUS
> 
> I think nfct->use is still held and the conntrack is never really
> destroyed after death_by_timeout(), so later when the reply comes
> the conntrack still exists in the hash and the conntrack API
> fires a IPCT_STATUS event after the IPCT_DESTROY event was fired,
> which I'm assuming is an invalid sequence of events. ;)

OK, I moved the IPCT_DESTROY event to destroy_conntrack instead of 
death_by_timeout, this must fix the problem of out of sequence events.

> So, what would be the harm in the following patch to
> ip_conntrack_proto_icmp.c?
> 
> diff -u a/ip_conntrack_proto_icmp.c b/ip_conntrack_proto_icmp.c
> --- a/ip_conntrack_proto_icmp.c 2005-06-28 16:52:18.000000000 -0500
> +++ b/ip_conntrack_proto_icmp.c 2005-06-28 16:52:46.000000000 -0500
> @@ -92,15 +92,7 @@
>                        const struct sk_buff *skb,
>                        enum ip_conntrack_info ctinfo)
>  {
> -       /* Try to delete connection immediately after all replies:
> -           won't actually vanish as we still have skb, and del_timer
> -           means this will only run once even if count hits zero twice
> -           (theoretically possible with SMP) */
> -       if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
> -               if (atomic_dec_and_test(&ct->proto.icmp.count)
> -                   && del_timer(&ct->timeout))
> -                       ct->timeout.function((unsigned long)ct);
> -       } else {
> +       if (CTINFO2DIR(ctinfo) != IP_CT_DIR_REPLY) {
>                 atomic_inc(&ct->proto.icmp.count);
>                 ip_ct_refresh_acct(ct, ctinfo, skb, ip_ct_icmp_timeout);
>         }

I don't want to change the current icmp tracking logic, the connection 
tracking table could get full sooner because of icmp entries that has 
already seen their reply wanting to timeout.

--
Pablo
