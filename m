From: Michael Rash <mbr@cipherdyne.org>
Subject: [PATCH] --log-ip-options broken in 2.4
Date: Sat, 29 Jan 2005 02:04:23 -0500
Message-ID: <20050129070423.GA25755@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

It looks like --log-ip-options is broken in 2.4, i.e. the OPT field
never appears in Netfilter logs even when packets contain IP options.
I have attached a small patch that fixes this.  It removes the
"iph->ihl * 4 >= datalen" condition, which rarely happens ("ping -T
tsonly -s 1 <host>" will trigger it for example).  The resulting code is
analogous to the code in the 2.6 kernel.

This is for Netfilter bugzilla # 288.

Thanks,

--Mike

Michael Rash
http://www.cipherdyne.org/
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ipt_LOG.c_ipoptions.patch"

--- linux-2.4.29.orig/net/ipv4/netfilter/ipt_LOG.c      2005-01-29 01:55:29.000000000 -0500
+++ linux-2.4.29/net/ipv4/netfilter/ipt_LOG.c   2005-01-29 01:50:36.000000000 -0500
@@ -67,8 +67,7 @@
                printk("FRAG:%u ", ntohs(iph->frag_off) & IP_OFFSET);

        if ((info->logflags & IPT_LOG_IPOPT)
-           && iph->ihl * 4 != sizeof(struct iphdr)
-           && iph->ihl * 4 >= datalen) {
+           && iph->ihl * 4 > sizeof(struct iphdr)) {
                unsigned int i;

                /* Max length: 127 "OPT (" 15*4*2chars ") " */


--fdj2RfSjLxBAspz7--
