From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: [PATCH] Re: [BUG] Security Announcement: ip6tables bug - level:
	very high
Date: 06 Jun 2002 03:58:00 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023328680.2192.22.camel@hoi>
References: <Pine.LNX.4.33.0206031139030.4553-100000@blackhole.kfki.hu>
	<1023317890.912.28.camel@hoi>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-1qCeQITg4VzNIIPLuVqn"
Cc: Darko Kraus <DKraus@smartbus.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter Devel <netfilter-devel@lists.samba.org>
In-Reply-To: <1023317890.912.28.camel@hoi>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-1qCeQITg4VzNIIPLuVqn
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,


*** Description / example ***

The exapmle scenario:
# ip6tables -L
# tcpreplay6 <pure-icmpv6
# tcpreplay6 <ah-len24-spi4096-clean-dst-len8-sub2-len4-pad1-pad1
// or any other packet with extension headers
# ip6tables -A OUTPUT -p ipv6-icmp
# tcpreplay6 <pure-icmpv6
# ip6tables -L OUTPUT -n -v
Chain OUTPUT (policy ACCEPT 1 packets, 57 bytes)
 pkts bytes target     prot opt in     out    source destination        
    1    57            icmpv6    *      *      ::/0   ::/0       
# tcpreplay6 <ah-len24-spi4096-clean-dst-len8-sub2-len4-pad1-pad1
// or any other packet with extension headers
 
	*** The kernel crashed immediately. ***

(The test packets can be found in the pool:
http://www.securityaudit.hu/Netfilter/addons/TestPackets/ )
 
*** Background ***
The original code contains 
- 2 errors in its source code and 
	When calculates the length of the AH header it used an index 	from the
'air'.
> -		      hdrlen = hdrptr[i] * 4 + 8;
> +			hdrlen = hdrptr[1] * 4 + 8;
	When set the pointer for the first header
> -                hdrptr = (u_int8_t *)(ipv6 + 1);
> +                hdrptr = (u_int8_t *)((void *)ipv6 + 1);
	(the kernel crashed here...)
- 1 error in its design.
	The code checked the extension headers - without the headers.
	It set the index after the ipv6 header and started iterate the
	headers until the protocol header to find the type of the 
	protocol. In the skbuff the ipv6 header is only the pure header,
	nothing more, so it walked somewhere in the kernel memory.


*** Affected systems ***
Any Linux system, which has a rule with protocol match (-p)!
 
*** Preparedness ***
Any script-kiddie, or a plain user with instructions.
Automated tool: possible
 
*** Result ***
Kernel crash
 
*** Required packet ***
- any IPv6 packet with options

*** Modifications in the code ***
I got the header parser code from my extension header patches, and put
it into the ip6_tables.c.
It can be buggy - I checked with the testpackets and worked properly.
It ahndles the '-p all' counter quiestion/ticket, too.
I left the original code (with the debug messages) in the file.

For the '-p all' question:
- patkets with NONE or ESP ext. headers won't be counted (it's only a
return, so it can be changed)
- the ip6tables never adds the size of the extensions to the counters!
	(It counts only the ipv6-header and the payload.)

Regards,
 
 	kisza

-- 
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /-----Member of the BUTE-MIS-SEARCHlab------>

--=-1qCeQITg4VzNIIPLuVqn
Content-Disposition: attachment; filename=exthdr-bug-20020606
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=exthdr-bug-20020606; charset=ISO-8859-2

--- linux-p0bug/net/ipv6/netfilter/ip6_tables.c	Wed Jun  5 23:57:31 2002
+++ linux/net/ipv6/netfilter/ip6_tables.c	Thu Jun  6 03:30:59 2002
@@ -7,6 +7,8 @@
  * 19 Jan 2002 Harald Welte <laforge@gnumonks.org>
  * 	- increase module usage count as soon as we have rules inside
  * 	  a table
+ * 06 Jun 2002 Andras Kis-Szabo <kisza@sch.bme.hu>
+ *      - new (and real) extension header parser code
  */
 #include <linux/config.h>
 #include <linux/skbuff.h>
@@ -25,6 +27,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
=20
 #define IPV6_HDR_LEN	(sizeof(struct ipv6hdr))
+#define IPV6_OPTHDR_LEN	(sizeof(struct ipv6_opt_hdr))
=20
 /*#define DEBUG_IP_FIREWALL*/
 /*#define DEBUG_ALLOW_ALL*/ /* Useful for remote debugging */
@@ -133,12 +136,26 @@
 	return 0;
 }
=20
+/* Check for an extension */
+static int ipv6_ext_hdr(u8 nexthdr)
+{
+        return ( (nexthdr =3D=3D IPPROTO_HOPOPTS)   ||
+                 (nexthdr =3D=3D IPPROTO_ROUTING)   ||
+                 (nexthdr =3D=3D IPPROTO_FRAGMENT)  ||
+                 (nexthdr =3D=3D IPPROTO_ESP)       ||
+                 (nexthdr =3D=3D IPPROTO_AH)        ||
+                 (nexthdr =3D=3D IPPROTO_NONE)      ||
+                 (nexthdr =3D=3D IPPROTO_DSTOPTS) );
+}
+
+#if 0
+/* The old extension-header parser. Sorry for the #if 0!
+ * 		-- kisza */
 /* takes in current header and pointer to the header */
 /* if another header exists, sets hdrptr to the next header
    and returns the new header value, else returns 0 */
 static u_int8_t ip6_nexthdr(u_int8_t currenthdr, u_int8_t *hdrptr)
 {
-	int i;
 	u_int8_t hdrlen, nexthdr =3D 0;
 	switch(currenthdr){
 		case IPPROTO_AH:
@@ -147,13 +164,14 @@
 		repeatedly...with a large stick...no, an even LARGER
 		stick...no, you're still not thinking big enough */
 			nexthdr =3D *hdrptr;
-			hdrlen =3D hdrptr[i] * 4 + 8;
+			hdrlen =3D hdrptr[1] * 4 + 8;
 			hdrptr =3D hdrptr + hdrlen;
 			break;
 		/*stupid rfc2402 */
 		case IPPROTO_DSTOPTS:
 		case IPPROTO_ROUTING:
 		case IPPROTO_HOPOPTS:
+			dprintf(" Found a general header.\n");
 			nexthdr =3D *hdrptr;
 			hdrlen =3D hdrptr[1] * 8 + 8;
 			hdrptr =3D hdrptr + hdrlen;
@@ -163,13 +181,18 @@
 			hdrptr =3D hdrptr + 8;
 			break;
 	}=09
+
+	dprintf(" Found header: %hi\n", nexthdr);
+
 	return nexthdr;
=20
 }
+#endif
=20
 /* Returns whether matches rule or not. */
 static inline int
-ip6_packet_match(const struct ipv6hdr *ipv6,
+ip6_packet_match(const struct sk_buff *skb,
+		 const struct ipv6hdr *ipv6,
 		 const char *indev,
 		 const char *outdev,
 		 const struct ip6t_ip6 *ip6info,
@@ -227,17 +250,86 @@
 	/* look for the desired protocol header */
 	if((ip6info->flags & IP6T_F_PROTO)) {
 		u_int8_t currenthdr =3D ipv6->nexthdr;
-		u_int8_t *hdrptr;
-		hdrptr =3D (u_int8_t *)(ipv6 + 1);
+		struct ipv6_opt_hdr *hdrptr;
+		u_int16_t ptr;		/* Header offset in skb */
+		u_int16_t hdrlen;	/* Header */
+
+		ptr =3D IPV6_HDR_LEN;
+
+		while (ipv6_ext_hdr(currenthdr)) {
+	                /* Is there enough space for the next ext header? */
+	                if (skb->len - ptr < IPV6_OPTHDR_LEN)
+	                        return 0;
+
+			/* NONE or ESP: there isn't protocol part */
+			/* If we want to count these packets in '-p all',
+			 * we will change the return 0 to 1*/
+			if ((currenthdr =3D=3D IPPROTO_NONE) ||=20
+				(currenthdr =3D=3D IPPROTO_ESP))
+				return 0;
+
+	                hdrptr =3D (struct ipv6_opt_hdr *)(skb->data + ptr);
+
+			/* Size calculation */
+	                if (currenthdr =3D=3D IPPROTO_FRAGMENT) {
+	                        hdrlen =3D 8;
+	                } else if (currenthdr =3D=3D IPPROTO_AH)
+	                        hdrlen =3D (hdrptr->hdrlen+2)<<2;
+	                else
+	                        hdrlen =3D ipv6_optlen(hdrptr);
+
+			currenthdr =3D hdrptr->nexthdr;
+	                ptr +=3D hdrlen;
+			/* ptr is too large */
+	                if ( ptr > skb->len )=20
+				return 0;
+		}
+
+		/* currenthdr contains the protocol header */
+
+		dprintf("Packet protocol %hi ?=3D %s%hi.\n",
+				currenthdr,=20
+				ip6info->invflags & IP6T_INV_PROTO ? "!":"",
+				ip6info->proto);
+
+		if (ip6info->proto =3D=3D currenthdr) {
+			if(ip6info->invflags & IP6T_INV_PROTO) {
+				return 0;
+			}
+			return 1;
+		}
+
+		/*
+		 * Old extension header parser - WRONG IDEA! It always=20
+		 * causes crash with an extension!
+ 		 * 	-- kisza
+		hdrptr =3D (u_int8_t *)((void *)ipv6 + 1);
 		do {
+			dprintf("Packet protocol currenthdr: %hi ?=3D %hi.\n",
+					currenthdr, ip6info->proto);
 			if (ip6info->proto =3D=3D currenthdr) {
-				if(ip6info->invflags & IP6T_INV_PROTO)
+				if(ip6info->invflags & IP6T_INV_PROTO) {
+					dprintf("Packet protocol %hi does not "
+						"match %hi.%s\n",
+						currenthdr, ip6info->proto,
+						ip6info->invflags &
+						IP6T_INV_PROTO ? " (INV)":"");
 					return 0;
+				}
+				dprintf("Packet protocol %hi "
+					"matches %hi.%s\n",
+					currenthdr, ip6info->proto,
+					ip6info->invflags &
+					IP6T_INV_PROTO ? " (INV)":"");
 				return 1;
 			}
 			currenthdr =3D ip6_nexthdr(currenthdr, hdrptr);
 		} while(currenthdr);
-		if (!(ip6info->invflags & IP6T_INV_PROTO))
+		*/
+
+		/* We need match for the '-p all', too! */
+		if ((ip6info->proto !=3D 0) &&
+			!(ip6info->invflags & IP6T_INV_PROTO))
 			return 0;
 	}
 	return 1;
@@ -359,7 +451,8 @@
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
 		(*pskb)->nfcache |=3D e->nfcache;
-		if (ip6_packet_match(ipv6, indev, outdev, &e->ipv6, offset)) {
+		if (ip6_packet_match(*pskb, ipv6, indev, outdev,=20
+			&e->ipv6, offset)) {
 			struct ip6t_entry_target *t;
=20
 			if (IP6T_MATCH_ITERATE(e, do_match,

--=-1qCeQITg4VzNIIPLuVqn--
