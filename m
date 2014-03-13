From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 1/2] update FSF address in license text
Date: Thu, 13 Mar 2014 10:02:13 +0100
Message-ID: <1394701334-23508-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbaCMJC1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:02:27 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2D92Q1s017247
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2014 05:02:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

http://www.gnu.org/licenses/gpl-2.0.html
http://www.fsf.org/about/contact/
---
 extensions/libxt_CONNMARK.c      | 2 +-
 extensions/libxt_connmark.c      | 2 +-
 extensions/libxt_osf.c           | 2 +-
 include/linux/netfilter/xt_osf.h | 2 +-
 libxtables/xtables.c             | 2 +-
 utils/nfnl_osf.c                 | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 5d5351e..42cf207 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -17,7 +17,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 #include <stdbool.h>
 #include <stdint.h>
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 6f1d532..95477de 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -17,7 +17,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 #include <stdbool.h>
 #include <stdint.h>
diff --git a/extensions/libxt_osf.c b/extensions/libxt_osf.c
index 52dba47..496b480 100644
--- a/extensions/libxt_osf.c
+++ b/extensions/libxt_osf.c
@@ -14,7 +14,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 
 /*
diff --git a/include/linux/netfilter/xt_osf.h b/include/linux/netfilter/xt_osf.h
index 18afa49..d0c4c76 100644
--- a/include/linux/netfilter/xt_osf.h
+++ b/include/linux/netfilter/xt_osf.h
@@ -14,7 +14,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 
 #ifndef _XT_OSF_H
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index a511c08..1ab86d5 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -13,7 +13,7 @@
  *
  *	You should have received a copy of the GNU General Public License
  *	along with this program; if not, write to the Free Software
- *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 #include "config.h"
 #include <ctype.h>
diff --git a/utils/nfnl_osf.c b/utils/nfnl_osf.c
index bb5f92d..645ec64 100644
--- a/utils/nfnl_osf.c
+++ b/utils/nfnl_osf.c
@@ -14,7 +14,7 @@
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
 
 #include <sys/types.h>
-- 
1.8.5.3

