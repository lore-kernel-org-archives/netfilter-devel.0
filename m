From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [PATCH] improve REDIRECT manpage
Date: Mon, 14 Mar 2005 14:08:47 +0200
Message-ID: <42357ECF.4080009@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060804080107030000030007"
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

This is a multi-part message in MIME format.
--------------060804080107030000030007
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Added a line about the fact that the new destination address is the primary
address of the incoming interface.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCNX7NxyF48ZTvn+4RAkKiAKDge3iFzfVvybiMML5jSeJV5I4uxwCfQaqV
zYr7VhWIwQQ3tFCFvYm3/D0=
=gqPP
-----END PGP SIGNATURE-----

--------------060804080107030000030007
Content-Type: text/x-patch;
 name="REDIRECT-manpage-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="REDIRECT-manpage-1.patch"

--- orig-iptables-1.3.1/extensions/libipt_REDIRECT.man	2004-10-10 12:56:24.000000000 +0300
+++ iptables-1.3.1/extensions/libipt_REDIRECT.man	2005-03-14 14:04:49.029809038 +0200
@@ -5,9 +5,10 @@
 and
 .B OUTPUT
 chains, and user-defined chains which are only called from those
-chains.  It alters the destination IP address to send the packet to
-the machine itself (locally-generated packets are mapped to the
-127.0.0.1 address).  It takes one option:
+chains.  It redirects the packet to the machine itself by changing the
+destination IP to the primary address of the incoming interface
+(locally-generated packets are mapped to the 127.0.0.1 address).  It
+takes one option:
 .TP
 .BR "--to-ports " "\fIport\fP[-\fIport\fP]"
 This specifies a destination port or range of ports to use: without

--------------060804080107030000030007--
