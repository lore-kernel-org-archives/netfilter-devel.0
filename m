From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Re: 2.6.11-rc2 TCP ignores PMTU ICMP (Re: Linux 2.6.11-rc2)
Date: Fri, 28 Jan 2005 02:18:27 +0100
Message-ID: <41F992E3.20005@trash.net>
References: <20050127154118.45e59991.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030900070405080601090209"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050127154118.45e59991.davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------030900070405080601090209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David S. Miller wrote:

>Hey guys, please try to take a look at this one.
>
>There are multiple confirmations that merely having ipt_MASQUERADE
>loaded or built into the kernel causes PMTU ICMP messages to be
>ignored in the current kernel.
>
>I suspect this is more fallout from Rusty's recent conntrack/nat
>stuff.  Maybe it'll result in some more nfsim testcases being
>added, so perhaps not such a bad thing afterall :-)
>
You were right, NAT messes up the inner packet pretty badly :)

IP (tos 0xd0, ttl  64, id 40755, offset 0, flags [none], length: 88) 
172.16.1.123 > 172.16.1.123: icmp 68: type-#142 for IP (tos 0x10, ttl 
180, id 13605, offset 0, flags [DF], length: 60, bad cksum e8b3 
(->73d8)!) 172.16.1.123 > 172.16.195.55:  ip-proto-225 40

This patch fixes it.

Signed-off-by: Patrick McHardy <kaber@trash.net>


--------------030900070405080601090209
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/ipv4/netfilter/ip_nat_proto_tcp.c 1.10 vs edited =====
--- 1.10/net/ipv4/netfilter/ip_nat_proto_tcp.c	2005-01-17 23:00:55 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_proto_tcp.c	2005-01-28 02:13:06 +01:00
@@ -105,7 +105,7 @@
 		return 0;
 
 	iph = (struct iphdr *)((*pskb)->data + iphdroff);
-	hdr = (struct tcphdr *)((*pskb)->data + iph->ihl*4);
+	hdr = (struct tcphdr *)((*pskb)->data + hdroff);
 
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		/* Get rid of src ip and src pt */


--------------030900070405080601090209--
