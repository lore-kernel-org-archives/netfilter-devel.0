From: Stephane Ouellette <ouellettes@videotron.ca>
Subject: [TRIVIAL][TYPO]  Trivial typo in NETLINK target help file
Date: Sat, 14 Aug 2004 23:56:38 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411EDEF6.4090204@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_l7NGRfreG88rZJjtaFb/Mw)"
Cc: Netfilter Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
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

--Boundary_(ID_l7NGRfreG88rZJjtaFb/Mw)
Content-type: text/plain; charset=us-ascii; format=flowed
Content-transfer-encoding: 7BIT

Harald,

   here's a trivial patch that fixes a typo in p-o-m.

Stephane.


--Boundary_(ID_l7NGRfreG88rZJjtaFb/Mw)
Content-type: text/plain; name=NETLINK_help.diff; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=NETLINK_help.diff

--- patch-o-matic-ng-20040621/NETLINK/help	Sat Dec 20 11:19:17 2003
+++ patch-o-matic-ng-fixed/NETLINK/help	Mon Aug  9 23:42:23 2004
@@ -1,4 +1,4 @@
 CONFIG_IP_NF_TARGET_NETLINK adds a NETLINK target that sends dropped packets to
 userspace via a netlink socket.  Apps such as fwmon
-(http://firestorm.geek-ware.co.uk) can then recieve and dislpay these packets.
+(http://firestorm.geek-ware.co.uk) can then receive and display these packets.
 This option is basically a re-implementation of the ipchains -o option.

--Boundary_(ID_l7NGRfreG88rZJjtaFb/Mw)--
