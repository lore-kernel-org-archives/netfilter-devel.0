From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] remove unused field from struct ip_nat_info
Date: Sun, 01 Jun 2003 00:56:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED93310.9020007@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010807050802020402030500"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010807050802020402030500
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,
i couldn't find any reference of 'mtype' field in ip_nat_info.
This patch removes it.

Best regards,
Patrick


--------------010807050802020402030500
Content-Type: text/plain;
 name="ip_nat-unused-field.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_nat-unused-field.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1248  -> 1.1249 
#	include/linux/netfilter_ipv4/ip_nat.h	1.4     -> 1.5    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/06/01	kaber@trash.net	1.1249
# [NETFILTER] remove unused field from struct ip_nat_info
# --------------------------------------------
#
diff -Nru a/include/linux/netfilter_ipv4/ip_nat.h b/include/linux/netfilter_ipv4/ip_nat.h
--- a/include/linux/netfilter_ipv4/ip_nat.h	Sun Jun  1 00:53:12 2003
+++ b/include/linux/netfilter_ipv4/ip_nat.h	Sun Jun  1 00:53:12 2003
@@ -105,9 +105,6 @@
 	/* Manipulations to be done on this conntrack. */
 	struct ip_nat_info_manip manips[IP_NAT_MAX_MANIPS];
 
-	/* The mapping type which created us (NULL for null mapping). */
-	const struct ip_nat_mapping_type *mtype;
-
 	struct ip_nat_hash bysource, byipsproto;
 
 	/* Helper (NULL if none). */

--------------010807050802020402030500--
