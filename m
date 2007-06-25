From: Joseph Jezak <josejx@gentoo.org>
Subject: iptables: "getsockopt failed strangely"
Date: Mon, 25 Jun 2007 11:53:40 -0400
Message-ID: <467FE504.6040606@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010609030004070304030808"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------010609030004070304030808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On PowerPC, with a binary compiled statically, we're seeing the 
error message in the topic when simply running the iptables binary.
For more information, the Gentoo bug is available here: 
http://bugs.gentoo.org/show_bug.cgi?id=136813

Basically, the issue arises from a missing check for the result from 
the module request located in 
/usr/src/linux/net/ipv4/netfilter/iptables.c

A patch to add a check for -ENOENT and printing out the missing 
module name then return -EPROTONOSUPPORT instead of -ENOENT is 
attached and "fixes" the bug for me.

-Joe

--------------010609030004070304030808
Content-Type: text/plain;
 name="ip_tables.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_tables.patch"

--- ip_tables.c	2007-04-06 14:39:08.000000000 -0400
+++ /home/jjezak/ip_tables.c	2007-04-28 02:22:57.000000000 -0400
@@ -2004,6 +2004,11 @@
 							 rev.revision,
 							 target, &ret),
 					"ipt_%s", rev.name);
+		if (ret == -ENOENT) {
+			printk("iptables: Unable to load ipt_%s\n", rev.name);
+			return -EPROTONOSUPPORT;
+		}
+
 		break;
 	}
 

--------------010609030004070304030808--
