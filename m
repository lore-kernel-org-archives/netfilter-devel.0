From: "Jaroslaw J. Pyszny" <arghil@tlen.pl>
Subject: [PATCH] libipt_ecn.c fix
Date: Wed, 6 Nov 2002 20:06:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021106190634.GB1897@szalony.siec>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NDin8bjvE/0mNLFQ"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

  IPTables (userspace) 1.2.7a (CVS) 
  I think `print_dscp(.....)' is not needed in libipt_ecn.c
  

Best regards,
  Jarek
 
-- 
8   \\|||//           Jaroslaw J. Pyszny         \\|||//
b    (o|o)       "Vitae,non scholae,discimus"     (o|o)
i   --\_/--        arghil@zsk.tech.us.edu.pl     --\_/-- 
t =-> Masz 8-bit. komputer i chcesz siê go pozbyæ daj znaæ. <-=

--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-1.2.7a-ipt_ecn.patch"

diff -urN userspace/extensions/libipt_ecn.c userspace.new/extensions/libipt_ecn.c
--- userspace/extensions/libipt_ecn.c	Mon Aug  5 22:24:55 2002
+++ userspace.new/extensions/libipt_ecn.c	Wed Nov  6 19:38:26 2002
@@ -100,15 +100,6 @@
 		           "ECN match: some option required");
 }
 
-static void
-print_dscp(u_int8_t dscp, int invert, int numeric)
-{
-	if (invert)
-		fputc('!', stdout);
-
- 	printf("0x%02x ", dscp);
-}
-
 /* Prints out the matchinfo. */
 static void
 print(const struct ipt_ip *ip,

--NDin8bjvE/0mNLFQ--
