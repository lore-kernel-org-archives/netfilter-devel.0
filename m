From: Felipe W Damasio <felipewd@terra.com.br>
Subject: [PATCH 2/9] Remove unneeded linux/version.h from net/ipv4/netfilter/ip_conntrack_standalone
Date: Fri, 29 Aug 2003 17:09:00 -0300
Sender: kernel-janitor-discuss-admin@lists.sourceforge.net
Message-ID: <3F4FB2DC.50006@terra.com.br>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030207070504020807030206"
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
--------------030207070504020807030206
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

	Based on Randy's modified checkversion.pl script.

	Compile fine against 2.6.0-test4.

	Please consider applying.

	Cheers,

Felipe

--------------030207070504020807030206
Content-Type: text/plain;
 name="ip_conntrack_standalone.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_standalone.patch"

--- linux-2.6.0-test4/net/ipv4/netfilter/ip_conntrack_standalone.c.orig	Fri Aug 29 16:44:23 2003
+++ linux-2.6.0-test4/net/ipv4/netfilter/ip_conntrack_standalone.c	Fri Aug 29 16:44:28 2003
@@ -14,7 +14,6 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
-#include <linux/version.h>
 #include <net/checksum.h>
 
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)

--------------030207070504020807030206--



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
