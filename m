Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF891C8600
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2025 23:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743030474; cv=none; b=hEf+S8plhXbhpwvsOMx2bOVcQ0Durb0OD2bZPmBXRQMhrgKCU4EUazVNDnvbWx7yzQUsw+magTjOvXg5Kil255j+2D3gAn8n9KRB+KWdtjI3jQeULoua3rQo15Zjt3wA64rkx66BcOM7JIEhqiNDC7cvfVtFf351+q++WrjhlL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743030474; c=relaxed/simple;
	bh=NIRLCWARBibxIupsrJ0k92XEme32S3GqD8bQ9XRymSU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=toO8Aooj5wm6W8H6pk68KJc+ruFma/bCWc2qrBxAq6gCYUPayFgwfJOuOB7NegVn4d7OqhHFdzH5Y1NVDpiIK1MIOFt17P83ZqLKSpB/P2H9rTZmuIOKcisnuTgo3gomFNBKhlbFnz6JDat72195Ylh2mz+KFF6YepYqCvOEZYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=XmW6K6su; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="XmW6K6su"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1743030470; x=1743635270; i=corubba@gmx.de;
	bh=mSWnJHWdG+/v4DdArB7nfhJGqzPbIgaCAqGuZTvu0N8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=XmW6K6suW8d8gdwD5Btfcs7KlKu+oqFtUWFn9sa4TXTpwiftTPvpSoV2tQ+UiQYW
	 SUy69p+likSwvEl9xumgHN5W3G827jQ9CH64JOienAYREDE8+FaVefnAkGOkgqGFK
	 pKzyLeQKFt7kMarKy2FMUWRCoYmt7ZB/rw6N9WA7tsRIaDsEh3NjObAPzegWOwJzD
	 POrG0HJ+ifdKttIOh+tLEa+dVsZxNSkhvo7kJaBqIZlroGm2zmzOCmRjvuYcCyUNe
	 0qX8r0r3PuwsWlOHawUEhX/rRJXmxtGzkzQE4idwEq/ZKHjKBm/f5vuUyeMuvKu9M
	 21awEGWHxRJTakrZjQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([83.135.90.83]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MY68d-1td4R90Fwr-00QVat for
 <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 00:07:50 +0100
Message-ID: <daacf9ff-0a91-4e38-8b9a-73342ea45f9d@gmx.de>
Date: Thu, 27 Mar 2025 00:07:49 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: [PATCH ulogd2,v3 2/4] nfct: add network namespace support
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <3f962848-fe38-4869-8422-f54dacc6a9d6@gmx.de>
Content-Language: de-CH
In-Reply-To: <3f962848-fe38-4869-8422-f54dacc6a9d6@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LptZiJlu3JdzTGOgKL4LWcg4lZj+JyfFF91M0TKVIICaR/SJTap
 3+MX3PMIlyGvn9NFrar/aT+iMyXxBbXDArJlEw+Oe1l8RUqNu+2BiX83QtZ7ccT79NvySFC
 BReQxCXgu5iVTqqdW+SuJ1ETaxeYER+SwxovAluCL+uYImnzJaZRk3yRZoQblHN8eKt6a2J
 3k/HFBwqXIh7t74EGocPw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fBCu6seIKak=;UOdVRSzuYx9Xb2sPtMyWxYCsuDC
 pFy/84UpSRc1+M23LKkdezxLyp1luikC4p//Rk25Vq9uXjEDDJUCeMsugEO7I6PEBNQ/0/f5a
 lXiSq0U7Np+cmDlAVCl0KRIPGAB3pvTNpWZi2yZgMLaBxBQxVrP+w4FdHtlghA1pNJp5FMOr0
 jb0kZteO/hR7hTaMh89GdHlJg1ePiZmsl0x4S4vVWwgTrk4+rPwBJb8cVxFdJ6BZ/pa0BQlbb
 fZ/FTsgOqQx563nvb0vm5zjq73ytWe9G14PeiJURTVbEtPTEWeNjs+StLOCPjk/hZ4E7bIdsv
 pmn9bgU1RkHVp4jEn7eo7VIyyUo40dI8Mw2ucYCKWnEhQemmbnU5ke3Q2grkt02G5wQCOL59p
 x57XSOe06vn2a5R4JxnNRFllOjEERkhW5J+54nZjEAE+rnaRsVgucBCvvrhpAfYeYp7Eht+c8
 HSGEMzxO46tsCzr6jm55fFhgVhSArsyhSLvtXBZxiynjuKmHoaxrlTKwmnW/CNAAwDVgMtCdZ
 Jdq1ok4Km/+EJ/1gJHZq5BhM2WqP07T5i4b2lKIKMra/HuYj6qHuaPZFN+Z/mKFFKkbkx6z5r
 CSHDIkgQ0s5VHDeW/2ILiH3Iv8cQvTS8m6MFljOV+EISit1vDOG7qN8UwUcc0Hcm4rrdqPLi7
 2euXyXDWqV5Ub2n0uLu+amAljXW5cSq8fgJ9Ei9C5gEd0ZogfrAIHClr6d8YKQjEWotd0KOKE
 BS9NW964HBBRQELlwM0hPOTLGTnrX+GeL5cfNyyWb72kx2C2Cz/l98lytkY5E2IrmYzX0o3fR
 KbR++VqQmrZvNoFyaOd5TUk/qInkLwu6P5zOZ+SICCUc1qfY2HI+1kcvm9sSoLk357gTuzMg5
 UqBJ1yHG775z6b/9OaOFrj1i7MndzUs7IiBmM27KXOd9QRw+iVAh0NRDkwoM1vSAnLFw+Efjq
 Ht8rnJpAvSu9QomSTZpmYnCjCeuWfYXfbH4KejWQCiuT2Lmfjoj7PxPlEOPvzH+UA7BsLihKk
 XCNWfpbAUYKxZto/XNdxRy/m1GjkFPtUU0s2pi/0NUAaxOY1QWrY1VjpcHKxetnDuwwGAUv03
 ILReZddjsJ9xR7Whf9r+P4Dt+ZIs5gdflBzjFeQD/FXQQWUv09aEniWTleUFhmXX5QjCuN0TI
 +JEjmUC1BWzTnkiB81cWZR28af+EBZV3J7nIa7TpBsLOHmvrprBhI+iFWrmUWVyaRRwswobO5
 Ply+N2gIz7MHnEXQMP1FX2x/xwynHN5uCENkId6ds7zKHbLqW40MuCgm6L0Ur+bGW6tlcHCFu
 dtqs8lF9RnKc2b7r7oCOM/qV2q5Plpkxaszg4QUX1Yu4ZKQ/eGeLOLv2ODVA92w/EeoIEGxiX
 C0xz02JVMZ1xta/5c4ZPeDO8zxGLQxl+PcScQjP01WHAQyu7SCS3uPYYCn6mObmtM2SEjSvxg
 2MXyJMIVXfExd+u/R5gLAPna3ofQ=

Allow the plugin to fetch data from a different network namespace. This
is possible by changing the network namespace before opening the netlink
socket, and immediately changing back to the original network namespace
once the socket is open. The number of nfct_open usages here warranted a
dedicated wrapper function.

If changing back to the original network namespace fails, ulogd will
log an error, but continue to run in a different network namespace than
it was started in, which may cause unexpected behaviour. But I don't see
a way to properly "escalate" it such that ulogd aborts entirely.

Also slightly adjust the error log messages to specify which socket
failed to open.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/flow/ulogd_inpflow_NFCT.c | 82 +++++++++++++++++++++++++++------
 ulogd.conf.in                   |  1 +
 2 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NF=
CT.c
index fbebfb0..8746b88 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -45,6 +45,7 @@
 #include <ulogd/timer.h>
 #include <ulogd/ipfix_protocol.h>
 #include <ulogd/addr.h>
+#include <ulogd/namespace.h>

 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>

@@ -78,7 +79,7 @@ struct nfct_pluginstance {
 #define EVENT_MASK	NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTRO=
Y

 static struct config_keyset nfct_kset =3D {
-	.num_ces =3D 12,
+	.num_ces =3D 13,
 	.ces =3D {
 		{
 			.key	 =3D "pollinterval",
@@ -149,6 +150,11 @@ static struct config_keyset nfct_kset =3D {
 			.type	 =3D CONFIG_TYPE_STRING,
 			.options =3D CONFIG_OPT_NONE,
 		},
+		{
+			.key     =3D "network_namespace_path",
+			.type    =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+		},
 	},
 };
 #define pollint_ce(x)	(x->ces[0])
@@ -163,6 +169,7 @@ static struct config_keyset nfct_kset =3D {
 #define src_filter_ce(x)	((x)->ces[9])
 #define dst_filter_ce(x)	((x)->ces[10])
 #define proto_filter_ce(x)	((x)->ces[11])
+#define network_namespace_path_ce(x)	((x)->ces[12])

 enum nfct_keys {
 	NFCT_ORIG_IP_SADDR =3D 0,
@@ -980,6 +987,55 @@ static int read_cb_ovh(int fd, unsigned int what, voi=
d *param)
 	return 0;
 }

+/**
+ * nfct_open_in_netns() - Open conntrack netlink socket in a namespace
+ * @subscriptions: ctnetlink groups to subscribe to events
+ * @target_netns_path: path to the network namespace, can be NULL
+ *
+ * On error, NULL is returned and errno is explicitly set.
+ */
+struct nfct_handle *nfct_open_in_netns(unsigned int subscriptions,
+                                       const char *const target_netns_pat=
h)
+{
+	struct nfct_handle *result =3D NULL;
+	int source_netns_fd =3D -1;
+
+	if ((target_netns_path !=3D NULL) &&
+	    (strlen(target_netns_path) > 0) &&
+	    (join_netns_path(target_netns_path, &source_netns_fd) !=3D ULOGD_IRE=
T_OK)) {
+		ulogd_log(ULOGD_FATAL, "error joining target network "
+		                       "namespace\n");
+		goto err_tns;
+	}
+
+	result =3D nfct_open(NFNL_SUBSYS_CTNETLINK, subscriptions);
+	if (result =3D=3D NULL) {
+		ulogd_log(ULOGD_FATAL, "error opening ctnetlink: %s\n",
+		                       strerror(errno));
+		goto err_nfct;
+	}
+
+	if ((target_netns_path !=3D NULL) &&
+	    (strlen(target_netns_path) > 0) &&
+	    (join_netns_fd(source_netns_fd, NULL) !=3D ULOGD_IRET_OK)) {
+		ulogd_log(ULOGD_FATAL, "error joining source network "
+		                       "namespace\n");
+		goto err_sns;
+	}
+	/* join_netns_fd() closes the fd after successful join */
+	source_netns_fd =3D -1;
+
+	return result;
+
+err_sns:
+	nfct_close(result);
+err_nfct:
+	if (source_netns_fd >=3D 0)
+		close(source_netns_fd);
+err_tns:
+	return NULL;
+}
+
 static int
 dump_reset_handler(enum nf_conntrack_msg_type type,
 		   struct nf_conntrack *ct, void *data)
@@ -1029,7 +1085,7 @@ static void get_ctr_zero(struct ulogd_pluginstance *=
upi)
 	struct nfct_handle *h;
 	int family =3D AF_UNSPEC;

-	h =3D nfct_open(CONNTRACK, 0);
+	h =3D nfct_open_in_netns(0, network_namespace_path_ce(upi->config_kset).=
u.string);
 	if (h =3D=3D NULL) {
 		ulogd_log(ULOGD_FATAL, "Cannot dump and reset counters\n");
 		return;
@@ -1305,10 +1361,10 @@ static int constructor_nfct_events(struct ulogd_pl=
uginstance *upi)
 			(struct nfct_pluginstance *)upi->private;


-	cpi->cth =3D nfct_open(NFNL_SUBSYS_CTNETLINK,
-			     eventmask_ce(upi->config_kset).u.value);
+	cpi->cth =3D nfct_open_in_netns(eventmask_ce(upi->config_kset).u.value,
+	                              network_namespace_path_ce(upi->config_kset=
).u.string);
 	if (!cpi->cth) {
-		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+		ulogd_log(ULOGD_FATAL, "error opening event netlink socket\n");
 		goto err_cth;
 	}

@@ -1376,9 +1432,9 @@ static int constructor_nfct_events(struct ulogd_plug=
instance *upi)
 		/* populate the hashtable: we use a disposable handler, we
 		 * may hit overrun if we use cpi->cth. This ensures that the
 		 * initial dump is successful. */
-		h =3D nfct_open(CONNTRACK, 0);
+		h =3D nfct_open_in_netns(0, network_namespace_path_ce(upi->config_kset)=
.u.string);
 		if (!h) {
-			ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+			ulogd_log(ULOGD_FATAL, "error opening initial-fill netlink socket\n");
 			goto err_ovh;
 		}
 		nfct_callback_register(h, NFCT_T_ALL,
@@ -1388,9 +1444,9 @@ static int constructor_nfct_events(struct ulogd_plug=
instance *upi)

 		/* the overrun handler only make sense with the hashtable,
 		 * if we hit overrun, we resync with ther kernel table. */
-		cpi->ovh =3D nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+		cpi->ovh =3D nfct_open_in_netns(0, network_namespace_path_ce(upi->confi=
g_kset).u.string);
 		if (!cpi->ovh) {
-			ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+			ulogd_log(ULOGD_FATAL, "error opening overrun-read netlink socket\n");
 			goto err_ovh;
 		}

@@ -1407,9 +1463,9 @@ static int constructor_nfct_events(struct ulogd_plug=
instance *upi)
 		ulogd_register_fd(&cpi->nfct_ov);

 		/* we use this to purge old entries during overruns.*/
-		cpi->pgh =3D nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+		cpi->pgh =3D nfct_open_in_netns(0, network_namespace_path_ce(upi->confi=
g_kset).u.string);
 		if (!cpi->pgh) {
-			ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+			ulogd_log(ULOGD_FATAL, "error opening overrun-purge netlink socket\n")=
;
 			goto err_pgh;
 		}
 	}
@@ -1442,9 +1498,9 @@ static int constructor_nfct_polling(struct ulogd_plu=
ginstance *upi)
 		goto err;
 	}

-	cpi->pgh =3D nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+	cpi->pgh =3D nfct_open_in_netns(0, network_namespace_path_ce(upi->config=
_kset).u.string);
 	if (!cpi->pgh) {
-		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+		ulogd_log(ULOGD_FATAL, "error opening polling netlink socket\n");
 		goto err;
 	}
 	nfct_callback_register(cpi->pgh, NFCT_T_ALL, &polling_handler, upi);
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 9a04bf7..f7e3fa3 100644
=2D-- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -139,6 +139,7 @@ logfile=3D"/var/log/ulogd.log"
 #netlink_socket_buffer_size=3D217088
 #netlink_socket_buffer_maxsize=3D1085440
 #reliable=3D1 # enable reliable flow-based logging (may drop packets)
+#network_namespace_path=3D/run/netns/other # import flows from a differen=
t network namespace
 hash_enable=3D0

 # Logging of system packet through NFLOG
=2D-
2.49.0
