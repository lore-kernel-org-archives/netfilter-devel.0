From: Patrick McHardy <kaber@trash.net>
Subject: Re: Resolving inner ICMP connections
Date: Sun, 04 Dec 2005 17:18:51 +0100
Message-ID: <439316EB.2030401@trash.net>
References: <438F501A.5060804@cs.princeton.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Mark Huang <mlhuang@CS.Princeton.EDU>
In-Reply-To: <438F501A.5060804@cs.princeton.edu>
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

Mark Huang wrote:
> Hi all,
> 
> Is it a bug that 
> net/ipv4/netfilter/ip_conntrack_proto_icmp.c:icmp_error_message()
> associates ICMP error message packets with the connection specified in 
> the inner IP packet, even if the direction of that connection makes no 
> sense?

That depends. What do you mean with "makes no sense"?

> I found a router in France that accidentally swaps the direction of the 
> inner IP packet, instead of preserving it verbatim inside the ICMP error 
> message. So, for instance, if you (A) traceroute it (B):

Maybe an old version of linux? :) NAT used to do stange things to
locally generated ICMP packets until about a year ago.

> IP: A -> B
>   UDP: a -> b
> 
> You get back an ICMP destination unreachable message that looks like:
> 
> IP: B -> A
>   ICMP: type 3, code 3
>     IP: B -> A
>     UDP: b -> a
> 
> Instead of:
> 
> IP: B -> A
>   ICMP: type 3, code 3
>     IP: A -> B
>     UDP: a -> b
> 
> Obviously there's something seriously wrong with this router. What 
> happens is that the ICMP error message gets associated with the original 
> side of the connection (as in IP_CT_DIR_ORIGINAL), not the reply side, 
> messing up a few assumptions I was making in my NF_IP_LOCAL_IN hook.

What are these assumptions?
