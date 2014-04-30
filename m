From: Vasily Averin <vvs@parallels.com>
Subject: Re: [PATCH 1/1] superfluous skb->nfct check in
	br_nf_dev_queue_xmit
Date: Wed, 30 Apr 2014 13:06:08 +0400
Message-ID: <5360BD00.6050906@parallels.com>
References: <534FB7D2.3020705@parallels.com> <53535C35.7070108@parallels.com>
	<20140424163243.GN31953@breakpoint.cc>
	<535E4B74.4050107@parallels.com>
	<20140428131646.GP31953@breakpoint.cc>
	<535E64D2.7080700@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: bridge@lists.linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	Stephen Hemminger <stephen@networkplumber.org>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <bridge-bounces@lists.linux-foundation.org>
In-Reply-To: <535E64D2.7080700@parallels.com>
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

On 04/28/2014 06:25 PM, Vasily Averin wrote:
>>> Therefore I believe that my patch is still correct, however now I think we also need 
>>> to remove #if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV4) in br_nf_dev_queue_xmit().
>>
>> I don't think so, DEFRAG_IPV4 is dependency glue, so it shouldn't be
>> possible to build kernel with CONNTRACK_IPV4=n and DEFRAG_IPV4=(m|y).
> 
> Also I believe you are wrong with dependencies:
> NF_CONNTRACK_IPV4 forces NF_DEFRAG_IPV4, not vice versa

If you do not want to remove this #ifdef at all
how do you like an idea to replace NF_CONNTRACK_IPV4 to NF_DEFRAG_IPV4?
