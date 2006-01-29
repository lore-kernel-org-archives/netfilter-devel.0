From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.16-rc1-mm3 XFRM+NAT issue
Date: Sun, 29 Jan 2006 23:59:24 +0100
Message-ID: <43DD48CC.9070709@trash.net>
References: <1138563710.26998.22.camel@leto.intern.saout.de>	
	<43DD1E3E.70503@trash.net>
	<1138568354.21229.1.camel@leto.intern.saout.de>	
	<43DD3E3D.5070201@trash.net>
	<1138573848.28464.1.camel@leto.intern.saout.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000705090201060609030308"
Cc: netfilter-devel@lists.netfilter.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christophe Saout <christophe@saout.de>
In-Reply-To: <1138573848.28464.1.camel@leto.intern.saout.de>
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
--------------000705090201060609030308
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Christophe Saout wrote:
> Am Sonntag, den 29.01.2006, 23:14 +0100 schrieb Patrick McHardy:
> 
> 
>>41 is IPPROTO_IPV6, you seem to be talking to the remote side using IPv6
>>over sit, which is why NAT on the TCP packet doesn't work.
> 
> 
> Ok, I'm stupid, forget this, IPv6 is a completely different issue. It's
> really IPv4 that isn't working.
> 
> This time with -4 on the command line:
> 
> Jan 29 23:27:38 server IN=eth0 OUT= MAC=00:01:80:5c:0f:48:00:02:8a:ba:b8:58:08:00 SRC=192.168.80.90 DST=<inet host> LEN=60 TOS=0x10 PREC=0x00 TTL=64 ID=38799 DF PROTO=TCP SPT=40255 DPT=25 WINDOW=5840 RES=0x00 CWR ECE SYN URGP=0 
> Jan 29 23:27:38 server IN=eth0 OUT=ppp0 SRC=192.168.80.90 DST=<inet host> LEN=60 TOS=0x10 PREC=0x00 TTL=63 ID=38799 DF PROTO=TCP SPT=40255 DPT=25 WINDOW=5840 RES=0x00 CWR ECE SYN URGP=0 
> Jan 29 23:27:38 server IN= OUT=ppp0 SRC=192.168.80.90 DST=<inet host> LEN=60 TOS=0x10 PREC=0x00 TTL=63 ID=38799 DF PROTO=TCP SPT=40255 DPT=25 WINDOW=5840 RES=0x00 CWR ECE SYN URGP=0 
> Jan 29 23:27:38 server IN= OUT=ppp0 SRC=<gateway pub ip> DST=<inet host> LEN=104 TOS=0x10 PREC=0x00 TTL=63 ID=38799 DF PROTO=ESP SPI=0x1249d895 
> Jan 29 23:27:38 server IN= OUT=ppp0 SRC=<gateway pub ip> DST=<inet host> LEN=104 TOS=0x10 PREC=0x00 TTL=63 ID=38799 DF PROTO=ESP SPI=0x1249d895 
> Jan 29 23:27:38 server IN=ppp0 OUT= MAC= SRC=<inet host> DST=<gateway pub ip> LEN=104 TOS=0x00 PREC=0x00 TTL=55 ID=0 DF PROTO=ESP SPI=0xbdbf1ca7 
> Jan 29 23:27:38 server IN=ppp0 OUT= MAC= SRC=<inet host> DST=<gateway pub ip> LEN=104 TOS=0x00 PREC=0x00 TTL=55 ID=0 DF PROTO=ESP SPI=0xbdbf1ca7 
> Jan 29 23:27:38 server IN=ppp0 OUT= MAC=45:00:00:68:00:00:40:00:37:06:56:bd:d5:ef:c5:f1:54:38:fc:8d:bd:bf SRC=<inet host> DST=<gateway pub ip> LEN=60 TOS=0x00 PREC=0x00 TTL=55 ID=0 DF PROTO=TCP SPT=25 DPT=40255 WINDOW=5792 RES=0x00 ECE ACK SYN URGP=0 
> Jan 29 23:27:38 server IN=ppp0 OUT= MAC=45:00:00:68:00:00:40:00:37:06:56:bd:d5:ef:c5:f1:54:38:fc:8d:bd:bf SRC=<inet host> DST=192.168.80.90 LEN=60 TOS=0x00 PREC=0x00 TTL=55 ID=0 DF PROTO=TCP SPT=25 DPT=40255 WINDOW=5792 RES=0x00 ECE ACK SYN URGP=0 
> Jan 29 23:27:38 server IN= OUT=ppp0 SRC=<gateway pub ip> DST=<inet host> LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=954 DF PROTO=TCP SPT=40255 DPT=25 WINDOW=0 RES=0x00 RST URGP=0 
> Jan 29 23:27:38 server IN= OUT=ppp0 SRC=<gateway pub ip> DST=<inet host> LEN=40 TOS=0x00 PREC=0x00 TTL=64 ID=954 DF PROTO=TCP SPT=40255 DPT=25 WINDOW=0 RES=0x00 RST URGP=0 
> Jan 29 23:27:38 server IN= OUT=ppp0 SRC=<gateway pub ip> DST=<inet host> LEN=88 TOS=0x00 PREC=0x00 TTL=64 ID=954 DF PROTO=ESP SPI=0x1249d895 
> Jan 29 23:27:38 server IN= OUT=ppp0 SRC=<gateway pub ip> DST=<inet host> LEN=88 TOS=0x00 PREC=0x00 TTL=64 ID=954 DF PROTO=ESP SPI=0x1249d895 

Found it, the packet doesn't have its dst_entry released after DNAT in
PRE_ROUTING because of an incorrect check and is delivered locally.
This patch should fix it.

--------------000705090201060609030308
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index ad438fb..74633cd 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -209,8 +209,8 @@ ip_nat_in(unsigned int hooknum,
 	    && (ct = ip_conntrack_get(*pskb, &ctinfo)) != NULL) {
 		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 
-		if (ct->tuplehash[dir].tuple.src.ip !=
-		    ct->tuplehash[!dir].tuple.dst.ip) {
+		if (ct->tuplehash[dir].tuple.dst.ip !=
+		    ct->tuplehash[!dir].tuple.src.ip) {
 			dst_release((*pskb)->dst);
 			(*pskb)->dst = NULL;
 		}

--------------000705090201060609030308--
