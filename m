From: Kevin Fenzi <kevin@scrye.com>
Subject: nftables/libnftables packages for Fedora
Date: Sun, 12 Jan 2014 13:40:24 -0700
Message-ID: <20140112134024.2475a4f2@voldemort.scrye.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/t2MwdbCP2pz.SCDWnCRSF+Z"; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:43916
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaALUqk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 15:46:40 -0500
Received: from voldemort.scrye.com (localhost [IPv6:::1])
	by voldemort.scrye.com (Postfix) with ESMTP id 7CBC421601
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Jan 2014 13:40:28 -0700 (MST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/t2MwdbCP2pz.SCDWnCRSF+Z
Content-Type: multipart/mixed; boundary="MP_/H3fsLG=llNqeKEZnpDgMI2E"

--MP_/H3fsLG=llNqeKEZnpDgMI2E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Greetings.=20

I apologize in advance if this is not the right place to discuss this.
If it's not, please point me the right direction and I will move it
there. :)=20

I am packaging up libnftables/nftables for Fedora.=20

libnftables has already passed review:=20
https://bugzilla.redhat.com/show_bug.cgi?id=3D1036319

and nftables has yet to be reviewed:=20
https://bugzilla.redhat.com/show_bug.cgi?id=3D1036320
but has some comments. (more always welcome)

I have some questions/comments/suggestions based on the packaging that
I thought would be good to run by nftables developers.=20

1. Completely minor, but noted in review of both packages that the
COPYING file has the old fsf address in it. Would be great if you could
update to the new one.=20
https://fedoraproject.org/wiki/Common_Rpmlint_issues#incorrect-fsf-address

2. There is some question about the /etc/nftables/* scripts. In Fedora
land, things in /etc/ should be config files, but these aren't really
config files. They call nft without a full path (/usr/sbin/nft, etc).
Should these really be in /usr/share ? or is it expected users will
modify them? Could you clarify the use case there?

3. nftables hard codes installing as root, which is no good for
building packages (patch attached that just removes the owner/group
setting there).=20

4. nftables sets make to '-s' (ie, silent) on subdirs. It's good for
building packages to have verbose output in build logs. Would it be
possible to remove that? If not I can patch it out here.=20

5. Is there currently, or planned any version coupling between
libnftables and nftables? Obviously we want them to stay somewhat
close, but down the road will compat be just by soname/version?=20

6. I recently enabled the xml stuff in libnftables and am seeing a
number of tests fail:=20

parsing xmlfiles/55-rule-real.xml: =1B[31mFAILED=1B[0m (Invalid argument)
and
parsing xmlfiles/74-set.xml: =1B[31mFAILED=1B[0m (Invalid argument)
mxml: <!-- nft add rule filter output ct secmark 0 counter --> cannot
be a second root node after <nftables>

Full build log at:=20
http://kojipkgs.fedoraproject.org//packages/libnftables/0/0.4.20140111git.f=
c21/data/logs/x86_64/build.log

Are these expected? The Invalid argument might be because it doesn't
have nftables available in the build kernel? But the json tests
work. :(=20

Thanks. Again, if I should send this somewhere else instead, just let
me know. Comments welcome here, direct email and/or in the above review
bugs. ;)=20

kevin

--MP_/H3fsLG=llNqeKEZnpDgMI2E
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=nftables-install.patch

diff -Nur nftables-0.0.orig/doc/Makefile.in nftables-0.0/doc/Makefile.in
--- nftables-0.0.orig/doc/Makefile.in	2013-11-29 03:29:41.000000000 -0700
+++ nftables-0.0/doc/Makefile.in	2013-11-30 14:31:33.159267834 -0700
@@ -10,11 +10,11 @@
 		@echo -e "  INSTALL\tdoc"
 		if test -n "$(mandocs-y)"; then \
 			$(MKDIR_P) $(DESTDIR)/${mandir}/man8 ;\
-			$(INSTALL) -m 755 -o root -g root $(mandocs-y) \
+			$(INSTALL) -m 755 -p $(mandocs-y) \
 					$(DESTDIR)/${mandir}/man8/ ;\
 		fi
 		if test -n "$(pdfdocs-y)"; then \
 			$(MKDIR_P) $(DESTDIR)/${pdfdir} ;\
-			$(INSTALL) -m 755 -o root -g root $(pdfdocs-y) \
+			$(INSTALL) -m 755 -p $(pdfdocs-y) \
 					$(DESTDIR)/${pdfdir}/ ;\
 		fi
diff -Nur nftables-0.0.orig/files/Makefile.in nftables-0.0/files/Makefile.in
--- nftables-0.0.orig/files/Makefile.in	2013-11-29 03:29:41.000000000 -0700
+++ nftables-0.0/files/Makefile.in	2013-11-30 14:30:35.440421941 -0700
@@ -1,4 +1,4 @@
 install:
 	@echo -e "  INSTALL\tfiles"
 	$(MKDIR_P) $(DESTDIR)/$(confdir)
-	$(INSTALL) -m 755 -o root -g root $(SUBDIR)nftables/* $(DESTDIR)/$(confdi=
r)/
+	$(INSTALL) -m 755 -p $(SUBDIR)nftables/* $(DESTDIR)/$(confdir)/
diff -Nur nftables-0.0.orig/Makefile.rules.in nftables-0.0/Makefile.rules.in
--- nftables-0.0.orig/Makefile.rules.in	2013-11-29 03:29:41.000000000 -0700
+++ nftables-0.0/Makefile.rules.in	2013-11-30 14:26:03.461158244 -0700
@@ -61,7 +61,7 @@
 $(1)-install:
 			@echo -e "  INSTALL\t$1"
 			$(MKDIR_P) $$(DESTDIR)/$$($(1)-destdir)
-			$(INSTALL) -m 755 -o root -g root \
+			$(INSTALL) -m 755 -p \
 				$(SUBDIR)$(1) \
 				$$(DESTDIR)/$$($(1)-destdir)/$(1)
 install_targets		+=3D $(1)-install

--MP_/H3fsLG=llNqeKEZnpDgMI2E--

--Sig_/t2MwdbCP2pz.SCDWnCRSF+Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJS0v28AAoJEEs3sNgP+7teCtgQAIEf6BlKzIFLjlYo2qWCImVM
CB56iwqG/jhJZr6LtWWYuiDIV7+Nuh+FB8GzVuIP4Cvh+5rz7GUmib3oeftTttv/
5oQeu9/F/qephKI7l/Xf4tcmJxyQgzKsI7/qf4Z1RDpmpq1SYxa+IxgHmmutSEmE
kOWe8ZdQk9P5MJl31qgiUc4wjXkyoImTM15Kgbu0ZvDRJB5wtjRMXw5DiVm8hX7K
6wESLF7wDjGvioOb2kaV/NnRocSuqT2MIFWAq0viGYhtB7Wkfpcy7JMAHPPu0Qx9
7UTrZEJPZSSdxNAywHCUFZQhRWBcL/AvG5kacZJ9l/glpbJUq5mstZpK8p7crugF
Kwmr5p8RSVhzjL3krbfAYH/Y5sddt0igX7C+I8mdGmoMnmRP8FQQezUUtZQxbltw
zjGUVivBY25baIsR1l6ILrqoY3H7assg3uAQoagFFu7dNlNMe5lUjvXxKdwHuJ34
ATEIuOfRDzsxRUFYtc32O5p0iU7Cl0XdERbBAKGhLAWOUSEUCQgKBT+UIl5br3cD
AQEjgxFQnxR8d19ygN/qVihHTpCItM8H+oo+VbYmAR+0f5CFQ3kENhHdKJ/LDC7d
9KF8WHq8oF2KZDQeg0ZNtCHnAJ0vGwTvlCBJI9lCe+U6qfojdawqGH7lRlE4bVEB
k9GJBvPSlHzDnjSicDhX
=xWUw
-----END PGP SIGNATURE-----

--Sig_/t2MwdbCP2pz.SCDWnCRSF+Z--
