From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] note owner match brokenness
Date: Fri, 1 Oct 2004 13:44:47 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041001204447.GA30390@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Someone recently complained in bugzilla that the note about owner
match being broken on SMP took hours to find because it was in
syslog instead of userspace.  Hopefully the below patch will
save others some time.

This closes bugzilla #244

Phil



--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-owner

diff -ru ipt-orig/extensions/libipt_owner.c ipt-new/extensions/libipt_owner.c
--- ipt-orig/extensions/libipt_owner.c	2004-06-14 15:02:17.000000000 -0700
+++ ipt-new/extensions/libipt_owner.c	2004-10-01 13:36:50.779263920 -0700
@@ -22,6 +22,7 @@
 "[!] --pid-owner processid  Match local pid\n"
 "[!] --sid-owner sessionid  Match local sid\n"
 "[!] --cmd-owner name       Match local command name\n"
+"NOTE: pid, sid and command matching are broken on SMP\n"
 "\n",
 IPTABLES_VERSION);
 #else
@@ -31,6 +32,7 @@
 "[!] --gid-owner groupid    Match local gid\n"
 "[!] --pid-owner processid  Match local pid\n"
 "[!] --sid-owner sessionid  Match local sid\n"
+"NOTE: pid and sid matching are broken on SMP\n"
 "\n",
 IPTABLES_VERSION);
 #endif /* IPT_OWNER_COMM */

--fUYQa+Pmc3FrFX/N--
