From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Fw: a small bug in iptables.c and ip6tables.c get_modprobe()
Date: Thu, 14 Oct 2004 08:46:20 +0300
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041014054620.GG4827@nalle>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Didn't see this message in the archive, so perhaps cc'ing the list
doesn't work. Sorry if this is a double post.

-Mikko

----- Forwarded message -----

To: 219686@bugs.debian.org
Cc: debian-firewall@lists.debian.org, netfilter-devel@lists.netfilter.org
Subject: a small bug in iptables.c and ip6tables.c get_modprobe()

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


----- End forwarded message -----
