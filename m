From: Harald Welte <laforge@gnumonks.org>
Subject: [jorge@dti2.net: Re: Fw: PROBLEM: PATCH for 2.4.23-pre4 and up hang on one system]
Date: Wed, 12 Nov 2003 09:33:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031112083357.GA19776@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com.br>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
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


--zx4FCpZtqtKETZ7O
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi again!

Since there is now a second bug report on that 'fix', I think it's
better to back it out for 2.4.23.  The code has been without that 'fix'
for the whole 2.4.x time, and it didn't seem to cause any real problem.

So rather than fixing the theoretical case, I'd say we keep the code
like before (please revert the below patch) and make user complaints go
away.

We'll try to investigate this further, but not before 2.4.23.

Sorry for the inconvenience,

Harald.

--- linux/net/ipv4/netfilter/ip_nat_core.c	26 Aug 2003 11:13:19 -0000	1.6
+++ linux/net/ipv4/netfilter/ip_nat_core.c	28 Aug 2003 08:25:45 -0000
@@ -159,8 +159,8 @@
 				continue;
 		}
=20
-		if ((mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
-		    && proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
+		if (!(mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
+		    || proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
 				       &mr->range[i].min, &mr->range[i].max))
 			return 1;
 	}

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--ew6BAiZeqk4r7MaW
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: X-Sieve: cmu-sieve 2.0
Received: from anguita.dti2.net ([81.24.162.8])
	by coruscant.gnumonks.org with esmtp (Exim 4.20)
	id 1AJj00-0003tQ-IQ
	for laforge@gnumonks.org; Wed, 12 Nov 2003 00:36:44 +0000
Received: from gala.dti2.net
	by sanrafael_fax
	(MDaemon.PRO.v6.8.5.R)
	with ESMTP id 36-md50000000324.tmp
	for <laforge@gnumonks.org>; Wed, 12 Nov 2003 01:36:04 +0100
Received: from cintasverdes [81.24.162.6] by gala.dti2.net
  (SMTPD32-7.13) id A072F6019C; Wed, 12 Nov 2003 01:36:02 +0100
Message-ID: <009d01c3a8b4$f331e960$06a21851@intranet.dti2.net>
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>
To: "Harald Welte" <laforge@gnumonks.org>
Cc: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
References: <20031110233225.00de7987.davem@redhat.com> <20031111104317.GZ8206@sunbeam.de.gnumonks.org>
Subject: Re: Fw: PROBLEM: PATCH for 2.4.23-pre4 and up hang on one system
Date: Wed, 12 Nov 2003 01:36:02 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1158
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1165
X-Spam-Processed: anguita.dti2.net, Wed, 12 Nov 2003 01:36:04 +0100
	(not processed: message from valid local sender)
X-Return-Path: jorge@dti2.net
X-MDaemon-Deliver-To: laforge@gnumonks.org
X-Spam-Score: 0.0 (/)

----- Original Message ----- 
From: "Harald Welte" <laforge@gnumonks.org>
To: "David S. Miller" <davem@redhat.com>
Cc: "Netfilter Development Mailinglist"
<netfilter-devel@lists.netfilter.org>
Sent: Tuesday, November 11, 2003 11:43 AM
Subject: Re: Fw: PROBLEM: PATCH for 2.4.23-pre4 and up hang on one system


>On Mon, Nov 10, 2003 at 11:32:25PM -0800, David S. Miller wrote:
>> Please have a look, thanks guys.
>
>Thanks, David.  Marcelo forwarded that message to the netfilter
>(non-devel) list, see my reply attached.
>
>I've read and change again and again: The change _is_ correct.  Also, it
>is in effect for quite some time, we have it in CVS/patch-o-matic for
>more than two months, and lots of people are using patch-o-matic.
>
>I also cannot reproduce the bug here, I'm running quite a lot of
>post-pre4 systems in such a simple SNAT scenario.


    Mr Welte, I'd spent the last week debugging a problem in one of my
routers and I can now say that this change has something to do with it. I
use a modified 2.4.21 kernel on my routers, it has been running for months
without a glitch. The last week I applied some patches from pom so that I
can use the connmark and several other new match/targets. I test all the
changes in an SMP box and it worked fine, then I installed the kernel on a
production box and it started to hang "randomly", from minutes to hours. It
is not a hard lockup but a livelock, the box doesn't have network neither
userspace but still responds to Alt-SysRq keys. When I saw this bug report I
tried reverting only this one patch and it started to work again, the box
has been up for 4 days now.
    As I said in my development box I was unable to reproduce the lock.

    Best regards,

    -Jorge

==============================================================
Jorge Boncompte - Tecnico de sistemas
DTI2 - Desarrollo de la Tecnologia de las Comunicaciones
--------------------------------------------------------------
C/ Abogado Enriquez Barrios, 5   14004 CORDOBA (SPAIN)
Tlf: +34 957 761395 / FAX: +34 957 450380
==============================================================
- Sin pistachos no hay Rock & Roll...
- Without wicker a basket cannot be done.
==============================================================




--ew6BAiZeqk4r7MaW--

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/sfB1XaXGVTD0i/8RAsmKAJ9fxCisebzYW7q9dHSa8iOBAhRV1gCfVGvw
nFiJ7g4JNBgxGAdS8kuNLzQ=
=Szrj
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
