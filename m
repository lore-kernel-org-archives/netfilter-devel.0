Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B1D1DB951
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 22:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741473559; cv=none; b=NWivm5OP4mT9woirSR18pcaJvP81yrfaosKj+gItQTKXnkt5O1K43rCuhjNOgPOhMc3XZRYCvTTkNsirjUA2vVYJFaTuFf9H8tAv7UtU6/czbYE7Zz6vAYcyJJPZfZ+oMHLVtnRE3nxV2otOJ2+YKSElJ2WXHmLD9F/qVZ2pxmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741473559; c=relaxed/simple;
	bh=8fKNwo3KtLU86B3wpcCt9Kh/jwsoMHbgfbM+WlqOGzs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=uM8uRSduSrkPLec/pJokb+Q6jHdfC0PYBapIMK3QOsR83whbXIMuhVOq1IFxkTT36skEOhylpDyDv7/oBIKANlUEDsqzTwV+ctdifqsvlEsLqkML/k8BkDUg32IGcyOrVOsOj9iqu9s8o09z3412SDprRKRMvWl5StL62W1oq+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=LZKZFxr4; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="LZKZFxr4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741473555; x=1742078355; i=corubba@gmx.de;
	bh=qPikGOyeOQeesui8k/UOYVKJ9tFwdQWGDXP/R5VZFIU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=LZKZFxr4jdI6uYedXcMMXJyM7nB3tKUEehuSSO3/gwOQabzS+V2bjNaqe/OaIfTh
	 egHu4TP3VxlPMFPBOolN6sc8D1i/JICeJn+NTrKGlz3mkEHfA1NdQdjEj+rOCh4U4
	 UmtdEZhhpP8/GEgQxxYR29zIUiyVbMLl9yJ1Y8fQ4rXzVwBj+4YK98J51NwIQOQUh
	 F33R9+rX8J/c8lJLK+2ovQZdk1hPYd6n+H7H70YcZCMfiupCSB2mi8xkHFHO4WxlH
	 jWUo80oS4UlxVhEXHfmoKCcrK3NB6V2XpNSV6DI/8ieF9j7mM4SFLAcb4kMkwHuPG
	 xyzVMe5PSYGAnqNNKQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N5GE1-1t82vH47vR-013zfP for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2025 23:39:15 +0100
Message-ID: <f01d26d9-0cb3-4095-8414-280d3c156a2e@gmx.de>
Date: Sat, 8 Mar 2025 23:39:14 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 8/8] all: remove trivial configure hooks
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Language: de-CH
In-Reply-To: <ca5581f5-5e54-47f5-97c8-bcc788c77781@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:6HOmspAgn+9hUcpx1zs0o2GviM+pcOkBGx6zlwPTRgEG57zlevK
 DLAjLix86ZhwJVJ4Twd+rFQCIenTunuT1Fx3KpA7fk1vWPCcL2/CPt+G+ct4W5bZndiwqNk
 i1t+iSD+oWqWIf+ASkdJUsCLpwEC8DQDGBzdI3x5KNZprLvY6orXKKqGoQQgL0smflET5HW
 px5qBk55POdMEQQ6vrJhA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YTEeUtfF7XA=;f6LOWE32lpG+4mUQ5fivSwtqL7b
 BB1mCerepAeDYKPGt45NmCYQwGiUe9Icpova0H4Ja4Yq6vxgtUQz4dy6/ybQ1H7bWToUAJiXc
 /b3N283XFHB9Qn6Xu/NjIy3pcJRWTj4b1nD7s8SGlGQTyN9EojFVmFVfz1DOjZk9DoktQ/jJ+
 tF2P37f5DZIhdGplSTaoRMv/YZ47p7UmOV28YN9bLgHL8Je8WJt1P97S/kUpgKM0wvbxzif/E
 ZJDIdpUAM6/KVQB8OVFzi/2XyISrX41VaXfm1yFp1dTQVL4o3c2CdJARJuTaXdFg9BJ00zJUN
 3Vcqx/KtqSYXDXcfqxNaXwAnMr/UipLoS9Sj6o4wWBOg1fTc/biRu7Xq6R+5k6D9BBM0FGSDS
 hdYc8BfFFHFk2syH4UpC3zSwKwm7PzW+Bcux2j3YaHL1dcCbwEyRT3kwNFhwAkxkvJGisXltB
 7EHlFWv/x7IHfQpz6xpx7xMQiW+KH/O1XKx21jTInRqyFJfgiSv99qc1zSUIswbBqwLY8U83N
 EAyOCGxvzLAdKJ1nFUJodHJbOYyEFMiMhyaWqFDDj9tETewfCgZLpDvQ09vtU4S/1F8ov0nDZ
 Us3qBByOzdAQ4vVE+xErwQxe4HjrBvmgVagLmgalxVKhZP+tg0h5I6Zc5F9mAEihsYQVcBltI
 ZHWwvcvQReWPliLE1TtlnLHoTGMuHDdi3Kzzfkoe3GIdb6xHHhax9+GZZZgy8efTsC5QUh2qZ
 vrGRAEQilSA1Usr0gwms1NbWGrlBCxTpxLxAc21PwjQsVQ5theYw3Ss9YUktk4vUBre49ve8y
 UrgkJzrU78ZZVHGY4bFSkPoNm6/wbfvsuHgAC+UnpVzWcoUr2Xf83pSUsPdpBig1Z4dx5/3X1
 YjGqBDlfGAbvdy/TosLBmGQkR/tEqXyT7RW6NoMXxxCQNmvCbpM8VTps5jbKGSMJWsf2hoDx7
 5E+0MPLWVqSJFrhWSjCuS/xrG+c4X/ECeslWcTUr7RK7elkP6NAfBaY6MIi0b1GnxpMI7Vu+f
 PWDZ9hUjaQDlyBoYAp5i/+htMTeUlZ6nf4k9tUDJgrrAo3AYSarU27n+aFAdt4wJG1t9YY1It
 hSzQ9YsJHJBl2xZxZvDqvNMj96vOVQk9SoQrJ38ItswyBQrHN4dZZpTH4ULvIUBSDEIRDBSFa
 A3rnhfa+QjG+rrX1x2UKcxNAJRVPd/bnSNUncxlEiiV9NYNnWNrsfJFfkJdPP2PD5yfs2jUFp
 K0pqmajvtW0V/7Kd77Gmy9rcLysbDRZKexKaswzXH8V11ypdYCYDZtZn+gFRa/fSFWoo/gDqp
 zu1GNUFcimvayjsSdPGFTdhQPUFqeXcM2q3FrFK67vKlHQ0noCmRKwnXpeyqFQ2LRbltxmdHj
 q6+iRH7UvztzE8oJrOOX3zwjcCsEf7A2ZBhzERPGsvrJmwA36HRgi+pex6

These are now covered by the default implementation.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 filter/ulogd_filter_MARK.c           | 10 ----------
 input/flow/ulogd_inpflow_NFCT.c      | 13 -------------
 input/packet/ulogd_inppkt_NFLOG.c    | 10 ----------
 input/packet/ulogd_inppkt_ULOG.c     |  6 ------
 input/packet/ulogd_inppkt_UNIXSOCK.c | 10 ----------
 output/pcap/ulogd_output_PCAP.c      |  7 -------
 output/ulogd_output_GRAPHITE.c       |  8 --------
 output/ulogd_output_LOGEMU.c         |  8 --------
 output/ulogd_output_NACCT.c          | 13 -------------
 output/ulogd_output_XML.c            | 13 -------------
 10 files changed, 98 deletions(-)

diff --git a/filter/ulogd_filter_MARK.c b/filter/ulogd_filter_MARK.c
index d5a8181..b977780 100644
=2D-- a/filter/ulogd_filter_MARK.c
+++ b/filter/ulogd_filter_MARK.c
@@ -88,15 +88,6 @@ static int interp_mark(struct ulogd_pluginstance *pi)
 	return ULOGD_IRET_OK;
 }

-static int configure(struct ulogd_pluginstance *upi,
-		     struct ulogd_pluginstance_stack *stack)
-{
-	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
-		  "plugin `%s'\n", upi->id, upi->plugin->name);
-
-	return ulogd_parse_configfile(upi->id, upi->config_kset);
-}
-
 static struct ulogd_plugin mark_pluging =3D {
 	.name =3D "MARK",
 	.input =3D {
@@ -109,7 +100,6 @@ static struct ulogd_plugin mark_pluging =3D {
 		},
 	.interp =3D &interp_mark,
 	.config_kset =3D &libulog_kset,
-	.configure =3D &configure,
 	.version =3D VERSION,
 };

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NF=
CT.c
index ec3dff6..31457de 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -1023,18 +1023,6 @@ static void polling_timer_cb(struct ulogd_timer *t,=
 void *data)
 	ulogd_add_timer(&cpi->timer, pollint_ce(upi->config_kset).u.value);
 }

-static int configure_nfct(struct ulogd_pluginstance *upi,
-			  struct ulogd_pluginstance_stack *stack)
-{
-	int ret;
-
-	ret =3D ulogd_parse_configfile(upi->id, upi->config_kset);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
 static void overrun_timeout(struct ulogd_timer *a, void *data)
 {
 	int family =3D AF_UNSPEC;
@@ -1551,7 +1539,6 @@ static struct ulogd_plugin nfct_plugin =3D {
 	},
 	.config_kset 	=3D &nfct_kset,
 	.interp 	=3D NULL,
-	.configure	=3D &configure_nfct,
 	.start		=3D &constructor_nfct,
 	.stop		=3D &destructor_nfct,
 	.signal		=3D &signal_nfct,
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt=
_NFLOG.c
index f716136..62b3963 100644
=2D-- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -551,15 +551,6 @@ release_ct:
 	return ret;
 }

-static int configure(struct ulogd_pluginstance *upi,
-		     struct ulogd_pluginstance_stack *stack)
-{
-	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
-		  "plugin `%s'\n", upi->id, upi->plugin->name);
-
-	return ulogd_parse_configfile(upi->id, upi->config_kset);
-}
-
 static int become_system_logging(struct ulogd_pluginstance *upi, uint8_t =
pf)
 {
 	struct nflog_input *ui =3D (struct nflog_input *) upi->private;
@@ -723,7 +714,6 @@ struct ulogd_plugin libulog_plugin =3D {
 		.num_keys =3D ARRAY_SIZE(output_keys),
 	},
 	.priv_size 	=3D sizeof(struct nflog_input),
-	.configure 	=3D &configure,
 	.start 		=3D &start,
 	.stop 		=3D &stop,
 	.config_kset 	=3D &libulog_kset,
diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_=
ULOG.c
index 44bc71d..2eb994c 100644
=2D-- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -266,11 +266,6 @@ static int ulog_read_cb(int fd, unsigned int what, vo=
id *param)
 	return 0;
 }

-static int configure(struct ulogd_pluginstance *upi,
-		     struct ulogd_pluginstance_stack *stack)
-{
-	return ulogd_parse_configfile(upi->id, upi->config_kset);
-}
 static int init(struct ulogd_pluginstance *upi)
 {
 	struct ulog_input *ui =3D (struct ulog_input *) &upi->private;
@@ -325,7 +320,6 @@ struct ulogd_plugin libulog_plugin =3D {
 		.keys =3D output_keys,
 		.num_keys =3D ARRAY_SIZE(output_keys),
 	},
-	.configure =3D &configure,
 	.start =3D &init,
 	.stop =3D &fini,
 	.config_kset =3D &libulog_kset,
diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inp=
pkt_UNIXSOCK.c
index b328500..0d9ba60 100644
=2D-- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -713,15 +713,6 @@ static int unixsock_server_read_cb(int fd, unsigned i=
nt what, void *param)
 	return 0;
 }

-static int configure(struct ulogd_pluginstance *upi,
-		     struct ulogd_pluginstance_stack *stack)
-{
-	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
-		  "plugin `%s'\n", upi->id, upi->plugin->name);
-
-	return ulogd_parse_configfile(upi->id, upi->config_kset);
-}
-
 static int start(struct ulogd_pluginstance *upi)
 {
 	struct unixsock_input *ui =3D (struct unixsock_input *) upi->private;
@@ -809,7 +800,6 @@ struct ulogd_plugin libunixsock_plugin =3D {
 		.num_keys =3D ARRAY_SIZE(output_keys),
 	},
 	.priv_size 	=3D sizeof(struct unixsock_input),
-	.configure 	=3D &configure,
 	.start 		=3D &start,
 	.stop 		=3D &stop,
 	.config_kset 	=3D &libunixsock_kset,
diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PC=
AP.c
index 474992e..ec29a9e 100644
=2D-- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -257,12 +257,6 @@ static void signal_pcap(struct ulogd_pluginstance *up=
i, int signal)
 	}
 }

-static int configure_pcap(struct ulogd_pluginstance *upi,
-			  struct ulogd_pluginstance_stack *stack)
-{
-	return ulogd_parse_configfile(upi->id, upi->config_kset);
-}
-
 static int start_pcap(struct ulogd_pluginstance *upi)
 {
 	return append_create_outfile(upi);
@@ -291,7 +285,6 @@ static struct ulogd_plugin pcap_plugin =3D {
 	.config_kset	=3D &pcap_kset,
 	.priv_size	=3D sizeof(struct pcap_instance),

-	.configure	=3D &configure_pcap,
 	.start		=3D &start_pcap,
 	.stop		=3D &stop_pcap,
 	.signal		=3D &signal_pcap,
diff --git a/output/ulogd_output_GRAPHITE.c b/output/ulogd_output_GRAPHITE=
.c
index e54b24d..6942123 100644
=2D-- a/output/ulogd_output_GRAPHITE.c
+++ b/output/ulogd_output_GRAPHITE.c
@@ -210,13 +210,6 @@ static int fini_graphite(struct ulogd_pluginstance *p=
i) {
 	return 0;
 }

-static int configure_graphite(struct ulogd_pluginstance *pi,
-			    struct ulogd_pluginstance_stack *stack)
-{
-	ulogd_log(ULOGD_DEBUG, "parsing config file section %s\n", pi->id);
-	return ulogd_parse_configfile(pi->id, pi->config_kset);
-}
-
 static struct ulogd_plugin graphite_plugin =3D {
 	.name =3D "GRAPHITE",
 	.input =3D {
@@ -230,7 +223,6 @@ static struct ulogd_plugin graphite_plugin =3D {
 	.config_kset 	=3D &graphite_kset,
 	.priv_size 	=3D sizeof(struct graphite_instance),

-	.configure	=3D &configure_graphite,
 	.start	 	=3D &start_graphite,
 	.stop	 	=3D &fini_graphite,

diff --git a/output/ulogd_output_LOGEMU.c b/output/ulogd_output_LOGEMU.c
index f5d1def..372cac3 100644
=2D-- a/output/ulogd_output_LOGEMU.c
+++ b/output/ulogd_output_LOGEMU.c
@@ -174,13 +174,6 @@ static int fini_logemu(struct ulogd_pluginstance *pi)=
 {
 	return 0;
 }

-static int configure_logemu(struct ulogd_pluginstance *pi,
-			    struct ulogd_pluginstance_stack *stack)
-{
-	ulogd_log(ULOGD_DEBUG, "parsing config file section %s\n", pi->id);
-	return ulogd_parse_configfile(pi->id, pi->config_kset);
-}
-
 static struct ulogd_plugin logemu_plugin =3D {
 	.name =3D "LOGEMU",
 	.input =3D {
@@ -194,7 +187,6 @@ static struct ulogd_plugin logemu_plugin =3D {
 	.config_kset 	=3D &logemu_kset,
 	.priv_size 	=3D sizeof(struct logemu_instance),

-	.configure	=3D &configure_logemu,
 	.start	 	=3D &start_logemu,
 	.stop	 	=3D &fini_logemu,

diff --git a/output/ulogd_output_NACCT.c b/output/ulogd_output_NACCT.c
index 080a576..fa7c501 100644
=2D-- a/output/ulogd_output_NACCT.c
+++ b/output/ulogd_output_NACCT.c
@@ -197,18 +197,6 @@ sighup_handler_print(struct ulogd_pluginstance *pi, i=
nt signal)
 	}
 }

-static int
-nacct_conf(struct ulogd_pluginstance *pi,
-		   struct ulogd_pluginstance_stack *stack)
-{
-	int ret;
-
-	if ((ret =3D ulogd_parse_configfile(pi->id, pi->config_kset)) < 0)
-		return ret;
-
-	return 0;
-}
-
 static int
 nacct_init(struct ulogd_pluginstance *pi)
 {
@@ -243,7 +231,6 @@ static struct ulogd_plugin nacct_plugin =3D {
 	.output =3D {
 		.type =3D ULOGD_DTYPE_SINK,
 	},
-	.configure =3D &nacct_conf,
 	.interp	=3D &nacct_interp,
 	.start 	=3D &nacct_init,
 	.stop	=3D &nacct_fini,
diff --git a/output/ulogd_output_XML.c b/output/ulogd_output_XML.c
index 55c7a7c..b657436 100644
=2D-- a/output/ulogd_output_XML.c
+++ b/output/ulogd_output_XML.c
@@ -185,18 +185,6 @@ static int xml_output(struct ulogd_pluginstance *upi)
 	return ULOGD_IRET_OK;
 }

-static int xml_configure(struct ulogd_pluginstance *upi,
-			 struct ulogd_pluginstance_stack *stack)
-{
-	int ret;
-
-	ret =3D ulogd_parse_configfile(upi->id, upi->config_kset);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
 static int xml_fini(struct ulogd_pluginstance *pi)
 {
 	struct xml_priv *op =3D (struct xml_priv *) &pi->private;
@@ -333,7 +321,6 @@ static struct ulogd_plugin xml_plugin =3D {
 	.config_kset	=3D &xml_kset,
 	.priv_size	=3D sizeof(struct xml_priv),

-	.configure	=3D &xml_configure,
 	.start		=3D &xml_start,
 	.stop		=3D &xml_fini,
 	.interp		=3D &xml_output,
=2D-
2.48.1

