From: Felipe W Damasio <felipewd@terra.com.br>
Subject: [PATCH 9/9] Remove unneeded linux/version.h from net/ipv4/netfilter/ip_nat_standalone
Date: Fri, 29 Aug 2003 17:09:31 -0300
Sender: kernel-janitor-discuss-admin@lists.sourceforge.net
Message-ID: <3F4FB2FB.1050900@terra.com.br>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070201010204040400000500"
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
--------------070201010204040400000500
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

	Based on Randy's modified checkversion.pl script.

	Compile fine against 2.6.0-test4.

	Please consider applying.

	Cheers,

Felipe

--------------070201010204040400000500
Content-Type: text/plain;
 name="ip_nat_standalone.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_nat_standalone.patch"

--- linux-2.6.0-test4/net/ipv4/netfilter/ip_nat_standalone.c.orig	Fri Aug 29 16:44:54 2003
+++ linux-2.6.0-test4/net/ipv4/netfilter/ip_nat_standalone.c	Fri Aug 29 16:45:01 2003
@@ -23,7 +23,6 @@
 #include <linux/proc_fs.h>
 #include <net/checksum.h>
 #include <linux/spinlock.h>
-#include <linux/version.h>
 
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_nat_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_nat_lock)

--------------070201010204040400000500--



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
