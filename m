From: Scott Andrew Baillie <sbaillie@bigpond.net.au>
Subject: ip_tables.h does not compile when using g++
Date: 14 Sep 2002 12:07:22 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032005243.9337.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-biCbV2v9vfS+XtwrCIyN"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter List <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-biCbV2v9vfS+XtwrCIyN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Hi,

I noticed a discussion on this list in May regarding this problem
but nobody seemed to care.

The file linux-2.4.19/include/linux/netfilter_ipv4/ip_tables.h is
included by user space programs as well as the kernel, hence I think
that it should compile using g++.

This patch makes it compile. Patch is also attached.


diff -ur linux-2.4.19/include/linux/netfilter_ipv4/ip_tables.h
linux-2.4.19-new/include/linux/netfilter_ipv4/ip_tables.h
--- linux-2.4.19/include/linux/netfilter_ipv4/ip_tables.h	Mon Feb 25
19:38:13 2002
+++ linux-2.4.19-new/include/linux/netfilter_ipv4/ip_tables.h	Sat Sep 14
11:11:01 2002
@@ -292,7 +292,7 @@
 static __inline__ struct ipt_entry_target *
 ipt_get_target(struct ipt_entry *e)
 {
-	return (void *)e + e->target_offset;
+	return ((struct ipt_entry_target *)((char *)e + e->target_offset));
 }
 
 /* fn returns 0 to continue iteration */

Regards,

Scott.



--=-biCbV2v9vfS+XtwrCIyN
Content-Disposition: attachment; filename=linux-2.4.19-new.patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=linux-2.4.19-new.patch; charset=ISO-8859-1

diff -ur linux-2.4.19/include/linux/netfilter_ipv4/ip_tables.h linux-2.4.19=
-new/include/linux/netfilter_ipv4/ip_tables.h
--- linux-2.4.19/include/linux/netfilter_ipv4/ip_tables.h	Mon Feb 25 19:38:=
13 2002
+++ linux-2.4.19-new/include/linux/netfilter_ipv4/ip_tables.h	Sat Sep 14 11=
:11:01 2002
@@ -292,7 +292,7 @@
 static __inline__ struct ipt_entry_target *
 ipt_get_target(struct ipt_entry *e)
 {
-	return (void *)e + e->target_offset;
+	return ((struct ipt_entry_target *)((char *)e + e->target_offset));
 }
=20
 /* fn returns 0 to continue iteration */

--=-biCbV2v9vfS+XtwrCIyN--
