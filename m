From: Patrick McHardy <kaber@trash.net>
Subject: Re: LVS-NAT and source routing
Date: Tue, 29 Aug 2006 14:52:45 +0200
Message-ID: <44F4389D.6040601@trash.net>
References: <20060829073751.GB23278@verge.net.au>	<44F4039D.2060909@trash.net>
	<20060829.023138.120676636.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: krb@irridia.com, ratz@drugphish.ch, netfilter-devel@lists.netfilter.org,
	dave@jamsoft.com, ja@ssi.bg, horms@verge.net.au, jmack@wm7d.net,
	fsarwari@exchangesolutions.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20060829.023138.120676636.davem@davemloft.net>
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

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Tue, 29 Aug 2006 11:06:37 +0200
> 
> 
>>but you could make the whole thing depend on CONFIG_IP_MULTIPLE_TABLES.
> 
> 
> IPSEC can make the saddr changes matter too.  BTW it shows a technical
> issue with nf_ip_reroute(), since it only checks for changes to
> saddr/daddr/tos when even things like port changes can make IPSEC
> generate a different route.


Right. It also ignores nfmark changes, which is not valid anymore since
nfnetlink_queue allows to change these. I'm going to fix it up and send
the patch with my next batch of netfilter patches.
