From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 1/5] update kernel requires
Date: Wed, 19 Jan 2005 01:44:48 +0100
Message-ID: <20050119004448.GA12967@roonstrasse.net>
References: <20050119004332.GA12629@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="zYM0uCDKw75PZbzx"
Cc: Robert Iakobashvili <roberti@GoNetworks.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050119004332.GA12629@roonstrasse.net>
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


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

this patch sets the kernel requirements to 2.6.10-mm2 or later


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="01-update_kernel_requires.patch"

Wed Jan 19 01:31:26 CET 2005  max@duempel.org
  * updated kernel requires
diff -rN -u h323-3-old/h323-conntrack-nat/info h323-3-new/h323-conntrack-nat/info
--- h323-3-old/h323-conntrack-nat/info	2005-01-19 01:35:14.120751024 +0100
+++ h323-3-new/h323-conntrack-nat/info	2005-01-19 01:35:14.171743272 +0100
@@ -1,4 +1,4 @@
 Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
 Status: Alpha
 Repository: extra
-Requires: linux < 2.6.0
+Requires: linux >= 2.6.10-mm2


--zYM0uCDKw75PZbzx--
