From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH: POM-NG] explicit selection of patchlets
Date: Thu, 30 Jun 2005 01:31:49 +0900 (JST)
Message-ID: <200506291631.j5TGVnvn007870@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Jun_30_01:31:49_2005_026)--"
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

----Next_Part(Thu_Jun_30_01:31:49_2005_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

If user specify patchlets explicitly, runme script checks the wrong path
 to "info". Please consider the attached patch.

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Thu_Jun_30_01:31:49_2005_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="runme.patch"

Index: runme
===================================================================
--- runme	(revision 4067)
+++ runme	(working copy)
@@ -148,11 +148,12 @@
 	}
 }
 
-if ($#ARGV >= 0 && (-f "$ARGV[0]/info" || -f "$ARGV[0].info")) {
+if ($#ARGV >= 0 && (-f "$POMNG_ROOT_DIR/$ARGV[0]/info"
+		    || -f "$POMNG_ROOT_DIR/$ARGV[0].info")) {
 	# patch or update file
 	# user wants to specify patches manually
 	for my $p (@ARGV) {
-		if (-f "$p/info") {
+		if (-f "$POMNG_ROOT_DIR/$p/info") {
 			push(@patchlets, $p);
 		} elsif (-f "$p.info") {
 			push(@patchlets, $p);

----Next_Part(Thu_Jun_30_01:31:49_2005_026)----
