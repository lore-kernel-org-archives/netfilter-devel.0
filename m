From: Thomas Woerner <twoerner@redhat.com>
Subject: [PATCH] ip6tables-save and udp port range
Date: Tue, 23 Sep 2003 11:21:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F701080.80203@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020404060503070001040209"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------020404060503070001040209
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Hello,


ip6tables-save is not saving an udp port range if one of the ports is 
0x0 or 0xFFFF. This is aleady fixed in the ipv4 version.

I have attached the patch.


Thanks in advance
Thomas Woerner


-- 
Thomas Woerner, Software Engineer      Phone: +49-711-96437-0
Red Hat GmbH                           Fax  : +49-711-96437-111
Hauptstaetterstr. 58                   Email: twoerner@redhat.com
D-70178 Stuttgart                      Web  : http://www.redhat.de/

--------------020404060503070001040209
Content-Type: text/plain;
 name="iptables-1.2.8-save_ports.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-1.2.8-save_ports.patch"

--- iptables-1.2.8/extensions/libip6t_udp.c.save_ports	2003-09-17 16:11:40.000000000 +0200
+++ iptables-1.2.8/extensions/libip6t_udp.c	2003-09-17 16:27:17.000000000 +0200
@@ -205,7 +205,7 @@
 	const struct ip6t_udp *udpinfo = (struct ip6t_udp *)match->data;
 
 	if (udpinfo->spts[0] != 0
-	    && udpinfo->spts[1] != 0xFFFF) {
+	    || udpinfo->spts[1] != 0xFFFF) {
 		if (udpinfo->invflags & IP6T_UDP_INV_SRCPT)
 			printf("! ");
 		if (udpinfo->spts[0]
@@ -219,7 +219,7 @@
 	}
 
 	if (udpinfo->dpts[0] != 0
-	    && udpinfo->dpts[1] != 0xFFFF) {
+	    || udpinfo->dpts[1] != 0xFFFF) {
 		if (udpinfo->invflags & IP6T_UDP_INV_DSTPT)
 			printf("! ");
 		if (udpinfo->dpts[0]

--------------020404060503070001040209--
