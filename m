From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [TRIVIAL][PATCH] 25_natcore-nohelper.patch compile problem
Date: Wed, 4 Jun 2003 11:19:22 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0306041111160.31270@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

25_natcore-nohelper.patch applied to the kernel will not compile with
gcc3.3 (i think 3.2 too)

It is because gcc3.3 will complain about an unterminated string here:

                              DEBUGP("calling nat helper (exp=%p) for
                                      packet\n", exp);


Here is patch to patch-o-matic to fix the patch so it compiles with
gcc-3.3.

Regards,
Maciej

Index: 25_natcore-nohelper.patch
===================================================================
RCS file: /cvspublic/netfilter/patch-o-matic/pending/25_natcore-nohelper.patch,v
retrieving revision 1.1
diff -u -r1.1 25_natcore-nohelper.patch
--- 25_natcore-nohelper.patch	26 Mar 2003 15:31:08 -0000	1.1
+++ 25_natcore-nohelper.patch	4 Jun 2003 09:11:15 -0000
@@ -21,7 +21,7 @@

  		DEBUGP("do_bindings: helper existing for (%p)\n", ct);

-@@ -817,19 +823,22 @@
+@@ -817,19 +823,21 @@
  				continue;

  			if (exp_for_packet(exp, pskb)) {
@@ -30,8 +30,7 @@
 -					exp);
 +				/* FIXME: May be true multiple times in the
 +				 * case of UDP!! */
-+				DEBUGP("calling nat helper (exp=%p) for
-+					packet\n", exp);
++				DEBUGP("calling nat helper (exp=%p) for	packet\n", exp);
  				ret = helper->help(ct, exp, info, ctinfo,
  						   hooknum, pskb);
  				if (ret != NF_ACCEPT) {
