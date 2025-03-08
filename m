Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05D619EEBD
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 22:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741473279; cv=none; b=rMLnwCJXVDWIxrSMC3snXJ+8XvW85kLRgS36QRnGlNDeB8UuN8rU6ekikJbu1+52ju5PJ0886vLl/taYULTuBjP+IKBIPWVDjts9w/FV5YdNyP4wYYsK6fTI1VDKB3fUyKpfKyNle8z8v0aKO6HZ/PMig0ztiTh2CRJWDRXyW8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741473279; c=relaxed/simple;
	bh=KdQhXD40fq3vyqBcGikMxzVK+1Oy5DW2D55Ym5MyIAk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=QWgKRleeSgeRZZnHHcyvks9iE0e43UPoD3zOGyrYRD+3ruHbdNAUwQQyM0+6+J9gk+DHMl17C1IBlfnHIwimfSt+clBgUSFa2Fq1jWXNDOpro//EB1wWFycGGWvHGM5eS61Xp+5qpHkaqScMtyzvNe8BPe4vEvOaZ3q5BvK/L7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=s4OKn1iI; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="s4OKn1iI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741473275; x=1742078075; i=corubba@gmx.de;
	bh=FqLRC45v1PendL1XW5/K0116n689uTLP6cTwVXSx5Uc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=s4OKn1iIED3MtD+QYoQfKi9BnpM9IZceJmK1Fvqn9ZEUNuOzEN2lvc977LPXlVQR
	 SG5wek90BcoLy+gcTZhORlhKm3bodyOFq6EN6tVB2iCTZoPc1QkUAnzbZ3p7fqZ2H
	 PhWsDdZjk+0t4ecRuNy8fsJaIdDS1D2b/KgJrcjpYc2YxvUECTnAZXO+nQ4c4IU/Q
	 Ejup0vna10rllRFO1ERiGk6oIM3RrnYC2qUqtYljAYcleQuqC3lTPlMo8bHNX3kqJ
	 jT9QcDP6SXwYsbq9lxNfp8oGdgfYgD67OnFQm95FvTt9WMs0L7S/n54tnT15PeIo8
	 Huc4eDLfsDA9XTZyrw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M26r3-1tp7sB3Re5-00FsSt for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2025 23:34:34 +0100
Message-ID: <6d010cf6-fcaf-4bc7-a50b-d5162b5037c0@gmx.de>
Date: Sat, 8 Mar 2025 23:34:34 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 3/8] all: use config_parse_file function in all plugins
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Language: de-CH
In-Reply-To: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Vb9VBG3aZz+CJCP3AIahVHMb7zN8I3eBLgB8B7sIu/N5AkitSNR
 fZ5yVXssnrFNeDCGH92CgSyps5Qa2l9uaW/DU4g/J03nUD2mnXlj/ZwPIMlZ0ykXIkw92Nz
 uq/CuhP23l3ZrO7/w9Mb1nrd8KL4cXmqQoMwzcQqw0H5cMoAqfVwq72eTWTgSCqL2/n888+
 OMXSEkk2Gvlxz2X+aCVzA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fOQ0oKJng1w=;U8gspNgN46CKbWWo1SXSFeC/xPe
 G1yju102HK9X3AwPfuEcXkw1lrQ8J8vPxl4CiznOx5GZs8mmkpsX0F3XBdRkxU3ma+BUHY3v6
 bByjgRlK5A6EroLQ6CFLr5+Qd2fL5N6p51Pe+P2xNpRE1drjpm8hleIVAj4K60ce61v9rZJE9
 yFDd4m+OeQw2IPABQC73+8yvlcwHuNyQhfz4pzMFRhoIRCo9rxX+Xqhalasn/8EiGX6oegma0
 NapXJjKI0vrI0R8enxIwf2aQHWkmFunyKJh7kwAGx2zh6oHujoQBQrBzLVpcq1/mQbrM56o/A
 S1ciPOLVS2odo3hqofBerBMWGhKRH13yARTQ3J7PpOCRjPMYvvYcYjQJIFXZENDleXtlL0vyy
 hImvAOKkxs9HfThobBcoe1fwtCkrzHnwuyxkyPzFss6LvtE5wBzCOFwNY9UqcEjjoeIbkLfZi
 SkXrmq7GIIH79ihGYWXVdTfbluZeZBftzDR7LUXftA2V1MfUIoTv7OtdKfYhAe5/nazhKwtbR
 mT/5n+u+B5+qOdbJpRtUEZGDPYt0zt3RgqBZNPT/A79bq2YAKPDH3P2ROvW3wR85vcuBuKA/S
 bOIVVFxC93/X2C0IgD7yXM5Seof62ON3+fIMXFqBx6xpR12CTbTdXJj6VAkLnTxHf0210HTHu
 YYZ6TtvZcOLV2bTgpAK1GsbZ5ru5knJtiZ06mNuhHpqOs+50nY1YyJtn1Hu8gV/8j4Xsi31J3
 4OjrY9FbpxvCEkjanfvN0h86TT0M/0PEgoIIS3fHn/XlLpu8NUG9zcPXSlD28Hgne+7orQWFB
 qrx9zz01UCFPqkdyj8As6H2fQHHtvlrREtLZflA9M+NSU50x8WhoUd5k5vIOPfL4TdFQnbAPZ
 IB2Edha7ZtA7ybM1bIxjat3DLsqlj7TAdrL0QWLH+T7GN8nAaX+zcFJ8wBHCm4Jvtzbj69/3o
 8mpmU7hQKaIhFcEM9jS3ZOc2AuUhybiYihM299nXRu6eoT/MEOhSPE4GVN37NuT002EXyzG5G
 9FaI/hEInVA6LHcV5IUzunrJRg+n8jjg9tR78nH5QVx9RKwYmV3Uyx8egbsx/v12sKKH1J3jR
 fsi/6wTSUV04UALFfdUVFPt9/PASxufnrC/ejyHbzHC3qfmtiBKA+8QG3Ry+jpceVpKjpGvzB
 NTS5mbJrbfHBxotYQbZW3Qpt4PCdh1whvF9EAX2Bwj/btPaHp856xaJDHhEHo6G7QMPjxkJLw
 COpnQ8C6ZM+oG+EHF0zsnipfa7KkH5JD4vxU1QIF5WjwffFFex7xn9TEc8t2WQtVlvPkOvclz
 S7Xk5yYKAJWInKvmSV77HBSqc//Dlkos0bYK2G+ZujmKXbSFkmJHxfxg89gO8Kgv9nx4q6Neq
 sPHvLJ9oigK6XD9UaDIxS82MbG0Fet0w+xTGP3HXBl7HdLbFODbtyvG5BJbmSLp012WjjEuvz
 mmmy2+g==

Replace all usages of `config_parse_file()` in plugins with the new
`ulogd_parse_configfile()` function, adding error handling where it was
missing. I used the same codestyle as the surrounding code, which varies
between plugins.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 filter/ulogd_filter_MARK.c            | 3 +--
 input/flow/ulogd_inpflow_NFCT.c       | 2 +-
 input/packet/ulogd_inppkt_NFLOG.c     | 3 +--
 input/packet/ulogd_inppkt_ULOG.c      | 2 +-
 input/packet/ulogd_inppkt_UNIXSOCK.c  | 3 +--
 input/sum/ulogd_inpflow_NFACCT.c      | 2 +-
 output/ipfix/ulogd_output_IPFIX.c     | 2 +-
 output/pcap/ulogd_output_PCAP.c       | 2 +-
 output/sqlite3/ulogd_output_SQLITE3.c | 3 ++-
 output/ulogd_output_GPRINT.c          | 2 +-
 output/ulogd_output_GRAPHITE.c        | 2 +-
 output/ulogd_output_JSON.c            | 2 +-
 output/ulogd_output_LOGEMU.c          | 2 +-
 output/ulogd_output_NACCT.c           | 2 +-
 output/ulogd_output_OPRINT.c          | 2 +-
 output/ulogd_output_SYSLOG.c          | 7 ++++---
 output/ulogd_output_XML.c             | 2 +-
 util/db.c                             | 2 +-
 18 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/filter/ulogd_filter_MARK.c b/filter/ulogd_filter_MARK.c
index 149725d..d5a8181 100644
=2D-- a/filter/ulogd_filter_MARK.c
+++ b/filter/ulogd_filter_MARK.c
@@ -94,8 +94,7 @@ static int configure(struct ulogd_pluginstance *upi,
 	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
 		  "plugin `%s'\n", upi->id, upi->plugin->name);

-	config_parse_file(upi->id, upi->config_kset);
-	return 0;
+	return ulogd_parse_configfile(upi->id, upi->config_kset);
 }

 static struct ulogd_plugin mark_pluging =3D {
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NF=
CT.c
index 899b7e3..ec3dff6 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -1028,7 +1028,7 @@ static int configure_nfct(struct ulogd_pluginstance =
*upi,
 {
 	int ret;

-	ret =3D config_parse_file(upi->id, upi->config_kset);
+	ret =3D ulogd_parse_configfile(upi->id, upi->config_kset);
 	if (ret < 0)
 		return ret;

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt=
_NFLOG.c
index 4fdeb12..f716136 100644
=2D-- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -557,8 +557,7 @@ static int configure(struct ulogd_pluginstance *upi,
 	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
 		  "plugin `%s'\n", upi->id, upi->plugin->name);

-	config_parse_file(upi->id, upi->config_kset);
-	return 0;
+	return ulogd_parse_configfile(upi->id, upi->config_kset);
 }

 static int become_system_logging(struct ulogd_pluginstance *upi, uint8_t =
pf)
diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_=
ULOG.c
index 45ffc8b..44bc71d 100644
=2D-- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -269,7 +269,7 @@ static int ulog_read_cb(int fd, unsigned int what, voi=
d *param)
 static int configure(struct ulogd_pluginstance *upi,
 		     struct ulogd_pluginstance_stack *stack)
 {
-	return config_parse_file(upi->id, upi->config_kset);
+	return ulogd_parse_configfile(upi->id, upi->config_kset);
 }
 static int init(struct ulogd_pluginstance *upi)
 {
diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inp=
pkt_UNIXSOCK.c
index f1d1534..b328500 100644
=2D-- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -719,8 +719,7 @@ static int configure(struct ulogd_pluginstance *upi,
 	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
 		  "plugin `%s'\n", upi->id, upi->plugin->name);

-	config_parse_file(upi->id, upi->config_kset);
-	return 0;
+	return ulogd_parse_configfile(upi->id, upi->config_kset);
 }

 static int start(struct ulogd_pluginstance *upi)
diff --git a/input/sum/ulogd_inpflow_NFACCT.c b/input/sum/ulogd_inpflow_NF=
ACCT.c
index b022e63..bd45df4 100644
=2D-- a/input/sum/ulogd_inpflow_NFACCT.c
+++ b/input/sum/ulogd_inpflow_NFACCT.c
@@ -221,7 +221,7 @@ static int configure_nfacct(struct ulogd_pluginstance =
*upi,
 {
 	int ret;

-	ret =3D config_parse_file(upi->id, upi->config_kset);
+	ret =3D ulogd_parse_configfile(upi->id, upi->config_kset);
 	if (ret < 0)
 		return ret;

diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output=
_IPFIX.c
index 1c0f730..e96c7f8 100644
=2D-- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -268,7 +268,7 @@ static int ipfix_configure(struct ulogd_pluginstance *=
pi, struct ulogd_pluginsta
 	int oid, port, mtu, ret;
 	char addr[16];

-	ret =3D config_parse_file(pi->id, pi->config_kset);
+	ret =3D ulogd_parse_configfile(pi->id, pi->config_kset);
 	if (ret < 0)
 		return ret;

diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PC=
AP.c
index 19ce47f..474992e 100644
=2D-- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -260,7 +260,7 @@ static void signal_pcap(struct ulogd_pluginstance *upi=
, int signal)
 static int configure_pcap(struct ulogd_pluginstance *upi,
 			  struct ulogd_pluginstance_stack *stack)
 {
-	return config_parse_file(upi->id, upi->config_kset);
+	return ulogd_parse_configfile(upi->id, upi->config_kset);
 }

 static int start_pcap(struct ulogd_pluginstance *upi)
diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_=
output_SQLITE3.c
index 6aeb7a3..51c0fc8 100644
=2D-- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -363,7 +363,8 @@ sqlite3_configure(struct ulogd_pluginstance *pi,
 {
 	/* struct sqlite_priv *priv =3D (void *)pi->private; */

-	config_parse_file(pi->id, pi->config_kset);
+	if (ulogd_parse_configfile(pi->id, pi->config_kset) < 0)
+		return -1;

 	if (ulogd_wildcard_inputkeys(pi) < 0)
 		return -1;
diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
index 37829fa..8f881a3 100644
=2D-- a/output/ulogd_output_GPRINT.c
+++ b/output/ulogd_output_GPRINT.c
@@ -230,7 +230,7 @@ static int gprint_configure(struct ulogd_pluginstance =
*upi,
 	if (ret < 0)
 		return ret;

-	ret =3D config_parse_file(upi->id, upi->config_kset);
+	ret =3D ulogd_parse_configfile(upi->id, upi->config_kset);
 	if (ret < 0)
 		return ret;

diff --git a/output/ulogd_output_GRAPHITE.c b/output/ulogd_output_GRAPHITE=
.c
index 5328f8e..e54b24d 100644
=2D-- a/output/ulogd_output_GRAPHITE.c
+++ b/output/ulogd_output_GRAPHITE.c
@@ -214,7 +214,7 @@ static int configure_graphite(struct ulogd_pluginstanc=
e *pi,
 			    struct ulogd_pluginstance_stack *stack)
 {
 	ulogd_log(ULOGD_DEBUG, "parsing config file section %s\n", pi->id);
-	return config_parse_file(pi->id, pi->config_kset);
+	return ulogd_parse_configfile(pi->id, pi->config_kset);
 }

 static struct ulogd_plugin graphite_plugin =3D {
diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index f80d0e2..2e7211a 100644
=2D-- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -494,7 +494,7 @@ static int json_configure(struct ulogd_pluginstance *u=
pi,
 	if (ret < 0)
 		return ret;

-	ret =3D config_parse_file(upi->id, upi->config_kset);
+	ret =3D ulogd_parse_configfile(upi->id, upi->config_kset);
 	if (ret < 0)
 		return ret;

diff --git a/output/ulogd_output_LOGEMU.c b/output/ulogd_output_LOGEMU.c
index cfcfab7..f5d1def 100644
=2D-- a/output/ulogd_output_LOGEMU.c
+++ b/output/ulogd_output_LOGEMU.c
@@ -178,7 +178,7 @@ static int configure_logemu(struct ulogd_pluginstance =
*pi,
 			    struct ulogd_pluginstance_stack *stack)
 {
 	ulogd_log(ULOGD_DEBUG, "parsing config file section %s\n", pi->id);
-	return config_parse_file(pi->id, pi->config_kset);
+	return ulogd_parse_configfile(pi->id, pi->config_kset);
 }

 static struct ulogd_plugin logemu_plugin =3D {
diff --git a/output/ulogd_output_NACCT.c b/output/ulogd_output_NACCT.c
index d369c7a..080a576 100644
=2D-- a/output/ulogd_output_NACCT.c
+++ b/output/ulogd_output_NACCT.c
@@ -203,7 +203,7 @@ nacct_conf(struct ulogd_pluginstance *pi,
 {
 	int ret;

-	if ((ret =3D config_parse_file(pi->id, pi->config_kset)) < 0)
+	if ((ret =3D ulogd_parse_configfile(pi->id, pi->config_kset)) < 0)
 		return ret;

 	return 0;
diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c
index 13934ff..1137be1 100644
=2D-- a/output/ulogd_output_OPRINT.c
+++ b/output/ulogd_output_OPRINT.c
@@ -161,7 +161,7 @@ static int oprint_configure(struct ulogd_pluginstance =
*upi,
 	if (ret < 0)
 		return ret;

-	ret =3D config_parse_file(upi->id, upi->config_kset);
+	ret =3D ulogd_parse_configfile(upi->id, upi->config_kset);
 	if (ret < 0)
 		return ret;

diff --git a/output/ulogd_output_SYSLOG.c b/output/ulogd_output_SYSLOG.c
index 9777f0f..9ee6a61 100644
=2D-- a/output/ulogd_output_SYSLOG.c
+++ b/output/ulogd_output_SYSLOG.c
@@ -83,12 +83,13 @@ static int _output_syslog(struct ulogd_pluginstance *u=
pi)
 static int syslog_configure(struct ulogd_pluginstance *pi,
 			    struct ulogd_pluginstance_stack *stack)
 {
-	int syslog_facility, syslog_level;
+	int syslog_facility, syslog_level, ret;
 	char *facility, *level;
 	struct syslog_instance *li =3D (struct syslog_instance *) &pi->private;

-	/* FIXME: error handling */
-	config_parse_file(pi->id, pi->config_kset);
+	ret =3D ulogd_parse_configfile(pi->id, pi->config_kset);
+	if (ret < 0)
+		return ret;

 	facility =3D pi->config_kset->ces[0].u.string;
 	level =3D pi->config_kset->ces[1].u.string;
diff --git a/output/ulogd_output_XML.c b/output/ulogd_output_XML.c
index 44af596..55c7a7c 100644
=2D-- a/output/ulogd_output_XML.c
+++ b/output/ulogd_output_XML.c
@@ -190,7 +190,7 @@ static int xml_configure(struct ulogd_pluginstance *up=
i,
 {
 	int ret;

-	ret =3D config_parse_file(upi->id, upi->config_kset);
+	ret =3D ulogd_parse_configfile(upi->id, upi->config_kset);
 	if (ret < 0)
 		return ret;

diff --git a/util/db.c b/util/db.c
index 749a45f..11c3e6a 100644
=2D-- a/util/db.c
+++ b/util/db.c
@@ -153,7 +153,7 @@ int ulogd_db_configure(struct ulogd_pluginstance *upi,
 	ulogd_log(ULOGD_NOTICE, "(re)configuring\n");

 	/* First: Parse configuration file section for this instance */
-	ret =3D config_parse_file(upi->id, upi->config_kset);
+	ret =3D ulogd_parse_configfile(upi->id, upi->config_kset);
 	if (ret < 0) {
 		ulogd_log(ULOGD_ERROR, "error parsing config file\n");
 		return ret;
=2D-
2.48.1

