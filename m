From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: ACC and port numers
Date: Wed, 26 Nov 2003 11:46:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FC4847F.9070809@balabit.hu>
References: <3FC46FA4.6060503@kenjitsu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: s.bogatyrev@kenjitsu.net
In-Reply-To: <3FC46FA4.6060503@kenjitsu.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

Stanisalv V. Bogatyrev wrote:
>     I added some code, but I get broken port nubers on incoming traffic. 
> I'm new in netfilter/iptables programming and can't find a mistake. Help 
> me please, what do I need to correct to make it work?


> 	  case IPPROTO_TCP: 
> 	    tcp_hdr = (*pskb)->h.th;
> 	    //We don't do ntohs() here. In userspace we trust. So Don't forget to modify ipacc.c
> 	
> 	    sport=tcp_hdr->source;
> 	    dport=tcp_hdr->dest;	    

   The problem lies here: for incoming packets, skb->h.th is not yet set. 
You should try it this way:

struct iphdr *iph = (*pskb)->nh.iph;
struct tcphdr *tcp_hdr = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);

   Of course the code for UDP, ICMP, etc. should also be upgraded (for TCP 
and UDP the ports are at the same location). I didn't check, but you 
should also take care of byte order problems.

-- 
   Regards,
     Krisztian KOVACS
