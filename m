From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: [RESEND][PATCH] ftp helper typo (espv/epsv)
Date: Fri, 17 Jan 2003 17:08:55 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0301171708020.11990@dns.toxicfilms.tv>
References: <Pine.LNX.4.51.0301101654540.30861@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
In-Reply-To: <Pine.LNX.4.51.0301101654540.30861@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

this is the espv/epsv typo fix in ip_conntrack_ftp.c as suggested
by CURRENT_ISSUES.

Regards,
Maciej Soltysiak


--- linux/net/ipv4/netfilter/ip_conntrack_ftp.c	2002-11-29 00:53:15.000000000 +0100
+++ linux.new/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-01-10 16:53:57.000000000 +0100
@@ -32,7 +32,7 @@

 static int try_rfc959(const char *, size_t, u_int32_t [], char);
 static int try_eprt(const char *, size_t, u_int32_t [], char);
-static int try_espv_response(const char *, size_t, u_int32_t [], char);
+static int try_epsv_response(const char *, size_t, u_int32_t [], char);

 static struct ftp_search {
 	enum ip_conntrack_dir dir;
@@ -65,7 +65,7 @@
 		IP_CT_DIR_REPLY,
 		"229 ", sizeof("229 ") - 1, '(', ')',
 		IP_CT_FTP_EPSV,
-		try_espv_response,
+		try_epsv_response,
 	},
 };

@@ -157,7 +157,7 @@
 }

 /* Returns 0, or length of numbers: |||6446| */
-static int try_espv_response(const char *data, size_t dlen, u_int32_t array[6],
+static int try_epsv_response(const char *data, size_t dlen, u_int32_t array[6],
 			     char term)
 {
 	char delim;
