From: Felipe W Damasio <felipewd@terra.com.br>
Subject: [PATCH 1/9] Remove unneeded linux/version.h from net/ipv4/netfilter/ip_conntrack_core.c
Date: Fri, 29 Aug 2003 17:08:51 -0300
Sender: kernel-janitor-discuss-admin@lists.sourceforge.net
Message-ID: <3F4FB2D3.1040709@terra.com.br>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000806080403040002080607"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <kernel-janitor-discuss-admin@lists.sourceforge.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
--------------000806080403040002080607
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

	Based on Randy's modified checkversion.pl script.

	Compile fine against 2.6.0-test4.

	Please consider applying.

	Cheers,

Felipe

--------------000806080403040002080607
Content-Type: text/plain;
 name="ip_conntrack_core.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_core.patch"

--- linux-2.6.0-test4/net/ipv4/netfilter/ip_conntrack_core.c.orig	Fri Aug 29 16:42:56 2003
+++ linux-2.6.0-test4/net/ipv4/netfilter/ip_conntrack_core.c	Fri Aug 29 16:43:04 2003
@@ -13,7 +13,6 @@
  *	- export ip_conntrack[_expect]_{find_get,put} functions
  * */
 
-#include <linux/version.h>
 #include <linux/config.h>
 #include <linux/types.h>
 #include <linux/icmp.h>

--------------000806080403040002080607--



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
