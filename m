From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] ipset: fix syntax error in bash completion and hyphen used
 as minus sign in manpage
Date: Sat, 11 May 2013 08:34:52 +0700
Message-ID: <20130511013452.GA31273@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54027 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3EKBfB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 21:35:01 -0400
Received: by mail-pd0-f174.google.com with SMTP id u10so3132515pdi.5
        for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2013 18:35:01 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I have prepared the Debian package for new 6.19 release,
The Lintian (Debian packaging tool) has warned about the syntax error in
ipset bash completion script and also the hyphen used as minus sign in
manpage.

The syntax error is shown as below.

$ bash ipset_bash_completion
ipset_bash_completion: line 680: syntax error near unexpected token `('    =
                                                                =20
ipset_bash_completion: line 680: `
@(create|n|add|del|test|destroy|x|list|save|restore|flush|rename|e|swap|w|h=
elp|version))'

Therefore, the patches was included in debian package and push to github
which prepared for the pull-request.

Please consider to merge them.

Best regards,
Neutron Soutmun


The following changes since commit 85196765617c27d69155618d113addbc418679ad:

  ipset 6.19 released (2013-05-09 17:33:39 +0200)

are available in the git repository at:

  git://github.com/neutronth/ipset.git debian-fix

for you to fetch changes up to 77124447af920585d53dd3e28e2a41e5418f1d3d:

  Fix hyphen used as minus sign in manpage (2013-05-11 07:58:22 +0700)

----------------------------------------------------------------
Neutron Soutmun (2):
      Set extglob shell option in global scoped
      Fix hyphen used as minus sign in manpage

 src/ipset.8                                       |    2 +-
 utils/ipset_bash_completion/ipset_bash_completion |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/ipset.8 b/src/ipset.8
index 6e627a2..7bb55e1 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -278,7 +278,7 @@ ipset create test hash:ip timeout 300
 .IP
 ipset add test 192.168.0.1 timeout 60
 .IP
-ipset -exist add test 192.168.0.1 timeout 600
+ipset \-exist add test 192.168.0.1 timeout 600
 .PP=20
 .SS nomatch
 The \fBhash\fR set types which can store \fBnet\fR type of data (i.e. hash=
:*net*)
diff --git a/utils/ipset_bash_completion/ipset_bash_completion b/utils/ipse=
t_bash_completion/ipset_bash_completion
index cc7ea7b..69ba635 100644
--- a/utils/ipset_bash_completion/ipset_bash_completion
+++ b/utils/ipset_bash_completion/ipset_bash_completion
@@ -47,6 +47,8 @@
 #
 # -----------------------------------------------------------------
=20
+shopt -s extglob
+
 # -----------------------------------------------------------------
 # Functions
 # -----------------------------------------------------------------
@@ -537,7 +539,6 @@ done < "${_IPSET_IPLIST_FILE}"
 # -----------------------------------------------------------------
=20
 _ipset_complete() {
-shopt -s extglob
 local cur prev cword words ips_version
 local str_action str_setname str_type str_filename
 local str_glob str_regex str_prefix str_suffix

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRjaA8AAoJEJ0EcL2mzcRXUC8P/3U3lIgVyDHsKnxF1bSJYaJv
XIHfJpjvVpOO4W55eCer2r9Z4nNioXCMthsAZ5RNphCBMj/xVLjTwl2uVihBPVCj
AwrTOPWdJVjlP2+UymUV3gQSwNh5yQ8NOwmtLaG150UGcxiCbKjkdY4ony/2rA4t
aapaFZI9TVBdlGfBm5PUsGQPfEeTYeeNctrG0Q1MKt8jhBA5cSP5j6ykQOXc/RbT
BtpsE7rKG00Rb8C8V7shDDOiHNR/Sf/1YyDXXYgS5YhpzaEV8C0QEeLGLU0/mE02
tTWUWt6upC996ZUu+Q4OQ6aJ7zPLL4SzzUJWmhEZicojAyFqmgER8tnWeXQTudhE
ehCRNpC+DpYW1Tulf69NQF1Kxyqmxah8hMq+WXFUXjCaqeoQIZ/SN0fxcAkTmlQV
6BoArcoPgD/aOvv1YV5XplS2WUdra1NDrMktmN7/9CPA23D8sdj9supeXMbMyEpe
TKlLg6O7qgc1PyTWP+hrwcImmrgGDFP09D6VwnKG4TySHJhoIvkuiIOYIoraMuE+
PK8y6zYknmr6p6WRAkeFLvYaULkWTgSgFbaxXOEsRbvsheYM37002Z+DOskl1s+N
8M5VaYcL+B5YuRapxQ5tPxbzlmedMKZSNXnxsMDrGgdLaAHNHtPjbZo1dWlYfrl/
B+DFx4VwjhfToh2mjMSA
=WqiW
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
