From: Tomas Mandys <tomas.mandys@2p.cz>
Subject: Changing source/destination address for local packets
Date: Mon, 25 Jun 2007 17:58:00 +0200
Message-ID: <200706251758.00586.tomas.mandys@2p.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi,
I playing in my RTPPROXY module (finally almost ready) with change of source 
and destination addresses. It works but there is problem when is changed 
address for locally generated packets to another local address.


IP: 192.168.1.1
UDP packet:  192.168.1.1:10000  -->  192.168.1.1:50000
OUTPUT hook changes destination address (like DNAT) resp. dest port only: 
50000 --> 20000
POSTROUTING changes source port (like SNAT): 10000 --> 60000
now PREROUTING is called but conntrack (ip_conntrack_get) is related to 
session 192.168.1.1:10000  -->  192.168.1.1:50000 
(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip/udp.port) instead
address from (*pskb)->nh.iph->daddr (192.168.1.1:60000), pudph->dest 
(192.168.1.1:20000).

I think it's caused that (*pskb)->nfct is left unchanged.

I tried to refresh conntrack in PREROUTING but unsucessfully:

if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip != 
(*pskb)->nh.iph->daddr ||
          ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.udp.port) != 
ntohs(pudph->dest)) {

1) if (ip_conntrack_in(hooknum, pskb, in, out, NULL) == NF_DROP) {
          return NF_DROP;
    }
    ct = ip_conntrack_get(*pskb, &ctinfo);
   ip_conntrack_in  ... symbol not known

2) nf_conntrack_put((*pskb)->nfct);  /* causes kernel crash */
    nf_ct_untrack(*pskb);
 kernel crashes

3) maybe PREROUTING hook with higher priority than has ip_conntrack_in() 
callback
and reset (*pskb)->nfct.
not checked
}

Note I actually I do not need such RTPPROXY (local<->local) scenario but I 
think such behaviour is not correct.

Note also seems that locally generated UDP packets have bad UDPH checksum (udp 
data not checksumed and seems like not 0xFFFFed or so).

I'm sorry if this issues have been discussed or even fixed, I had no time to 
follow changes.

Kernel: 2.6.17.8

Thanks
Tomas

http://www.2p.cz
