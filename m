From: Chris Zubrzycki <beren@mac.com>
Subject: Re: netfilter/iptables - small patch
Date: Fri, 5 Dec 2003 00:12:26 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <9E16F37A-26E1-11D8-B36F-000A959832EC@mac.com>
Mime-Version: 1.0 (Apple Message framework v606)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-3--47849894"
Content-Transfer-Encoding: 7bit
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


--Apple-Mail-3--47849894
Content-Type: multipart/mixed; boundary=Apple-Mail-2--47849897


--Apple-Mail-2--47849897
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed

Hey guys, I made a small patch to the iptables makefile, which 
enables/fixes the install-devel-headers target, which is needed for our 
match plugin ipt_p2p. Hope it makes it into the next release. ;-)  Has 
anyone thought of converting the makefile to automake? It might be much 
easier to upgrade and maintain, and at least it's not as evil as 
autoconf ;-)


--Apple-Mail-2--47849897
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="iptables-1.2.9.diff"
Content-Disposition: attachment;
	filename=iptables-1.2.9.diff

--- Makefile	Sun Nov  2 12:00:08 2003
+++ Makefile.new	Fri Dec  5 00:03:26 2003
@@ -83,6 +83,8 @@
 IPT_LIBDIR:=$(LIBDIR)/iptables
 endif
 
+DEVEL_HEADERS:="include/ip6tables.h  include/iptables.h  include/iptables_common.h  include/libippool  include/libipq  include/libiptc  include/libipulog"
+
 .PHONY: default
 default: print-extensions all
 
@@ -157,7 +159,7 @@
 .PHONY: install-devel-headers
 install-devel-headers: $(DEVEL_HEADERS)
 	@[ -d $(DESTDIR)$(INCDIR) ] || mkdir -p $(DESTDIR)$(INCDIR)
-	@cp -v $(DEVEL_HEADERS) $(DESTDIR)$(INCDIR)
+	@cp -rv $(DEVEL_HEADERS) $(DESTDIR)$(INCDIR)
 
 .PHONY: install-devel-libs
 install-devel-libs: $(DEVEL_LIBS)

--Apple-Mail-2--47849897
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed



-chris zubrzycki
- --
PGP public key: http://homepage.mac.com/beren/publickey.txt
ID: 0xA2ABC070
Fingerprint: 26B0 BA6B A409 FA83 42B3  1688 FBF9 8232 A2AB C070
========================================================
"Of course, you realize this means war."
-B. Bunny


--Apple-Mail-2--47849897--

--Apple-Mail-3--47849894
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (Darwin)

iD8DBQE/0BO++/mCMqKrwHARAnBFAKCq14+kDMuhWquqlWf3ZsJzZbQGlACeOHLf
H4FNoviEweGn/l1xbANEEHo=
=xZqK
-----END PGP SIGNATURE-----

--Apple-Mail-3--47849894--
