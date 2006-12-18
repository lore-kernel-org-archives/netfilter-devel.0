From: Harald Welte <laforge@netfilter.org>
Subject: [gentuu@gmail.com: iptables static build bug]
Date: Mon, 18 Dec 2006 10:40:37 +0100
Message-ID: <1314.64228402383$1166435150@news.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QwZB9vYiNIzNXIj"
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


--+QwZB9vYiNIzNXIj
Content-Type: multipart/mixed; boundary="8S1fMsFYqgBC+BN/"
Content-Disposition: inline


--8S1fMsFYqgBC+BN/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please verify this bug report / patch, thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8S1fMsFYqgBC+BN/
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: Received: from ganesha.gnumonks.org ([unix socket])
	by ganesha (Cyrus v2.1.18-IPv6-Debian-2.1.18-1+sarge2) with LMTP;
	Mon, 18 Dec 2006 10:29:12 +0100
X-Sieve: CMU Sieve 2.2
Return-path: <gentuu@gmail.com>
Received: from nf-out-0910.google.com ([64.233.182.187])
	by ganesha.gnumonks.org with esmtp (Exim 4.50) id 1GwEo3-0008S3-Jn
	for laforge@gnumonks.org; Mon, 18 Dec 2006 10:29:11 +0100
Received: by nf-out-0910.google.com with SMTP id i2so578016nfe
	for <laforge@gnumonks.org>; Mon, 18 Dec 2006 01:29:10 -0800 (PST)
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=gmail.com;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
	b=r/LjZk42jlJKKl23X5JFkkiGkehrfF0XyivsMfB5zwZReIu8Y6SteFBDz9PB14QnJtsr1HwTN6qRtSZrwhp3sD5lAbtUuCGUWrhctbbTDA/QUtFJanP1aQ1aoCbXQyaLt8zavxiBXrTZ8wgX7iWYdNRmxYGj2M/7Tuw8shL68DE=
Received: by 10.82.127.15 with SMTP id z15mr506699buc.1166434150168;
	Mon, 18 Dec 2006 01:29:10 -0800 (PST)
Received: by 10.82.160.18 with HTTP; Mon, 18 Dec 2006 01:29:10 -0800 (PST)
Message-ID: <9fd9b9b50612180129u31b2f006q5dba016de9eeabd9@mail.gmail.com>
Date: Mon, 18 Dec 2006 11:29:10 +0200
From: "Tux P" <gentuu@gmail.com>
To: marc@mbsi.ca
Subject: iptables static build bug
Cc: laforge@gnumonks.org, jmorris@intercode.com.au
In-Reply-To: <9fd9b9b50612180117m3e70db62q41f16784dddb43bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_9481_16282572.1166434150087"
References: <9fd9b9b50612180117m3e70db62q41f16784dddb43bb@mail.gmail.com>
X-Spam-Score: 0.1 (/)
X-Spam-Report: SpamASsassin versoin 3.0.3 on ganesha.gnumonks.org summary:
	Content analysis details:   (0.1 points, 5.0 required)
	pts rule name              description
	---- ----------------------
	--------------------------------------------------
	0.0 RCVD_BY_IP             Received by mail server with no name
	0.0 HTML_60_70             BODY: Message is 60% to 70% HTML
	0.0 HTML_MESSAGE           BODY: HTML included in message

------=_Part_9481_16282572.1166434150087
Content-Type: multipart/alternative;
	boundary="----=_Part_9482_24800286.1166434150087"

------=_Part_9482_24800286.1166434150087
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi *,

I found subj. Static iptables tries to load kernel modules
(modprobe fails and shows pesky message about every iptables run)
regardless their static present in the kernel.

and created a simple patch to fix this.
Please look (also attached):

--- iptables-1.3.7/iptables.c.orig      2006-12-04 03:15:20.000000000 -0800
+++ iptables-1.3.7/iptables.c   2006-12-18 00:50:51.000000000 -0800
@@ -774,7 +774,7 @@
        }
 #else
        if (ptr && !ptr->loaded) {
-               if (tryload != DONT_LOAD)
+               if (tryload != DONT_LOAD && tryload != DURING_LOAD)
                        ptr->loaded = 1;
                else
                        ptr = NULL;
@@ -1093,7 +1093,7 @@
        }
 #else
        if (ptr && !ptr->loaded) {
-               if (tryload != DONT_LOAD)
+               if (tryload != DONT_LOAD && tryload != DURING_LOAD)
                        ptr->loaded = 1;
                else
                        ptr = NULL;



Thanks

Nick

------=_Part_9482_24800286.1166434150087--

------=_Part_9481_16282572.1166434150087
Content-Type: application/octet-stream; name="static_iptables_modprobe.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="static_iptables_modprobe.patch"
X-Attachment-Id: f_evuorkrt

LS0tIGlwdGFibGVzLTEuMy43L2lwdGFibGVzLmMub3JpZwkyMDA2LTEyLTA0IDAzOjE1OjIwLjAw
MDAwMDAwMCAtMDgwMAorKysgaXB0YWJsZXMtMS4zLjcvaXB0YWJsZXMuYwkyMDA2LTEyLTE4IDAw
OjUwOjUxLjAwMDAwMDAwMCAtMDgwMApAQCAtNzc0LDcgKzc3NCw3IEBACiAJfQogI2Vsc2UKIAlp
ZiAocHRyICYmICFwdHItPmxvYWRlZCkgewotCQlpZiAodHJ5bG9hZCAhPSBET05UX0xPQUQpCisJ
CWlmICh0cnlsb2FkICE9IERPTlRfTE9BRCAmJiB0cnlsb2FkICE9IERVUklOR19MT0FEKQogCQkJ
cHRyLT5sb2FkZWQgPSAxOwogCQllbHNlCiAJCQlwdHIgPSBOVUxMOwpAQCAtMTA5Myw3ICsxMDkz
LDcgQEAKIAl9CiAjZWxzZQogCWlmIChwdHIgJiYgIXB0ci0+bG9hZGVkKSB7Ci0JCWlmICh0cnls
b2FkICE9IERPTlRfTE9BRCkKKwkJaWYgKHRyeWxvYWQgIT0gRE9OVF9MT0FEICYmIHRyeWxvYWQg
IT0gRFVSSU5HX0xPQUQpCiAJCQlwdHItPmxvYWRlZCA9IDE7CiAJCWVsc2UKIAkJCXB0ciA9IE5V
TEw7Cg==
------=_Part_9481_16282572.1166434150087--

--8S1fMsFYqgBC+BN/--

--+QwZB9vYiNIzNXIj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFhmIUXaXGVTD0i/8RAk0LAKCensjw0dGj+fLaA3tSTKr7gLfjrwCfftT7
EAJo38B03Hk2LD8my74WJ5I=
=zwC+
-----END PGP SIGNATURE-----

--+QwZB9vYiNIzNXIj--
