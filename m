From: Kiran Kumar Immidi <immidi@spymac.com>
Subject: Re: sctp conntrack
Date: Mon, 2 Aug 2004 15:55:38 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200408021555.38315.immidi@spymac.com>
References: <20040722191649.GJ14946@obroa-skai.de.gnumonks.org> <200407271348.34615.immidi@spymac.com> <20040801165005.GA14539@sunbeam2>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iahDBK5sYTuv8ep"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040801165005.GA14539@sunbeam2>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_iahDBK5sYTuv8ep
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 01 August 2004 10:20 pm, Harald Welte wrote:

> > - The type of these timeouts in case of TCP is unsigned long, though the
> > code in ip_conntrack_standalone.c treats them as unsigned int. I am not
> > sure of the working, but I suspect something wrong here. I have followed
> > the same pattern however.
>
> yes, indeed. on 64bit archs this is going to cause trouble :(

  Do you want me to make a patch for this?

  Attached is a patch which adds SCTP support for the LOG target. This applies 
against 2.6.7 sources. (I had sent this patch earlier, but that one seems to 
have problems.. this is fine).
--Boundary-00=_iahDBK5sYTuv8ep
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="ipt_LOG.c_sctp.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="ipt_LOG.c_sctp.diff"

--- linux-2.6.7/net/ipv4/netfilter/ipt_LOG.c.orig	2004-08-02 15:44:29.009342792 +0530
+++ linux-2.6.7/net/ipv4/netfilter/ipt_LOG.c	2004-08-02 15:45:08.014413120 +0530
@@ -17,6 +17,7 @@
 #include <net/icmp.h>
 #include <net/udp.h>
 #include <net/tcp.h>
+#include <linux/sctp.h>
 #include <net/route.h>
 
 #include <linux/netfilter.h>
@@ -310,6 +311,90 @@
 		printk("SPI=0x%x ", ntohl(esph.spi));
 		break;
 	}
+	case IPPROTO_SCTP: {
+			u_int32_t offset, count;
+			sctp_sctphdr_t sh;
+			sctp_chunkhdr_t sch;
+
+			const char *sctp_chunk_names[255] = {
+			 [0]    = "DATA",
+			 [1]    = "INIT",
+			 [2]    = "INIT_ACK",
+			 [3]    = "SACK",
+			 [4]    = "HEARTBEAT",
+			 [5]    = "HEARTBEAT_ACK",
+			 [6]    = "ABORT",
+			 [7]    = "SHUTDOWN",
+			 [8]    = "SHUTDOWN_ACK",
+			 [9]    = "ERROR",
+			 [10]   = "COOKIE_ECHO",
+			 [11]   = "COOKIE_ACK",
+			 [12]   = "ECN_ECNE",
+			 [13]   = "ECN_CWR",
+			 [14]   = "SHUTDOWN_COMPLETE",
+			 [0xc1] = "ASCONF",
+			 [0x80] = "ASCONF_ACK",
+			};
+
+		/* Max length: 11 "PROTO=SCTP " */
+		printk("PROTO=SCTP ");
+
+		if (ntohs(iph.frag_off) & IP_OFFSET)
+			break;
+
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		if (skb_copy_bits(skb, iphoff+iph.ihl*4, &sh, sizeof(sh))
+		    < 0) {
+			printk("INCOMPLETE [%u bytes] ",
+			       skb->len - iphoff - iph.ihl*4);
+			break;
+		}
+
+		/* Max length: 20 "SPT=65535 DPT=65535 " */
+		printk("SPT=%u DPT=%u ",
+		       ntohs(sh.source), ntohs(sh.dest));
+
+		printk("Chunks: ");
+		count = 0;
+		for (offset = iph.ihl * 4 + sizeof (sctp_sctphdr_t) + iphoff;
+			offset < skb->len;
+			offset += (htons(sch.length) + 3) & ~3, count++) {
+			if (skb_copy_bits(skb, offset, &sch, 
+				sizeof(sch)) < 0) {
+				printk("INCOMPLETE CHUNK HDR[%u bytes] ",
+					skb->len - iphoff - iph.ihl*4);
+				break;
+			}
+			printk("%s",sctp_chunk_names[sch.type]? 
+				sctp_chunk_names[sch.type]: "UNKNOWN");
+
+			/* Print the chunk flags */
+			if (sch.type == SCTP_CID_DATA) {
+				char u,b,e;
+
+				u = b = e = 0;
+				if (sch.flags & 1) e = 1;
+				if (sch.flags & 2) b = 1;
+				if (sch.flags & 4) u = 1;
+
+				if (u || b || e) {
+					printk("[");
+					u && printk("U");
+					b && printk("B");
+					e && printk("E");
+					printk("]");
+				}
+			} else if (sch.type == SCTP_CID_ABORT 
+				|| sch.type == SCTP_CID_SHUTDOWN_COMPLETE) {
+				if (sch.flags & 1) {
+					printk("[T]");
+				}
+			}
+			printk(" ");
+		}
+		printk(": %d chunk%s ", count, (count == 1)? "": "s");
+		break;
+	}
 	/* Max length: 10 "PROTO 255 " */
 	default:
 		printk("PROTO=%u ", iph.protocol);

--Boundary-00=_iahDBK5sYTuv8ep--
