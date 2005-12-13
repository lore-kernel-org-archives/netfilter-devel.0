From: Marcus Sundberg <marcus@ingate.com>
Subject: [PATCH] nfsim: Increase maximum argv size for tcpsession DATA
Date: Tue, 13 Dec 2005 17:12:00 +0100
Message-ID: <439EF2D0.4000606@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

this patch increases the argv buffer in the tcp_send() function.
I ran in to this limit when constructing RTSP packets, and I see no
reason not to make it "large enough for everyone" while at it.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>

--- nfsim/tools/tcpsession.c	(revision 6316)
+++ nfsim/tools/tcpsession.c	(working copy)
@@ -124,7 +124,7 @@
 		     int datanum, char *data[])
 {
 	char *ctx = talloc(NULL, char);
-	char *argv[20];
+	char *argv[1024];
 	int argc;

 	argc = 0;

-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Software Developer, Ingate Systems AB |  http://www.ingate.com/
