From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: a small bug in iptables.c and ip6tables.c get_modprobe()
Date: Thu, 14 Oct 2004 02:53:42 +0300
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041013235342.GD4827@nalle>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_DzwR/p5e7iHuZaSo/7nRvA)"
Cc: netfilter-devel@lists.netfilter.org, debian-firewall@lists.debian.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: 219686@bugs.debian.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--Boundary_(ID_DzwR/p5e7iHuZaSo/7nRvA)
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline

Hello,

This #219686 Lokkit bug in Debian is not actually a Lokkit bug but an iptables
bug, heh. Firewall or other scripts should not have to load iptables 
modules since iptables the executable can do it for them. strace and gdb
showed - after some head scratching - why an 'iptables -L' or 
'iptables -N foo' loaded the modules but 'iptables -N RH-Lokkit-0-50-INPUT' 
did not.

Attached patches fixes this in iptables 1.2.9, which is now in Debian
testing, and they also apply to the latest 1.2.11 from netfilter.org.

I'm not on the Cc'd lists, so could you please Cc me in if you reply,
thanks.

-Mikko

--Boundary_(ID_DzwR/p5e7iHuZaSo/7nRvA)
Content-type: text/plain; charset=us-ascii; NAME=iptables_modprobe_fix.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=iptables_modprobe_fix.patch

--- iptables.c-original	2004-10-13 20:22:34.000000000 +0300
+++ iptables.c	2004-10-14 02:23:21.000000000 +0300
@@ -1565,8 +1565,9 @@
 	if (procfile < 0)
 		return NULL;
 
-	ret = malloc(1024);
+	ret = (char *) malloc(1024);
 	if (ret) {
+		memset (ret, 0, 1024);
 		switch (read(procfile, ret, 1024)) {
 		case -1: goto fail;
 		case 1024: goto fail; /* Partial read.  Wierd */

--Boundary_(ID_DzwR/p5e7iHuZaSo/7nRvA)
Content-type: text/plain; charset=us-ascii; NAME=ip6tables_modprobe_fix.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=ip6tables_modprobe_fix.patch

--- ip6tables.c-original	2004-10-14 02:22:06.000000000 +0300
+++ ip6tables.c	2004-10-14 02:25:11.000000000 +0300
@@ -1568,8 +1568,9 @@
 	if (procfile < 0)
 		return NULL;
 
-	ret = malloc(1024);
+	ret = (char *) malloc(1024);
 	if (ret) {
+		memset (ret, 0, 1024);
 		switch (read(procfile, ret, 1024)) {
 		case -1: goto fail;
 		case 1024: goto fail; /* Partial read.  Wierd */

--Boundary_(ID_DzwR/p5e7iHuZaSo/7nRvA)--
