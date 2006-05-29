From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] trivial connlimit manpage fix
Date: Mon, 29 May 2006 08:53:36 -0700
Message-ID: <20060529155336.GA11270@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Transfer-Encoding: 8bit
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
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

As pointed out by Sérgio Luís Martins in bug #475, the
connlimit example is missing a chain.

Phil



--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-clman

diff -ru ipt-orig/extensions/libipt_connlimit.man ipt-new/extensions/libipt_connlimit.man
--- ipt-orig/extensions/libipt_connlimit.man	2005-03-31 22:54:23.000000000 -0800
+++ ipt-new/extensions/libipt_connlimit.man	2006-05-29 08:50:24.000000000 -0700
@@ -10,10 +10,10 @@
 Examples:
 .TP
 # allow 2 telnet connections per client host
-iptables -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT
+iptables -A INPUT -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT
 .TP
 # you can also match the other way around:
-iptables -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT
+iptables -A INPUT -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT
 .TP
 # limit the nr of parallel http requests to 16 per class C sized \
 network (24 bit netmask)

--opJtzjQTFsWo+cga--
