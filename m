From: Thomas Woerner <twoerner@redhat.com>
Subject: iptables-save (1.2.8): ports and levels
Date: Thu, 10 Jul 2003 15:55:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F0D705B.8000708@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020602010000090405040401"
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

This is a multi-part message in MIME format.
--------------020602010000090405040401
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Hello,


I have attached a patch to fix iptable-save behavior. Normally port 
numbers are saved. But multiport and mport are saving service names 
instead of port numbers.
LOG is also saving log names instead of log levels.

The patch enables numeric output for multiport and mport. The patch is 
fixing this.


Thanks in advance
Thomas Woerner

-- 
Thomas Woerner, Software Developer     Phone: +49-711-96437-0
Red Hat GmbH                           Fax  : +49-711-96437-111
Hauptstaetterstr. 58                   Email: twoerner@redhat.com
D-70178 Stuttgart                      Web  : http://www.redhat.de/

--------------020602010000090405040401
Content-Type: text/plain;
 name="iptables-1.2.8-numeric.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-1.2.8-numeric.patch"

--- iptables-1.2.8/extensions/libip6t_multiport.c.numeric	2003-07-10 12:35:27.000000000 +0200
+++ iptables-1.2.8/extensions/libip6t_multiport.c	2003-07-10 12:35:27.000000000 +0200
@@ -237,7 +237,7 @@
 
 	for (i=0; i < multiinfo->count; i++) {
 		printf("%s", i ? "," : "");
-		print_port(multiinfo->ports[i], ip->proto, 0);
+		print_port(multiinfo->ports[i], ip->proto, 1);
 	}
 	printf(" ");
 }
--- iptables-1.2.8/extensions/libipt_mport.c.numeric	2003-07-10 12:35:27.000000000 +0200
+++ iptables-1.2.8/extensions/libipt_mport.c	2003-07-10 12:35:27.000000000 +0200
@@ -276,10 +276,10 @@
                     && minfo->ports[i-1] == minfo->ports[i])
                         break;
 		printf("%s", i ? "," : "");
-		print_port(minfo->ports[i], ip->proto, 0);
+		print_port(minfo->ports[i], ip->proto, 1);
                 if (pflags & (1<<i)) {
                         printf(":");
-                        print_port(minfo->ports[++i], ip->proto, 0);
+                        print_port(minfo->ports[++i], ip->proto, 1);
                 }
 	}
 	printf(" ");
--- iptables-1.2.8/extensions/libipt_multiport.c.numeric	2003-07-10 12:35:27.000000000 +0200
+++ iptables-1.2.8/extensions/libipt_multiport.c	2003-07-10 12:35:27.000000000 +0200
@@ -237,7 +237,7 @@
 
 	for (i=0; i < multiinfo->count; i++) {
 		printf("%s", i ? "," : "");
-		print_port(multiinfo->ports[i], ip->proto, 0);
+		print_port(multiinfo->ports[i], ip->proto, 1);
 	}
 	printf(" ");
 }
--- iptables-1.2.8/extensions/libipt_LOG.c.numeric	2003-07-10 12:35:27.000000000 +0200
+++ iptables-1.2.8/extensions/libipt_LOG.c	2003-07-10 12:43:20.000000000 +0200
@@ -230,16 +230,8 @@
 	if (strcmp(loginfo->prefix, "") != 0)
 		printf("--log-prefix \"%s\" ", loginfo->prefix);
 
-	if (loginfo->level != LOG_DEFAULT_LEVEL) {
-		for (i = 0;
-		     i < sizeof(ipt_log_names) / sizeof(struct ipt_log_names);
-		     i++) {
-			if (loginfo->level == ipt_log_names[i].level) {
-				printf("--log-level %s ", ipt_log_names[i].name);
-				break;
-			}
-        }
-    }
+	if (loginfo->level != LOG_DEFAULT_LEVEL)
+		printf("--log-level %d ", loginfo->level);
 
 	if (loginfo->logflags & IPT_LOG_TCPSEQ)
 		printf("--log-tcp-sequence ");
--- iptables-1.2.8/extensions/libip6t_LOG.c.numeric	2003-07-10 12:35:27.000000000 +0200
+++ iptables-1.2.8/extensions/libip6t_LOG.c	2003-07-10 12:43:15.000000000 +0200
@@ -230,16 +230,8 @@
 	if (strcmp(loginfo->prefix, "") != 0)
 		printf("--log-prefix \"%s\" ", loginfo->prefix);
 
-	if (loginfo->level != LOG_DEFAULT_LEVEL) {
-		for (i = 0;
-		     i < sizeof(ip6t_log_names) / sizeof(struct ip6t_log_names);
-		     i++) {
-			if (loginfo->level == ip6t_log_names[i].level) {
-				printf("--log-level %s ", ip6t_log_names[i].name);
-				break;
-			}
-        }
-    }
+	if (loginfo->level != LOG_DEFAULT_LEVEL)
+		printf("--log-level %d ", loginfo->level);
 
 	if (loginfo->logflags & IP6T_LOG_TCPSEQ)
 		printf("--log-tcp-sequence ");

--------------020602010000090405040401--
