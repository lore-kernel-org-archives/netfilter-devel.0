Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5DD1C8600
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 23:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743030529; cv=none; b=U10OdhWN0KaY6MRBm/Bxgso5KfubNnjYkeGl8hNnl82AIyvydkahRL/ihXAamb8J3xvSsn22uJTXXuKZe6w7o4uSaP4EZpRdtTXeRVXWhGy2g77pO0SLpCRas0XU1lGHdkcvKY7hN2LxR5njghjDhtaY/+f7IiV9ZfUGsdq5HzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743030529; c=relaxed/simple;
	bh=vW2sjwleHNdO3fSoA9o1siYFe2uQpObwFFUGPzUHmtM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=mbCcaLcSVnbpSrxfUqF6nQdTa75p2wGWuMwjgCnRl6jsvUTZISAUtpx03YU2VOmbnjlBLoxiYt7Kj++Tgj748/JEeaMZxvSqRlJ1HQqZk/Mmb0SsXRT/6L+hMOqF0eHRA3RjsDlxfDfYH/cXhorfClDb1CYnejUMM5uVJaH7obw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=AdvnBt5e; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="AdvnBt5e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1743030525; x=1743635325; i=corubba@gmx.de;
	bh=5MwN7+yV8dAAeYGc/qtXvFoJIsBZ/rgPfGL5xDVbqC8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=AdvnBt5evYDXYTZV8SF2C9ug7nyNnGwN9NcIVzaTMOlQfU4n7jPO6Jw/nOZ5eS7+
	 hFUAUQYR9X6sGnLDlIzPhNo8A9goFx55Yo7C4ZvQu5zuAy+xv/QAXVKZFTO6ucFhu
	 O6uu7Bdnbu0dRhbAk/x1OMxLb9dG5eqEE3pKrqBMu0RLcnAOFRMHMZtt2EnHuj3AA
	 idobkjFLrrk65LA5cswoM0igOBUsdqejaZLDzP17TUjYG+UUZ2/YRKHQEGDEB7RWv
	 S2H0orfjJ09QYd89SdJGeWnYanDkQ3Leo+9rp3wRMzDJpSmJpq0fGqrJpKMOBxIc4
	 gmSikT84P0P0Rg/Ybg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([83.135.90.83]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MBDnI-1tqSZv0uQ2-00E4xh for
 <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 00:08:45 +0100
Message-ID: <57f7811c-9f47-4735-adbe-ff167e664157@gmx.de>
Date: Thu, 27 Mar 2025 00:08:44 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: [PATCH ulogd2,v3 3/4] nflog: add network namespace support
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <3f962848-fe38-4869-8422-f54dacc6a9d6@gmx.de>
Content-Language: de-CH
In-Reply-To: <3f962848-fe38-4869-8422-f54dacc6a9d6@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:R5PlcdJKoNgH8yugpMYGh80sDavcAp45LBe+/TIeApDHwS2YBV+
 x/ESKoE+DWxyy/uOIXSuG2a5I3thP//SYSVcQ/k0uRNSDQel82seG2tSTg6ASc84TSKOdmw
 m0caKHeYgbny20iQ3bjqDEKjkHxWowF0nEc9BlHuw/FjA/aFKMp96QgSdsrvn6PKjDrzcha
 o5+t3Zi48k3bRUUrsBYzg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Bdd2mDYdoF4=;BaJNXjM22YLB76HHdVEFtV+2hxS
 Sue49/VhYXTdkK1oC2QBCyVA9mImpI2YfyAU9gaUfB+2Q4uSdREdZd5QCT9jcsvS/MdBtTiXL
 dizrEI2IojyOxto5slirre14Jfu1D+Itw+BBaiT51wROsh0JCNwd38fnChSYDZZB1Kc1gEW50
 lYTIUiD2y3VWv62bV8D2iIcIJwingTGtlPOlG88Jn93GtEWesFOD/HSYjoQjDixFsVuzTDRnW
 UpYYU4iuyJ5e5yHYrcQv8o+Rm1zBtZAoJrctJvsstIvuEeUvuJWm54+gL6NECIsdyU6mYnn0/
 f0BvwrZ9d1MXbwr9hXb4ej7MMAyhTVZYIV3YDS/ZrX/PRysXO5jFMsEN6nV10MxwCUy/tiCpF
 6pY8AszHmnSXokvYJ1alrWOThmVfuN7sdksxZzMgsW3SVefHXoyvOAVj6bFaBQdFQrD/DsJmF
 ef37bReW7EJfBzZBINlyGbGgGsZeb0PBmSft8C1SzojvTGhEUOXL6ASixGKIJ6j3Xnm4qbR/o
 r4f4/jAHqxl80cmS5al/AGPvt8MeS5ByusP39TL2B0juiXgU4t/MRi+/BMM0WddsiCUEXorli
 rYmvipMR5YC1q0Zr7b6NhcIGvQq4PD+K3Ri1wMHVdccDaHFHWvEXgmxHRus9wMVMXb/XoSeMd
 Hx8rNE3xIwVOZ4NgDm7ShuNkUD9w4c3nkvMeFtpuXd6BQMA1C1EYPBrRF4LMZARahkx5s86KG
 nXV1KX6C5zjCBb8dXs6M75n65m75+7mo3Z6RK5GWSRJU1R5Gps3dvG70oP09Otrxjy9wXOIzg
 IQQOGDS25vzcDpcgckH/Nu+Q/kb37+ifVe35jBZF6z0tpvlDKIxZ+Y/Q23hCBkqTYXHtq2mVR
 QG63NcFJ/GHkAJqKLNI+b4X2gjMxSzvFtN3FSzbtUghnl8DPlx9G8DBdwQV0CVPVHi/kH1t+w
 a1UA9KxsvTT9mCBqDPd5lzI0HyH8hOZCt7Kcx3dQ+R+gB6L7vWrgmbJM6x0jUa1rq7AgsFeYY
 uMPl04YzrgUJHzDEYEEYt+/zTbdIvnMZUSWwLSi4xwF2MRPgkdTAMK1ryRjo7t3RDRbavSoXt
 WCEOkEzUDNGISQKychntncH9lcgNgU3QjEG+gp3A1aOSBDxJpZ+w8JtVClcMCJY5K/z93q/vA
 doCWbs07WmoD+BIHtHUvrin+5ok844eusI67YIL5ZAcEzTBBu+8RBL28ilokCYUUpDZjy264l
 mDhyG/LmSzLxtmY5UgXr18VxJrcfaYUX1uw6zEjw1f65n3E5hLVMBYGnAf4ti1QObFAiW+m98
 vLw/9RMf//IqJkAbD54z600qIaQCIq13wARWf0OANLv84MJXpgKVuDIFpfo3RAHCeG2YacfiI
 ipcHFaYLEw8XcD5lUcb2CMRLfZdonLBnQ9A9ja8Iz4JMhmfQtvBO7NI+BDNwy2eusiCLCac/I
 0SymQirNPTz0DlbkBl4TPcGayJSA=

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/packet/ulogd_inppkt_NFLOG.c | 32 ++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt=
_NFLOG.c
index 62b3963..b7042be 100644
=2D-- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -10,6 +10,7 @@
 #include <stdbool.h>

 #include <ulogd/ulogd.h>
+#include <ulogd/namespace.h>
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_log/libnetfilter_log.h>
 #ifdef BUILD_NFCT
@@ -40,7 +41,7 @@ struct nflog_input {
 /* configuration entries */

 static struct config_keyset libulog_kset =3D {
-	.num_ces =3D 12,
+	.num_ces =3D 13,
 	.ces =3D {
 		{
 			.key 	 =3D "bufsize",
@@ -115,6 +116,11 @@ static struct config_keyset libulog_kset =3D {
 			.options =3D CONFIG_OPT_NONE,
 			.u.value =3D 0,
 		},
+		{
+			.key     =3D "network_namespace_path",
+			.type    =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+		},
 	}
 };

@@ -130,6 +136,7 @@ static struct config_keyset libulog_kset =3D {
 #define nlthreshold_ce(x) (x->ces[9])
 #define nltimeout_ce(x) (x->ces[10])
 #define attach_conntrack_ce(x) (x->ces[11])
+#define network_namespace_path_ce(x) (x->ces[12])

 enum nflog_keys {
 	NFLOG_KEY_RAW_MAC =3D 0,
@@ -585,11 +592,32 @@ static int start(struct ulogd_pluginstance *upi)
 	if (!ui->nfulog_buf)
 		goto out_buf;

+	const char *const target_netns_path =3D
+			network_namespace_path_ce(upi->config_kset).u.string;
+	int source_netns_fd =3D -1;
+	if ((strlen(target_netns_path) > 0) &&
+	    (join_netns_path(target_netns_path, &source_netns_fd) !=3D ULOGD_IRE=
T_OK)
+	   ) {
+		ulogd_log(ULOGD_FATAL, "error joining target network "
+		                       "namespace\n");
+		goto out_ns;
+	}
+
 	ulogd_log(ULOGD_DEBUG, "opening nfnetlink socket\n");
 	ui->nful_h =3D nflog_open();
 	if (!ui->nful_h)
 		goto out_handle;

+	if ((strlen(target_netns_path) > 0) &&
+	    (join_netns_fd(source_netns_fd, NULL) !=3D ULOGD_IRET_OK)
+	   ) {
+		ulogd_log(ULOGD_FATAL, "error joining source network "
+		                       "namespace\n");
+		goto out_handle;
+	}
+	/* join_netns_fd() closes the fd after successful join */
+	source_netns_fd =3D -1;
+
 	/* This is the system logging (conntrack, ...) facility */
 	if ((group_ce(upi->config_kset).u.value =3D=3D 0) ||
 			(bind_ce(upi->config_kset).u.value > 0)) {
@@ -685,6 +713,8 @@ out_bind:
 	}
 	nflog_close(ui->nful_h);
 out_handle:
+	if (source_netns_fd >=3D 0) close(source_netns_fd);
+out_ns:
 	free(ui->nfulog_buf);
 out_buf:
 	return -1;
=2D-
2.49.0
