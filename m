From: Nicolas Bouliane <nib@cookinglinux.org>
Subject: [PATCH] ip_conntrack_ftp segfault
Date: Mon, 03 Jan 2005 14:22:19 -0500
Message-ID: <41D99B6B.6050601@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040604010600040907030006"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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
--------------040604010600040907030006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Hi,

This patch fix two bugs (when DEBUGP is defined):
o The var `data` doesn't exist, hence gcc complains.
o It segfault because we print an integer with `%s`.

Cheers! :)

-acidfu

--------------040604010600040907030006
Content-Type: text/x-patch;
 name="ip_conntrack_ftp.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_conntrack_ftp.c.patch"

--- /usr/src/old/linux-2.6.10/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-12-24 16:35:59.000000000 -0500
+++ ip_conntrack_ftp.c	2005-01-03 14:09:06.000000000 -0500
@@ -347,9 +347,8 @@
 		goto out;
 	}
 
-	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
-	       (int)matchlen, data + matchoff,
-	       matchlen, ntohl(th->seq) + matchoff);
+	DEBUGP("conntrack_ftp: match `%s' (%u bytes at %u)\n",
+			search[i].pattern, matchlen, ntohl(th->seq) + matchoff);
 
 	/* Allocate expectation which will be inserted */
 	exp = ip_conntrack_expect_alloc();

--------------040604010600040907030006--
