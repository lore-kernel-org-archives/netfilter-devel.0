From: Jan Du Caju <Jan.DuCaju@kuleuven.net>
Subject: [PATCH] nf-log for 2.4.29
Date: Thu, 10 Feb 2005 18:27:12 +0100
Message-ID: <20050210172712.GC4353@kuleuven.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
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


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

nf-log can not be applied to a 2.4.29 kernel with patch-o-matic-ng-20050208
Please find in attachment a patch that tries to change this.

Greetings,
Jan.
--------------------------------------------------- KULeuvenNet -------
Jan.DuCaju@kuleuven.net         http://www.kuleuven.net/e_index.html
K.U.Leuven                      http://www.kuleuven.ac.be/english/
LUDIT - KULeuvenNet             http://ludit.kuleuven.be/index_en.html
de Croylaan 52A                 3001 Leuven                     Belgium
-----------------------------------------------------------------------

--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patchFor_nf-log_linux-2.4.patch"

--- nf-log/linux-2.4.patch	Thu Feb 10 18:12:18 2005
+++ nf-log-2.4.29/linux-2.4.patch	Thu Feb 10 18:11:45 2005
@@ -100,9 +100,9 @@
 +	}
 +}
 +
- /* This does not belong here, but ipt_REJECT needs it if connection
-    tracking in use: without this, connection may not be in hash table,
-    and hence manufactured ICMP or RST packets will not be associated
+ /* This does not belong here, but locally generated errors need it if connection
+    tracking in use: without this, connection may not be in hash table, and hence
+    manufactured ICMP or RST packets will not be associated with it. */
 diff -urN --exclude-from=diff.exclude linux-2.4.20-base/net/ipv4/netfilter/ipt_LOG.c linux-2.4.20-log/net/ipv4/netfilter/ipt_LOG.c
 --- linux-2.4.20-base/net/ipv4/netfilter/ipt_LOG.c	2002-02-25 20:38:14.000000000 +0100
 +++ linux-2.4.20-log/net/ipv4/netfilter/ipt_LOG.c	2003-05-13 19:30:26.000000000 +0200
@@ -474,6 +474,7 @@
  EXPORT_SYMBOL(nf_setsockopt);
  EXPORT_SYMBOL(nf_getsockopt);
  EXPORT_SYMBOL(ip_ct_attach);
+ EXPORT_SYMBOL(nf_ct_attach);
 +EXPORT_SYMBOL(nf_log_register);
 +EXPORT_SYMBOL(nf_log_unregister);
 +EXPORT_SYMBOL(nf_log_packet);

--a8Wt8u1KmwUX3Y2C--
