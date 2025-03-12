Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E3686349
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 14:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741791231; cv=none; b=ra4dBcKBAAcFUF02B8jOVnl1zjLKdo5vIIskI/sP5L5MJfECQE6Uc2iYfou4jHc1FoMTkyp1WzhYnklO05Tglh5xPvzUjR/C0uFzp1QRt4vdI0JWlWW5XixnIBamNewRFCm51e/kl1giy0lneXdqZ6g211jFNmbbKD1osvn4UiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741791231; c=relaxed/simple;
	bh=eULFPGd2gLHIb6obxD9CbAhnp51Z1eRe7gN4W488JqM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=n4RFmVmEZSdjJo0hQDDNRzwnWzjt2B8FVAauBTkR7l22GAn52mxoEhnrYDtimmgkbE+vxsYvIwFZ8c3HeOz0OkFna0hWOqzE+LKahUyXYlC6FlVPiVERDEZbrOKuB+X5H/NkOp31GPI94eLpnykl1w13X1McADPYQgq/Co4l+Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=EKzopE8f; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="EKzopE8f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741791227; x=1742396027; i=corubba@gmx.de;
	bh=0ntlk5Vr6xIjbD43FDo+kcGeIUSudMnpdHZWC+xW1aI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=EKzopE8fm2hnFPXjKdAKMyY9VU8kWmMLljeLH32f5vKvsk9g7WZn/MquUM441m04
	 FaOSv+zlCBVtyHEqOgZNV+qbMNyLlIK941tJqH88o6HyGHixcS9+yfoPfvcfnu5sS
	 03ooGfWi6Bt2ySDlJ6x3xHYUCSv5OMYwNpB3UhIzvIjCfg9zz+bJPEHusfUQOg4Hi
	 gupC/GuryY8W1XHp8ODVdA9yjxSNJyuF9ixWOeztE98MUtTXhwRmjiqd9hYQqkbRi
	 rrliXvH1GxfElhm7gQfGkm4Vhw0kpMt7kQuk/te1i0eG1OE+DehfwR3BPytkbTq5j
	 m+qNXXqrsGCzjp40MA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.254]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MIx3C-1tdaOv07wY-00ZBV0 for
 <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 15:53:47 +0100
Message-ID: <c71f3ada-6c56-47f3-8165-edb0d9921ee2@gmx.de>
Date: Wed, 12 Mar 2025 15:53:46 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2,v2 2/6] all: use config_parse_file function in all
 plugins
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
Content-Language: de-CH
In-Reply-To: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2yK0gGydRxeiYsFS16+fl1rTqTLZlM5ErYEveYZ4Bejb+BlKoKQ
 MNWTwg5ARbaNsfu0554MuJrKmx9a3doSaQC7AGg53CfHelyYtAmMBT6vh/Rcv1Z3AbbN4jO
 Cn4zGmCSijrYq9JvR+X6WgRLu0eoxSCMWl8sxkO0eBkZElRpFCB5C7yre+Dj0o7rhc1KwoB
 gqfZgDUl3S/30oyFmTKag==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:sSKzTFuWW+0=;Wjg7EkFRCSLAeBIWML67gwLF4hI
 JjoNhMpQKqFLgjxRnYfAzPSkFvIjnTq/Yi/Xe3NtVNLtxm+7Ji4c0vwbEmR8di53EyP7TNZ3V
 oDjUfVaLmLsDECIulmhMAWBuHHAFYqfLR+kn55gl7w8LorRMJuxrjdkaiTjEc1n88NUn5wsve
 H/SxlqoQmzD6l/dEWX0erUIQvGcD72GZGvEljE8kI1rfHfTBWWSVLo2sUHT3jkmA1U93fwuWw
 KZI21+60AkBcIJyGzzy+ZmRXjUpUMG5Os/9BcA1e/vwHPBlre5g77J8RGONPwQh+m+xfLNbMQ
 rVphYHZ2Dbuk2lj+kTGilgJmGqab18MuYT0R7NkeiGMbKqPb3AM/Fn5EFL3YBNOTQYZmAJvwe
 1EHjtO5B1Iv+wWNhefUILuk8lB2R1QDoSzbmG5jVJa3T479MjgnbAXyX0FBtpx5RBwZwYC3Y4
 g5j6nj9tzgdxo82CegMajW8CsVCWbmBj3jtT2G7NnYGlM2RPQb8iNynNzMI46VbVsOBl+wYef
 hh+urnK8hTrW/ePfFrQL3CuIN/6UYwq7FGasdUOLUQWHdskuD949l9CktKioAQT3pGSxqTjZh
 zbctXnQRjE0JIXIiTcagN2FTjdS+PErnBBDDiKeumZ0N9JrWL/cxocuooVr9izxaEAiGlosrd
 UHw+Nzxv2k+S3IIyCHlNE9jD42mHjVMyO8UIWkioXQv1RjL1ltrn0nHO8ePJ8VOI/E5IrXH7n
 sC/HfE0t7wBwbcLOHm3eDy50kKjC0a8TAWy83i8Bl6NexU3qoLGwVLtSrRybpNFgoFsFqEsmB
 b0hpi2cEVE9n8fXjnIOsp7KPl2uV74MOqYlmafopoIqYGrROoURLTL+eYXIam6TbVo/6AEDLp
 VL+Jwujemrsi3dbcL8lDnOgsm+KUoJtOMTMYv55byxC6/dVVAFPyubA228Ptnri8I+MGqa6At
 Cy9HjAV/B7GGPd2DIEFlNjmz/Jj12Fqpj4KOWwYNI6IF0iJy8RDGrPJkAsQBIghhlhYxyZxDC
 MRFC+Aoz8vrBS461nIu8i8heaQf9PrxQcHPsMTMCpsu87ox2nZisnZwbHkFTdmkclmincqJIE
 DiPqNSGVM3aWlPDFmyuF0eOaZAy3nCdcBFnX5iP6QM5N5Uz59/iD0d2PZDtISGoSylgzTPhXF
 qrS68pcU608Q5kcCxeuaoHjMqdge3vRD/XSUKK74tPJs3aefzkXzFfdtDhEOUf2bC5ATtPTEk
 uMZdKc01ab5mRcMPJNGLioVvONuUY0UR1jEgjaTjHsmIHhaBYo2ryP0L9cCDFYjU4ujDmwywj
 tKNcEbd1H5Suq8t/nDI7gRneswSB/vnbdxXSCi/w+sb4qHDeYCUgVxxGBzdydQydQu1AJ/ECS
 ZnqGMTmYRrEZuRqyP6rxxbRuGqKWWM57EOB8/ym4ytLDoD3uuVtAcqDl4Sq7ykSICAmo9H16A
 dsQTTBSymQeII1fSoYtsnOwv44bGiVChavrWl3aQlXayGZm1m

Replace all usages of `config_parse_file()` in plugins with the new
`ulogd_parse_configfile()` function, adding error handling where it was
missing. I used the same codestyle as the surrounding code, which varies
between plugins.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
Changes in v2:
  - None

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
index fe827a7..5213cc3 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -1054,7 +1054,7 @@ static int configure_nfct(struct ulogd_pluginstance =
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
index 88e0035..8c8fd9d 100644
=2D-- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -272,7 +272,7 @@ static int ipfix_configure(struct ulogd_pluginstance *=
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
index 20dd308..dfebfe2 100644
=2D-- a/output/ulogd_output_GPRINT.c
+++ b/output/ulogd_output_GPRINT.c
@@ -233,7 +233,7 @@ static int gprint_configure(struct ulogd_pluginstance =
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
