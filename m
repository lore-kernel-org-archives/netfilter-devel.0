From: Michal Pokrywka <mpokrywka@hoga.pl>
Subject: IP SET target iptables fix
Date: Thu, 17 Mar 2005 18:40:01 +0100
Message-ID: <200503171840.01301.mpokrywka@hoga.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hello,
Current iptables target needs to test for IP_SET_INVALID_ID when
printing or saving rules from kernel, currently it errors "iptables v1.3.1:
Set id 65535 in kernel doesn't exist."

Patch below fixes this problem:

diff -Nru iptables-1.3.1.orig/extensions/libipt_SET.c iptables-1.3.1/extensions/libipt_SET.c
--- iptables-1.3.1.orig/extensions/libipt_SET.c 2005-03-17 14:16:26.005537000 +0100
+++ iptables-1.3.1/extensions/libipt_SET.c 2005-03-17 14:18:43.055537000 +0100
@@ -121,6 +121,8 @@
  int i;
  char setname[IP_SET_MAXNAMELEN];
  
+ if (info->index == IP_SET_INVALID_ID)
+     return;
  get_set_byid(setname, info->index);
  printf("%s %s", prefix, setname);
  for (i = 0; i < IP_SET_MAX_BINDINGS; i++) {
