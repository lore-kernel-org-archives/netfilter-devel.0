From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/24] libxtables: check for negative numbers in xtables_strtou*
Date: Wed, 25 May 2011 01:08:06 +0200
Message-ID: <1306278506-11463-6-git-send-email-jengelh@medozas.de>
References: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40930 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933573Ab1EXXIe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:34 -0400
In-Reply-To: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 xtables.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/xtables.c b/xtables.c
index 3c9a13f..e11a77e 100644
--- a/xtables.c
+++ b/xtables.c
@@ -15,7 +15,7 @@
  *	along with this program; if not, write to the Free Software
  *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-
+#include <ctype.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <netdb.h>
@@ -430,11 +430,16 @@ bool xtables_strtoul(const char *s, char **end, unsigned long long *value,
                      unsigned long min, unsigned long max)
 {
 	unsigned long v;
+	const char *p;
 	char *my_end;
 
 	errno = 0;
+	/* Since strtoul allows leading minus, we have to check for ourself. */
+	for (p = s; isspace(*p); ++p)
+		;
+	if (*p == '-')
+		return false;
 	v = strtoul(s, &my_end, 0);
-
 	if (my_end == s)
 		return false;
 	if (end != NULL)
-- 
1.7.3.4

