From: "Piotr =?iso-8859-2?Q?Gasid=B3o?=" <quaker@pandora.barbara.eu.org>
Subject: [PATCH] [resent] ipt_account match, ooops when reset fix
Date: Wed, 12 May 2004 22:55:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040512205505.GA21447@pandora.barbara.eu.org>
References: <20040405204906.GA26879@pandora.barbara.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_pandora.barbara.ds.polsl.gliwice.pl-32296-1084395306-0001-2"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040405204906.GA26879@pandora.barbara.eu.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_pandora.barbara.ds.polsl.gliwice.pl-32296-1084395306-0001-2
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
This is resent of my previous message. I attach patch which removes
possibility of making ooops while writting to proc file.

--=20
Piotr 'QuakeR' Gasid=B3o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ipt_account-0.1.5-to-0.1.5.1.diff"
Content-Transfer-Encoding: quoted-printable

diff -uNr patch-o-matic-ng-old/account/linux/include/linux/netfilter_ipv4/i=
pt_account.h patch-o-matic-ng/account/linux/include/linux/netfilter_ipv4/ip=
t_account.h
--- patch-o-matic-ng-old/account/linux/include/linux/netfilter_ipv4/ipt_acc=
ount.h	Wed Mar 17 15:50:12 2004
+++ patch-o-matic-ng/account/linux/include/linux/netfilter_ipv4/ipt_account=
.h	Mon Apr  5 22:31:49 2004
@@ -2,7 +2,7 @@
  * accounting match (ipt_account.c)
  * (C) 2003,2004 by Piotr Gasid=B3o (quaker@barbara.eu.org)
  *
- * Version: 0.1.5
+ * Version: 0.1.5.1
  *
  * This software is distributed under the terms of GNU GPL
  */
diff -uNr patch-o-matic-ng-old/account/linux/net/ipv4/netfilter/ipt_account=
.c patch-o-matic-ng/account/linux/net/ipv4/netfilter/ipt_account.c
--- patch-o-matic-ng-old/account/linux/net/ipv4/netfilter/ipt_account.c	Mon=
 Apr  5 22:23:40 2004
+++ patch-o-matic-ng/account/linux/net/ipv4/netfilter/ipt_account.c	Mon Apr=
  5 22:41:19 2004
@@ -2,7 +2,7 @@
  * accounting match (ipt_account.c)
  * (C) 2003,2004 by Piotr Gasid=B3o (quaker@barbara.eu.org)
  *
- * Version: 0.1.5
+ * Version: 0.1.5.1
  *
  * This software is distributed under the terms of GNU GPL
  */
@@ -24,7 +24,7 @@
 #include <linux/netfilter_ipv4/ipt_account.h>
=20
 static char version[] =3D
-KERN_INFO "ipt_account 0.1.5 : Piotr Gasid=B3o <quaker@barbara.eu.org>, ht=
tp://www.barbara.eu.org/~quaker/ipt_account/\n";
+KERN_INFO "ipt_account 0.1.5.1 : Piotr Gasid=B3o <quaker@barbara.eu.org>, =
http://www.barbara.eu.org/~quaker/ipt_account/\n";
=20
 /* default rights for files created in /proc/net/ipt_account/ */
 static int ip_list_perms =3D 0644;
@@ -210,11 +210,12 @@
 	char kernel_buffer[1024];
 	u_int32_t hosts_count =3D INADDR_BROADCAST - table->netmask + 1;
 =09
-	copy_from_user(kernel_buffer, buffer, len);
+	if (copy_from_user(kernel_buffer, buffer, len))
+		return -EFAULT;
 	kernel_buffer[len - 1] =3D 0;
 =09
 	/* echo "reset" > /proc/net/ipt_recent/table clears the table */
-	if (!strncmp(kernel_buffer, "reset", len)) {
+	if (!memcmp(kernel_buffer, "reset", 5)) {
 		spin_lock(&table->ip_list_lock);
 		memset(table->ip_list, 0, sizeof(struct t_ipt_account_ip_list) * hosts_c=
ount);
 		spin_unlock(&table->ip_list_lock);

--Nq2Wo0NMKNjxTN9z--

--=_pandora.barbara.ds.polsl.gliwice.pl-32296-1084395306-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQFAoo8pgEmu6PNADqoRAvlKAJ0R2/+B8BM2VCaZCuYbR1IsHVFPUQCdEXlr
xlSb8RMw3IrVDe6PaiDe/0k=
=MHAV
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-32296-1084395306-0001-2--
