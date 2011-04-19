From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: [PATCH 1/5] Don't load ip6?_tables module when already loaded.
Date: Mon, 18 Apr 2011 18:23:49 -0700
Message-ID: <1303176233-14063-1-git-send-email-zenczykowski@gmail.com>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
To: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:43567 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1DSBYM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:24:12 -0400
Received: by pxi2 with SMTP id 2so3954254pxi.10
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2011 18:24:12 -0700 (PDT)
In-Reply-To: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: Maciej =C5=BBenczykowski <maze@google.com>

Signed-off-by: Maciej Zenczykowski <maze@google.com>
---
 xshared.h |    2 ++
 xtables.c |   34 +++++++++++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/xshared.h b/xshared.h
index be53535..34f3265 100644
--- a/xshared.h
+++ b/xshared.h
@@ -29,6 +29,7 @@ struct xtables_target;
 /**
  * xtables_afinfo - protocol family dependent information
  * @kmod:		kernel module basename (e.g. "ip_tables")
+ * @proc_exists:	file which exists in procfs when module already loade=
d
  * @libprefix:		prefix of .so library name (e.g. "libipt_")
  * @family:		nfproto family
  * @ipproto:		used by setsockopt (e.g. IPPROTO_IP)
@@ -37,6 +38,7 @@ struct xtables_target;
  */
 struct xtables_afinfo {
 	const char *kmod;
+	const char *proc_exists;
 	const char *libprefix;
 	uint8_t family;
 	uint8_t ipproto;
diff --git a/xtables.c b/xtables.c
index a260c7b..e424c28 100644
--- a/xtables.c
+++ b/xtables.c
@@ -27,9 +27,11 @@
 #include <unistd.h>
 #include <sys/socket.h>
 #include <sys/stat.h>
+#include <sys/statfs.h>
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <arpa/inet.h>
+#include <linux/magic.h> /* for PROC_SUPER_MAGIC */
=20
 #include <xtables.h>
 #include <limits.h> /* INT_MAX in ip_tables.h/ip6_tables.h */
@@ -139,6 +141,7 @@ struct option *xtables_merge_options(struct option =
*orig_opts,
=20
 static const struct xtables_afinfo afinfo_ipv4 =3D {
 	.kmod          =3D "ip_tables",
+	.proc_exists   =3D "/proc/net/ip_tables_names",
 	.libprefix     =3D "libipt_",
 	.family	       =3D NFPROTO_IPV4,
 	.ipproto       =3D IPPROTO_IP,
@@ -148,6 +151,7 @@ static const struct xtables_afinfo afinfo_ipv4 =3D =
{
=20
 static const struct xtables_afinfo afinfo_ipv6 =3D {
 	.kmod          =3D "ip6_tables",
+	.proc_exists   =3D "/proc/net/ip6_tables_names",
 	.libprefix     =3D "libip6t_",
 	.family        =3D NFPROTO_IPV6,
 	.ipproto       =3D IPPROTO_IPV6,
@@ -369,15 +373,35 @@ int xtables_insmod(const char *modname, const cha=
r *modprobe, bool quiet)
 	return -1;
 }
=20
+/* return true if a given file exists within procfs */
+static bool proc_file_exists(const char *filename)
+{
+	struct stat s;
+	struct statfs f;
+
+	if (lstat(filename, &s)) return false;
+	if (!S_ISREG(s.st_mode)) return false;
+	if (statfs(filename, &f)) return false;
+	if (f.f_type !=3D PROC_SUPER_MAGIC) return false;
+	return true;
+}
+
 int xtables_load_ko(const char *modprobe, bool quiet)
 {
 	static bool loaded =3D false;
-	static int ret =3D -1;
+	int ret;
=20
-	if (!loaded) {
-		ret =3D xtables_insmod(afinfo->kmod, modprobe, quiet);
-		loaded =3D (ret =3D=3D 0);
-	}
+	if (loaded)
+		return 0;
+
+	if (proc_file_exists(afinfo->proc_exists)) {
+		loaded =3D true;
+		return 0;
+	};
+
+	ret =3D xtables_insmod(afinfo->kmod, modprobe, quiet);
+	if (ret =3D=3D 0)
+		loaded =3D true;
=20
 	return ret;
 }
--=20
1.7.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
