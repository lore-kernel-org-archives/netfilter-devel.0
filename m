From: Max Kellermann <max@duempel.org>
Subject: Re: is this make sense: iptables -A PREROUTING -t nat -j SNAT --to
	0.0.0.0
Date: Tue, 22 Mar 2005 15:55:22 +0100
Message-ID: <20050322145522.GA12927@roonstrasse.net>
References: <42403008.9070006@cardvn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Nguyen Dinh Nam <64vn@cardvn.net>
Content-Disposition: inline
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

On 2005/03/22 15:47, Nguyen Dinh Nam <64vn@cardvn.net> wrote:
> But I think that this approach is more interesting
> iptables -A PREROUTING -t nat -j SNAT --to 0.0.0.0
> 
> The rule clears the source IP address from the packet, later, routing 
> code will bind an ip address to the packet based on routing decision. In 
> the case where the host has several internet providers, the traditional 
> method needs several rules, as well as using CONNMARK to bind each TCP 
> connection to only one internet provider. If this new approach is 
> possible, it'll simplify the problem tremendously

Why don't you just use -j MASQUERADE if writing one rule per interface
is too much work for you?

I don't understand how CONNMARK helps with your "traditional method".

Max
