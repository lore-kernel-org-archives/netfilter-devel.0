From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: [PATCH] bug in ipt_unclean, fragments
Date: Thu, 8 May 2003 00:34:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030507223405.GH30808@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following part of ipt_unclean.c is not correct:

/* CHECK: More fragments, but doesn't fill 8-byte boundary. */
if ((ntohs(iph->frag_off) & IP_MF)
   && (ntohs(iph->tot_len) % 8) != 0) {
      limpk("Truncated fragment %u long.\n", ntohs(iph->tot_len));
      return 0;
}

Fragments must be 8-byte alligned only by its payload, not the entire
packet. This bug has effectly killed almost _all_ fragments before. Its easy
to test with a ping with -s with an argument larger than 1472. Noone will
get through if you match by the old ipt_unclean.

-------

Also below part doesn't allow use to use the DF (dont fragment bit) when
already fragmented. This must be wrong. Since mounting root over nfs at
linux kernel boot uses it:

/* CHECK: DF set and offset or MF set. */
if ((ntohs(iph->frag_off) & IP_DF)
   && (offset || (ntohs(iph->frag_off) & IP_MF))) {
      limpk("DF set and offset=%u, MF=%u.\n",
      offset, ntohs(iph->frag_off) & IP_MF);
      return 0;
}


May  8 00:24:40 zelda kernel: ipt_unclean: DF set and offset=185, MF=8192.
May  8 00:24:40 zelda kernel: FW raw bond0_unclean IN=bond0 OUT=
MAC=00:80:c8:b9:33:a6:00:40:63:c0:e9:e3:08:00 SRC=10.20.1.4
DST=193.11.248.120 LEN=1500 TOS=0x00 PREC=0x00 TTL=64 ID=19567 DF MF
FRAG:185 PROTO=UDP 
May  8 00:24:40 zelda kernel: ipt_unclean: DF set and offset=0, MF=8192.
May  8 00:24:40 zelda kernel: FW raw bond0_unclean IN=bond0 OUT=
MAC=00:80:c8:b9:33:a6:00:40:63:c0:e9:e3:08:00 SRC=10.20.1.4
DST=193.11.248.120 LEN=1500 TOS=0x00 PREC=0x00 TTL=64 ID=19567 DF MF
PROTO=UDP SPT=800 DPT=2049 LEN=4224 
May  8 00:24:40 zelda kernel: ipt_unclean: DF set and offset=370, MF=0.
May  8 00:24:40 zelda kernel: FW raw bond0_unclean IN=bond0 OUT=
MAC=00:80:c8:b9:33:a6:00:40:63:c0:e9:e3:08:00 SRC=10.20.1.4
DST=193.11.248.120 LEN=152 TOS=0x00 PREC=0x00 TTL=64 ID=19568 DF FRAG:370
PROTO=UDP 
May  8 00:24:40 zelda kernel: ipt_unclean: DF set and offset=185, MF=8192.
May  8 00:24:40 zelda kernel: FW raw bond0_unclean IN=bond0 OUT=
MAC=00:80:c8:b9:33:a6:00:40:63:c0:e9:e3:08:00 SRC=10.20.1.4
DST=193.11.248.120 LEN=1500 TOS=0x00 PREC=0x00 TTL=64 ID=19568 DF MF
FRAG:185 PROTO=UDP 
May  8 00:24:40 zelda kernel: ipt_unclean: DF set and offset=0, MF=8192.
May  8 00:24:52 zelda kernel: ipt_unclean: DF set and offset=370, MF=0.
May  8 00:24:52 zelda kernel: FW raw bond0_unclean IN=bond0 OUT=
MAC=00:80:c8:b9:33:a6:00:40:63:c0:e9:e3:08:00 SRC=10.20.1.4
DST=193.11.248.120 LEN=1284 TOS=0x00 PREC=0x00 TTL=64 ID=19569 DF FRAG:370
PROTO=UDP 
May  8 00:24:52 zelda kernel: ipt_unclean: DF set and offset=185, MF=8192.
May  8 00:24:52 zelda kernel: FW raw bond0_unclean IN=bond0 OUT=
MAC=00:80:c8:b9:33:a6:00:40:63:c0:e9:e3:08:00 SRC=10.20.1.4
DST=193.11.248.120 LEN=1500 TOS=0x00 PREC=0x00 TTL=64 ID=19569 DF MF
FRAG:185 PROTO=UDP 


--------

Patch is below (also attached):

-- /home/gozem/ipt_unclean.c	2003-05-08 00:08:44.000000000 +0200
+++ net/ipv4/netfilter/ipt_unclean.c	2003-05-08 00:29:16.000000000 +0200
@@ -462,8 +462,8 @@
 
 	/* CHECK: More fragments, but doesn't fill 8-byte boundary. */
 	if ((ntohs(iph->frag_off) & IP_MF)
-	    && (ntohs(iph->tot_len) % 8) != 0) {
-		limpk("Truncated fragment %u long.\n", ntohs(iph->tot_len));
+	    && ( (ntohs(iph->tot_len) - iph->ihl*4) % 8 ) != 0) {
+		limpk("Truncated fragment %u long.\n", ntohs(iph->tot_len) - iph->ihl*4);
 		return 0;
 	}
 
@@ -473,14 +473,6 @@
 		return 0;
 	}
 
-	/* CHECK: DF set and offset or MF set. */
-	if ((ntohs(iph->frag_off) & IP_DF)
-	    && (offset || (ntohs(iph->frag_off) & IP_MF))) {
-		limpk("DF set and offset=%u, MF=%u.\n",
-		      offset, ntohs(iph->frag_off) & IP_MF);
-		return 0;
-	}
-
 	/* CHECK: Zero-sized fragments. */
 	if ((offset || (ntohs(iph->frag_off) & IP_MF))
 	    && datalen == 0) {

 
-- 
/Joakim Axelsson A.K.A Gozem@EFnet

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ipt_unclean.patch"

--- /home/gozem/ipt_unclean.c	2003-05-08 00:08:44.000000000 +0200
+++ net/ipv4/netfilter/ipt_unclean.c	2003-05-08 00:29:16.000000000 +0200
@@ -462,8 +462,8 @@
 
 	/* CHECK: More fragments, but doesn't fill 8-byte boundary. */
 	if ((ntohs(iph->frag_off) & IP_MF)
-	    && (ntohs(iph->tot_len) % 8) != 0) {
-		limpk("Truncated fragment %u long.\n", ntohs(iph->tot_len));
+	    && ( (ntohs(iph->tot_len) - iph->ihl*4) % 8 ) != 0) {
+		limpk("Truncated fragment %u long.\n", ntohs(iph->tot_len) - iph->ihl*4);
 		return 0;
 	}
 
@@ -473,14 +473,6 @@
 		return 0;
 	}
 
-	/* CHECK: DF set and offset or MF set. */
-	if ((ntohs(iph->frag_off) & IP_DF)
-	    && (offset || (ntohs(iph->frag_off) & IP_MF))) {
-		limpk("DF set and offset=%u, MF=%u.\n",
-		      offset, ntohs(iph->frag_off) & IP_MF);
-		return 0;
-	}
-
 	/* CHECK: Zero-sized fragments. */
 	if ((offset || (ntohs(iph->frag_off) & IP_MF))
 	    && datalen == 0) {

--SLDf9lqlvOQaIe6s--
