From: Nguyen Dinh Nam <64vn@cardvn.net>
Subject: Re: is this make sense: iptables -A PREROUTING -t nat -j SNAT --to
 0.0.0.0
Date: Wed, 23 Mar 2005 01:56:26 +0700
Message-ID: <42406A5A.10003@cardvn.net>
References: <42403008.9070006@cardvn.net>
	<20050322145522.GA12927@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050322145522.GA12927@roonstrasse.net>
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

I use each -j SNAT for an interface because -j MASQUERADE doesn't work 
well with multipath routes, and SNAT has better performance than MASQ.

CONNMARK helps keeping packets of the same connection routed via a given 
nexthop which is selected by the multipath route for the first (--state 
NEW) packet, I wrote about it here:
http://selab.edu.ms/twiki/bin/view/Networking/MultihomedLinuxNetworking
it's a vital part of a multihomed internet gateway. With SNAT/MASQ 
available in PREROUTING, CONNMARK is no long required, hence save a lot 
of works and increase the performance.

Max Kellermann wrote:

> Why don't you just use -j MASQUERADE if writing one rule per interface
> is too much work for you?
>
> I don't understand how CONNMARK helps with your "traditional method".
>
> Max
>
