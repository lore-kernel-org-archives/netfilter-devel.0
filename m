From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Tue, 28 Jun 2005 04:15:59 +0200
Message-ID: <42C0B2DF.8060907@eurodev.net>
References: <42C03F2E.30706@eurodev.net> <42C07046.10101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42C07046.10101@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
> I haven't looked at the patch for a long time, and it removes
> and adds the whole file, so not sure if it is new ..

Yes, that's new. Ick, it seems I didn't express fine myself. Together 
with the big and confusing patch I uploaded a splitted version that 
makes easier the review as well:

http://people.netfilter.org/~pablo/ctnetlink-2.6.12/2.6.11-vs-2.6.12/

> +		/* This is tricky but it works. ip_nat_setup_info needs the
> +		 * hook number as parameter, so let's do the correct
> +		 * conversion and run away */
> +		if (*status & IPS_SRC_NAT_DONE)
> +			hooknum = NF_IP_POST_ROUTING; /* IP_NAT_MANIP_SRC */
> +		else if (*status & IPS_DST_NAT_DONE)
> +			hooknum = NF_IP_PRE_ROUTING;  /* IP_NAT_MANIP_DST */
> +		else
> +			return -EINVAL; /* Missing NAT flags */
> 
> This doesn't work reliably, locally generated packets never enter
> PRE_ROUTING but can be DNATed. I think the hook should be supplied
> by the user.

The macro HOOK2MANIP used is ip_nat_setup_info returns the same value 
(maniptype) for NF_IP_PRE_ROUTING and NF_IP_LOCAL_IN, so the same 
manipulation (DNAT) will be applied to such conntrack. Since we works 
with conntracks, I don't mind where the packets came from, just want to 
apply the NAT handling that the user has requested.

--
Pablo
