From: Patrick McHardy <kaber@trash.net>
Subject: Re: Changing source/destination address for local packets
Date: Mon, 25 Jun 2007 18:09:05 +0200
Message-ID: <467FE8A1.6030905@trash.net>
References: <200706251758.00586.tomas.mandys@2p.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Tomas Mandys <tomas.mandys@2p.cz>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706251758.00586.tomas.mandys@2p.cz>
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

Tomas Mandys wrote:
> Hi,
> I playing in my RTPPROXY module (finally almost ready) with change of source 
> and destination addresses. It works but there is problem when is changed 
> address for locally generated packets to another local address.
> 
> 
> IP: 192.168.1.1
> UDP packet:  192.168.1.1:10000  -->  192.168.1.1:50000
> OUTPUT hook changes destination address (like DNAT) resp. dest port only: 
> 50000 --> 20000
> POSTROUTING changes source port (like SNAT): 10000 --> 60000
> now PREROUTING is called but conntrack (ip_conntrack_get) is related to 
> session 192.168.1.1:10000  -->  192.168.1.1:50000 
> (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip/udp.port) instead
> address from (*pskb)->nh.iph->daddr (192.168.1.1:60000), pudph->dest 
> (192.168.1.1:20000).


You need to change the conntrack tuples as well if you mangle
a packet in case you're not using the standard NAT functions
for this (which you probably should). If you change the destination
address to a local one you additionally need to perform rerouting
(you *should* do that whenever you change the destination in OUTPUT,
but for this case it really is necessary).
