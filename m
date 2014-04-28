From: Vasily Averin <vvs@parallels.com>
Subject: Re: [PATCH 1/1] superfluous skb->nfct check in
	br_nf_dev_queue_xmit
Date: Mon, 28 Apr 2014 18:25:22 +0400
Message-ID: <535E64D2.7080700@parallels.com>
References: <534FB7D2.3020705@parallels.com> <53535C35.7070108@parallels.com>
	<20140424163243.GN31953@breakpoint.cc>
	<535E4B74.4050107@parallels.com>
	<20140428131646.GP31953@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: bridge@lists.linux-foundation.org, Patrick McHardy <kaber@trash.net>,
	Stephen Hemminger <stephen@networkplumber.org>,
	netfilter-devel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <bridge-bounces@lists.linux-foundation.org>
In-Reply-To: <20140428131646.GP31953@breakpoint.cc>
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

>> Therefore I believe that my patch is still correct, however now I think we also need 
>> to remove #if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV4) in br_nf_dev_queue_xmit().
> 
> I don't think so, DEFRAG_IPV4 is dependency glue, so it shouldn't be
> possible to build kernel with CONNTRACK_IPV4=n and DEFRAG_IPV4=(m|y).

Could you please explain, why this #ifdef is required?

I'm going to remove this #ifdef because it was added together with nfct check.

Also I believe you are wrong with dependencies:
NF_CONNTRACK_IPV4 forces NF_DEFRAG_IPV4, not vice versa

net/ipv4/netfilter/Kconfig
config NF_DEFRAG_IPV4
        tristate
        default n

config NF_CONNTRACK_IPV4
        tristate "IPv4 connection tracking support (required for NAT)"
        depends on NF_CONNTRACK
        default m if NETFILTER_ADVANCED=n
        select NF_DEFRAG_IPV4
