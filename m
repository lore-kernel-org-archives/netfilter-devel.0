Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655A417F4F6
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 23:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743030563; cv=none; b=u/ABOgzh3RQ0pUpVAdFXvoJ2MzNbgqIch50GdoNn12A5R/tMmWqq/5P5JMlvDhjMyD7hT5cU+Wh0gEeIDrvLSYbikvEVGeN+YZXqyjUrhEmi/3IngZTNm9iPHcy0VnJSVIF3jqFQlPKXfYPgsIwBYOfou72YxLQY2Vo/pNLzIqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743030563; c=relaxed/simple;
	bh=yla4HFoYN4TRMmhieBm0mdQpwfl8bkrfszDypKOEzUo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=M0sKxfxq5cnHJo2qqbLk7FnVnD5c3qomqDnt5uBZHH56MttI6heeRmLobsFZcluTdTqIODscYCdTpQrHOH5DhrdDQUlrw2uTFQ2B63v1ERDFUEisOvfeHQqtkXOmu3p9Bbldx47H6UtxQaOhBWmHZnUYZQ98ArHBD2DBWXFJxco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=Pg36/nz8; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="Pg36/nz8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1743030559; x=1743635359; i=corubba@gmx.de;
	bh=DVqFplMfg131/oBXzN76mcmEMrtKsAn7KZDnG/VT7zQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Pg36/nz8sSwOqlZgZu0z5iBFbLoGND+Lj7MJwOzz/HNr7NMfRRCIg9G7HmuzTbxO
	 hr0OjMK2ksyIS7UFuGRZIiUWy4o2MKCjJgSAnhJHMzFPmPGiabyhBnul4hEq2tLf4
	 FZA7qsaVh6I102vRNJD7FOwI0rMhKmDsybaL9lW5JY/p3Hhvvt5krOKY1alEPcbn+
	 gAZxRG0hWiyUCFp32/va/jUvLGa44lEKflKvf4vAXbHSyvnQ+qtfY3CXrkm+wsX3S
	 pLmZnGlkcNmpvSk2uJPnA42SwPsC5qIgFWf8cnxo/ZnME+xgxIaabnxA8neAWud78
	 wBRoUV4NeQ+8AqskAg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([83.135.90.83]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MaJ3n-1tasUU1yEf-00Si91 for
 <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 00:09:19 +0100
Message-ID: <1ccccdb1-4530-4a58-898d-5822b49f3dd4@gmx.de>
Date: Thu, 27 Mar 2025 00:09:19 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: [PATCH ulogd2,v3 4/4] nfacct: add network namespace support
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <3f962848-fe38-4869-8422-f54dacc6a9d6@gmx.de>
Content-Language: de-CH
In-Reply-To: <3f962848-fe38-4869-8422-f54dacc6a9d6@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:h1v7rCJ5i4IHlNjHxgfR87rX973dbSO67I/pIZrUtSMZEXlPCj0
 mda3xqJufgALLbY7AAjI4KDM34oujBzrRBhLvGUW3nx77M9lXwcxuCxQ+SKbJJrQPVhWjI9
 fRYQdMxh/cOcTxfNKPIVeTsxLnaY+x7JyukHn5uq9AQ6cR6Jvlsi5bTR1fHYi+xjOxqn1Ub
 vuEoPrRca+tq6W7tdmjnw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:9yGY521yzko=;R/BxrANbpDJFcqlG3B8tyXoltkG
 HJ5CaC/0aU4xt1wVbHJm2RXhAc3ieZckcDL1EQkNQZcN4cT0+uIxijUcV3VLga38QNYQc13yh
 rE5WXOpGAPN12l5XgKHQqirYFHR8UtiR0RMqbIekUzpusmdn5DT0hBXzepwWxJwpiY0+DgCNL
 Muv3ybtT0dzWZLyxu9iouHJOaw44TWCAIprdNTqsq3v4ijSX4gUIWhJIYEanMi1417BDOMkOG
 V5bFQecxQtwUYIIDfDO+6U3c2dnqBOJdfb1QUMxwbelTvhgHhW0hrb5rlLYgZqlhleuaLExZ5
 sDg7eTbPcEWglmBIfKMCOmaUGxp83PqtbvPfyBS3aeeN7CUKJIEzFvoBSLgDwY3J+3npHI5Sp
 679Xhe3l/KiBtWtxNP9F3BxlzL6/vVIBdL3F54HL3nSZvPeUZ1kGjPPZKOBEJU2EDDOdg0+VN
 jUKpETCGRKnttD8JSaQpYuWKCLrECCT8JPImBqia7GD9QxrS7uiMJUeFrj95+5XcmczOUhUor
 PJYWIlfyrzlqVORIUgzSNToN4A+WAOFMUh3pLR6Ksla0WyE4xamv8M0og7HIBb19oMMbBLWAq
 hPh46PQzat/qfX0mnwsrAuKz6dmhxxe338NCq61/fU0/pWNkCv+x33xDfGqwpexf8Sfwc+Vjp
 2XjGZrHcJUycz8/ZEtfavitLjaXAH6oWfqIiPoKykCl9BgQBHT2xRSA9wZTEesh/wdJ0/EWKT
 dlrBmVhlntfAL/SVTrh0N8jY+7VsFN/JQPXh505rwoGqqozJLtM6R0lqSyb+S9ZkNhciaa1MO
 TLJQQRdNvxdxI1rpc63l3jBWFwuQKt1YXAWYHGKEr6CSngKbni1ZAIbxRPJ3txMCv/lZ8qR/g
 JFpnveoAIPeWnAtFnMiQvnuEA1lCVhhfvrG7GWMmibOPpTh8ArelT1flKBSOqbn4WhYsPgE02
 aEcrmgd/7UZIX44iSsR1gFYCeWQhc3f9PpHep/S+TybJzsKGf4weqSDPhS7atnqNTGbJRpRZE
 LqOKaDFeLZUaurV5R1btxnspvfPA8ze7icfh03NkYwGWMmGTSHZVH9faeu+57WvhOcFv5rh0E
 RejJOmcnPknfg8ZIlkGVWJkwemv4FN9YmokH8YTC99CEViNnWHgk0RL8wkBxd0Dwr2ziOHCaI
 yTMYztgujuBTKZofekLNBrB/bPgnV7n/RBiN+ZoPPfmXur8bTdkcRtNLjsqOrmxj46gXixFFS
 LMm6G5FMSZBQvmofH0RCp0rTxwNm0ReF3o+E0TTVNUuKnxJjOz+8Zw48vDiP0PDlDNzQpsw5O
 jpR2qaTRVhU0nrQh1W3ZRWtftoKicBcfujxYFAntYqFaWsOfUSZAWwgE00ZlVYvYkI6/CQoCM
 6RI6cROh1Jz1nV4Nt3Sl/9PXa6yuKJswJ7Zkcz85FG0UjM7nh8peALFUqdzqGllToNqczpJPe
 fEqJzF5YH+Jrjnxnmmyddxkmpp+8=

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/sum/ulogd_inpflow_NFACCT.c | 33 ++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/input/sum/ulogd_inpflow_NFACCT.c b/input/sum/ulogd_inpflow_NF=
ACCT.c
index bd45df4..e962b1d 100644
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
@@ -240,12 +247,34 @@ static int constructor_nfacct(struct ulogd_pluginsta=
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
+	/* join_netns_fd() closes the fd after successful join */
+	source_netns_fd =3D -1;
+
 	if (mnl_socket_bind(cpi->nl, 0, MNL_SOCKET_AUTOPID) < 0) {
 		ulogd_log(ULOGD_FATAL, "cannot bind netlink socket\n");
 		return -1;
=2D-
2.49.0
