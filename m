Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4837F2475DD
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 14:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741791412; cv=none; b=pHicrp0zqHdlBW8xjqR/N1BPbFkELbgob8nnEhFS2uDc9i8M+zo9iIDWidW6bSXPuuUYFf5RGo2SPa+Lpd8baMdzYVR5LhpXDx499IhwqpZx7ph3ndeeen5MrzEd5Xkt/fGA4feXJDLXpY5uyf/VFHye49T2yM1ZDMIub76oMqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741791412; c=relaxed/simple;
	bh=Zy4Xy4jwd5V5sZAAO7sX7rOJMrtYfsf4FU4scVxzJkY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ir9lZea8JBaSQLePq717BqZSJ6k6+axwpFB7ZwJtz8hUaEeEGetQ2hru1gYb0hpbIZvbXusZ8sT61mjLqzVTVQSIFNxsgk4v4gFq0PHikIOBe477sJ1r99zl5OivRzVoRb++Vn5o9Hg9eQElVs/DJmtdVh5zH5mnrM4aYUZ1ECk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=qn8iJ2rU; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="qn8iJ2rU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741791408; x=1742396208; i=corubba@gmx.de;
	bh=kRg+OfCNwrYi1vU1FMSxLvLRSghP0pe40thUlL9XsyY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=qn8iJ2rU8dDh4kvsKDoBWo5r9eDBs6JMxof2s589K+dCMeAZ52+dhJ4JCuEU/5QH
	 xtWLDjgPFoAhWr2XjoyvtpWfjp7bf96AsRXsTuicN+Qmte4n+Aase7NXg3d4/EnMi
	 qMMkgb9XGG411qRk4JbmznkTgFMwGI5CtG7kKm5osqHMN98gDNTkcLoiEvZeDzH62
	 +U3kQltooNS25Z7eV5KAptdN3gkbkxRNqc11NkbJDZv71/W/cMDUON6RQaV0cL9YL
	 SfouMqJZ+jpDYUVzMx2Ps/w2CJHwvTU3rINpBuZokwTxFtctHss5OMcbXm6cDLpvs
	 m6tDMlHdRwzqZ0choQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.254]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M8hZJ-1tnioD1uwj-00GaU8 for
 <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 15:56:48 +0100
Message-ID: <dd2a515b-54e8-42bb-a032-68c70a0f9672@gmx.de>
Date: Wed, 12 Mar 2025 15:56:48 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2,v2 6/6] all: remove trivial configure hooks
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
Content-Language: de-CH
In-Reply-To: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5Oxz7l5JM8M5W/5ggVah9MxNRYmsxak+3x8NMErNY57trLxbXhT
 LAm8V5CXO9bSkq4GxcpAZzqjha77E4qlYNv/p8h0hK+dgHbSlIiN0EjdOqAM7Oh3mn99Xc4
 ZiipYNqI1VGZM0kxn8q3Z1RnOuTCcsZGRhMjNgSKhStCJ5Qa3ILOTJSAIEeLt/JW8TyInW2
 jA+aY37J+fCtEeic2lKwA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2/KFxyygiEc=;HZFWpSk3FeloYOm+MZE5i9cbAyj
 nMuzDKd+6fVCX1EA6PICxFafEjC2oElcTK4fd9GW1VSqBbcYnIQD7qhEK1lkifGLP2LqlDYk2
 oGiHMvTFz7TwXtpcURaiVdzqFWl1S4cRwseRIvCUkssMEb1ziJSHXXVrZ7Wab5scqJRS0m6wn
 aFEbDvAKMgJKtopkCu9GvOv3pL3wIjSXYk+/lIu+DvF9x3Ia7Fa2hj8599HU13ZhCc4j0u80u
 GsDvNxMWCnWjbgJR4qNRdIYzr9na1AbcXCURsadiZY0heC39OxcooSDMCyo9MJLVObTX1zxQ5
 khfRgLToFeBVrRHW6+oVLy2cZRcxynmh/4YkUw10CxOKDOYTqv0wLLdGy1GCG/kP7pQRSU9uL
 DJEJ6gMzeaqxPqn8u8JtNmloZsW+wA2O4qrprULbgzsl9NL4BaepFFSBnEh6FV7s2b1hQVYL4
 WMonAEIZa+MIo4sPy1fK5cn6/BQemI2iE/k8GkAkdfhvGbnCNvJFHf4U6H/Bjf1lH3tyIlQRm
 gHOx3JWEHxZb8sgmMlI8fviCnphfdFXABLbT7Z5YMHHVcbxfuSqOL5QQW/m4djRgRuK+Ai9IO
 B/yMu56qOoUXeydYycMTEI8IfZZUh5IJCeDix/r5x5rsjpPBkLdEHtZ37sm3/Lp9bQqRk+0QY
 MbkypeD2iBU0j3OzZpg2WGD8C9DAqWuIeX6gFZoGno0P1TAKJYP5f5ryMTat8dB6ImaSKarBc
 eDaIpV/XqVr4ACZZYFciQYx+iAiF410a8CZsIv9UpVTObPwsU6a2u53gbLREUBcAs3nYkGM40
 bho5INZpl0d9J5c2cJsvDZZeXY70oAHAK7oXwRzV8mco8jkHVrE5xgyhnMbf9fsbQs/Sp1/h7
 /csbVji7BunhmIXONL2UA+pejAANQ9z1EOC4PZPvmhN01m0YvANOnwKSYh70+2wjA9WsJwRxS
 StqbxU85pDVicDB1ZbaYO46iwWe33uonVg8vxaGU0ua0rchbBswwIhpNl7VkNDjfFVwF7S5L7
 znFgTvdo3EuzVCIABEapMj8MuidWlef522HvylF+QSecijCfwm1knqe/L6bd/upPYoPbikaYb
 r6vPr12pK8rycMCqYt0VlQWvhDlc80hOUWWoRPkmD3AYyXwSHh/IbaveS0O6AYGGDWmQokrOi
 Jyex2II5p9aaPBD1RiZH6EUo7erhGJiRJnjCwSVaV6TtdERfTpwhcprQZsqqmMuUUzI384Jp8
 PxNXRBiPyjZI47IJpq89+JYTGVN1xUIIJgJkFkDcnmqCaFoZbfRLPmBqnLvnES24F1UnngnzP
 RNu+CRojKTixwzKi+JwjvKrxK/iaJhoTrviMKN35A23IAp+OczIHB9mFxNA0HSkmQJyIPcnTD
 /090IceLdXEw+PS2ikFfNjlHIA2o/xCNVXrAUfMLt7SqMu9h+Sd96g3bWXgZUle+hYdpJg4ih
 geAKFBFskCi+sgOrqhJv3TXWDz8wtsSj34MXCjos034XIv5q1

These are now covered by the default implementation.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
Changes in v2:
  - None

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
index 5213cc3..93edb76 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -1049,18 +1049,6 @@ static void polling_timer_cb(struct ulogd_timer *t,=
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
@@ -1577,7 +1565,6 @@ static struct ulogd_plugin nfct_plugin =3D {
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
