From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 21 Jun 2004 02:07:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D626CB.9090102@trash.net>
References: <Pine.LNX.4.33.0406141551410.12847-100000@blackhole.kfki.hu>	 <40D18A0B.2070101@eurodev.net> <1087759076.9146.32.camel@tux.rsn.bth.se> <40D60A2D.2080800@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000309090904090805050209"
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40D60A2D.2080800@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000309090904090805050209
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Pablo Neira wrote:
> Would you be willing to apply the patch attached to pom-ng? It applies 
> to linux-2.6.patch_02-udp-icmp and it adds more checkings for invalid 
> icmp combinations.

You should use the defined types for better readability. Something like
this ..

Regards
Patrick

--------------000309090904090805050209
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/ipv4/netfilter/ip_conntrack_proto_icmp.c 1.8 vs edited =====
--- 1.8/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-06-21 01:50:41 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-06-21 02:03:10 +02:00
@@ -27,6 +27,38 @@
 #define DEBUGP(format, args...)
 #endif
 
+#define OK 1
+#define IV 0
+
+#define ICMP_ROUTER_ADV	9
+#define ICMP_ROUTER_SEL	10
+
+/* ICMP types and codes described in RFC's:
+ * 	- 792: Internet Control Message Protocol. Most types.
+ * 	- 1256: ICMP Router Discovery Messages. Types 9 and 10.
+ * 	- 950: Internet Standard Subnetting Procedure. Types 17 and 18.
+ * 	- 1812: Requirements for IP Version 4 Routers. Type 3. Section 5.2.7.1
+ */
+static u_int8_t icmp_valid[NR_ICMP_TYPES+1][NR_ICMP_UNREACH+1] = 
+{
+	/*                          0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 */
+	[ICMP_ECHOREPLY]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_DEST_UNREACH]	= {OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK},
+	[ICMP_SOURCE_QUENCH]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_REDIRECT] 	= {OK,OK,OK,OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_ECHO]		= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_ROUTER_ADV]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_ROUTER_SEL]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_TIME_EXCEEDED]	= {OK,OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_PARAMETERPROB]	= {OK,OK,OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_TIMESTAMP]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_TIMESTAMPREPLY]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_INFO_REQUEST]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_INFO_REPLY]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_ADDRESS]		= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+	[ICMP_ADDRESSREPLY]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
+};
+
 static int icmp_pkt_to_tuple(const struct sk_buff *skb,
 			     unsigned int dataoff,
 			     struct ip_conntrack_tuple *tuple)
@@ -245,6 +277,22 @@
 		if (LOG_INVALID(IPPROTO_ICMP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
 				      "ip_ct_icmp: invalid ICMP type ");
+		return -NF_ACCEPT;
+	}
+
+	/* 15 is the highest 'known' ICMP code. See RFC 1812 */
+	if (icmph.code > NR_ICMP_UNREACH) {
+		if (LOG_INVALID(IPPROTO_ICMP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
+				      "ip_ct_icmp: invalid ICMP code ");
+		return -NF_ACCEPT;
+	}
+
+	/* check for invalid combinations */
+	if (!icmp_valid[icmph.type][icmph.code]) {
+		if (LOG_INVALID(IPPROTO_ICMP))
+			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
+				      "ip_ct_icmp: invalid ICMP type/code ");
 		return -NF_ACCEPT;
 	}
 

--------------000309090904090805050209--
