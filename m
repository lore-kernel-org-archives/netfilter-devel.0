From: "Nicolas Bouliane" <nib@cookinglinux.org>
Subject: [PATCH] fix twin tos argument.
Date: Sun, 19 Dec 2004 16:40:51 -0500 (EST)
Message-ID: <35966.66.11.161.14.1103492451.squirrel@66.11.161.14>
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20041219164051_89560"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

------=_20041219164051_89560
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

I was writing an nfsim .sim for the match tos, when I realized that when
we enter --tos twice the second overwrite the first.

so, I took the initiative to fixed It. Please tell me if you dislike the
way I did, else please apply it ! :-)

Thanks ya!

- acidfu
------=_20041219164051_89560
Content-Type: text/x-patch; name="libipt_tos.c.patch"
Content-Disposition: attachment; filename="libipt_tos.c.patch"
Content-Transfer-Encoding: quoted-printable

--- extensions/libipt_tos.c.old	2004-12-19 00:22:23.000000000 -0500
+++ extensions/libipt_tos.c	2004-12-19 00:33:15.000000000 -0500
@@ -91,6 +91,11 @@
=20
 	switch (c) {
 	case '1':
+		/* Ensure that `--tos' haven't been used yet. */
+		if (*flags =3D=3D 1)
+			exit_error(PARAMETER_PROBLEM,
+					"tos match: only use --tos once!");
+
 		check_inverse(optarg, &invert, &optind, 0);
 		parse_tos(argv[optind-1], tosinfo);
 		if (invert)
------=_20041219164051_89560--
