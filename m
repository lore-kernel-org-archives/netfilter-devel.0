From: Tim Burress <tim@variosecure.net>
Subject: Re: Handling Port-Unreachable Response to UDP
Date: Tue, 29 Jul 2003 13:04:08 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F25F238.3000902@variosecure.net>
References: <3F252AAE.7000109@variosecure.net> <1059403723.12254.10.camel@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:

>mån 2003-07-28 klockan 15.52 skrev Tim Burress:
>
>  
>
>>We've been looking at a problem in which a client sends a UDP packet to 
>>a server on an unused port. This generates an ICMP port-unreachable 
>>packet (as usual), but we find that this same ICMP packet can then be 
>>replayed back to the client over and over. Apparently it gets through 
>>netfilter because our standard rules allow RELATED traffic.
>>    
>>
>
>Explain the context of "replayed back to the client over and over".
>
In a test of one of our systems, an engineer set up a scenario in which 
a client and server machine were connected via a firewall running 
iptables/netfilter. The client sends a UDP packet to an unused port on 
the server, and the server responds with ICMP port-unreachable. This 
packet is captured on the server side and then replayed back to the 
client machine, passing safely through the firewall until the conntrack 
associated with the original UDP "session" times out. Thus there are 
really two issues, (1) the fact that multiple ICMP error messages pass 
through in response to single "stimulus" packet, and (2) the fact that 
replayed packets are getting through at all. We need to investigate the 
second issue further, but the first one prompted some discussion. We 
seem to be in a gray area since (as far as we know) there are no 
standards governing how sessions consisting entirely of connectionless 
protocols should respond to ICMP error messages. It seemed like deleting 
the conntrack record for the UDP session might be worthwhile because it 
closes off the possibility of flooding the client with ICMP error 
messages, but it sounds like people are more concerned about the 
overhead of setting up and tearing down conntrack records if the client 
sends multiple UDP packets.

We're curious enough about this to benchmark it, though, so I was just 
wondering what the proper procedure is to destroy a conntrack record. I 
see several entrypoints in ip_conntrack_core.c that look promising, but 
it's hard to tell what calls what sometimes when function pointers are 
embedded in structures. Is it enough just to call destroy_conntrack() or 
do we need to call clean_from_lists() first? Or is there a better way? 
I'm not yet clear on how the data structures relate to each other.

Thanks for your replies!

Tim
