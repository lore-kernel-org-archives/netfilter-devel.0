From: Felipe W Damasio <felipewd@terra.com.br>
Subject: [PATCH 6/9] Remove unneeded linux/version.h from net/ipv4/netfilter/ip_nat_core
Date: Fri, 29 Aug 2003 17:09:18 -0300
Sender: kernel-janitor-discuss-admin@lists.sourceforge.net
Message-ID: <3F4FB2EE.8080509@terra.com.br>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090505070401040800000800"
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
--------------090505070401040800000800
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

	Based on Randy's modified checkversion.pl script.

	Compile fine against 2.6.0-test4.

	Please consider applying.

	Cheers,

Felipe

--------------090505070401040800000800
Content-Type: text/plain;
 name="ip_nat_core.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_nat_core.patch"

--- linux-2.6.0-test4/net/ipv4/netfilter/ip_nat_core.c.orig	Fri Aug 29 16:44:38 2003
+++ linux-2.6.0-test4/net/ipv4/netfilter/ip_nat_core.c	Fri Aug 29 16:44:44 2003
@@ -2,7 +2,6 @@
 
 /* (c) 1999 Paul `Rusty' Russell.  Licenced under the GNU General
    Public Licence. */
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/timer.h>

--------------090505070401040800000800--



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
