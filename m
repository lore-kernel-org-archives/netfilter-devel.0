From: Patrick McHardy <kaber@trash.net>
Subject: Re: LVS-NAT and source routing
Date: Sun, 10 Sep 2006 11:54:24 +0200
Message-ID: <4503E0D0.7090004@trash.net>
References: <20060829073751.GB23278@verge.net.au> <44F4039D.2060909@trash.net>
	<20060904033754.GA13845@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Ken Brownfield <krb@irridia.com>, Roberto Nibali <ratz@drugphish.ch>,
	netfilter-devel@lists.netfilter.org,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Julian Anastasov <ja@ssi.bg>, David Black <dave@jamsoft.com>,
	Joseph Mack NA3T <jmack@wm7d.net>, David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Horms <horms@verge.net.au>
In-Reply-To: <20060904033754.GA13845@verge.net.au>
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

Horms wrote:
> On Tue, Aug 29, 2006 at 11:06:37AM +0200, Patrick McHardy wrote:
> 
>>ip_route_me_harder is meant for the opposite case, rerouting locally
>>originating packets as if they were forwarded (if the source is
>>non-local). For your case just calling ip_route_output_key should be
>>faster since it saves the inet_addr_type call. I think nf_ip_reroute
>>doesn't help much since you always seem to change the source address,
>>but you could make the whole thing depend on CONFIG_IP_MULTIPLE_TABLES.
> 
> 
> I took a look into this. It seems that the real key is to avoid
> uneccesary calls to inet_addr_type(). But it seems that the rest
> of ip_route_me_harder() really is needed for ip_vs. If that isn't
> correct, please set me straight.
> 
> But if it is correct, it really does mean a fair ammount of duplicated
> code going into ip_vs_core.c. I wonder if a better option would be
> to allow the addr_type to be passed to ip_route_me_harder(). I have
> a patch below which expresses this idea. It has the nice advantage
> of offering the scope for other callers to supply the addr_type if it
> is known, though I am not sure that this can be the case.


Usually not, but your patch looks fine anyway. We might even be able
to remove the largely duplicated route_reverse() in ipt_REJECT if
we use LL_MAX_HEADER instead of LL_RESERVED_SPACE for the RST packet
(since we would need to route after allocating the packet and
reversing the addresses).
