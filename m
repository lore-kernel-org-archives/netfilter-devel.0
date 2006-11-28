From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/3][NETFILTER] remove the reference to ipchains from Kconfig
Date: Tue, 28 Nov 2006 18:46:58 +0100
Message-ID: <456C7612.5010206@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000705050209040105030301"
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------000705050209040105030301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sorry if you received this email twice

--

This is something that I had in mind for long time ago, let me know what
you think.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------000705050209040105030301
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER] remove the reference to ipchains from Kconfig

It is time to move on :-)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: linux-2.6.git/net/Kconfig
===================================================================
--- linux-2.6.git.orig/net/Kconfig	2006-11-28 15:07:50.000000000 +0100
+++ linux-2.6.git/net/Kconfig	2006-11-28 15:08:15.000000000 +0100
@@ -75,7 +75,7 @@ config NETWORK_SECMARK
 	  If you are unsure how to answer this question, answer N.
 
 menuconfig NETFILTER
-	bool "Network packet filtering (replaces ipchains)"
+	bool "Network packet filtering framework (Netfilter)"
 	---help---
 	  Netfilter is a framework for filtering and mangling network packets
 	  that pass through your Linux box.


--------------000705050209040105030301--
