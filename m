From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim 2/4] check current_command in expect_log_hook()
Date: Mon, 21 Feb 2005 18:19:22 +0100
Message-ID: <20050221171922.GA32389@roonstrasse.net>
References: <20050221171719.GA32254@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050221171719.GA32254@roonstrasse.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Allow script_fail() calls even when there is no current_command parsed
yet.


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="02-nfsim-script_fail_check_current_command.patch"

Mon Feb 21 16:49:24 CET 2005  max@duempel.org
  * allow script_fail call even when there is no current_command parsed yet
diff -rN -u nfsim-1-old/core/expect.c nfsim-1-new/core/expect.c
--- nfsim-1-old/core/expect.c	Mon Feb 21 18:04:52 2005
+++ nfsim-1-new/core/expect.c	Mon Feb 21 16:49:17 2005
@@ -130,6 +130,9 @@
 	struct expect *e;
 	bool ret = false;
 
+	if (current_command == NULL)
+		return false;
+
 	/* Only allow each pattern to match once, so we can easily
 	 * expect something to happen twice. */
 	for (e = expect; e; e = e->next) {


--ew6BAiZeqk4r7MaW--
