Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53442AF03
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 01:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742864990; cv=none; b=VU0C4xHLvtQPk53pJZICnEy5/B+ImofCqmzDmO56A2lbnHXQ1buC6tgpiUJUnEpkDtOKpV/NsGWWCtgF3UfxrO9IotMV5L7IkoouRZFWhSWmb3K64sD41hgwxgyrrhbXw4wJrhqoMVzsx50h14OADxFPovKBZtrUpa7z1aBUpkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742864990; c=relaxed/simple;
	bh=hxz0NV+xxSASud76LkoLMLcIQiwwjKakx71wcArVKCc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=AIUkuLbpHycOtsey7yAbBAJNYQipqcgpKCk9lP7KDs7pCGP6XDBjVJo1fPOfAfxcer32wR/wUIF6RGHaMQn0VDw86BWET+vvd7K/sbbor4jpXF29AFobtGi4yiMJu7SDOgwhpUc1dHjsaTNwVeKjtgZPW/hnbatTZFimruPeSig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=W1mIMa9n; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="W1mIMa9n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1742864986; x=1743469786; i=corubba@gmx.de;
	bh=shTjxZ2MIGQgwWpzZ2P1wMUQ1FsTarQE0w+yDJNX2Ec=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=W1mIMa9nM5z9bOMxTzzrzzC8XYifsQjAbawB3vNqHdSZnaBd+5T9+8mU0j2Q6f5i
	 opmhixxpoHUd3fteHajRaliW3f0Mt7e7cstbw+HzNdw9V8m7sr17nA8WdFuV5Fyrb
	 /9ED6qwBX0zWc/Gf2XMODLlzhPbvfL5UjNLPPmkgwNdfceA9vgxvIWYv8hFUiUNSg
	 /WPiVG9iWk47sF5CNG5VS9ooYdAQXxzoEh4jimyPQZoaehayhX/7iCoDa1fsb4eRl
	 I9r48dWBQ1J1NCgUJ2bek3N4YB7WWWEGZ8xHEjjuF5k48Sc4v3UWYDWcZrFjRoY5b
	 8MOYeMyC0hlTIm2GCg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([83.135.90.83]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MeCtj-1tOeRa47Il-00kxJ2 for
 <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 02:09:46 +0100
Message-ID: <5d90b6e7-d14b-4a92-83f7-9086049554b2@gmx.de>
Date: Tue, 25 Mar 2025 02:09:45 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: [PATCH ulogd2,v2 4/4] nfacct: add network namespace support
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
Content-Language: de-CH
In-Reply-To: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OasJqPiQKZfyVfiriN8x5QF15EvLK+bxft0ciIaPANxodCmrfwU
 lme6fglFCW2JFpqaLbq+h/AQnGIzZe3svpi2gv9MKRm4X+NeqVp8lfVM7SKzRrtOMy21X7V
 Ux2SHDs/RE1GjGSW/eQVir9vv/ErFJBZVOs0d0/0J+/5LnqiU+npTaNJxOh3AJTl7YNefoS
 J9HlC0gLIU0yEaB6vCHJw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Y5j7qh5nmoQ=;7UZJG4BP3TyOyE6Ko9WpVOFDpPV
 zMWuBwRTOTABPBHHjMRAuYwtD7gqqK4xdDs0Ew82qAeBFgCV28h1X7Cvn8mZZmt1HZoOE8pPR
 egy5xVNj/NUA20SiOVTmRHB40Zmwc7dBlAfn4ewSPgA7+rWaeM4Mb2HGovWahAKOOfckQW4kP
 WEE3wRp1+xDelKQGnd31OL9J1DTPYXtLoN6zyTnEl7egTimA6SDMyXAgtYZ28wrAqnBLqBV0Q
 ECLbqxvOLq1BFzDS9mXbIp2utnoCDumOu3kkgkrzAlXewaKQ+YLcOH1kNsa7wRBnD+MRw1bxL
 qwBQwjvOed40GQJPBcFaWmobmMhMQV2BM8t+srk9+FkWVCPIvH6oGaVjVa3upuwyE83A42xlx
 oc0HwMmW+hFjf81IVQoM1ybpjqmfzZHceimeXJeyFXvNMNRg1UuxdVwSFe/sLL7enHXtP/Nxt
 ZysOwDuFf//pXtsLOBxwNojzE4Re3vM3yo+qPpmNcJmA2GtBJJS8d5/+BQD2lIZ21icl0yz3a
 0Di3xl6Z3bFe7m5pYIb0Fb5nUPrl4ETbca0jN4Nlxg5PsQY0JNs2F9qbWsPvMRoQRPizqAYey
 GL/9ztRwUTwE3h36zYl+pV0WKf4W+wZOcC1tvjQJMLJa82+Stfj5R7jV68fpLc0RKn+cam3Fu
 VcXNmMo7yYIuBUAXDjag2/0MWWQtQjW8PKwhZw0X/mg6w83qktrptcjZADW57OFpNFG+6sKTJ
 HsC+Rh/NyJ9GNZKU76LOTkpNm03x6mSy4aDRPD6RPFBWu9hpAEUzAvBiZgIe/ZfX+VQYuPhah
 dAQroM02CJc1v1FUbKMLa8aS+Z3h1qNxjvTPRKfKsFqkjiBZmtW8+a2/2++Wu0kD8opcVKq5W
 pqMU/DSuz3xt6bb4TSVrwQgGKbLrvwg3NQ8ik4HFgZfdzxH2budcFyZmzbUOMchkP0Tux0aIy
 GdgriamU71maxTXPnGLanKjnWpIrFZnLkymLuLcPNcqvGgZt0BvPHE9aIhOzHbJ5Ha1FSOt5n
 eRUFW/4YU1HZuzPb28+mTQSM+/U22x8QBE//vCOsVOD9x2SKVaBGs2JgJ/6FMSvFXteEVa1N5
 kjAnZrfb2X75OygmkAgueLRC++U/7p6+OEWXy82jKfc3nWXJctfrnZIpMe75osJTfttzxWM2r
 ixmhoLpOV7k5ULaSsOKZ6b0U4n/F4DJpApXs74hmS8VhcpM15CLHOlxWtbhk0gbv0z5U1lDOM
 BWHrnkHwRm2Hp1VmV3XHLI4wi8badXEG/gcx3OHMLv1sez74yRIKdNtMDNUsg5bFu+01ol1iU
 R0XxTdtfjUmDtXJdf5k14LgsYmK/lby3P1SPWFqjGpBrjvOZQ5KMy3XJH3fTozYgWZL1bboea
 r7uc4AUQDuWwo8iZQ3Iwrz5/9Co3kxQGkiUJtgL/U25kn3wFGid3kSWPsYjFltf3GEvNvdVS/
 /QEr05Go0DaJJri/1jszk5SgezbU=

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/sum/ulogd_inpflow_NFACCT.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/input/sum/ulogd_inpflow_NFACCT.c b/input/sum/ulogd_inpflow_NF=
ACCT.c
index bd45df4..97bfd8b 100644
=2D-- a/input/sum/ulogd_inpflow_NFACCT.c
+++ b/input/sum/ulogd_inpflow_NFACCT.c
@@ -20,6 +20,7 @@

 #include <ulogd/ulogd.h>
 #include <ulogd/timer.h>
+#include <ulogd/namespace.h>

 #include <libmnl/libmnl.h>
 #include <libnetfilter_acct/libnetfilter_acct.h>
@@ -52,13 +53,19 @@ static struct config_keyset nfacct_kset =3D {
 			.type	 =3D CONFIG_TYPE_INT,
 			.options =3D CONFIG_OPT_NONE,
 			.u.value =3D 0,
-		}
+		},
+		{
+			.key	 =3D "network_namespace_path",
+			.type	 =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+		},
 	},
-	.num_ces =3D 3,
+	.num_ces =3D 4,
 };
 #define pollint_ce(x)	(x->ces[0])
 #define zerocounter_ce(x) (x->ces[1])
 #define timestamp_ce(x) (x->ces[2])
+#define network_namespace_path_ce(x) (x->ces[3])

 enum ulogd_nfacct_keys {
 	ULOGD_NFACCT_NAME,
@@ -240,12 +247,33 @@ static int constructor_nfacct(struct ulogd_pluginsta=
nce *upi)
 	if (pollint_ce(upi->config_kset).u.value =3D=3D 0)
 		return -1;

+	const char *const target_netns_path =3D
+			network_namespace_path_ce(upi->config_kset).u.string;
+	int source_netns_fd =3D -1;
+	if ((strlen(target_netns_path) > 0) &&
+	    (join_netns_path(target_netns_path, &source_netns_fd) !=3D ULOGD_IRE=
T_OK)
+	   ) {
+		ulogd_log(ULOGD_FATAL, "error joining target network "
+		                       "namespace\n");
+		return -1;
+	}
+
 	cpi->nl =3D mnl_socket_open(NETLINK_NETFILTER);
 	if (cpi->nl =3D=3D NULL) {
 		ulogd_log(ULOGD_FATAL, "cannot open netlink socket\n");
 		return -1;
 	}

+	if ((strlen(target_netns_path) > 0) &&
+	    (join_netns_fd(source_netns_fd, NULL) !=3D ULOGD_IRET_OK)
+	   ) {
+		ulogd_log(ULOGD_FATAL, "error joining source network "
+		                       "namespace\n");
+		close(source_netns_fd);
+		return -1;
+	}
+	source_netns_fd =3D -1;
+
 	if (mnl_socket_bind(cpi->nl, 0, MNL_SOCKET_AUTOPID) < 0) {
 		ulogd_log(ULOGD_FATAL, "cannot bind netlink socket\n");
 		return -1;
=2D-
2.49.0
