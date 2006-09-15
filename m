From: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Subject: Re: rtsp-conntrack without needing NAT
Date: Fri, 15 Sep 2006 10:15:47 +0200
Message-ID: <20060915081547.GA26883@ekonomika.be>
References: <20060914125154.GA4620@ekonomika.be> <450A2EAC.8030701@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Cc: Patrick McHardy <kaber@trash.net>, Mickael Marchand <marchand@kde.org>,
	kulnet@kulnet.kuleuven.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <450A2EAC.8030701@trash.net>
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


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 15, 2006 at 06:40:12AM +0200, Patrick McHardy wrote:
> 
> You're more likely to find someone if you post your changes as a patch
> to the original version.
> 

Sorry about that. I recreated the patch based on
the latest pom-ng snapshot (patch-o-matic-ng-20060914)

kind regards,
-- Steven

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="patch-o-matic-ng-20060914-rtsp.patch"

diff -Naur patch-o-matic-ng-20060913/patchlets/rtsp-conntrack/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_rtsp.h patch-o-matic-ng-20060913-patched-rtsp/patchlets/rtsp-conntrack/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_rtsp.h
--- patch-o-matic-ng-20060913/patchlets/rtsp-conntrack/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_rtsp.h	2005-08-29 22:54:36.000000000 +0200
+++ patch-o-matic-ng-20060913-patched-rtsp/patchlets/rtsp-conntrack/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_rtsp.h	2006-09-15 09:52:21.679949264 +0200
@@ -11,9 +11,10 @@
 #ifndef _IP_CONNTRACK_RTSP_H
 #define _IP_CONNTRACK_RTSP_H
 
-/* #define IP_NF_RTSP_DEBUG */
+//#define IP_NF_RTSP_DEBUG 1
 #define IP_NF_RTSP_VERSION "0.6.21"
 
+#ifdef __KERNEL__
 /* port block types */
 typedef enum {
     pb_single,  /* client_port=x */
@@ -47,7 +48,13 @@
 #endif
 };
 
-#ifdef __KERNEL__
+extern unsigned int (*ip_nat_rtsp_hook)(struct sk_buff **pskb,
+				 enum ip_conntrack_info ctinfo,
+				 unsigned int matchoff, unsigned int matchlen,
+				 struct ip_ct_rtsp_expect *expinfo,
+				 struct ip_conntrack_expect *exp);
+
+extern void (*ip_nat_rtsp_hook_expectfn)(struct ip_conntrack *ct, struct ip_conntrack_expect *exp);
 
 #define RTSP_PORT   554
 
diff -Naur patch-o-matic-ng-20060913/patchlets/rtsp-conntrack/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rtsp.c patch-o-matic-ng-20060913-patched-rtsp/patchlets/rtsp-conntrack/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rtsp.c
--- patch-o-matic-ng-20060913/patchlets/rtsp-conntrack/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rtsp.c	2005-09-19 16:53:50.000000000 +0200
+++ patch-o-matic-ng-20060913-patched-rtsp/patchlets/rtsp-conntrack/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rtsp.c	2006-09-15 09:52:55.341831880 +0200
@@ -22,12 +22,15 @@
  * 2005-02-13: Harald Welte <laforge@netfilter.org>
  * 	- port to 2.6
  * 	- update to recent post-2.6.11 api changes
+ * 2006-09-14: Steven Van Acker <deepstar@singularity.be>
+ *      - removed calls to NAT code from conntrack helper: NAT no longer needed to use rtsp-conntrack
  */
 
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
+#include <linux/inet.h>
 #include <net/checksum.h>
 #include <net/tcp.h>
 
@@ -44,7 +47,7 @@
 #include <linux/netfilter_mime.h>
 
 #define MAX_SIMUL_SETUP 8 /* XXX: use max_outstanding */
-
+#define IP_NF_RTSP_DEBUG
 #define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__ , ## args)
 #ifdef IP_NF_RTSP_DEBUG
 #define DEBUGP(fmt, args...) printk(KERN_DEBUG "%s: %s: " fmt, __FILE__, __FUNCTION__ , ## args)
@@ -68,13 +71,15 @@
 module_param(setup_timeout, int, 0400);
 MODULE_PARM_DESC(setup_timeout, "timeout on for unestablished data channels");
 
-static char rtsp_buffer[65536];
+static char *rtsp_buffer;
 static DEFINE_SPINLOCK(rtsp_buffer_lock);
 
 unsigned int (*ip_nat_rtsp_hook)(struct sk_buff **pskb,
 				 enum ip_conntrack_info ctinfo,
-				 struct ip_ct_rtsp_expect *expinfo,
+				 unsigned int matchoff, unsigned int matchlen,struct ip_ct_rtsp_expect* prtspexp,
 				 struct ip_conntrack_expect *exp);
+void (*ip_nat_rtsp_hook_expectfn)(struct ip_conntrack *ct, struct ip_conntrack_expect *exp);
+
 EXPORT_SYMBOL_GPL(ip_nat_rtsp_hook);
 
 /*
@@ -106,49 +111,47 @@
 static int
 rtsp_parse_message(char* ptcp, uint tcplen, uint* ptcpoff,
                    uint* phdrsoff, uint* phdrslen,
-                   uint* pcseqoff, uint* pcseqlen)
+                   uint* pcseqoff, uint* pcseqlen,
+                   uint* transoff, uint* translen)
 {
-    uint    entitylen = 0;
-    uint    lineoff;
-    uint    linelen;
-
-    if (!nf_nextline(ptcp, tcplen, ptcpoff, &lineoff, &linelen))
-    {
-        return 0;
-    }
-
-    *phdrsoff = *ptcpoff;
-    while (nf_mime_nextline(ptcp, tcplen, ptcpoff, &lineoff, &linelen))
-    {
-        if (linelen == 0)
-        {
-            if (entitylen > 0)
-            {
-                *ptcpoff += min(entitylen, tcplen - *ptcpoff);
-            }
-            break;
-        }
-        if (lineoff+linelen > tcplen)
-        {
-            INFOP("!! overrun !!\n");
-            break;
-        }
-
-        if (nf_strncasecmp(ptcp+lineoff, "CSeq:", 5) == 0)
-        {
-            *pcseqoff = lineoff;
-            *pcseqlen = linelen;
-        }
-        if (nf_strncasecmp(ptcp+lineoff, "Content-Length:", 15) == 0)
-        {
-            uint off = lineoff+15;
-            SKIP_WSPACE(ptcp+lineoff, linelen, off);
-            nf_strtou32(ptcp+off, &entitylen);
-        }
-    }
-    *phdrslen = (*ptcpoff) - (*phdrsoff);
-
-    return 1;
+	uint    entitylen = 0;
+	uint    lineoff;
+	uint    linelen;
+	
+	if (!nf_nextline(ptcp, tcplen, ptcpoff, &lineoff, &linelen))
+		return 0;
+	
+	*phdrsoff = *ptcpoff;
+	while (nf_mime_nextline(ptcp, tcplen, ptcpoff, &lineoff, &linelen)) {
+		if (linelen == 0) {
+			if (entitylen > 0)
+				*ptcpoff += min(entitylen, tcplen - *ptcpoff);
+			break;
+		}
+		if (lineoff+linelen > tcplen) {
+			INFOP("!! overrun !!\n");
+			break;
+		}
+		
+		if (nf_strncasecmp(ptcp+lineoff, "CSeq:", 5) == 0) {
+			*pcseqoff = lineoff;
+			*pcseqlen = linelen;
+		} 
+
+		if (nf_strncasecmp(ptcp+lineoff, "Transport:", 10) == 0) {
+			*transoff = lineoff;
+			*translen = linelen;
+		}
+		
+		if (nf_strncasecmp(ptcp+lineoff, "Content-Length:", 15) == 0) {
+			uint off = lineoff+15;
+			SKIP_WSPACE(ptcp+lineoff, linelen, off);
+			nf_strtou32(ptcp+off, &entitylen);
+		}
+	}
+	*phdrslen = (*ptcpoff) - (*phdrsoff);
+	
+	return 1;
 }
 
 /*
@@ -169,97 +172,95 @@
 rtsp_parse_transport(char* ptran, uint tranlen,
                      struct ip_ct_rtsp_expect* prtspexp)
 {
-    int     rc = 0;
-    uint    off = 0;
-
-    if (tranlen < 10 || !iseol(ptran[tranlen-1]) ||
-        nf_strncasecmp(ptran, "Transport:", 10) != 0)
-    {
-        INFOP("sanity check failed\n");
-        return 0;
-    }
-    DEBUGP("tran='%.*s'\n", (int)tranlen, ptran);
-    off += 10;
-    SKIP_WSPACE(ptran, tranlen, off);
-
-    /* Transport: tran;field;field=val,tran;field;field=val,... */
-    while (off < tranlen)
-    {
-        const char* pparamend;
-        uint        nextparamoff;
-
-        pparamend = memchr(ptran+off, ',', tranlen-off);
-        pparamend = (pparamend == NULL) ? ptran+tranlen : pparamend+1;
-        nextparamoff = pparamend-ptran;
-
-        while (off < nextparamoff)
-        {
-            const char* pfieldend;
-            uint        nextfieldoff;
-
-            pfieldend = memchr(ptran+off, ';', nextparamoff-off);
-            nextfieldoff = (pfieldend == NULL) ? nextparamoff : pfieldend-ptran+1;
-
-            if (strncmp(ptran+off, "client_port=", 12) == 0)
-            {
-                u_int16_t   port;
-                uint        numlen;
-
-                off += 12;
-                numlen = nf_strtou16(ptran+off, &port);
-                off += numlen;
-                if (prtspexp->loport != 0 && prtspexp->loport != port)
-                {
-                    DEBUGP("multiple ports found, port %hu ignored\n", port);
-                }
-                else
-                {
-                    prtspexp->loport = prtspexp->hiport = port;
-                    if (ptran[off] == '-')
-                    {
-                        off++;
-                        numlen = nf_strtou16(ptran+off, &port);
-                        off += numlen;
-                        prtspexp->pbtype = pb_range;
-                        prtspexp->hiport = port;
-
-                        // If we have a range, assume rtp:
-                        // loport must be even, hiport must be loport+1
-                        if ((prtspexp->loport & 0x0001) != 0 ||
-                            prtspexp->hiport != prtspexp->loport+1)
-                        {
-                            DEBUGP("incorrect range: %hu-%hu, correcting\n",
-                                   prtspexp->loport, prtspexp->hiport);
-                            prtspexp->loport &= 0xfffe;
-                            prtspexp->hiport = prtspexp->loport+1;
-                        }
-                    }
-                    else if (ptran[off] == '/')
-                    {
-                        off++;
-                        numlen = nf_strtou16(ptran+off, &port);
-                        off += numlen;
-                        prtspexp->pbtype = pb_discon;
-                        prtspexp->hiport = port;
-                    }
-                    rc = 1;
-                }
-            }
-
-            /*
-             * Note we don't look for the destination parameter here.
-             * If we are using NAT, the NAT module will handle it.  If not,
-             * and the client is sending packets elsewhere, the expectation
-             * will quietly time out.
-             */
-
-            off = nextfieldoff;
-        }
+	int     rc = 0;
+	uint    off = 0;
+	
+	if (tranlen < 10 || !iseol(ptran[tranlen-1]) ||
+	    nf_strncasecmp(ptran, "Transport:", 10) != 0) {
+		INFOP("sanity check failed\n");
+		return 0;
+	}
+	
+	DEBUGP("tran='%.*s'\n", (int)tranlen, ptran);
+	off += 10;
+	SKIP_WSPACE(ptran, tranlen, off);
+	
+	/* Transport: tran;field;field=val,tran;field;field=val,... */
+	while (off < tranlen) {
+		const char* pparamend;
+		uint        nextparamoff;
+		
+		pparamend = memchr(ptran+off, ',', tranlen-off);
+		pparamend = (pparamend == NULL) ? ptran+tranlen : pparamend+1;
+		nextparamoff = pparamend-ptran;
+		
+		while (off < nextparamoff) {
+			const char* pfieldend;
+			uint        nextfieldoff;
+			
+			pfieldend = memchr(ptran+off, ';', nextparamoff-off);
+			nextfieldoff = (pfieldend == NULL) ? nextparamoff : pfieldend-ptran+1;
+		   
+			if (strncmp(ptran+off, "client_port=", 12) == 0) {
+				u_int16_t   port;
+				uint        numlen;
+		    
+				off += 12;
+				numlen = nf_strtou16(ptran+off, &port);
+				off += numlen;
+				if (prtspexp->loport != 0 && prtspexp->loport != port)
+					DEBUGP("multiple ports found, port %hu ignored\n", port);
+				else {
+					DEBUGP("lo port found : %hu\n", port);
+					prtspexp->loport = prtspexp->hiport = port;
+					if (ptran[off] == '-') {
+						off++;
+						numlen = nf_strtou16(ptran+off, &port);
+						off += numlen;
+						prtspexp->pbtype = pb_range;
+						prtspexp->hiport = port;
+						
+						// If we have a range, assume rtp:
+						// loport must be even, hiport must be loport+1
+						if ((prtspexp->loport & 0x0001) != 0 ||
+						    prtspexp->hiport != prtspexp->loport+1) {
+							DEBUGP("incorrect range: %hu-%hu, correcting\n",
+							       prtspexp->loport, prtspexp->hiport);
+							prtspexp->loport &= 0xfffe;
+							prtspexp->hiport = prtspexp->loport+1;
+						}
+					} else if (ptran[off] == '/') {
+						off++;
+						numlen = nf_strtou16(ptran+off, &port);
+						off += numlen;
+						prtspexp->pbtype = pb_discon;
+						prtspexp->hiport = port;
+					}
+					rc = 1;
+				}
+			}
+			
+			/*
+			 * Note we don't look for the destination parameter here.
+			 * If we are using NAT, the NAT module will handle it.  If not,
+			 * and the client is sending packets elsewhere, the expectation
+			 * will quietly time out.
+			 */
+			
+			off = nextfieldoff;
+		}
+		
+		off = nextparamoff;
+	}
+	
+	return rc;
+}
 
-        off = nextparamoff;
+void expected(struct ip_conntrack* ct, struct ip_conntrack_expect *exp)
+{
+    if(ip_nat_rtsp_hook_expectfn) {
+        ip_nat_rtsp_hook_expectfn(ct,exp);
     }
-
-    return rc;
 }
 
 /*** conntrack functions ***/
@@ -269,182 +270,177 @@
 help_out(struct sk_buff **pskb, unsigned char *rb_ptr, unsigned int datalen,
                 struct ip_conntrack* ct, enum ip_conntrack_info ctinfo)
 {
-    struct ip_ct_rtsp_expect expinfo;
-    int dir = CTINFO2DIR(ctinfo);   /* = IP_CT_DIR_ORIGINAL */
-    //struct  tcphdr* tcph = (void*)iph + iph->ihl * 4;
-    //uint    tcplen = pktlen - iph->ihl * 4;
-    char*   pdata = rb_ptr;
-    //uint    datalen = tcplen - tcph->doff * 4;
-    uint    dataoff = 0;
-    int ret = NF_ACCEPT;
-
-    struct ip_conntrack_expect *exp;
-
-    memset(&expinfo, 0, sizeof(expinfo));
-
-    while (dataoff < datalen)
-    {
-        uint    cmdoff = dataoff;
-        uint    hdrsoff = 0;
-        uint    hdrslen = 0;
-        uint    cseqoff = 0;
-        uint    cseqlen = 0;
-        uint    lineoff = 0;
-        uint    linelen = 0;
-        uint    off;
-
-        if (!rtsp_parse_message(pdata, datalen, &dataoff,
-                                &hdrsoff, &hdrslen,
-                                &cseqoff, &cseqlen))
-        {
-            break;      /* not a valid message */
-        }
-
-        if (strncmp(pdata+cmdoff, "SETUP ", 6) != 0)
-        {
-            continue;   /* not a SETUP message */
-        }
-        DEBUGP("found a setup message\n");
-
-        off = 0;
-        while (nf_mime_nextline(pdata+hdrsoff, hdrslen, &off,
-                                &lineoff, &linelen))
-        {
-            if (linelen == 0)
-            {
-                break;
-            }
-            if (off > hdrsoff+hdrslen)
-            {
-                INFOP("!! overrun !!");
-                break;
-            }
-
-            if (nf_strncasecmp(pdata+hdrsoff+lineoff, "Transport:", 10) == 0)
-            {
-                rtsp_parse_transport(pdata+hdrsoff+lineoff, linelen, &expinfo);
-            }
-        }
-
-        if (expinfo.loport == 0)
-        {
-            DEBUGP("no udp transports found\n");
-            continue;   /* no udp transports found */
-        }
-
-        DEBUGP("udp transport found, ports=(%d,%hu,%hu)\n",
-              (int)expinfo.pbtype,
-              expinfo.loport,
-              expinfo.hiport);
-
-	exp = ip_conntrack_expect_alloc();
-	if (!exp) {
-		ret = NF_DROP;
+	struct ip_ct_rtsp_expect expinfo;
+	
+	int dir = CTINFO2DIR(ctinfo);   /* = IP_CT_DIR_ORIGINAL */
+	//struct  tcphdr* tcph = (void*)iph + iph->ihl * 4;
+	//uint    tcplen = pktlen - iph->ihl * 4;
+	char*   pdata = rb_ptr;
+	//uint    datalen = tcplen - tcph->doff * 4;
+	uint    dataoff = 0;
+	int ret = NF_ACCEPT;
+	
+	struct ip_conntrack_expect *exp;
+	
+	memset(&expinfo, 0, sizeof(expinfo));
+	
+	while (dataoff < datalen) {
+		uint    cmdoff = dataoff;
+		uint    hdrsoff = 0;
+		uint    hdrslen = 0;
+		uint    cseqoff = 0;
+		uint    cseqlen = 0;
+		uint    transoff = 0;
+		uint    translen = 0;
+		uint    off;
+		
+		if (!rtsp_parse_message(pdata, datalen, &dataoff,
+					&hdrsoff, &hdrslen,
+					&cseqoff, &cseqlen,
+					&transoff, &translen))
+			break;      /* not a valid message */
+		
+		if (strncmp(pdata+cmdoff, "SETUP ", 6) != 0)
+			continue;   /* not a SETUP message */
+		DEBUGP("found a setup message\n");
+
+		off = 0;
+		if(translen) {
+			rtsp_parse_transport(pdata+transoff, translen, &expinfo);
+		}
+
+		if (expinfo.loport == 0) {
+			DEBUGP("no udp transports found\n");
+			continue;   /* no udp transports found */
+		}
+
+		DEBUGP("udp transport found, ports=(%d,%hu,%hu)\n",
+		       (int)expinfo.pbtype, expinfo.loport, expinfo.hiport);
+
+		exp = ip_conntrack_expect_alloc(ct);
+		if (!exp) {
+			ret = NF_DROP;
+			goto out;
+		}
+
+		exp->master = ct;
+
+		exp->expectfn = expected;
+		exp->flags = 0;
+
+		exp->tuple = ((struct ip_conntrack_tuple)
+				{
+					{ ct->tuplehash[!dir].tuple.src.ip,
+						{ 0 } 
+					},
+					{ 	
+						ct->tuplehash[!dir].tuple.dst.ip,
+						{ .udp = { htons(expinfo.loport) } },
+						IPPROTO_UDP 
+					}
+				});
+		exp->mask = ((struct ip_conntrack_tuple)
+				{ 
+					{ 0,
+						{ 0 } 
+					},
+					{
+						0xFFFFFFFF, 
+						{ .udp = { 0xFFFF } }, 0xFF 
+					}
+				});
+		if (expinfo.pbtype == pb_range) {
+			DEBUGP("Changing expectation mask to handle multiple ports\n");
+			exp->mask.dst.u.udp.port  = 0xfffe;
+		}
+
+		DEBUGP("expect_related %u.%u.%u.%u:%u-%u.%u.%u.%u:%u\n",
+		       NIPQUAD(exp->tuple.src.ip),
+		       ntohs(exp->tuple.src.u.udp.port),
+		       NIPQUAD(exp->tuple.dst.ip),
+		       ntohs(exp->tuple.dst.u.udp.port));
+
+		if (ip_nat_rtsp_hook)
+			/* pass the request off to the nat helper */
+			ret = ip_nat_rtsp_hook(pskb, ctinfo, hdrsoff, hdrslen, &expinfo, exp);
+		else if (ip_conntrack_expect_related(exp) != 0) {
+			INFOP("ip_conntrack_expect_related failed\n");
+			ret  = NF_DROP;
+		}
+		ip_conntrack_expect_put(exp);
 		goto out;
 	}
-
-        //exp->seq = ntohl(tcph->seq) + hdrsoff; /* mark all the headers */
-	exp->master = ct;
-        //exp.help.exp_rtsp_info.len = hdrslen;
-
-        exp->tuple.src.ip = ct->tuplehash[!dir].tuple.src.ip;
-        exp->mask.src.ip  = 0xffffffff;
-        exp->tuple.dst.ip = ct->tuplehash[dir].tuple.src.ip;
-        exp->mask.dst.ip  = 0xffffffff;
-        exp->tuple.dst.u.udp.port = expinfo.loport;
-        exp->mask.dst.u.udp.port  = 
-		(expinfo.pbtype == pb_range) ? 0xfffe : 0xffff;
-        exp->tuple.dst.protonum = IPPROTO_UDP;
-        exp->mask.dst.protonum  = 0xff;
-
-        DEBUGP("expect_related %u.%u.%u.%u:%u-%u.%u.%u.%u:%u\n",
-                NIPQUAD(exp->tuple.src.ip),
-                ntohs(exp->tuple.src.u.tcp.port),
-                NIPQUAD(exp->tuple.dst.ip),
-                ntohs(exp->tuple.dst.u.tcp.port));
-
-	if (ip_nat_rtsp_hook)
-        	/* pass the request off to the nat helper */
-		ret = ip_nat_rtsp_hook(pskb, ctinfo, &expinfo, exp);
-	else if (ip_conntrack_expect_related(exp) != 0) {
-  		INFOP("ip_conntrack_expect_related failed\n");
-		ip_conntrack_expect_free(exp);
-		ret  = NF_DROP;
-	}
-	goto out;
-    }
 out:
 
-    return ret;
+	return ret;
 }
 
 /* inbound packet: server->client */
 static inline int
 help_in(struct sk_buff **pskb, size_t pktlen,
-                struct ip_conntrack* ct, enum ip_conntrack_info ctinfo)
+	struct ip_conntrack* ct, enum ip_conntrack_info ctinfo)
 {
-    return NF_ACCEPT;
+	return NF_ACCEPT;
 }
 
 static int help(struct sk_buff **pskb, struct ip_conntrack* ct, enum
 		ip_conntrack_info ctinfo) 
 {
-    struct tcphdr _tcph, *th;
-    unsigned int dataoff, datalen;
-    char *rb_ptr;
-    int ret = NF_DROP;
-
-    /* Until there's been traffic both ways, don't look in packets. */
-    if (ctinfo != IP_CT_ESTABLISHED && 
-	ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY)
-    {
-        DEBUGP("conntrackinfo = %u\n", ctinfo);
-        return NF_ACCEPT;
-    }
+	struct tcphdr _tcph, *th;
+	unsigned int dataoff, datalen;
+	char *rb_ptr;
+	int ret = NF_DROP;
+
+	/* Until there's been traffic both ways, don't look in packets. */
+	if (ctinfo != IP_CT_ESTABLISHED && 
+	    ctinfo != IP_CT_ESTABLISHED + IP_CT_IS_REPLY) {
+		DEBUGP("conntrackinfo = %u\n", ctinfo);
+		return NF_ACCEPT;
+	}
 
-    /* Not whole TCP header? */
-    th = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
-		    	    sizeof(_tcph), &_tcph);
-    if (!th)
-	    return NF_ACCEPT;
+	/* Not whole TCP header? */
+	th = skb_header_pointer(*pskb, (*pskb)->nh.iph->ihl*4,
+				sizeof(_tcph), &_tcph);
+	if (!th)
+		return NF_ACCEPT;
    
-    /* No data ? */
-    dataoff = (*pskb)->nh.iph->ihl*4 + th->doff*4;
-    datalen = (*pskb)->len - dataoff;
-    if (dataoff >= (*pskb)->len)
-	    return NF_ACCEPT;
-
-    spin_lock_bh(&rtsp_buffer_lock);
-    rb_ptr = skb_header_pointer(*pskb, dataoff,
-		    		(*pskb)->len - dataoff, rtsp_buffer);
-    BUG_ON(rb_ptr == NULL);
+	/* No data ? */
+	dataoff = (*pskb)->nh.iph->ihl*4 + th->doff*4;
+	datalen = (*pskb)->len - dataoff;
+	if (dataoff >= (*pskb)->len)
+		return NF_ACCEPT;
+
+	spin_lock_bh(&rtsp_buffer_lock);
+	rb_ptr = skb_header_pointer(*pskb, dataoff,
+				    (*pskb)->len - dataoff, rtsp_buffer);
+	BUG_ON(rb_ptr == NULL);
 
 #if 0
-    /* Checksum invalid?  Ignore. */
-    /* FIXME: Source route IP option packets --RR */
-    if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
-                     csum_partial((char*)tcph, tcplen, 0)))
-    {
-        DEBUGP("bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
-               tcph, tcplen, NIPQUAD(iph->saddr), NIPQUAD(iph->daddr));
-        return NF_ACCEPT;
-    }
+	/* Checksum invalid?  Ignore. */
+	/* FIXME: Source route IP option packets --RR */
+	if (tcp_v4_check(tcph, tcplen, iph->saddr, iph->daddr,
+			 csum_partial((char*)tcph, tcplen, 0)))
+	{
+		DEBUGP("bad csum: %p %u %u.%u.%u.%u %u.%u.%u.%u\n",
+		       tcph, tcplen, NIPQUAD(iph->saddr), NIPQUAD(iph->daddr));
+		return NF_ACCEPT;
+	}
 #endif
 
-    switch (CTINFO2DIR(ctinfo))
-    {
-    case IP_CT_DIR_ORIGINAL:
-        ret = help_out(pskb, rb_ptr, datalen, ct, ctinfo);
-        break;
-    case IP_CT_DIR_REPLY:
-	/* inbound packet: server->client */
-        ret = NF_ACCEPT;
-        break;
-    }
+	switch (CTINFO2DIR(ctinfo)) {
+	case IP_CT_DIR_ORIGINAL:
+		ret = help_out(pskb, rb_ptr, datalen, ct, ctinfo);
+		break;
+	case IP_CT_DIR_REPLY:
+		DEBUGP("IP_CT_DIR_REPLY\n");
+		/* inbound packet: server->client */
+		ret = NF_ACCEPT;
+		break;
+	}
 
-    spin_unlock_bh(&rtsp_buffer_lock);
+	spin_unlock_bh(&rtsp_buffer_lock);
 
-    return ret;
+	return ret;
 }
 
 static struct ip_conntrack_helper rtsp_helpers[MAX_PORTS];
@@ -454,78 +450,77 @@
 static void
 fini(void)
 {
-    int i;
-    for (i = 0; i < num_ports; i++)
-    {
-        DEBUGP("unregistering port %d\n", ports[i]);
-        ip_conntrack_helper_unregister(&rtsp_helpers[i]);
-    }
+	int i;
+	for (i = 0; i < num_ports; i++) {
+		DEBUGP("unregistering port %d\n", ports[i]);
+		ip_conntrack_helper_unregister(&rtsp_helpers[i]);
+	}
+	kfree(rtsp_buffer);
 }
 
 static int __init
 init(void)
 {
-    int i, ret;
-    struct ip_conntrack_helper *hlpr;
-    char *tmpname;
-
-    printk("ip_conntrack_rtsp v" IP_NF_RTSP_VERSION " loading\n");
-
-    if (max_outstanding < 1)
-    {
-        printk("ip_conntrack_rtsp: max_outstanding must be a positive integer\n");
-        return -EBUSY;
-    }
-    if (setup_timeout < 0)
-    {
-        printk("ip_conntrack_rtsp: setup_timeout must be a positive integer\n");
-        return -EBUSY;
-    }
+	int i, ret;
+	struct ip_conntrack_helper *hlpr;
+	char *tmpname;
+
+	printk("ip_conntrack_rtsp v" IP_NF_RTSP_VERSION " loading\n");
+
+	if (max_outstanding < 1) {
+		printk("ip_conntrack_rtsp: max_outstanding must be a positive integer\n");
+		return -EBUSY;
+	}
+	if (setup_timeout < 0) {
+		printk("ip_conntrack_rtsp: setup_timeout must be a positive integer\n");
+		return -EBUSY;
+	}
 
-    /* If no port given, default to standard rtsp port */
-    if (ports[0] == 0)
-    {
-        ports[0] = RTSP_PORT;
-    }
+	rtsp_buffer = kmalloc(65536, GFP_KERNEL);
+	if (!rtsp_buffer) 
+		return -ENOMEM;
+
+	/* If no port given, default to standard rtsp port */
+	if (ports[0] == 0) {
+		ports[0] = RTSP_PORT;
+	}
 
-    for (i = 0; (i < MAX_PORTS) && ports[i]; i++)
-    {
-        hlpr = &rtsp_helpers[i];
-        memset(hlpr, 0, sizeof(struct ip_conntrack_helper));
-        hlpr->tuple.src.u.tcp.port = htons(ports[i]);
-        hlpr->tuple.dst.protonum = IPPROTO_TCP;
-        hlpr->mask.src.u.tcp.port = 0xFFFF;
-        hlpr->mask.dst.protonum = 0xFF;
-        hlpr->max_expected = max_outstanding;
-        hlpr->timeout = setup_timeout;
-        hlpr->me = THIS_MODULE;
-        hlpr->help = help;
-
-        tmpname = &rtsp_names[i][0];
-        if (ports[i] == RTSP_PORT)
-        {
-            sprintf(tmpname, "rtsp");
-        }
-        else
-        {
-            sprintf(tmpname, "rtsp-%d", i);
-        }
-        hlpr->name = tmpname;
-
-        DEBUGP("port #%d: %d\n", i, ports[i]);
-
-        ret = ip_conntrack_helper_register(hlpr);
-
-        if (ret)
-        {
-            printk("ip_conntrack_rtsp: ERROR registering port %d\n", ports[i]);
-            fini();
-            return -EBUSY;
-        }
-        num_ports++;
-    }
-    return 0;
+	for (i = 0; (i < MAX_PORTS) && ports[i]; i++) {
+		hlpr = &rtsp_helpers[i];
+		memset(hlpr, 0, sizeof(struct ip_conntrack_helper));
+		hlpr->tuple.src.u.tcp.port = htons(ports[i]);
+		hlpr->tuple.dst.protonum = IPPROTO_TCP;
+		hlpr->mask.src.u.tcp.port = 0xFFFF;
+		hlpr->mask.dst.protonum = 0xFF;
+		hlpr->max_expected = max_outstanding;
+		hlpr->timeout = setup_timeout;
+		hlpr->me = THIS_MODULE;
+		hlpr->help = help;
+
+		tmpname = &rtsp_names[i][0];
+		if (ports[i] == RTSP_PORT) {
+			sprintf(tmpname, "rtsp");
+		} else {
+			sprintf(tmpname, "rtsp-%d", i);
+		}
+		hlpr->name = tmpname;
+
+		DEBUGP("port #%d: %d\n", i, ports[i]);
+
+		ret = ip_conntrack_helper_register(hlpr);
+
+		if (ret) {
+			printk("ip_conntrack_rtsp: ERROR registering port %d\n", ports[i]);
+			fini();
+			return -EBUSY;
+		}
+		num_ports++;
+	}
+	return 0;
 }
 
 module_init(init);
 module_exit(fini);
+
+EXPORT_SYMBOL(ip_nat_rtsp_hook_expectfn);
+
diff -Naur patch-o-matic-ng-20060913/patchlets/rtsp-conntrack/linux-2.6.11/net/ipv4/netfilter/ip_nat_rtsp.c patch-o-matic-ng-20060913-patched-rtsp/patchlets/rtsp-conntrack/linux-2.6.11/net/ipv4/netfilter/ip_nat_rtsp.c
--- patch-o-matic-ng-20060913/patchlets/rtsp-conntrack/linux-2.6.11/net/ipv4/netfilter/ip_nat_rtsp.c	2006-05-10 19:42:57.000000000 +0200
+++ patch-o-matic-ng-20060913-patched-rtsp/patchlets/rtsp-conntrack/linux-2.6.11/net/ipv4/netfilter/ip_nat_rtsp.c	2006-09-15 09:52:51.475419664 +0200
@@ -51,6 +51,7 @@
 #include <linux/netfilter_mime.h>
 
 #define INFOP(fmt, args...) printk(KERN_INFO "%s: %s: " fmt, __FILE__, __FUNCTION__ , ## args)
+#define IP_NF_RTSP_DEBUG
 #ifdef IP_NF_RTSP_DEBUG
 #define DEBUGP(fmt, args...) printk(KERN_DEBUG "%s: %s: " fmt, __FILE__, __FUNCTION__ , ## args)
 #else
@@ -62,11 +63,9 @@
 #define DSTACT_STRIP    1
 #define DSTACT_NONE     2
 
-static int      ports[MAX_PORTS];
 static char*    stunaddr = NULL;
 static char*    destaction = NULL;
 
-static int       num_ports = 0;
 static u_int32_t extip = 0;
 static int       dstact = 0;
 
@@ -164,7 +163,7 @@
         for (loport = prtspexp->loport; loport != 0; loport++) /* XXX: improper wrap? */
         {
             t.dst.u.udp.port = htons(loport);
-            if (ip_conntrack_change_expect(exp, &t) == 0)
+            if (ip_conntrack_expect_related(exp) == 0)
             {
                 DEBUGP("using port %hu\n", loport);
                 break;
@@ -180,7 +179,7 @@
         for (loport = prtspexp->loport; loport != 0; loport += 2) /* XXX: improper wrap? */
         {
             t.dst.u.udp.port = htons(loport);
-            if (ip_conntrack_change_expect(exp, &t) == 0)
+            if (ip_conntrack_expect_related(exp) == 0)
             {
                 hiport = loport + ~exp->mask.dst.u.udp.port;
                 DEBUGP("using ports %hu-%hu\n", loport, hiport);
@@ -197,7 +196,7 @@
         for (loport = prtspexp->loport; loport != 0; loport++) /* XXX: improper wrap? */
         {
             t.dst.u.udp.port = htons(loport);
-            if (ip_conntrack_change_expect(exp, &t) == 0)
+            if (ip_conntrack_expect_related(exp) == 0)
             {
                 DEBUGP("using port %hu (1 of 2)\n", loport);
                 break;
@@ -206,7 +205,7 @@
         for (hiport = prtspexp->hiport; hiport != 0; hiport++) /* XXX: improper wrap? */
         {
             t.dst.u.udp.port = htons(hiport);
-            if (ip_conntrack_change_expect(exp, &t) == 0)
+            if (ip_conntrack_expect_related(exp) == 0)
             {
                 DEBUGP("using port %hu (2 of 2)\n", hiport);
                 break;
@@ -362,37 +361,9 @@
     return 1;
 }
 
-static unsigned int
-expected(struct sk_buff **pskb, uint hooknum, struct ip_conntrack* ct, struct ip_nat_info* info)
-{
-    struct ip_nat_multi_range mr;
-    u_int32_t newdstip, newsrcip, newip;
-
-    struct ip_conntrack *master = master_ct(ct);
-
-    IP_NF_ASSERT(info);
-    IP_NF_ASSERT(master);
-
-    IP_NF_ASSERT(!(info->initialized & (1 << HOOK2MANIP(hooknum))));
-
-    newdstip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-    newsrcip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
-    newip = (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC) ? newsrcip : newdstip;
-
-    DEBUGP("newsrcip=%u.%u.%u.%u, newdstip=%u.%u.%u.%u, newip=%u.%u.%u.%u\n",
-           NIPQUAD(newsrcip), NIPQUAD(newdstip), NIPQUAD(newip));
-
-    mr.rangesize = 1;
-    /* We don't want to manip the per-protocol, just the IPs. */
-    mr.range[0].flags = IP_NAT_RANGE_MAP_IPS;
-    mr.range[0].min_ip = mr.range[0].max_ip = newip;
-
-    return ip_nat_setup_info(ct, &mr, hooknum);
-}
-
 static uint
 help_out(struct sk_buff **pskb, enum ip_conntrack_info ctinfo,
-	 struct ip_ct_rtsp_expect *prtspexp,
+	 unsigned int matchoff, unsigned int matchlen,struct ip_ct_rtsp_expect* prtspexp,
          struct ip_conntrack_expect* exp)
 {
     char*   ptcp;
@@ -407,10 +378,10 @@
     struct tcphdr* tcph = (struct tcphdr*)((void*)iph + iph->ihl*4);
 
     get_skb_tcpdata(*pskb, &ptcp, &tcplen);
-
-    hdrsoff = exp->seq - ntohl(tcph->seq);
-    hdrslen = prtspexp->len;
+    hdrsoff = matchoff;//exp->seq - ntohl(tcph->seq);
+    hdrslen = matchlen;
     off = hdrsoff;
+    DEBUGP("NAT rtsp help_out\n");
 
     while (nf_mime_nextline(ptcp, hdrsoff+hdrslen, &off, &lineoff, &linelen))
     {
@@ -428,8 +399,10 @@
         if (nf_strncasecmp(ptcp+lineoff, "Transport:", 10) == 0)
         {
             uint oldtcplen = tcplen;
-            if (!rtsp_mangle_tran(ct, ctinfo, exp, prtspexp, pskb, lineoff, linelen))
+	    DEBUGP("hdr: Transport\n");
+            if (!rtsp_mangle_tran(ctinfo, exp, prtspexp, pskb, lineoff, linelen))
             {
+		DEBUGP("hdr: Transport mangle failed");
                 break;
             }
             get_skb_tcpdata(*pskb, &ptcp, &tcplen);
@@ -444,35 +417,59 @@
     return NF_ACCEPT;
 }
 
-static int
-help(struct sk_buff **pskb,
-     enum ip_conntrack_info ctinfo,
-     struct ip_ct_rtsp_expect *ct_rtsp_info;
+static unsigned int
+help(struct sk_buff **pskb, enum ip_conntrack_info ctinfo, 
+     unsigned int matchoff, unsigned int matchlen,struct ip_ct_rtsp_expect* prtspexp,
      struct ip_conntrack_expect* exp)
 {
-    struct iphdr*  iph  = (struct iphdr*)(*pskb)->nh.iph;
-    struct tcphdr* tcph = (struct tcphdr*)((char*)iph + iph->ihl * 4);
-    uint datalen;
     int dir = CTINFO2DIR(ctinfo);
     int rc = NF_ACCEPT;
 
     switch (dir)
     {
     case IP_CT_DIR_ORIGINAL:
-        rc = help_out(pskb, ctinfo, ct_rtsp_info, exp, pskb);
+        rc = help_out(pskb, ctinfo, matchoff, matchlen, prtspexp, exp);
         break;
     case IP_CT_DIR_REPLY:
+	DEBUGP("unmangle ! %u\n", ctinfo);
     	/* XXX: unmangle */
 	rc = NF_ACCEPT;
         break;
     }
+    //UNLOCK_BH(&ip_rtsp_lock);
 
     return rc;
 }
 
+static void expected(struct ip_conntrack* ct, struct ip_conntrack_expect *exp)
+{
+    struct ip_nat_multi_range_compat mr;
+    u_int32_t newdstip, newsrcip, newip;
+
+    struct ip_conntrack *master = master_ct(ct);
+
+    newdstip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+    newsrcip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
+    //FIXME (how to port that ?)
+    //code from 2.4 : newip = (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC) ? newsrcip : newdstip;
+    newip = newdstip;
+
+    DEBUGP("newsrcip=%u.%u.%u.%u, newdstip=%u.%u.%u.%u, newip=%u.%u.%u.%u\n",
+           NIPQUAD(newsrcip), NIPQUAD(newdstip), NIPQUAD(newip));
+
+    mr.rangesize = 1;
+    // We don't want to manip the per-protocol, just the IPs. 
+    mr.range[0].flags = IP_NAT_RANGE_MAP_IPS;
+    mr.range[0].min_ip = mr.range[0].max_ip = newip;
+
+    ip_nat_setup_info(ct, &mr.range[0], NF_IP_PRE_ROUTING);
+}
+
+
 static void __exit fini(void)
 {
 	ip_nat_rtsp_hook = NULL;
+        ip_nat_rtsp_hook_expectfn = NULL;
 	synchronize_net();
 }
 
@@ -482,6 +479,7 @@
 
 	BUG_ON(ip_nat_rtsp_hook);
 	ip_nat_rtsp_hook = help;
+        ip_nat_rtsp_hook_expectfn = &expected;
 
 	if (stunaddr != NULL)
 		extip = in_aton(stunaddr);
@@ -496,6 +494,7 @@
 		if (strcmp(destaction, "none") == 0)
 			dstact = DSTACT_NONE;
 	}
+
 	return 0;
 }
 

--0OAP2g/MAC+5xKAE--
