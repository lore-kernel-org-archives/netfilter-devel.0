From: Karsten Desler <kdesler@soohrt.org>
Subject: Re: minor bug in iptables 1.2.9
Date: Sat, 31 Jan 2004 14:56:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040131135609.GA11570@soohrt.org>
References: <20040130084832.GA5527@sit0.ifup.net> <1075555394.22658.0.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1075555394.22658.0.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

Hi,

today I had a little more time to look at the code. A few lines
down, there's another incarnation of the same bug.
line 641:

	char buf[256];
	...
	strncpy(buf, name, sizeof(buf) - 1);
	if ((p = strrchr(buf, '/')) != NULL) {
	...

Patch attached.
  Karsten

--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="iptables-1.2.9-overflow2.patch"

--- iptables~.c	2004-01-31 14:42:29.000000000 +0100
+++ iptables.c	2004-01-31 14:53:57.000000000 +0100
@@ -639,6 +640,7 @@
 	int i, j, k, n;
 
 	strncpy(buf, name, sizeof(buf) - 1);
+	buf[sizeof(buf) - 1] = '\0';
 	if ((p = strrchr(buf, '/')) != NULL) {
 		*p = '\0';
 		addrp = parse_mask(p + 1);

--PNTmBPCT7hxwcZjr--
