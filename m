From: Nguyen Dinh Nam <64vn@cardvn.net>
Subject: Re: is this make sense: iptables -A PREROUTING -t nat -j SNAT --to
 0.0.0.0
Date: Sat, 26 Mar 2005 00:28:42 +0700
Message-ID: <42444A4A.5090308@cardvn.net>
References: <42403008.9070006@cardvn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42403008.9070006@cardvn.net>
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

Senior netfilter developers, please tell me if SNAT in PREROUTING is 
worth the effort to implement. At least, tell me if it is fit with the 
linux networking architecture?

Nguyen Dinh Nam wrote:

> Currently, SNAT/MASQ is only allowed in POSTROUTING/nat so at the 
> internet gateway, everyone is doing something like this:
> iptables -A POSTROUTING -t nat -o $external_interface -j SNAT --to 
> $external_ip
>
> But I think that this approach is more interesting
> iptables -A PREROUTING -t nat -j SNAT --to 0.0.0.0
>
> The rule clears the source IP address from the packet, later, routing 
> code will bind an ip address to the packet based on routing decision. 
> In the case where the host has several internet providers, the 
> traditional method needs several rules, as well as using CONNMARK to 
> bind each TCP connection to only one internet provider. If this new 
> approach is possible, it'll simplify the problem tremendously
>
> I've never touched netfilter source code so I don't know if it's 
> possible, it may be just a stupid idea.
