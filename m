From: Karsten Desler <kdesler@soohrt.org>
Subject: minor bug in iptables 1.2.9
Date: Fri, 30 Jan 2004 09:48:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040130084832.GA5527@sit0.ifup.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

while reading the iptables 1.2.9 source, I found this small bug in
iptables.c line 276:

struct in_addr *
dotted_to_addr(const char *dotted)
{
	char buf[20];
	...

	/* copy dotted string, because we need to modify it */
	strncpy(buf, dotted, sizeof(buf) - 1);
	...

strncpy does not \0-terminate strings if strlen(src) == n, thus the
following loop can easily run over the end of buf, if a big enough
mask is given:
  iptables -A INPUT -p tcp -s 1.1.1.1/000000000000000000.

Attached is a patch to fix this problem.

    Karsten

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-1.2.9-overflow.patch"

--- iptables~.c	2004-01-30 09:34:29.000000000 +0100
+++ iptables.c	2004-01-30 09:35:14.000000000 +0100
@@ -274,6 +274,7 @@
 
 	/* copy dotted string, because we need to modify it */
 	strncpy(buf, dotted, sizeof(buf) - 1);
+	buf[sizeof(buf) - 1] = '\0';
 	addrp = (unsigned char *) &(addr.s_addr);
 
 	p = buf;

--k1lZvvs/B4yU6o8G--
