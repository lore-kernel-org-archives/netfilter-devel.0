From: John Lange <john.lange@open-it.ca>
Subject: iptables --log-uid patch for 2.6
Date: Sun, 28 Nov 2004 12:55:09 -0600
Message-ID: <1101668109.2922.1618.camel@ws102.darkcore.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-sXm10I/Xj2lR0FACK/Y2"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-develop <netfilter-devel@lists.netfilter.org>
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


--=-sXm10I/Xj2lR0FACK/Y2
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

I sent this to the list yesterday but I don't think it made it through.
Apologies if it is a duplicate.

Here are patches against the userspace and the kernel which allows the
logging of the uid that generated the (outgoing) packet.

This patch was originally the work of Martin Josefsson for the 2.4
kernel but was never incorporated into the main code base. My work here
simply ports it to the 2.6 kernel and the current version of netfilter
(iptables).

It is useful for figuring out which users might have had their accounts
compromised by spam relays, IRC bots or other such things.

I've been running this patch on a production server since Oct 30 without
any problems.


--- linux-2.6.9/include/linux/netfilter_ipv4/ipt_LOG.h  2004-10-18 16:55:07.000000000 -0500
+++
linux-2.6.9-jl1/include/linux/netfilter_ipv4/ipt_LOG.h      2004-10-30
16:42:12.000000000 -0500
@@ -4,7 +4,8 @@
 #define IPT_LOG_TCPSEQ         0x01    /* Log TCP sequence numbers */
 #define IPT_LOG_TCPOPT         0x02    /* Log TCP options */
 #define IPT_LOG_IPOPT          0x04    /* Log IP options */
-#define IPT_LOG_MASK           0x07
+#define IPT_LOG_UID            0x08    /* Log UID owning local socket
*/
+#define IPT_LOG_MASK           0x0f
 
 struct ipt_log_info {
        unsigned char level;
--- linux-2.6.9/net/ipv4/netfilter/ipt_LOG.c    2004-10-18
16:55:06.000000000 -0500
+++ linux-2.6.9-jl1/net/ipv4/netfilter/ipt_LOG.c        2004-10-30
19:21:12.000000000 -0500
@@ -384,6 +384,8 @@
        }
 
        dump_packet(loginfo, skb, 0);
+       if ((loginfo->logflags & IPT_LOG_UID) && skb->sk &&
skb->sk->sk_socket && skb->sk->sk_socket->file)
+               printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
        printk("\n");
        spin_unlock_bh(&log_lock);
 }


--- iptables-1.2.11/extensions/libipt_LOG.c     2004-06-14
17:02:16.000000000 -0500
+++ iptables-1.2.11-jl/extensions/libipt_LOG.c  2004-10-30
16:39:16.000000000 -0500
@@ -21,7 +21,8 @@
 " --log-prefix prefix          Prefix log messages with this
prefix.\n\n"
 " --log-tcp-sequence           Log TCP sequence numbers.\n\n"
 " --log-tcp-options            Log TCP options.\n\n"
-" --log-ip-options             Log IP options.\n\n",
+" --log-ip-options             Log IP options.\n\n"
+" --log-uid                    Log UID owning the local socket.\n\n",
 IPTABLES_VERSION);
 }
 
@@ -31,6 +32,7 @@
        { .name = "log-tcp-sequence", .has_arg = 0, .flag = 0, .val =
'1' },
        { .name = "log-tcp-options",  .has_arg = 0, .flag = 0, .val =
'2' },
        { .name = "log-ip-options",   .has_arg = 0, .flag = 0, .val =
'3' },
+       { .name = "log-uid",          .has_arg = 0, .flag = 0, .val =
'4' },
        { .name = 0 }
 };
 
@@ -98,6 +100,7 @@
 #define IPT_LOG_OPT_TCPSEQ 0x04
 #define IPT_LOG_OPT_TCPOPT 0x08
 #define IPT_LOG_OPT_IPOPT 0x10
+#define IPT_LOG_OPT_UID 0x20
 
 /* Function which parses command options; returns true if it
    ate an option */
@@ -168,6 +171,15 @@
                *flags |= IPT_LOG_OPT_IPOPT;
                break;
 
+       case '4':
+               if (*flags & IPT_LOG_OPT_UID)
+                       exit_error(PARAMETER_PROBLEM,
+                                  "Can't specify --log-uid twice");
+
+               loginfo->logflags |= IPT_LOG_UID;
+               *flags |= IPT_LOG_OPT_UID;
+               break;
+
        default:
                return 0;
        }
@@ -211,6 +223,8 @@
                        printf("tcp-options ");
                if (loginfo->logflags & IPT_LOG_IPOPT)
                        printf("ip-options ");
+               if (loginfo->logflags & IPT_LOG_UID)
+                       printf("uid ");
                if (loginfo->logflags & ~(IPT_LOG_MASK))
                        printf("unknown-flags ");
        }
@@ -238,6 +252,8 @@
                printf("--log-tcp-options ");
        if (loginfo->logflags & IPT_LOG_IPOPT)
                printf("--log-ip-options ");
+       if (loginfo->logflags & IPT_LOG_UID)
+               printf("--log-uid ");
 }
 
 static
--- iptables-1.2.11/extensions/libipt_LOG.man   2004-01-22
09:04:24.000000000 -0600
+++ iptables-1.2.11-jl/extensions/libipt_LOG.man        2004-10-30
19:28:09.000000000 -0500
@@ -26,3 +26,6 @@
 .TP
 .B --log-ip-options
 Log options from the IP packet header.
+.TP
+.B --log-uid
+Log the userid of the process which generated the packet.
-- 
John Lange
OpenIT ltd.
(204) 885 0872

--=-sXm10I/Xj2lR0FACK/Y2
Content-Disposition: attachment; filename=ipt_LOG-uid.patch
Content-Type: text/x-patch; name=ipt_LOG-uid.patch; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

--- linux-2.6.9/include/linux/netfilter_ipv4/ipt_LOG.h	2004-10-18 16:55:07.000000000 -0500
+++ linux-2.6.9-jl1/include/linux/netfilter_ipv4/ipt_LOG.h	2004-10-30 16:42:12.000000000 -0500
@@ -4,7 +4,8 @@
 #define IPT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
 #define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
 #define IPT_LOG_IPOPT		0x04	/* Log IP options */
-#define IPT_LOG_MASK		0x07
+#define IPT_LOG_UID		0x08	/* Log UID owning local socket */
+#define IPT_LOG_MASK		0x0f
 
 struct ipt_log_info {
 	unsigned char level;
--- linux-2.6.9/net/ipv4/netfilter/ipt_LOG.c	2004-10-18 16:55:06.000000000 -0500
+++ linux-2.6.9-jl1/net/ipv4/netfilter/ipt_LOG.c	2004-10-30 19:21:12.000000000 -0500
@@ -384,6 +384,8 @@
 	}
 
 	dump_packet(loginfo, skb, 0);
+ 	if ((loginfo->logflags & IPT_LOG_UID) && skb->sk && skb->sk->sk_socket && skb->sk->sk_socket->file)
+ 		printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
 	printk("\n");
 	spin_unlock_bh(&log_lock);
 }

--=-sXm10I/Xj2lR0FACK/Y2
Content-Disposition: attachment; filename=ipt_LOG-uid.userspace.patch
Content-Type: text/x-patch; name=ipt_LOG-uid.userspace.patch;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

--- iptables-1.2.11/extensions/libipt_LOG.c	2004-06-14 17:02:16.000000000 -0500
+++ iptables-1.2.11-jl/extensions/libipt_LOG.c	2004-10-30 16:39:16.000000000 -0500
@@ -21,7 +21,8 @@
 " --log-prefix prefix		Prefix log messages with this prefix.\n\n"
 " --log-tcp-sequence		Log TCP sequence numbers.\n\n"
 " --log-tcp-options		Log TCP options.\n\n"
-" --log-ip-options		Log IP options.\n\n",
+" --log-ip-options		Log IP options.\n\n"
+" --log-uid			Log UID owning the local socket.\n\n",
 IPTABLES_VERSION);
 }
 
@@ -31,6 +32,7 @@
 	{ .name = "log-tcp-sequence", .has_arg = 0, .flag = 0, .val = '1' },
 	{ .name = "log-tcp-options",  .has_arg = 0, .flag = 0, .val = '2' },
 	{ .name = "log-ip-options",   .has_arg = 0, .flag = 0, .val = '3' },
+	{ .name = "log-uid",          .has_arg = 0, .flag = 0, .val = '4' },
 	{ .name = 0 }
 };
 
@@ -98,6 +100,7 @@
 #define IPT_LOG_OPT_TCPSEQ 0x04
 #define IPT_LOG_OPT_TCPOPT 0x08
 #define IPT_LOG_OPT_IPOPT 0x10
+#define IPT_LOG_OPT_UID 0x20
 
 /* Function which parses command options; returns true if it
    ate an option */
@@ -168,6 +171,15 @@
 		*flags |= IPT_LOG_OPT_IPOPT;
 		break;
 
+	case '4':
+		if (*flags & IPT_LOG_OPT_UID)
+			exit_error(PARAMETER_PROBLEM,
+				   "Can't specify --log-uid twice");
+
+		loginfo->logflags |= IPT_LOG_UID;
+		*flags |= IPT_LOG_OPT_UID;
+		break;
+
 	default:
 		return 0;
 	}
@@ -211,6 +223,8 @@
 			printf("tcp-options ");
 		if (loginfo->logflags & IPT_LOG_IPOPT)
 			printf("ip-options ");
+		if (loginfo->logflags & IPT_LOG_UID)
+			printf("uid ");
 		if (loginfo->logflags & ~(IPT_LOG_MASK))
 			printf("unknown-flags ");
 	}
@@ -238,6 +252,8 @@
 		printf("--log-tcp-options ");
 	if (loginfo->logflags & IPT_LOG_IPOPT)
 		printf("--log-ip-options ");
+	if (loginfo->logflags & IPT_LOG_UID)
+		printf("--log-uid ");
 }
 
 static
--- iptables-1.2.11/extensions/libipt_LOG.man	2004-01-22 09:04:24.000000000 -0600
+++ iptables-1.2.11-jl/extensions/libipt_LOG.man	2004-10-30 19:28:09.000000000 -0500
@@ -26,3 +26,6 @@
 .TP
 .B --log-ip-options
 Log options from the IP packet header.
+.TP
+.B --log-uid
+Log the userid of the process which generated the packet.

--=-sXm10I/Xj2lR0FACK/Y2--
