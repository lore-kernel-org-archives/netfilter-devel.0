From: Felipe W Damasio <felipewd@terra.com.br>
Subject: [PATCH 3/9] Remove unneeded linux/version.h from net/ipv4/netfilter/ipfwadm_core
Date: Fri, 29 Aug 2003 17:09:03 -0300
Sender: kernel-janitor-discuss-admin@lists.sourceforge.net
Message-ID: <3F4FB2DF.3090903@terra.com.br>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070703010107040306020004"
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
--------------070703010107040306020004
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

	Based on Randy's modified checkversion.pl script.

	Compile fine against 2.6.0-test4.

	Please consider applying.

	Cheers,

Felipe

--------------070703010107040306020004
Content-Type: text/plain;
 name="ipfwadm_core.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipfwadm_core.patch"

--- linux-2.6.0-test4/net/ipv4/netfilter/ipfwadm_core.c.orig	Fri Aug 29 16:45:40 2003
+++ linux-2.6.0-test4/net/ipv4/netfilter/ipfwadm_core.c	Fri Aug 29 16:45:53 2003
@@ -131,7 +131,6 @@
 #include <net/checksum.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
-#include <linux/version.h>
 
 MODULE_LICENSE("Dual BSD/GPL");
 

--------------070703010107040306020004--



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
