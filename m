From: Jan Holmberg <jan@artech.net>
Subject: Patch to save ca 100.000 kbyte, integrate save & restore to iptables
Date: Mon, 20 Sep 2004 17:24:08 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414EF618.4070602@artech.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030706020500020209010405"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030706020500020209010405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

A patch to save flash memory in embedded system  and make a symbolic 
link to iptables
to iptables-save and iptables-restore. More than 100.000 kbyte saved 
with this patch.


//Jan

--------------030706020500020209010405
Content-Type: text/plain;
 name="patch-iptables-1.2.9-hoj.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-iptables-1.2.9-hoj.diff"

diff -ur iptables-1.2.9/iptables-restore.c iptables-1.2.9-p/iptables-restore.c
--- iptables-1.2.9/iptables-restore.c	Sat May  3 20:52:13 2003
+++ iptables-1.2.9-p/iptables-restore.c	Sun May 23 23:14:51 2004
@@ -97,7 +97,7 @@
 		free(newargv[i]);
 }
 
-int main(int argc, char *argv[])
+int do_restore(int argc, char *argv[])
 {
 	iptc_handle_t handle = NULL;
 	char buffer[10240];
Only in iptables-1.2.9-p/: iptables-save
diff -ur iptables-1.2.9/iptables-save.c iptables-1.2.9-p/iptables-save.c
--- iptables-1.2.9/iptables-save.c	Sat May  3 20:52:13 2003
+++ iptables-1.2.9-p/iptables-save.c	Sun May 23 22:46:22 2004
@@ -313,7 +313,7 @@
  * :Chain name POLICY packets bytes
  * rule
  */
-int main(int argc, char *argv[])
+int do_save(int argc, char *argv[])
 {
 	const char *tablename = NULL;
 	int c;
diff -ur iptables-1.2.9/iptables-standalone.c iptables-1.2.9-p/iptables-standalone.c
--- iptables-1.2.9/iptables-standalone.c	Thu Aug  8 15:36:19 2002
+++ iptables-1.2.9-p/iptables-standalone.c	Sun May 23 23:15:52 2004
@@ -37,6 +37,10 @@
 #include <string.h>
 #include <iptables.h>
 
+int do_save(int, char *[]);
+ 
+int do_restore(int, char *[]);
+ 
 int
 main(int argc, char *argv[])
 {
@@ -50,7 +54,15 @@
 #ifdef NO_SHARED_LIBS
 	init_extensions();
 #endif
-
+  
+        if ( strlen(argv[0]) >=13 && 
+          !strncmp(argv[0]+strlen(argv[0])-13,"iptables-save",13)) 
+             return (do_save(argc, argv));  
+          
+        if ( strlen(argv[0]) >=16 && 
+          !strncmp(argv[0]+strlen(argv[0])-16,"iptables-restore",16)) 
+             return (do_restore(argc, argv));  
+          
 	ret = do_command(argc, argv, &table, &handle);
 	if (ret)
 		ret = iptc_commit(&handle);
@@ -58,6 +70,6 @@
 	if (!ret)
 		fprintf(stderr, "iptables: %s\n",
 			iptc_strerror(errno));
-
+        
 	exit(!ret);
 }
Only in iptables-1.2.9-p/: iptables-standalone.d
diff -ur iptables-1.2.9/iptables.c iptables-1.2.9-p/iptables.c
--- iptables-1.2.9/iptables.c	Sun Jun 15 00:39:35 2003
+++ iptables-1.2.9-p/iptables.c	Sun May 23 22:30:18 2004
@@ -2296,3 +2296,4 @@
 
 	return ret;
 }
+
Only in iptables-1.2.9-p/: iptables.d
Only in iptables-1.2.9-p/libiptc: libip4tc.d
Only in iptables-1.2.9-p/libiptc: libip6tc.d
Only in iptables-1.2.9-p/: patch-o-matic

--------------030706020500020209010405--
