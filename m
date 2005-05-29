From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [3/3] OSF: lib_ipt.c changes to support connector notifications.
Date: Mon, 30 May 2005 00:23:13 +0400
Message-ID: <20050530002313.1b88e3f5@zanzibar.2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- orig/iptables/extensions/libipt_osf.c
+++ mod/iptables/extensions/libipt_osf.c
@@ -35,14 +35,15 @@
 
 static void help(void)
 {
-	printf("OS fingerprint match v%s options:\n"
+	printf("OS fingerprint match options:\n"
 		"--genre [!] string	Match a OS genre by passive fingerprinting.\n"
 		"--smart		Use some smart extensions to determine OS (do not use TTL).\n"
 		"--log level		Log all(or only first) determined genres even if "
 					"they do not match desired one. "
 					"Level may be 0(all) or 1(only first entry).\n"
 		"--netlink		Log through netlink(NETLINK_NFLOG).\n",
-		IPTABLES_VERSION);
+		"--connector		Log through kernel connector [in 2.6.12-mm+].\n"
+		);
 }
 
 
@@ -51,6 +52,7 @@
 	{ .name = "smart",	.has_arg = 0, .flag = 0, .val = '2' },
 	{ .name = "log",	.has_arg = 1, .flag = 0, .val = '3' },
 	{ .name = "netlink",	.has_arg = 0, .flag = 0, .val = '4' },
+	{ .name = "connector",	.has_arg = 0, .flag = 0, .val = '5' },
 	{ .name = 0 }
 };
 
@@ -104,10 +106,16 @@
 			break;
 		case '4': /* --netlink */
 			if (*flags & IPT_OSF_NETLINK)
-				exit_error(PARAMETER_PROBLEM, "Can't specify multiple smart parameter");
+				exit_error(PARAMETER_PROBLEM, "Can't specify multiple netlink parameter");
 			*flags |= IPT_OSF_NETLINK;
 			info->flags |= IPT_OSF_NETLINK;
 			break;
+		case '5': /* --connector */
+			if (*flags & IPT_OSF_CONNECTOR)
+				exit_error(PARAMETER_PROBLEM, "Can't specify multiple connector parameter");
+			*flags |= IPT_OSF_CONNECTOR;
+			info->flags |= IPT_OSF_CONNECTOR;
+			break;
 		default:
 			return 0;
 	}







	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
