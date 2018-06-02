From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/20] ipvs: add ipv6 support to ftp
Date: Sat,  2 Jun 2018 02:22:59 +0200
Message-ID: <20180602002259.4024-21-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

Add support for FTP commands with extended format (RFC 2428):

- FTP EPRT: IPv4 and IPv6, active mode, similar to PORT
- FTP EPSV: IPv4 and IPv6, passive mode, similar to PASV.
EPSV response usually contains only port but we allow real
server to provide different address

We restrict control and data connection to be from same
address family.

Allow the "(" and ")" to be optional in PASV response.

Also, add ipvsh argument to the pkt_in/pkt_out handlers to better
access the payload after transport header.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h                   |  10 +-
 net/netfilter/ipvs/ip_vs_app.c        |  24 +-
 net/netfilter/ipvs/ip_vs_ftp.c        | 467 ++++++++++++++++++++++------------
 net/netfilter/ipvs/ip_vs_proto_sctp.c |   4 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c  |   4 +-
 net/netfilter/ipvs/ip_vs_proto_udp.c  |   4 +-
 6 files changed, 331 insertions(+), 182 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 0ac795b41ab8..03f567eb9536 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -763,14 +763,14 @@ struct ip_vs_app {
 	 *	   2=Mangled but checksum was not updated
 	 */
 	int (*pkt_out)(struct ip_vs_app *, struct ip_vs_conn *,
-		       struct sk_buff *, int *diff);
+		       struct sk_buff *, int *diff, struct ip_vs_iphdr *ipvsh);
 
 	/* input hook: Process packet in outin direction, diff set for TCP.
 	 * Return: 0=Error, 1=Payload Not Mangled/Mangled but checksum is ok,
 	 *	   2=Mangled but checksum was not updated
 	 */
 	int (*pkt_in)(struct ip_vs_app *, struct ip_vs_conn *,
-		      struct sk_buff *, int *diff);
+		      struct sk_buff *, int *diff, struct ip_vs_iphdr *ipvsh);
 
 	/* ip_vs_app initializer */
 	int (*init_conn)(struct ip_vs_app *, struct ip_vs_conn *);
@@ -1328,8 +1328,10 @@ int register_ip_vs_app_inc(struct netns_ipvs *ipvs, struct ip_vs_app *app, __u16
 int ip_vs_app_inc_get(struct ip_vs_app *inc);
 void ip_vs_app_inc_put(struct ip_vs_app *inc);
 
-int ip_vs_app_pkt_out(struct ip_vs_conn *, struct sk_buff *skb);
-int ip_vs_app_pkt_in(struct ip_vs_conn *, struct sk_buff *skb);
+int ip_vs_app_pkt_out(struct ip_vs_conn *, struct sk_buff *skb,
+		      struct ip_vs_iphdr *ipvsh);
+int ip_vs_app_pkt_in(struct ip_vs_conn *, struct sk_buff *skb,
+		     struct ip_vs_iphdr *ipvsh);
 
 int register_ip_vs_pe(struct ip_vs_pe *pe);
 int unregister_ip_vs_pe(struct ip_vs_pe *pe);
diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index 1c98c907bc63..12d74896556a 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -355,7 +355,8 @@ static inline void vs_seq_update(struct ip_vs_conn *cp, struct ip_vs_seq *vseq,
 }
 
 static inline int app_tcp_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb,
-				  struct ip_vs_app *app)
+				  struct ip_vs_app *app,
+				  struct ip_vs_iphdr *ipvsh)
 {
 	int diff;
 	const unsigned int tcp_offset = ip_hdrlen(skb);
@@ -386,7 +387,7 @@ static inline int app_tcp_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb,
 	if (app->pkt_out == NULL)
 		return 1;
 
-	if (!app->pkt_out(app, cp, skb, &diff))
+	if (!app->pkt_out(app, cp, skb, &diff, ipvsh))
 		return 0;
 
 	/*
@@ -404,7 +405,8 @@ static inline int app_tcp_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb,
  *	called by ipvs packet handler, assumes previously checked cp!=NULL
  *	returns false if it can't handle packet (oom)
  */
-int ip_vs_app_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb)
+int ip_vs_app_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb,
+		      struct ip_vs_iphdr *ipvsh)
 {
 	struct ip_vs_app *app;
 
@@ -417,7 +419,7 @@ int ip_vs_app_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb)
 
 	/* TCP is complicated */
 	if (cp->protocol == IPPROTO_TCP)
-		return app_tcp_pkt_out(cp, skb, app);
+		return app_tcp_pkt_out(cp, skb, app, ipvsh);
 
 	/*
 	 *	Call private output hook function
@@ -425,12 +427,13 @@ int ip_vs_app_pkt_out(struct ip_vs_conn *cp, struct sk_buff *skb)
 	if (app->pkt_out == NULL)
 		return 1;
 
-	return app->pkt_out(app, cp, skb, NULL);
+	return app->pkt_out(app, cp, skb, NULL, ipvsh);
 }
 
 
 static inline int app_tcp_pkt_in(struct ip_vs_conn *cp, struct sk_buff *skb,
-				 struct ip_vs_app *app)
+				 struct ip_vs_app *app,
+				 struct ip_vs_iphdr *ipvsh)
 {
 	int diff;
 	const unsigned int tcp_offset = ip_hdrlen(skb);
@@ -461,7 +464,7 @@ static inline int app_tcp_pkt_in(struct ip_vs_conn *cp, struct sk_buff *skb,
 	if (app->pkt_in == NULL)
 		return 1;
 
-	if (!app->pkt_in(app, cp, skb, &diff))
+	if (!app->pkt_in(app, cp, skb, &diff, ipvsh))
 		return 0;
 
 	/*
@@ -479,7 +482,8 @@ static inline int app_tcp_pkt_in(struct ip_vs_conn *cp, struct sk_buff *skb,
  *	called by ipvs packet handler, assumes previously checked cp!=NULL.
  *	returns false if can't handle packet (oom).
  */
-int ip_vs_app_pkt_in(struct ip_vs_conn *cp, struct sk_buff *skb)
+int ip_vs_app_pkt_in(struct ip_vs_conn *cp, struct sk_buff *skb,
+		     struct ip_vs_iphdr *ipvsh)
 {
 	struct ip_vs_app *app;
 
@@ -492,7 +496,7 @@ int ip_vs_app_pkt_in(struct ip_vs_conn *cp, struct sk_buff *skb)
 
 	/* TCP is complicated */
 	if (cp->protocol == IPPROTO_TCP)
-		return app_tcp_pkt_in(cp, skb, app);
+		return app_tcp_pkt_in(cp, skb, app, ipvsh);
 
 	/*
 	 *	Call private input hook function
@@ -500,7 +504,7 @@ int ip_vs_app_pkt_in(struct ip_vs_conn *cp, struct sk_buff *skb)
 	if (app->pkt_in == NULL)
 		return 1;
 
-	return app->pkt_in(app, cp, skb, NULL);
+	return app->pkt_in(app, cp, skb, NULL, ipvsh);
 }
 
 
diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 58d5d05aec24..4398a72edec5 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -29,6 +29,8 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
+#include <linux/ctype.h>
+#include <linux/inet.h>
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/netfilter.h>
@@ -44,9 +46,18 @@
 #include <net/ip_vs.h>
 
 
-#define SERVER_STRING "227 "
-#define CLIENT_STRING "PORT"
+#define SERVER_STRING_PASV "227 "
+#define CLIENT_STRING_PORT "PORT"
+#define SERVER_STRING_EPSV "229 "
+#define CLIENT_STRING_EPRT "EPRT"
 
+enum {
+	IP_VS_FTP_ACTIVE = 0,
+	IP_VS_FTP_PORT = 0,
+	IP_VS_FTP_PASV,
+	IP_VS_FTP_EPRT,
+	IP_VS_FTP_EPSV,
+};
 
 /*
  * List of ports (up to IP_VS_APP_MAX_PORTS) to be handled by helper
@@ -58,9 +69,15 @@ module_param_array(ports, ushort, &ports_count, 0444);
 MODULE_PARM_DESC(ports, "Ports to monitor for FTP control commands");
 
 
-/*	Dummy variable */
-static int ip_vs_ftp_pasv;
+static char *ip_vs_ftp_data_ptr(struct sk_buff *skb, struct ip_vs_iphdr *ipvsh)
+{
+	struct tcphdr *th = (struct tcphdr *)((char *)skb->data + ipvsh->len);
+
+	if ((th->doff << 2) < sizeof(struct tcphdr))
+		return NULL;
 
+	return (char *)th + (th->doff << 2);
+}
 
 static int
 ip_vs_ftp_init_conn(struct ip_vs_app *app, struct ip_vs_conn *cp)
@@ -78,20 +95,20 @@ ip_vs_ftp_done_conn(struct ip_vs_app *app, struct ip_vs_conn *cp)
 }
 
 
-/*
- * Get <addr,port> from the string "xxx.xxx.xxx.xxx,ppp,ppp", started
- * with the "pattern", ignoring before "skip" and terminated with
- * the "term" character.
- * <addr,port> is in network order.
+/* Get <addr,port> from the string "xxx.xxx.xxx.xxx,ppp,ppp", started
+ * with the "pattern". <addr,port> is in network order.
+ * Parse extended format depending on ext. In this case addr can be pre-set.
  */
 static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 				  const char *pattern, size_t plen,
-				  char skip, char term,
-				  __be32 *addr, __be16 *port,
-				  char **start, char **end)
+				  char skip, bool ext, int mode,
+				  union nf_inet_addr *addr, __be16 *port,
+				  __u16 af, char **start, char **end)
 {
 	char *s, c;
 	unsigned char p[6];
+	char edelim;
+	__u16 hport;
 	int i = 0;
 
 	if (data_limit - data < plen) {
@@ -113,6 +130,11 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 			if (s == data_limit)
 				return -1;
 			if (!found) {
+				/* "(" is optional for non-extended format,
+				 * so catch the start of IPv4 address
+				 */
+				if (!ext && isdigit(*s))
+					break;
 				if (*s == skip)
 					found = 1;
 			} else if (*s != skip) {
@@ -120,41 +142,102 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
 			}
 		}
 	}
+	/* Old IPv4-only format? */
+	if (!ext) {
+		p[0] = 0;
+		for (data = s; ; data++) {
+			if (data == data_limit)
+				return -1;
+			c = *data;
+			if (isdigit(c)) {
+				p[i] = p[i]*10 + c - '0';
+			} else if (c == ',' && i < 5) {
+				i++;
+				p[i] = 0;
+			} else {
+				/* unexpected character or terminator */
+				break;
+			}
+		}
 
-	for (data = s; ; data++) {
-		if (data == data_limit)
+		if (i != 5)
 			return -1;
-		if (*data == term)
-			break;
+
+		*start = s;
+		*end = data;
+		addr->ip = get_unaligned((__be32 *) p);
+		*port = get_unaligned((__be16 *) (p + 4));
+		return 1;
 	}
-	*end = data;
+	if (s == data_limit)
+		return -1;
+	*start = s;
+	edelim = *s++;
+	if (edelim < 33 || edelim > 126)
+		return -1;
+	if (s == data_limit)
+		return -1;
+	if (*s == edelim) {
+		/* Address family is usually missing for EPSV response */
+		if (mode != IP_VS_FTP_EPSV)
+			return -1;
+		s++;
+		if (s == data_limit)
+			return -1;
+		/* Then address should be missing too */
+		if (*s != edelim)
+			return -1;
+		/* Caller can pre-set addr, if needed */
+		s++;
+	} else {
+		const char *ep;
 
-	memset(p, 0, sizeof(p));
-	for (data = s; ; data++) {
-		c = *data;
-		if (c == term)
-			break;
-		if (c >= '0' && c <= '9') {
-			p[i] = p[i]*10 + c - '0';
-		} else if (c == ',' && i < 5) {
-			i++;
-		} else {
-			/* unexpected character */
+		/* We allow address only from same family */
+		if (af == AF_INET6 && *s != '2')
 			return -1;
+		if (af == AF_INET && *s != '1')
+			return -1;
+		s++;
+		if (s == data_limit)
+			return -1;
+		if (*s != edelim)
+			return -1;
+		s++;
+		if (s == data_limit)
+			return -1;
+		if (af == AF_INET6) {
+			if (in6_pton(s, data_limit - s, (u8 *)addr, edelim,
+				     &ep) <= 0)
+				return -1;
+		} else {
+			if (in4_pton(s, data_limit - s, (u8 *)addr, edelim,
+				     &ep) <= 0)
+				return -1;
 		}
+		s = (char *) ep;
+		if (s == data_limit)
+			return -1;
+		if (*s != edelim)
+			return -1;
+		s++;
 	}
-
-	if (i != 5)
+	for (hport = 0; ; s++)
+	{
+		if (s == data_limit)
+			return -1;
+		if (!isdigit(*s))
+			break;
+		hport = hport * 10 + *s - '0';
+	}
+	if (s == data_limit || !hport || *s != edelim)
 		return -1;
-
-	*start = s;
-	*addr = get_unaligned((__be32 *) p);
-	*port = get_unaligned((__be16 *) (p + 4));
+	s++;
+	*end = s;
+	*port = htons(hport);
 	return 1;
 }
 
-/*
- * Look at outgoing ftp packets to catch the response to a PASV command
+/* Look at outgoing ftp packets to catch the response to a PASV/EPSV command
  * from the server (inside-to-outside).
  * When we see one, we build a connection entry with the client address,
  * client port 0 (unknown at the moment), the server address and the
@@ -165,12 +248,13 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
  * The outgoing packet should be something like
  *   "227 Entering Passive Mode (xxx,xxx,xxx,xxx,ppp,ppp)".
  * xxx,xxx,xxx,xxx is the server address, ppp,ppp is the server port number.
+ * The extended format for EPSV response provides usually only port:
+ *   "229 Entering Extended Passive Mode (|||ppp|)"
  */
 static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
-			 struct sk_buff *skb, int *diff)
+			 struct sk_buff *skb, int *diff,
+			 struct ip_vs_iphdr *ipvsh)
 {
-	struct iphdr *iph;
-	struct tcphdr *th;
 	char *data, *data_limit;
 	char *start, *end;
 	union nf_inet_addr from;
@@ -184,14 +268,6 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 
 	*diff = 0;
 
-#ifdef CONFIG_IP_VS_IPV6
-	/* This application helper doesn't work with IPv6 yet,
-	 * so turn this into a no-op for IPv6 packets
-	 */
-	if (cp->af == AF_INET6)
-		return 1;
-#endif
-
 	/* Only useful for established sessions */
 	if (cp->state != IP_VS_TCP_S_ESTABLISHED)
 		return 1;
@@ -200,53 +276,77 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 	if (!skb_make_writable(skb, skb->len))
 		return 0;
 
-	if (cp->app_data == &ip_vs_ftp_pasv) {
-		iph = ip_hdr(skb);
-		th = (struct tcphdr *)&(((char *)iph)[iph->ihl*4]);
-		data = (char *)th + (th->doff << 2);
+	if (cp->app_data == (void *) IP_VS_FTP_PASV) {
+		data = ip_vs_ftp_data_ptr(skb, ipvsh);
 		data_limit = skb_tail_pointer(skb);
 
+		if (!data || data >= data_limit)
+			return 1;
+
 		if (ip_vs_ftp_get_addrport(data, data_limit,
-					   SERVER_STRING,
-					   sizeof(SERVER_STRING)-1,
-					   '(', ')',
-					   &from.ip, &port,
+					   SERVER_STRING_PASV,
+					   sizeof(SERVER_STRING_PASV)-1,
+					   '(', false, IP_VS_FTP_PASV,
+					   &from, &port, cp->af,
 					   &start, &end) != 1)
 			return 1;
 
-		IP_VS_DBG(7, "PASV response (%pI4:%d) -> %pI4:%d detected\n",
+		IP_VS_DBG(7, "PASV response (%pI4:%u) -> %pI4:%u detected\n",
 			  &from.ip, ntohs(port), &cp->caddr.ip, 0);
+	} else if (cp->app_data == (void *) IP_VS_FTP_EPSV) {
+		data = ip_vs_ftp_data_ptr(skb, ipvsh);
+		data_limit = skb_tail_pointer(skb);
 
-		/*
-		 * Now update or create an connection entry for it
+		if (!data || data >= data_limit)
+			return 1;
+
+		/* Usually, data address is not specified but
+		 * we support different address, so pre-set it.
 		 */
-		{
-			struct ip_vs_conn_param p;
-			ip_vs_conn_fill_param(cp->ipvs, AF_INET,
-					      iph->protocol, &from, port,
-					      &cp->caddr, 0, &p);
-			n_cp = ip_vs_conn_out_get(&p);
-		}
-		if (!n_cp) {
-			struct ip_vs_conn_param p;
-			ip_vs_conn_fill_param(cp->ipvs,
-					      AF_INET, IPPROTO_TCP, &cp->caddr,
-					      0, &cp->vaddr, port, &p);
-			/* As above, this is ipv4 only */
-			n_cp = ip_vs_conn_new(&p, AF_INET, &from, port,
-					      IP_VS_CONN_F_NO_CPORT |
-					      IP_VS_CONN_F_NFCT,
-					      cp->dest, skb->mark);
-			if (!n_cp)
-				return 0;
+		from = cp->daddr;
+		if (ip_vs_ftp_get_addrport(data, data_limit,
+					   SERVER_STRING_EPSV,
+					   sizeof(SERVER_STRING_EPSV)-1,
+					   '(', true, IP_VS_FTP_EPSV,
+					   &from, &port, cp->af,
+					   &start, &end) != 1)
+			return 1;
 
-			/* add its controller */
-			ip_vs_control_add(n_cp, cp);
-		}
+		IP_VS_DBG_BUF(7, "EPSV response (%s:%u) -> %s:%u detected\n",
+			      IP_VS_DBG_ADDR(cp->af, &from), ntohs(port),
+			      IP_VS_DBG_ADDR(cp->af, &cp->caddr), 0);
+	} else {
+		return 1;
+	}
 
-		/*
-		 * Replace the old passive address with the new one
-		 */
+	/* Now update or create a connection entry for it */
+	{
+		struct ip_vs_conn_param p;
+
+		ip_vs_conn_fill_param(cp->ipvs, cp->af,
+				      ipvsh->protocol, &from, port,
+				      &cp->caddr, 0, &p);
+		n_cp = ip_vs_conn_out_get(&p);
+	}
+	if (!n_cp) {
+		struct ip_vs_conn_param p;
+
+		ip_vs_conn_fill_param(cp->ipvs,
+				      cp->af, ipvsh->protocol, &cp->caddr,
+				      0, &cp->vaddr, port, &p);
+		n_cp = ip_vs_conn_new(&p, cp->af, &from, port,
+				      IP_VS_CONN_F_NO_CPORT |
+				      IP_VS_CONN_F_NFCT,
+				      cp->dest, skb->mark);
+		if (!n_cp)
+			return 0;
+
+		/* add its controller */
+		ip_vs_control_add(n_cp, cp);
+	}
+
+	/* Replace the old passive address with the new one */
+	if (cp->app_data == (void *) IP_VS_FTP_PASV) {
 		from.ip = n_cp->vaddr.ip;
 		port = n_cp->vport;
 		snprintf(buf, sizeof(buf), "%u,%u,%u,%u,%u,%u",
@@ -256,50 +356,54 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 			 ((unsigned char *)&from.ip)[3],
 			 ntohs(port) >> 8,
 			 ntohs(port) & 0xFF);
+	} else if (cp->app_data == (void *) IP_VS_FTP_EPSV) {
+		from = n_cp->vaddr;
+		port = n_cp->vport;
+		/* Only port, client will use VIP for the data connection */
+		snprintf(buf, sizeof(buf), "|||%u|",
+			 ntohs(port));
+	} else {
+		*buf = 0;
+	}
+	buf_len = strlen(buf);
 
-		buf_len = strlen(buf);
-
-		ct = nf_ct_get(skb, &ctinfo);
-		if (ct) {
-			bool mangled;
-
-			/* If mangling fails this function will return 0
-			 * which will cause the packet to be dropped.
-			 * Mangling can only fail under memory pressure,
-			 * hopefully it will succeed on the retransmitted
-			 * packet.
-			 */
-			mangled = nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
-							   iph->ihl * 4,
-							   start - data,
-							   end - start,
-							   buf, buf_len);
-			if (mangled) {
-				ip_vs_nfct_expect_related(skb, ct, n_cp,
-							  IPPROTO_TCP, 0, 0);
-				if (skb->ip_summed == CHECKSUM_COMPLETE)
-					skb->ip_summed = CHECKSUM_UNNECESSARY;
-				/* csum is updated */
-				ret = 1;
-			}
-		}
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct) {
+		bool mangled;
 
-		/*
-		 * Not setting 'diff' is intentional, otherwise the sequence
-		 * would be adjusted twice.
+		/* If mangling fails this function will return 0
+		 * which will cause the packet to be dropped.
+		 * Mangling can only fail under memory pressure,
+		 * hopefully it will succeed on the retransmitted
+		 * packet.
 		 */
-
-		cp->app_data = NULL;
-		ip_vs_tcp_conn_listen(n_cp);
-		ip_vs_conn_put(n_cp);
-		return ret;
+		mangled = nf_nat_mangle_tcp_packet(skb, ct, ctinfo,
+						   ipvsh->len,
+						   start - data,
+						   end - start,
+						   buf, buf_len);
+		if (mangled) {
+			ip_vs_nfct_expect_related(skb, ct, n_cp,
+						  ipvsh->protocol, 0, 0);
+			if (skb->ip_summed == CHECKSUM_COMPLETE)
+				skb->ip_summed = CHECKSUM_UNNECESSARY;
+			/* csum is updated */
+			ret = 1;
+		}
 	}
-	return 1;
+
+	/* Not setting 'diff' is intentional, otherwise the sequence
+	 * would be adjusted twice.
+	 */
+
+	cp->app_data = (void *) IP_VS_FTP_ACTIVE;
+	ip_vs_tcp_conn_listen(n_cp);
+	ip_vs_conn_put(n_cp);
+	return ret;
 }
 
 
-/*
- * Look at incoming ftp packets to catch the PASV/PORT command
+/* Look at incoming ftp packets to catch the PASV/PORT/EPRT/EPSV command
  * (outside-to-inside).
  *
  * The incoming packet having the PORT command should be something like
@@ -308,12 +412,19 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
  * In this case, we create a connection entry using the client address and
  * port, so that the active ftp data connection from the server can reach
  * the client.
+ * Extended format:
+ *	"EPSV\r\n" when client requests server address from same family
+ *	"EPSV 1\r\n" when client requests IPv4 server address
+ *	"EPSV 2\r\n" when client requests IPv6 server address
+ *	"EPSV ALL\r\n" - not supported
+ *	EPRT with specified delimiter (ASCII 33..126), "|" by default:
+ *	"EPRT |1|IPv4ADDR|PORT|\r\n" when client provides IPv4 addrport
+ *	"EPRT |2|IPv6ADDR|PORT|\r\n" when client provides IPv6 addrport
  */
 static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
-			struct sk_buff *skb, int *diff)
+			struct sk_buff *skb, int *diff,
+			struct ip_vs_iphdr *ipvsh)
 {
-	struct iphdr *iph;
-	struct tcphdr *th;
 	char *data, *data_start, *data_limit;
 	char *start, *end;
 	union nf_inet_addr to;
@@ -323,14 +434,6 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
 	/* no diff required for incoming packets */
 	*diff = 0;
 
-#ifdef CONFIG_IP_VS_IPV6
-	/* This application helper doesn't work with IPv6 yet,
-	 * so turn this into a no-op for IPv6 packets
-	 */
-	if (cp->af == AF_INET6)
-		return 1;
-#endif
-
 	/* Only useful for established sessions */
 	if (cp->state != IP_VS_TCP_S_ESTABLISHED)
 		return 1;
@@ -339,27 +442,48 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
 	if (!skb_make_writable(skb, skb->len))
 		return 0;
 
-	/*
-	 * Detecting whether it is passive
-	 */
-	iph = ip_hdr(skb);
-	th = (struct tcphdr *)&(((char *)iph)[iph->ihl*4]);
-
-	/* Since there may be OPTIONS in the TCP packet and the HLEN is
-	   the length of the header in 32-bit multiples, it is accurate
-	   to calculate data address by th+HLEN*4 */
-	data = data_start = (char *)th + (th->doff << 2);
+	data = data_start = ip_vs_ftp_data_ptr(skb, ipvsh);
 	data_limit = skb_tail_pointer(skb);
+	if (!data || data >= data_limit)
+		return 1;
 
 	while (data <= data_limit - 6) {
-		if (strncasecmp(data, "PASV\r\n", 6) == 0) {
+		if (cp->af == AF_INET &&
+		    strncasecmp(data, "PASV\r\n", 6) == 0) {
 			/* Passive mode on */
 			IP_VS_DBG(7, "got PASV at %td of %td\n",
 				  data - data_start,
 				  data_limit - data_start);
-			cp->app_data = &ip_vs_ftp_pasv;
+			cp->app_data = (void *) IP_VS_FTP_PASV;
 			return 1;
 		}
+
+		/* EPSV or EPSV<space><net-prt> */
+		if (strncasecmp(data, "EPSV", 4) == 0 &&
+		    (data[4] == ' ' || data[4] == '\r')) {
+			if (data[4] == ' ') {
+				char proto = data[5];
+
+				if (data > data_limit - 7 || data[6] != '\r')
+					return 1;
+
+#ifdef CONFIG_IP_VS_IPV6
+				if (cp->af == AF_INET6 && proto == '2') {
+				} else
+#endif
+				if (cp->af == AF_INET && proto == '1') {
+				} else {
+					return 1;
+				}
+			}
+			/* Extended Passive mode on */
+			IP_VS_DBG(7, "got EPSV at %td of %td\n",
+				  data - data_start,
+				  data_limit - data_start);
+			cp->app_data = (void *) IP_VS_FTP_EPSV;
+			return 1;
+		}
+
 		data++;
 	}
 
@@ -370,33 +494,52 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
 	 * then create a new connection entry for the coming data
 	 * connection.
 	 */
-	if (ip_vs_ftp_get_addrport(data_start, data_limit,
-				   CLIENT_STRING, sizeof(CLIENT_STRING)-1,
-				   ' ', '\r', &to.ip, &port,
-				   &start, &end) != 1)
+	if (cp->af == AF_INET &&
+	    ip_vs_ftp_get_addrport(data_start, data_limit,
+				   CLIENT_STRING_PORT,
+				   sizeof(CLIENT_STRING_PORT)-1,
+				   ' ', false, IP_VS_FTP_PORT,
+				   &to, &port, cp->af,
+				   &start, &end) == 1) {
+
+		IP_VS_DBG(7, "PORT %pI4:%u detected\n", &to.ip, ntohs(port));
+
+		/* Now update or create a connection entry for it */
+		IP_VS_DBG(7, "protocol %s %pI4:%u %pI4:%u\n",
+			  ip_vs_proto_name(ipvsh->protocol),
+			  &to.ip, ntohs(port), &cp->vaddr.ip,
+			  ntohs(cp->vport)-1);
+	} else if (ip_vs_ftp_get_addrport(data_start, data_limit,
+					  CLIENT_STRING_EPRT,
+					  sizeof(CLIENT_STRING_EPRT)-1,
+					  ' ', true, IP_VS_FTP_EPRT,
+					  &to, &port, cp->af,
+					  &start, &end) == 1) {
+
+		IP_VS_DBG_BUF(7, "EPRT %s:%u detected\n",
+			      IP_VS_DBG_ADDR(cp->af, &to), ntohs(port));
+
+		/* Now update or create a connection entry for it */
+		IP_VS_DBG_BUF(7, "protocol %s %s:%u %s:%u\n",
+			      ip_vs_proto_name(ipvsh->protocol),
+			      IP_VS_DBG_ADDR(cp->af, &to), ntohs(port),
+			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
+			      ntohs(cp->vport)-1);
+	} else {
 		return 1;
-
-	IP_VS_DBG(7, "PORT %pI4:%d detected\n", &to.ip, ntohs(port));
+	}
 
 	/* Passive mode off */
-	cp->app_data = NULL;
-
-	/*
-	 * Now update or create a connection entry for it
-	 */
-	IP_VS_DBG(7, "protocol %s %pI4:%d %pI4:%d\n",
-		  ip_vs_proto_name(iph->protocol),
-		  &to.ip, ntohs(port), &cp->vaddr.ip, 0);
+	cp->app_data = (void *) IP_VS_FTP_ACTIVE;
 
 	{
 		struct ip_vs_conn_param p;
-		ip_vs_conn_fill_param(cp->ipvs, AF_INET,
-				      iph->protocol, &to, port, &cp->vaddr,
+		ip_vs_conn_fill_param(cp->ipvs, cp->af,
+				      ipvsh->protocol, &to, port, &cp->vaddr,
 				      htons(ntohs(cp->vport)-1), &p);
 		n_cp = ip_vs_conn_in_get(&p);
 		if (!n_cp) {
-			/* This is ipv4 only */
-			n_cp = ip_vs_conn_new(&p, AF_INET, &cp->daddr,
+			n_cp = ip_vs_conn_new(&p, cp->af, &cp->daddr,
 					      htons(ntohs(cp->dport)-1),
 					      IP_VS_CONN_F_NFCT, cp->dest,
 					      skb->mark);
@@ -454,7 +597,7 @@ static int __net_init __ip_vs_ftp_init(struct net *net)
 		ret = register_ip_vs_app_inc(ipvs, app, app->protocol, ports[i]);
 		if (ret)
 			goto err_unreg;
-		pr_info("%s: loaded support on port[%d] = %d\n",
+		pr_info("%s: loaded support on port[%d] = %u\n",
 			app->name, i, ports[i]);
 	}
 	return 0;
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index eff7569824e5..3250c4a1111e 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -109,7 +109,7 @@ sctp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 			return 0;
 
 		/* Call application helper if needed */
-		ret = ip_vs_app_pkt_out(cp, skb);
+		ret = ip_vs_app_pkt_out(cp, skb, iph);
 		if (ret == 0)
 			return 0;
 		/* ret=2: csum update is needed after payload mangling */
@@ -156,7 +156,7 @@ sctp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 			return 0;
 
 		/* Call application helper if needed */
-		ret = ip_vs_app_pkt_in(cp, skb);
+		ret = ip_vs_app_pkt_in(cp, skb, iph);
 		if (ret == 0)
 			return 0;
 		/* ret=2: csum update is needed after payload mangling */
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 569631d2b2a1..80d10ad12a15 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -170,7 +170,7 @@ tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 			return 0;
 
 		/* Call application helper if needed */
-		if (!(ret = ip_vs_app_pkt_out(cp, skb)))
+		if (!(ret = ip_vs_app_pkt_out(cp, skb, iph)))
 			return 0;
 		/* ret=2: csum update is needed after payload mangling */
 		if (ret == 1)
@@ -251,7 +251,7 @@ tcp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		 *	Attempt ip_vs_app call.
 		 *	It will fix ip_vs_conn and iph ack_seq stuff
 		 */
-		if (!(ret = ip_vs_app_pkt_in(cp, skb)))
+		if (!(ret = ip_vs_app_pkt_in(cp, skb, iph)))
 			return 0;
 		/* ret=2: csum update is needed after payload mangling */
 		if (ret == 1)
diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
index c15ef7c2a1fa..e0ef11c3691e 100644
--- a/net/netfilter/ipvs/ip_vs_proto_udp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
@@ -162,7 +162,7 @@ udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		/*
 		 *	Call application helper if needed
 		 */
-		if (!(ret = ip_vs_app_pkt_out(cp, skb)))
+		if (!(ret = ip_vs_app_pkt_out(cp, skb, iph)))
 			return 0;
 		/* ret=2: csum update is needed after payload mangling */
 		if (ret == 1)
@@ -246,7 +246,7 @@ udp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
 		 *	Attempt ip_vs_app call.
 		 *	It will fix ip_vs_conn
 		 */
-		if (!(ret = ip_vs_app_pkt_in(cp, skb)))
+		if (!(ret = ip_vs_app_pkt_in(cp, skb, iph)))
 			return 0;
 		/* ret=2: csum update is needed after payload mangling */
 		if (ret == 1)
-- 
2.11.0
