From: Jan Du Caju <Jan.DuCaju@kuleuven.net>
Subject: [PATCH] raw for 2.4.29
Date: Thu, 10 Feb 2005 18:33:20 +0100
Message-ID: <20050210173320.GD4353@kuleuven.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="v9Ux+11Zm5mwPlX6"
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


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

the raw patch can not be applied to a 2.4.29 kernel with 
patch-o-matic-ng-20050208. Please find in attachment a patch that tries to 
change this.

Kind regards,
Jan
--------------------------------------------------- KULeuvenNet -------
Jan.DuCaju@kuleuven.net         http://www.kuleuven.net/e_index.html
K.U.Leuven                      http://www.kuleuven.ac.be/english/
LUDIT - KULeuvenNet             http://ludit.kuleuven.be/index_en.html
de Croylaan 52A                 3001 Leuven                     Belgium
-----------------------------------------------------------------------

--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patchFor_raw_linux-2.4.patch"

--- raw/linux-2.4.patch	Thu Feb 10 18:03:06 2005
+++ raw-2.4.29/linux-2.4.patch	Thu Feb 10 18:04:19 2005
@@ -8,6 +8,7 @@
 +/* Fake conntrack entry for untracked connections */
 +extern struct ip_conntrack ip_conntrack_untracked;
 +
+ extern int ip_ct_no_defrag;
  /* Returns new sk_buff, or NULL */
  struct sk_buff *
  ip_ct_gather_frags(struct sk_buff *skb);

--v9Ux+11Zm5mwPlX6--
