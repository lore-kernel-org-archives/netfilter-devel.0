From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: Re: [PATCH] conntracker/nat helper for Microsoft Media Services
Date: 24 Sep 2002 14:35:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032870935.6100.10.camel@xbox>
References: <1032732902.574.99.camel@exile>
	<20020924133925.M3810@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-l8D045+H+jinyeDhfSvr"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20020924133925.M3810@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-l8D045+H+jinyeDhfSvr
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2002-09-24 at 13:39, Harald Welte wrote:
> Thanks a lot for contributing this helper to the netfilter project, I have
> committed your patch to CVS right now.
> 
> However, there is a small remaining issue:
> 
... 
> 
> Those hunks should not be part of the .patch itself, but seperate pom-files,
> since this clashes with other helpers.  See 
> netfilter/patch-o-matic/talk-conntrack-nat.patch.ip_conntrack.h*
> 
> Please submit an incremental diff against the code which is now in CVS.
> Thanks.
> 

My mistake. Patch attached. Sorry for the inconvenience.

Regards,
Filip

--=-l8D045+H+jinyeDhfSvr
Content-Disposition: attachment; filename=diff.mms.ip_conntrack.h.fixup.20020924-1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=diff.mms.ip_conntrack.h.fixup.20020924-1;
	charset=ISO-8859-15

diff -urN netfilter-orig/patch-o-matic/extra/mms-conntrack-nat.patch netfil=
ter-changed/patch-o-matic/extra/mms-conntrack-nat.patch
--- netfilter-orig/patch-o-matic/extra/mms-conntrack-nat.patch	2002-09-24 1=
3:49:09.000000000 +0200
+++ netfilter-changed/patch-o-matic/extra/mms-conntrack-nat.patch	2002-09-2=
4 14:08:12.000000000 +0200
@@ -1,29 +1,3 @@
-diff -urN -X dontdiff linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_co=
nntrack.h linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntrack.h
---- linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_conntrack.h	2002-09-=
22 19:50:53.000000000 +0200
-+++ linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntrack.h	2002=
-09-17 04:08:25.000000000 +0200
-@@ -60,12 +60,14 @@
- /* Add protocol helper include file here */
- #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
- #include <linux/netfilter_ipv4/ip_conntrack_irc.h>
-+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>
-=20
- /* per expectation: application helper private data */
- union ip_conntrack_expect_help {
- 	/* insert conntrack helper private data (expect) here */
- 	struct ip_ct_ftp_expect exp_ftp_info;
- 	struct ip_ct_irc_expect exp_irc_info;
-+	struct ip_ct_mms_expect exp_mms_info;
-=20
- #ifdef CONFIG_IP_NF_NAT_NEEDED
- 	union {
-@@ -79,6 +81,7 @@
- 	/* insert conntrack helper private data (master) here */
- 	struct ip_ct_ftp_master ct_ftp_info;
- 	struct ip_ct_irc_master ct_irc_info;
-+	struct ip_ct_mms_master ct_mms_info;
- };
-=20
- #ifdef CONFIG_IP_NF_NAT_NEEDED
 diff -urN -X dontdiff linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_co=
nntrack_mms.h linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntra=
ck_mms.h
 --- linux-2.4.20-pre7/include/linux/netfilter_ipv4/ip_conntrack_mms.h	1970=
-01-01 01:00:00.000000000 +0100
 +++ linux-2.4.20-pre7-mms/include/linux/netfilter_ipv4/ip_conntrack_mms.h	=
2002-09-17 04:08:25.000000000 +0200
diff -urN netfilter-orig/patch-o-matic/extra/mms-conntrack-nat.patch.ip_con=
ntrack.h netfilter-changed/patch-o-matic/extra/mms-conntrack-nat.patch.ip_c=
onntrack.h
--- netfilter-orig/patch-o-matic/extra/mms-conntrack-nat.patch.ip_conntrack=
.h	1970-01-01 01:00:00.000000000 +0100
+++ netfilter-changed/patch-o-matic/extra/mms-conntrack-nat.patch.ip_conntr=
ack.h	2002-09-24 14:10:13.000000000 +0200
@@ -0,0 +1,2 @@
+/* Add protocol helper include file here */
+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>
diff -urN netfilter-orig/patch-o-matic/extra/mms-conntrack-nat.patch.ip_con=
ntrack.h-2 netfilter-changed/patch-o-matic/extra/mms-conntrack-nat.patch.ip=
_conntrack.h-2
--- netfilter-orig/patch-o-matic/extra/mms-conntrack-nat.patch.ip_conntrack=
.h-2	1970-01-01 01:00:00.000000000 +0100
+++ netfilter-changed/patch-o-matic/extra/mms-conntrack-nat.patch.ip_conntr=
ack.h-2	2002-09-24 14:11:42.000000000 +0200
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (expect) here */
+	struct ip_ct_mms_expect exp_mms_info;
diff -urN netfilter-orig/patch-o-matic/extra/mms-conntrack-nat.patch.ip_con=
ntrack.h-3 netfilter-changed/patch-o-matic/extra/mms-conntrack-nat.patch.ip=
_conntrack.h-3
--- netfilter-orig/patch-o-matic/extra/mms-conntrack-nat.patch.ip_conntrack=
.h-3	1970-01-01 01:00:00.000000000 +0100
+++ netfilter-changed/patch-o-matic/extra/mms-conntrack-nat.patch.ip_conntr=
ack.h-3	2002-09-24 14:12:16.000000000 +0200
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (master) here */
+	struct ip_ct_mms_master ct_mms_info;

--=-l8D045+H+jinyeDhfSvr--
