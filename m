From: Bart De Schuymer <bart.de.schuymer@pandora.be>
Subject: [PATCH] -M option unusable
Date: Sat, 15 Jun 2002 00:14:28 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206150014.28710.bart.de.schuymer@pandora.be>
References: <20020613175053.J2543@sunbeam.de.gnumonks.org> <200206131931.23688.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@lists.samba.org
In-Reply-To: <200206131931.23688.hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

This is just a small patch, guess the --modprobe option is not very popul=
ar :)
It's vs the CVS userspace iptables.c file.

--- iptables.c.old      Sat Jun 15 00:06:12 2002
+++ iptables.c  Sat Jun 15 00:06:04 2002
@@ -1682,7 +1682,7 @@
        opterr =3D 0;

        while ((c =3D getopt_long(argc, argv,
-          "-A:C:D:R:I:L::F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:",
+          "-A:C:D:R:I:L::F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:M:",
                                           opts, NULL)) !=3D -1) {
                switch (c) {
                        /*

cheers,
Bart
