From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH pom-ng 2/5] author update
Date: Wed, 19 Jan 2005 01:46:11 +0100
Message-ID: <20050119004611.GD12967@roonstrasse.net>
References: <20050119004332.GA12629@roonstrasse.net>
	<20050119004513.GB12967@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="B4IIlcmfBL/1gGOG"
Cc: Robert Iakobashvili <roberti@GoNetworks.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050119004513.GB12967@roonstrasse.net>
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


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2005/01/19 01:45, Max Kellermann <max@duempel.org> wrote:
> add myself as module author

oh no, the patchfile was missing.



--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="02-update_author.patch"

Wed Jan 19 01:32:02 CET 2005  max@duempel.org
  * added new author
diff -rN -u h323-3-old/h323-conntrack-nat/info h323-3-new/h323-conntrack-nat/info
--- h323-3-old/h323-conntrack-nat/info	2005-01-19 01:35:42.916373424 +0100
+++ h323-3-new/h323-conntrack-nat/info	2005-01-19 01:31:51.000000000 +0100
@@ -1,4 +1,4 @@
-Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, Max Kellermann <max@duempel.org>
 Status: Alpha
 Repository: extra
 Requires: linux >= 2.6.10-mm2
diff -rN -u h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c
--- h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c	2005-01-19 01:35:42.916373424 +0100
+++ h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_conntrack_h323.c	2005-01-19 01:35:42.963366280 +0100
@@ -1,6 +1,7 @@
 /* 
  * H.323 'brute force' extension for H.323 connection tracking. 
  * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * (c) 2005 Max Kellermann <max@duempel.org>
  *
  * Based on ip_masq_h323.c for 2.2 kernels from CoRiTel, Sofia project.
  * (http://www.coritel.it/projects/sofia/nat/)
diff -rN -u h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c
--- h323-3-old/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c	2005-01-19 01:35:42.914373728 +0100
+++ h323-3-new/h323-conntrack-nat/linux/net/ipv4/netfilter/ip_nat_h323.c	2005-01-19 01:35:42.961366584 +0100
@@ -1,6 +1,7 @@
 /* 
  * H.323 'brute force' extension for NAT alteration. 
  * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
+ * (c) 2005 Max Kellermann <max@duempel.org>
  *
  * Based on ip_masq_h323.c for 2.2 kernels from CoRiTel, Sofia project.
  * (http://www.coritel.it/projects/sofia/nat.html)


--B4IIlcmfBL/1gGOG--
