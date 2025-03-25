Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8141C2AF03
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 01:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742864919; cv=none; b=EaLpf6twjzQsmb8OxjuG5SS5RdiUyRYplaCjGKYr8K8pKUn4eac3mG3QRrI7pe9QWJYfLdmhfsR5n7mVSbxshgBcm9QGvv4vmQZ+O6xJOUKDYaOsYqCMCnYlkANXpZNtlTleai613E6cg5/3Py7I5r5rVCvmYI3vgajZ+JPakqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742864919; c=relaxed/simple;
	bh=gkrFV+iM2/Qld3T8nVtjJArpZ1pOEHD1uu6Jps84r7c=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=dd8lKqh7Oi13ziBei/tb0wZ4B7RhBJqkwgFopE6f87tb24fk9rOO/YbJpIf5SStFVxTWCaLgF1QsNH+DQrMZc3LFWxdCWAddat0t9peZG/bK3Ltl9xe71JcnHHYYrEVZma4K3kQcb6JdvksUsYubzq/mTaou7YorW2khM70yXns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=Ul9NzSwX; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="Ul9NzSwX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1742864913; x=1743469713; i=corubba@gmx.de;
	bh=ZMsnZgrzqm/fDGyE/38WHozp1fm5nrwUVvYMXPWAc14=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Ul9NzSwX6BFXGYzrYi5Jlbab84thqvmMBa7FKGLgiAcQPQxL3zlcX93rk8kULWxT
	 jHkrWIGtLdeXNV2TUuLTnmp/+GdfSL5G0MvOoiP1tTyWMu01CU2To5L7DIPndbnCy
	 0dQ8v9X6nxbqUlgo4xEMBrlqKGKm0SVjibUpQX5d92KfDIZ4+vURC2BRKwP6lpMd1
	 9gys3BxAYf+CueGdQSCx3FLzbhvoYey4eTT3osoFkQnTrJBL2mXOcL65O6B0JdT/m
	 yG6mkWs3YjFG6KyQa2ot7PMHKIEK0hVTXjr95xJqVaq9V2Kd8B5WCGHHsuztUIB/Q
	 t1L9bsurLxFjOSPmGQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([83.135.90.83]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MryXN-1tKr4e1saj-00g3oF for
 <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 02:08:33 +0100
Message-ID: <0e7e461d-a30a-42af-9427-96cd97eb108d@gmx.de>
Date: Tue, 25 Mar 2025 02:08:33 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: [PATCH ulogd2,v2 3/4] nflog: add network namespace support
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
Content-Language: de-CH
In-Reply-To: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ojVLbg2Rw5xJysf3xnJeeQEBkjV5dJJRz4K4ekRwHW7XpnQ7RMi
 NqEALY+kn+LUNwzbG3gAIdPnGpt+LO5FtVEjDc+UFLengeYYyv3e171TFA0C0PnqlDIWBGQ
 jlbpfON3mFue8jsCtB8iDiZX7warJ/xiaxJsrl6F5AewqpHKzrQb3El+PL7AGULmz3ToysU
 ofnEX+/PGNIJW2xR6iw6A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:BiFw+lCu/Wc=;6Z7E/qVP7L7hM1xah6Usxj6cfQY
 zpvCHZgQPzCLxK6axMuEEY2RXgMLQtQzkdJHi0c7ewwAbywGQJ4zpNm/OOwIU5Yv3MrNxMo8G
 EBVulvcenLDHuJTTBhupfAU3PiGKjI6XgkyZ3gbnSFLCeGhmRwVnby08BPFtstVTICUwx3eik
 WpPO8JStlC0XfH+A+Q0FSQy+Otn7GfzuM5c5lNMT5jcrPHk8zDHQ3po58L9mKAybBb5PdCmoK
 QFc6+gCOBK52jxvNvXtAULSn/S1UYiG2Hld0F+0v2TYiwXa5HFj9JcT0PL7OEvRs4/Fql/+Le
 VPCst0z8kVPJHi5aiqPBkv8TBjFTMpyJ833uwOAfa7lwvUIsgyb4dPKJLvYuRbgCkrDiqFbiz
 rMhyUR53fpx0MZRNvhM0fDhA7KiE36c45eCEHqUQLvjsLBa+0Qi0/o1Z19D53HXAhtpdYQIjN
 C90phQtdYnHn1LUTQ5WOhaXpHBl13gLGWwRcjCJg8Hjuh+DBRo3RG2cv2SsrmbC+ilu20PRfk
 veJ2Bw50kuxzHeDbBqG/Yx9IEt7cx9cF5ZgJB873bOBz8zqW101gRm0/CCWqHFQ4G+xSQK7P0
 F0RxUmLW2q/j9l5QFCSb0GO3j6v0tkEtESCF1zU3F1jkktiyU0vnRY4OLE8Y3LAM8VkRI2mfT
 MQnmjhUtobpGwCMolDNdnSqN3FHbEtlDpzRm1FSJEASw4ydtH7OauA04vaaf4CT6S6ge2kdy8
 T94LmHDUPBr2dr9eR7LoBiZp4iUFioII3horNOCmOk5pcAVYe9lKggl/9pYCJBIhMyNvTj5TF
 hHMQpn3+2Ux7RADPFhWWaHBQqDdhcYORPHC0Yqst3huixJHKhlBeZYMr/n8tmG7/ZL1sidaQA
 BgFD040fKeP1lpzITU6u0u3xL4vcf2j2x7SqJczmwEMkUM/weuknm7xes7tfoKHFg5Hfb/mZ3
 /HCsAY5T6MCaOXI2wNCnCsYzX8BwCZTV+ju1xLe/Zyfi+1U4UyNhI7kCzRTZ5IzDNTUA3XoR5
 5dPSgtuKwoyzi5io6PwAsAnr45U03UnJi+9l1Chl3ZM6Aj6Zx5kFdRajFtCh+MjGMzgibXoXb
 S/1GCMpxM3vELOgY8CLkBdZdJ2yEXeAB0i9J7S0JJ3YHRFLbt0uqypRjONJhFeRWUKdyCv6+Y
 G6iEE5zd4u01jh/rGd5oCNQG0lwKMUIaMwP8oM8lQqwi4CenbweBiPP4pQSphcnwb21ZVUHJi
 1DfhGO0PgPHwMiHAg/kZvk/eBJV5ApEYEZxquv1G8QtVSRLMbrSjjYobTl3E4FX3atQ78O0Ak
 NPShtNfxZ/64R83aadGIO9+0gDcqBfCBJScoFmj+s5lgI7ReyW7Ifgtcz326yOxfOS+ON5qFe
 wwHYafGIHc9DAC93d+EFMYWm1MouyUs4DnsTeH7QjH+cUoYP/YSvscWDNRDc5XCsG+U7Ucqtz
 jFKu0BEQwhqEC9czHd/FrK7DAqkE=

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/packet/ulogd_inppkt_NFLOG.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt=
_NFLOG.c
index 62b3963..f99272e 100644
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
@@ -585,11 +592,31 @@ static int start(struct ulogd_pluginstance *upi)
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
+	source_netns_fd =3D -1;
+
 	/* This is the system logging (conntrack, ...) facility */
 	if ((group_ce(upi->config_kset).u.value =3D=3D 0) ||
 			(bind_ce(upi->config_kset).u.value > 0)) {
@@ -685,6 +712,8 @@ out_bind:
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
