From: Jimmy Hedman <jimmy.hedman@southpole.se>
Subject: Patch for ULOG save
Date: 13 Sep 2002 17:21:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1031930509.1663.8.camel@goofy>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-5VSfET8eu4g+whx3c1Rl"
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


--=-5VSfET8eu4g+whx3c1Rl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,
i found that ULOG target doesn't get saved right when doing a
iptables-save so i created a small patch for it. The problem was that it
wasn't putting "'s around ulog-prefix arguments.
Patch attached is against 1.2.7a but the cvs tree seem to have the same
problem.

I don't subscribe to the developer mailinglist so if you answer, please
cc: me.

// Jimmy


Patch:
--- extensions/libipt_ULOG.c.old	2002-09-13 17:12:11 +0200
+++ extensions/libipt_ULOG.c	2002-09-13 17:12:34 +0200
@@ -157,7 +157,7 @@
 	    =3D (const struct ipt_ulog_info *) target->data;
=20
 	if (strcmp(loginfo->prefix, "") !=3D 0)
-		printf("--ulog-prefix %s ", loginfo->prefix);
+		printf("--ulog-prefix \"%s\" ", loginfo->prefix);
=20
 	if (loginfo->nl_group !=3D ULOG_DEFAULT_NLGROUP) {
 		printf("--ulog-nlgroup ");


--=20
Jimmy Hedman                       South Pole AB
Phone:  +46 8 51420420             Gelbjutarv=E4gen 5
Fax:    +46 8 51420429             SE - 17148 Solna=20
e-mail: jimmy.hedman@southpole.se  www.southpole.se

--=-5VSfET8eu4g+whx3c1Rl
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=patch; charset=ISO-8859-1

--- extensions/libipt_ULOG.c.old	2002-09-13 17:12:11.000000000 +0200
+++ extensions/libipt_ULOG.c	2002-09-13 17:12:34.000000000 +0200
@@ -157,7 +157,7 @@
 	    =3D (const struct ipt_ulog_info *) target->data;
=20
 	if (strcmp(loginfo->prefix, "") !=3D 0)
-		printf("--ulog-prefix %s ", loginfo->prefix);
+		printf("--ulog-prefix \"%s\" ", loginfo->prefix);
=20
 	if (loginfo->nl_group !=3D ULOG_DEFAULT_NLGROUP) {
 		printf("--ulog-nlgroup ");

--=-5VSfET8eu4g+whx3c1Rl--
