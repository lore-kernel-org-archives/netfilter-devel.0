From: Daniel <daniel@dev-zone.org>
Subject: Re: MAC address matching. Or other ideas.
Date: Mon, 12 May 2003 10:44:54 +1200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EBED266.3050608@dev-zone.org>
References: <3EB5A38C.4090606@dev-zone.org> <20030510105942.GB28426@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030510105942.GB28426@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thanks for your reply, I thought that there may be some issues with 
matching dst MAC addresses. You are right though that a better solution 
would be to base it on the gateways IP address. I would be happy to 
implement it myself, but I don't have any experience with C let alone 
kernel programming, though it would be cool to have something I wrote in 
the kernel. It you guys added a method to allow people to write perl 
modules then I would certainly contribute :).
If someone wants to/ has the time the time to implement such a match 
module then kudos to them, otherwise I will just have to find a 
different solution.

Thanks again for your help.
Daniel


Patrick Schaaf wrote:
>>Is it possible to get the MAC match module to match on dst MAC address 
>>rather than just src MAC?
> 
> 
> Not without much much work. The destination MAC is not known, generally,
> while the packet traverses the network stack; only on output, after
> a potentially long time waiting for an ARP reply, will a destination
> MAC be available for checking.
> 
> You could, maybe, be lucky to have it in the POSTROUTING table. But I
> doubt that.
> 
> 
>>So I want to be able to say only gimme traffic that is coming in and
>>out via gateway X, the only way I can figure to do that is by matching
>>the MAC address of the gateway,
> 
> 
> Why not the IP address of the gateway? That is known after routing,
> i.e. in both the INPUT and FORWARD chains, and a 'route' match
> is trivial to write, as far as I know. There is already a nice
> ROUTE target in patch-o-matic, such a route-match could A) be
> patterned after the target (take the same options), and it
> could B) look at the exact same structure (skb->dst) that the
> ROUTE target sets up. Nice mirror work.
> 
> If that's a solution for you, and you set out to implement it,
> just mail me if you have detail questions.
> 
> best regards
>   Patrick
