From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: libipq/payload doubt
Date: Thu, 20 May 2004 16:58:38 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405201637500.7143-100000@filer.marasystems.com>
References: <20040520021119.GA2959@maluco.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ulysses Almeida <munky@maluco.com.br>
In-Reply-To: <20040520021119.GA2959@maluco.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 19 May 2004, Ulysses Almeida wrote:

  Realy sorry, for this stupid question.. i just find iphdr->protocol
> that answers my first question. I don't have a clear idea about
> payload yet, but I'm walking on this direction.

What you get is an IP packet. The rules on how to parse an IP packet is 
pretty well defined in the IP standards

  IP:   Internet STD 5 / RFC 791
  UDP:  Internet STD 6 / RFC 768
  TCP:  Internet STD 7 / RFC 793
  ICMP: Internet STD 5 / RFC 792

To find the TCP header you have to first find the IP header length. This 
is iphdr->ihl

>From there you can then find the TCP payload by calculating the TCP header 
length. This is tcphd->doff

both ihl and doff indicate the size counted in 32-bit values.. (1 = 4 
bytes, 2 = 8 bytes etc...)

The linux headers has already gone thru the pain of defining correct bit
fields for the protocol fields in the packet data so I suggest you use
these. All you need to remember is to translate fields > 8 bits to/from
network byte order using nthos/htons (16 bits) or ntohl/htonl (32 bits) 
and pretty mych everything should fall into place.

Example:

  struct iphdr *iph = data;

  if (iph->protocol == IPPROTO_TCP) {
     struct tcphdr *tcph = (struct tcphdr *)((int32_t *)iph + iph->ihl);
     char *tcp_payload = (char *)((int32_t *)tcph + tcph->doff);

     ....

  }  
  

Regards
Henrik
