From: Felipe W Damasio <felipewd@terra.com.br>
Subject: [PATCH 7/9] Remove unneeded linux/version.h from net/ipv4/netfilter/ip_nat_helper
Date: Fri, 29 Aug 2003 17:09:26 -0300
Sender: kernel-janitor-discuss-admin@lists.sourceforge.net
Message-ID: <3F4FB2F6.1070107@terra.com.br>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090807070407030300040301"
Return-path: <kernel-janitor-discuss-admin@lists.sourceforge.net>
To: netfilter-devel@lists.netfilter.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	kernel-janitor-discuss@lists.sourceforge.net
Errors-To: kernel-janitor-discuss-admin@lists.sourceforge.net
List-Help: <mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:kernel-janitor-discuss@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/kernel-janitor-discuss>,
	<mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/kernel-janitor-discuss>,
	<mailto:kernel-janitor-discuss-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=kernel-janitor-discuss>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090807070407030300040301
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

	Based on Randy's modified checkversion.pl script.

	Compile fine against 2.6.0-test4.

	Please consider applying.

	Cheers,

Felipe

--------------090807070407030300040301
Content-Type: text/plain;
 name="ip_nat_helper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_nat_helper.patch"

--- linux-2.6.0-test4/net/ipv4/netfilter/ip_nat_helper.c.orig	Fri Aug 29 16:45:27 2003
+++ linux-2.6.0-test4/net/ipv4/netfilter/ip_nat_helper.c	Fri Aug 29 16:45:31 2003
@@ -12,7 +12,6 @@
  *		- make ip_nat_resize_packet more generic (TCP and UDP)
  *		- add ip_nat_mangle_udp_packet
  */
-#include <linux/version.h>
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/kmod.h>

--------------090807070407030300040301--



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
