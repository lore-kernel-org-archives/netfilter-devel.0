From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]: trivial patches
Date: Thu, 29 Jul 2004 16:29:16 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407290729.QAA28185@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Thu_Jul_29_16:29:16_2004_446)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Thu_Jul_29_16:29:16_2004_446)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

These patches fix strange indent in libip(6)t_{tcp,udp}.c.

Please apply.

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Jul_29_16:29:16_2004_446)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="iptables-indent.patch"

Index: extensions/libip6t_tcp.c
===================================================================
RCS file: /cvspublic/iptables/extensions/libip6t_tcp.c,v
retrieving revision 1.11
diff -u -r1.11 libip6t_tcp.c
--- extensions/libip6t_tcp.c	30 Mar 2003 18:29:56 -0000	1.11
+++ extensions/libip6t_tcp.c	27 Jul 2004 16:13:27 -0000
@@ -123,7 +123,7 @@
 		if (i == sizeof(tcp_flag_names)/sizeof(struct tcp_flag_names))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unknown TCP flag `%s'", ptr);
-		}
+	}
 
 	free(buffer);
 	return ret;
Index: extensions/libip6t_udp.c
===================================================================
RCS file: /cvspublic/iptables/extensions/libip6t_udp.c,v
retrieving revision 1.8
diff -u -r1.8 libip6t_udp.c
--- extensions/libip6t_udp.c	2 Oct 2003 19:59:27 -0000	1.8
+++ extensions/libip6t_udp.c	27 Jul 2004 16:13:27 -0000
@@ -50,9 +50,9 @@
 	    (portnum = service_to_port(port)) != -1)
 		return (u_int16_t)portnum;
 
-		exit_error(PARAMETER_PROBLEM,
-			   "invalid UDP port/service `%s' specified", port);
-	}
+	exit_error(PARAMETER_PROBLEM,
+		   "invalid UDP port/service `%s' specified", port);
+}
 
 static void
 parse_udp_ports(const char *portstring, u_int16_t *ports)
Index: extensions/libipt_tcp.c
===================================================================
RCS file: /cvspublic/iptables/extensions/libipt_tcp.c,v
retrieving revision 1.15
diff -u -r1.15 libipt_tcp.c
--- extensions/libipt_tcp.c	30 Mar 2003 18:29:56 -0000	1.15
+++ extensions/libipt_tcp.c	27 Jul 2004 16:13:28 -0000
@@ -123,7 +123,7 @@
 		if (i == sizeof(tcp_flag_names)/sizeof(struct tcp_flag_names))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unknown TCP flag `%s'", ptr);
-		}
+	}
 
 	free(buffer);
 	return ret;
Index: extensions/libipt_udp.c
===================================================================
RCS file: /cvspublic/iptables/extensions/libipt_udp.c,v
retrieving revision 1.10
diff -u -r1.10 libipt_udp.c
--- extensions/libipt_udp.c	26 Jul 2002 16:27:57 -0000	1.10
+++ extensions/libipt_udp.c	27 Jul 2004 16:13:28 -0000
@@ -50,9 +50,9 @@
 	    (portnum = service_to_port(port)) != -1)
 		return (u_int16_t)portnum;
 
-		exit_error(PARAMETER_PROBLEM,
-			   "invalid UDP port/service `%s' specified", port);
-	}
+	exit_error(PARAMETER_PROBLEM,
+		   "invalid UDP port/service `%s' specified", port);
+}
 
 static void
 parse_udp_ports(const char *portstring, u_int16_t *ports)

----Next_Part(Thu_Jul_29_16:29:16_2004_446)----
